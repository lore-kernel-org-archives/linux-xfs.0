Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ABD047F3F
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 18:49:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8C50C304048
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 16:48:58 -0800 (PST)
Received: from mail-qc0-f179.google.com (mail-qc0-f179.google.com
	[209.85.216.179]) by cuda.sgi.com with ESMTP id
	CKTn90UwFKVx7At8 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2015 16:48:57 -0800 (PST)
Received: by mail-qc0-f179.google.com with SMTP id c9so5588983qcz.10
	for <xfs@oss.sgi.com>; Thu, 08 Jan 2015 16:48:56 -0800 (PST)
From: Jeff Layton <jeff.layton@primarydata.com>
Date: Thu, 8 Jan 2015 16:48:51 -0800
Subject: Re: [PATCH 09/18] nfsd: implement pNFS operations
Message-ID: <20150108164851.03b64e16@synchrony.poochiereds.net>
In-Reply-To: <1420561721-9150-10-git-send-email-hch@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-10-git-send-email-hch@lst.de>
MIME-Version: 1.0
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
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Tue,  6 Jan 2015 17:28:32 +0100
Christoph Hellwig <hch@lst.de> wrote:

> Add support for the GETDEVICEINFO, LAYOUTGET, LAYOUTCOMMIT and
> LAYOUTRETURN NFSv4.1 operations, as well as backing code to manage
> outstanding layouts and devices.
> 
> Layout management is very straight forward, with a nfs4_layout_stateid
> structure that extents nfs4_stid to manage layout stateids as the
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
> 
> Parts of the XDR data, structures and marshaling/unmarshaling code, as
> well as many concepts are derived from the old pNFS server implementation
> from Andy Adamson, Benny Halevy, Dean Hildebrand, Marc Eshel, Fred Isaman,
> Mike Sager, Ricardo Labiaga and many others.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/nfsd/Kconfig                 |  10 +
>  fs/nfsd/Makefile                |   1 +
>  fs/nfsd/export.c                |   8 +
>  fs/nfsd/export.h                |   2 +
>  fs/nfsd/nfs4layouts.c           | 486 ++++++++++++++++++++++++++++++++++++++++
>  fs/nfsd/nfs4proc.c              | 266 ++++++++++++++++++++++
>  fs/nfsd/nfs4state.c             |  16 +-
>  fs/nfsd/nfs4xdr.c               | 306 +++++++++++++++++++++++++
>  fs/nfsd/nfsctl.c                |   9 +-
>  fs/nfsd/nfsd.h                  |  16 +-
>  fs/nfsd/pnfs.h                  |  80 +++++++
>  fs/nfsd/state.h                 |  21 ++
>  fs/nfsd/xdr4.h                  |  60 +++++
>  include/linux/nfs4.h            |   1 +
>  include/uapi/linux/nfsd/debug.h |   1 +
>  15 files changed, 1279 insertions(+), 4 deletions(-)
>  create mode 100644 fs/nfsd/nfs4layouts.c
>  create mode 100644 fs/nfsd/pnfs.h
> 

[...]

> @@ -4845,6 +4856,9 @@ nfsd4_close(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
>  	update_stateid(&stp->st_stid.sc_stateid);
>  	memcpy(&close->cl_stateid, &stp->st_stid.sc_stateid, sizeof(stateid_t));
>  
> +	nfsd4_return_all_file_layouts(stp->st_stateowner->so_client,
> +				      stp->st_stid.sc_file);
> +

Shouldn't the above be conditional on whether the lg_roc was true?

>  	nfsd4_close_open_stateid(stp);
>  
>  	/* put reference from nfs4_preprocess_seqid_op */

-- 
Jeff Layton <jlayton@primarydata.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
