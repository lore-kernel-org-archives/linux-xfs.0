Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7272 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbfDQJyf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 Apr 2019 05:54:35 -0400
Date: Wed, 17 Apr 2019 05:54:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: make tr_growdata a permanent transaction
Message-ID: <20190417095429.GA16377@bfoster>
References: <20190417093608.17146-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417093608.17146-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>

On Wed, Apr 17, 2019 at 05:36:08AM -0400, Brian Foster wrote:
> The growdata transaction is used by growfs operations to increase
> the data size of the filesystem. Part of this sequence involves
> extending the size of the last preexisting AG in the fs, if
> necessary. This is implemented by freeing the newly available
> physical range to the AG.
> 
> tr_growdata is not a permanent transaction, however, and block
> allocation transactions must be permanent to handle deferred frees
> of AGFL blocks. If the grow operation extends an existing AG that
> requires AGFL fixing, assert failures occur due to a populated dfops
> list on a non-permanent transaction and the AGFL free does not
> occur. This is reproduced (rarely) by xfs/104.
> 
> Change tr_growdata to a permanent transaction with a default log
> count. This increases initial transaction reservation size, but
> growfs is an infrequent and non-performance critical operation and
> so should have minimal impact. Also add an assert in the block
> allocation path to make this transaction requirement explicit and
> obvious to future callers.
> 
> Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> This is motivated by Darrick's recent xfs/104 failure report[1]. Note
> that I made the assert a bit more explicit than originally suggested
> because I think any transaction that performs block allocation should be
> expected to be able to handle arbitrary AGFL fixups. This survives an
> fstests auto run without any regressions[2] or assert failures.
> 
> Brian
> 
> [1] https://marc.info/?l=linux-xfs&m=155537961822223&w=2
> [2] Note that I was never able to reproduce the original xfs/104
> failure.
> 
>  fs/xfs/libxfs/xfs_alloc.c      | 2 ++
>  fs/xfs/libxfs/xfs_trans_resv.c | 6 +++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index bc3367b8b7bb..e4df1866f949 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2237,6 +2237,8 @@ xfs_alloc_fix_freelist(
>  	xfs_extlen_t		need;	/* total blocks needed in freelist */
>  	int			error = 0;
>  
> +	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> +

Naturally, just after sending this I'm reminded I never went back to
actually audit usage of XFS_ALLOC_FLAG_NOSHRINK. :P NOSHRINK is
currently used in userspace (repair) and scrub. The former is in a place
that looks to me like it already uses a permanent transaction. The
latter is not immediately clear to me. It looks like scrub can alloc
either tr_itruncate, which is permanent, or an empty transaction. The
noshrink call is associated with repair, which I think means we'd have
the permanent transaction (?), but it still might make sense to exclude
NOSHRINK callers from failing the assert in principle. Thoughts?

Brian

>  	if (!pag->pagf_init) {
>  		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
>  		if (error)
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index f99a7aefe418..83f4ee2afc49 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -876,9 +876,13 @@ xfs_trans_resv_calc(
>  	resp->tr_sb.tr_logres = xfs_calc_sb_reservation(mp);
>  	resp->tr_sb.tr_logcount = XFS_DEFAULT_LOG_COUNT;
>  
> +	/* growdata requires permanent res; it can free space to the last AG */
> +	resp->tr_growdata.tr_logres = xfs_calc_growdata_reservation(mp);
> +	resp->tr_growdata.tr_logcount = XFS_DEFAULT_PERM_LOG_COUNT;
> +	resp->tr_growdata.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
>  	/* The following transaction are logged in logical format */
>  	resp->tr_ichange.tr_logres = xfs_calc_ichange_reservation(mp);
> -	resp->tr_growdata.tr_logres = xfs_calc_growdata_reservation(mp);
>  	resp->tr_fsyncts.tr_logres = xfs_calc_swrite_reservation(mp);
>  	resp->tr_writeid.tr_logres = xfs_calc_writeid_reservation(mp);
>  	resp->tr_attrsetrt.tr_logres = xfs_calc_attrsetrt_reservation(mp);
> -- 
> 2.17.2
> 
