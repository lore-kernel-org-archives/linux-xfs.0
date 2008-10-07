Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Oct 2008 21:49:43 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m974ncAB028244
	for <xfs@oss.sgi.com>; Mon, 6 Oct 2008 21:49:39 -0700
Message-ID: <48EAEADD.7030602@sgi.com>
Date: Tue, 07 Oct 2008 15:51:41 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [REVIEW] Fix two mkfs.xfs bugs
References: <op.uib222cq3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.uib222cq3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Barry Naujok wrote:
> #1. -i maxpct option is not honoured (or ever used).

Looks good Barry.

Don

> 
> 
> Index: xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c
> ===================================================================
> --- xfs-cmds.orig/xfsprogs/mkfs/xfs_mkfs.c
> +++ xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c
> @@ -1808,6 +1808,9 @@ _("size %s specified for log subvolume i
> 
>      validate_ag_geometry(blocklog, dblocks, agsize, agcount);
> 
> +    if (!imflag)
> +        imaxpct = calc_default_imaxpct(blocklog, dblocks);
> +
>      if (!nodsflag) {
>          if (dsunit) {
>              if (xlv_dsunit && xlv_dsunit != dsunit) {
> @@ -2023,8 +2026,7 @@ an AG size that is one stripe unit small
>             "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
>              dfile, isize, (long long)agcount, (long long)agsize,
>              "", sectorsize, attrversion,
> -            "", blocksize, (long long)dblocks,
> -                   calc_default_imaxpct(blocklog, dblocks),
> +            "", blocksize, (long long)dblocks, imaxpct,
>              "", dsunit, dswidth,
>              dirversion, dirblocksize, nci,
>              logfile, 1 << blocklog, (long long)logblocks,
> @@ -2061,7 +2063,7 @@ an AG size that is one stripe unit small
>          (__uint8_t)(rtextents ?
>              libxfs_highbit32((unsigned int)rtextents) : 0);
>      sbp->sb_inprogress = 1;    /* mkfs is in progress */
> -    sbp->sb_imax_pct = calc_default_imaxpct(blocklog, dblocks);
> +    sbp->sb_imax_pct = imaxpct;
>      sbp->sb_icount = 0;
>      sbp->sb_ifree = 0;
>      sbp->sb_fdblocks = dblocks - agcount * XFS_PREALLOC_BLOCKS(mp) -
> 
> 
> ===================================================================
> 
> #2. If specifying a custom AG count (-d agcount) with stripe unit and
>     the calculated AG size from the AG count is not stripe unit aligned,
>     it refused to adjust the AG size and make the filesystem.
> 
>     The final geometry check is also moved after the sunit adjustments
>     might have been made.
> 
> 
> Index: xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c
> ===================================================================
> --- xfs-cmds.orig/xfsprogs/mkfs/xfs_mkfs.c
> +++ xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c
> @@ -1795,22 +1795,6 @@ _("size %s specified for log subvolume i
>          calc_default_ag_geometry(blocklog, dblocks,
>                  xlv_dsunit | xlv_dswidth, &agsize, &agcount);
> 
> -    /*
> -     * If the last AG is too small, reduce the filesystem size
> -     * and drop the blocks.
> -     */
> -    if ( dblocks % agsize != 0 &&
> -         (dblocks % agsize < XFS_AG_MIN_BLOCKS(blocklog))) {
> -        dblocks = (xfs_drfsbno_t)((agcount - 1) * agsize);
> -        agcount--;
> -        ASSERT(agcount != 0);
> -    }
> -
> -    validate_ag_geometry(blocklog, dblocks, agsize, agcount);
> -
> -    if (!imflag)
> -        imaxpct = calc_default_imaxpct(blocklog, dblocks);
> -
>      if (!nodsflag) {
>          if (dsunit) {
>              if (xlv_dsunit && xlv_dsunit != dsunit) {
> @@ -1861,13 +1845,14 @@ _("size %s specified for log subvolume i
>               */
>              if (tmp_agsize > XFS_AG_MAX_BLOCKS(blocklog))
>                  tmp_agsize = ((agsize) / dsunit) * dsunit;
> +
>              if ((tmp_agsize >= XFS_AG_MIN_BLOCKS(blocklog)) &&
> -                (tmp_agsize <= XFS_AG_MAX_BLOCKS(blocklog)) &&
> -                !daflag) {
> +                (tmp_agsize <= XFS_AG_MAX_BLOCKS(blocklog))) {
>                  agsize = tmp_agsize;
> -                agcount = dblocks/agsize +
> +                if (!daflag)
> +                    agcount = dblocks/agsize +
>                          (dblocks % agsize != 0);
> -                if (dasize || daflag)
> +                if (dasize)
>                      fprintf(stderr,
>                  _("agsize rounded to %lld, swidth = %d\n"),
>                          (long long)agsize, dswidth);
> @@ -1932,6 +1917,23 @@ an AG size that is one stripe unit small
>      }
> 
>      /*
> +     * If the last AG is too small, reduce the filesystem size
> +     * and drop the blocks.
> +     */
> +    if ( dblocks % agsize != 0 &&
> +         (dblocks % agsize < XFS_AG_MIN_BLOCKS(blocklog))) {
> +        ASSERT(!daflag);
> +        dblocks = (xfs_drfsbno_t)((agcount - 1) * agsize);
> +        agcount--;
> +        ASSERT(agcount != 0);
> +    }
> +
> +    validate_ag_geometry(blocklog, dblocks, agsize, agcount);
> +
> +    if (!imflag)
> +        imaxpct = calc_default_imaxpct(blocklog, dblocks);
> +
> +    /*
>       * check that log sunit is modulo fsblksize or default it to dsunit.
>       */
> 
