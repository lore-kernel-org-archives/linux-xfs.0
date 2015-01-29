Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7E4247FAE
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 14:33:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4E1CE8F8084
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 12:33:49 -0800 (PST)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id kur4zwhDesGC7bte for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 12:33:47 -0800 (PST)
Date: Thu, 29 Jan 2015 15:33:46 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 10/20] nfsd: implement pNFS operations
Message-ID: <20150129203346.GA11064@fieldses.org>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-11-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1421925006-24231-11-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Thu, Jan 22, 2015 at 12:09:56PM +0100, Christoph Hellwig wrote:
> Add support for the GETDEVICEINFO, LAYOUTGET, LAYOUTCOMMIT and
> LAYOUTRETURN NFSv4.1 operations, as well as backing code to manage
> outstanding layouts and devices.
> 
> Layout management is very straight forward, with a nfs4_layout_stateid
> structure that extends nfs4_stid to manage layout stateids as the
> top-level structure.  It is linked into the nfs4_file and nfs4_client
> structures like the other stateids, and contains a linked list of
> layouts that hang of the stateid.  The actual layout operations are
> implemented in layout drivers that are not part of this commit, but
> will be added later.
> 
> The worst part of this commit is the management of the pNFS device IDs,
> which suffers from a specification that is not sanely implementable due
> to the fact that the device-IDs are global and not bound to an export,
> and have a small enough size so that we can't store the fsid portion of
> a file handle, and must never be reused.  As we still do need perform all
> export authentication and validation checks on a device ID passed to
> GETDEVICEINFO we are caught between a rock and a hard place.  To work
> around this issue we add a new hash that maps from a 64-bit integer to a
> fsid so that we can look up the export to authenticate against it,
> a 32-bit integer as a generation that we can bump when changing the device,
> and a currently unused 32-bit integer that could be used in the future
> to handle more than a single device per export.  Entries in this hash
> table are never deleted as we can't reuse the ids anyway, and would have
> a severe lifetime problem anyway as Linux export structures are temporary
> structures that can go away under load.

Looks to me like that works.

...
> diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
> new file mode 100644
> index 0000000..28c8ff2
> --- /dev/null
> +++ b/fs/nfsd/nfs4layouts.c
> @@ -0,0 +1,488 @@
...
> +__be32
> +nfsd4_preprocess_layout_stateid(struct svc_rqst *rqstp,
> +		struct nfsd4_compound_state *cstate, stateid_t *stateid,
> +		bool create, u32 layout_type, struct nfs4_layout_stateid **lsp)
> +{
> +	struct nfs4_layout_stateid *ls;
> +	struct nfs4_stid *stid;
> +	unsigned char typemask = NFS4_LAYOUT_STID;
> +	__be32 status;
> +
> +	if (create)
> +		typemask |= (NFS4_OPEN_STID | NFS4_LOCK_STID | NFS4_DELEG_STID);
> +
> +	status = nfsd4_lookup_stateid(cstate, stateid, typemask, &stid,
> +			net_generic(SVC_NET(rqstp), nfsd_net_id));
> +	if (status)
> +		goto out;
> +
> +	if (!fh_match(&cstate->current_fh.fh_handle,
> +		      &stid->sc_file->fi_fhandle)) {
> +		status = nfserr_bad_stateid;
> +		goto out_put_stid;
> +	}
> +
> +	if (stid->sc_type != NFS4_LAYOUT_STID) {
> +		ls = nfsd4_alloc_layout_stateid(cstate, stid, layout_type);
> +		nfs4_put_stid(stid);
> +
> +		status = nfserr_jukebox;
> +		if (!ls)
> +			goto out;
> +	} else {
> +		ls = container_of(stid, struct nfs4_layout_stateid, ls_stid);
> +
> +		status = nfserr_bad_stateid;
> +		if (stateid->si_generation > stid->sc_stateid.si_generation)
> +			goto out_put_stid;

Is there no old_stateid case for layout stateids?  And is there any
chance of wraparound?  (I was comparing to check_stateid_generation and
expecting the only difference to be the handling of the generation-zero
case.)

> +		if (layout_type != ls->ls_layout_type)
> +			goto out_put_stid;
> +	}
> +
> +	*lsp = ls;
> +	return 0;
> +
> +out_put_stid:
> +	nfs4_put_stid(stid);
> +out:
> +	return status;
> +}
> +
> +static inline u64
> +layout_end(struct nfsd4_layout_seg *seg)
> +{
> +	u64 end = seg->offset + seg->length;
> +	return end >= seg->offset ? seg->length : NFS4_MAX_UINT64;

Shouldn't that be

	return end >= seg->offset ? end : NFS_MAX_UINT64;

?

> +}
> +
> +static void
> +layout_update_len(struct nfsd4_layout_seg *lo, u64 end)
> +{
> +	if (end == NFS4_MAX_UINT64)
> +		lo->length = NFS4_MAX_UINT64;

Is this case necessary?

> +	else
> +		lo->length = end - lo->offset;
> +}
...
> diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
> index ac71d13..b813913 100644
> --- a/fs/nfsd/nfs4proc.c
> +++ b/fs/nfsd/nfs4proc.c
...
> @@ -1966,6 +2213,25 @@ static struct nfsd4_operation nfsd4_ops[] = {
>  		.op_get_currentstateid = (stateid_getter)nfsd4_get_freestateid,
>  		.op_rsize_bop = (nfsd4op_rsize)nfsd4_only_status_rsize,
>  	},
> +#ifdef CONFIG_NFSD_PNFS
> +	[OP_GETDEVICEINFO] = {
> +		.op_func = (nfsd4op_func)nfsd4_getdeviceinfo,
> +		.op_flags = ALLOWED_WITHOUT_FH,
> +		.op_name = "OP_GETDEVICEINFO",
> +	},
> +	[OP_LAYOUTGET] = {
> +		.op_func = (nfsd4op_func)nfsd4_layoutget,
> +		.op_name = "OP_LAYOUTGET",
> +	},
> +	[OP_LAYOUTCOMMIT] = {
> +		.op_func = (nfsd4op_func)nfsd4_layoutcommit,
> +		.op_name = "OP_LAYOUTCOMMIT",
> +	},
> +	[OP_LAYOUTRETURN] = {
> +		.op_func = (nfsd4op_func)nfsd4_layoutreturn,
> +		.op_name = "OP_LAYOUTRETURN",
> +	},

Should any of these have OP_MODIFIES_SOMETHING set?  (Basically: would
we be in trouble if we succesfully completed one of these operations and
then weren't able to encode the result?)

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
