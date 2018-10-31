Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbeJaVI7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Oct 2018 17:08:59 -0400
Date: Wed, 31 Oct 2018 08:11:11 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: flush CoW fork reservations before processing quota
 get request
Message-ID: <20181031121110.GA15869@bfoster>
References: <20181023064808.23374-1-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181023064808.23374-1-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Tue, Oct 23, 2018 at 12:18:08PM +0530, Chandan Rajendra wrote:
> generic/305 fails on a 64k block sized filesystem due to the following
> interaction,
> 
> 1. We are writing 8 blocks (i.e. [0, 512k-1]) of data to a 1 MiB file.
> 2. XFS reserves 32 blocks of space in the CoW fork.
>    xfs_bmap_extsize_align() calculates XFS_DEFAULT_COWEXTSZ_HINT (32
>    blocks) as the number of blocks to be reserved.
> 3. The reserved space in the range [1M(i.e. i_size), 1M + 16
>    blocks] is  freed by __fput(). This corresponds to freeing "eof
>    blocks" i.e. space reserved beyond EOF of a file.
> 

This still refers to the COW fork, right?

> The reserved space to which data was never written i.e. [9th block,
> 1M(EOF)], remains reserved in the CoW fork until either the CoW block
> reservation trimming worker gets invoked or the filesystem is
> unmounted.
> 

And so this refers to cowblocks within EOF..? If so, that means those
blocks are consumed if that particular range of the file is written as
well. The above sort of reads like they'd stick around without any real
purpose, which is either a bit confusing or suggests I'm missing
something.

This also all sounds like expected behavior to this point..

> This commit fixes the issue by freeing unused CoW block reservations
> whenever quota numbers are requested by userspace application.
> 

Could you elaborate more on the fundamental problem wrt to quota? Are
the cow blocks not accounted properly or something? What exactly makes
this a problem with 64k page sizes and not the more common 4k page/block
size?

> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
> 
> PS: With the above patch, the tests xfs/214 & xfs/440 fail because the
> value passed to xfs_io's cowextsize does not have any effect when CoW
> fork reservations are flushed before querying for quota usage numbers.
> 
> fs/xfs/xfs_quotaops.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index a7c0c65..9236a38 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -218,14 +218,21 @@ xfs_fs_get_dqblk(
>  	struct kqid		qid,
>  	struct qc_dqblk		*qdq)
>  {
> +	int			ret;
>  	struct xfs_mount	*mp = XFS_M(sb);
>  	xfs_dqid_t		id;
> +	struct xfs_eofblocks	eofb = { 0 };
>  
>  	if (!XFS_IS_QUOTA_RUNNING(mp))
>  		return -ENOSYS;
>  	if (!XFS_IS_QUOTA_ON(mp))
>  		return -ESRCH;
>  
> +	eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
> +	ret = xfs_icache_free_cowblocks(mp, &eofb);
> +	if (ret)
> +		return ret;
> +

So this is a full scan of the in-core icache per call. I'm not terribly
familiar with the quota infrastructure code, but just from the context
it looks like this is per quota id. The eofblocks infrastructure
supports id filtering, which makes me wonder (at minimum) why we
wouldn't limit the scan to the id associated with the quota?

Brian

>  	id = from_kqid(&init_user_ns, qid);
>  	return xfs_qm_scall_getquota(mp, id, xfs_quota_type(qid.type), qdq);
>  }
> @@ -240,12 +247,18 @@ xfs_fs_get_nextdqblk(
>  	int			ret;
>  	struct xfs_mount	*mp = XFS_M(sb);
>  	xfs_dqid_t		id;
> +	struct xfs_eofblocks	eofb = { 0 };
>  
>  	if (!XFS_IS_QUOTA_RUNNING(mp))
>  		return -ENOSYS;
>  	if (!XFS_IS_QUOTA_ON(mp))
>  		return -ESRCH;
>  
> +	eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
> +	ret = xfs_icache_free_cowblocks(mp, &eofb);
> +	if (ret)
> +		return ret;
> +
>  	id = from_kqid(&init_user_ns, *qid);
>  	ret = xfs_qm_scall_getquota_next(mp, &id, xfs_quota_type(qid->type),
>  			qdq);
> -- 
> 2.9.5
> 
