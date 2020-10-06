Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38FD0C4363D
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4BFB208C7
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:25:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lctbKH6V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgJFEZI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgJFEZI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 00:25:08 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1C8C0613CE
        for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2020 21:25:08 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y20so590070pll.12
        for <linux-xfs@vger.kernel.org>; Mon, 05 Oct 2020 21:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DniLSi3MwNi5KhwbRV9QeRi6gDS1XS0uft+AB+uYe1o=;
        b=lctbKH6VPnn4Kf9snscDuhE/TQGIQl6HbPKZEsW11lto93WCgxk6/dTaNYIcJopyCx
         uqHdCb7+y9gYk6vx9sKh/RwU/8IyWBxzBFycxtKimAPXD8BdRWaokS+WH4+UnYfdsM5G
         BXzvpcNqpkZBT9RSSmQ3WdyNwN/2Qgai6lBIj6FeUbVc7zTw2QGAzolrczzhahpKVdQm
         V0q6j7yiPVMTwscqki6dIIfXKIk1WCh6MuKhR1113zrawwJzZN/RynYPKHSVeC7RCa3m
         yCoXHzKAVDOZC3D71rUaR8rFQmCxbzUPJU550Sw/RVI7u5f8ZUQ4rBxkfWYNg3a9Trjf
         G5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DniLSi3MwNi5KhwbRV9QeRi6gDS1XS0uft+AB+uYe1o=;
        b=ZGmSa6nliqrT2iPja8sS45VSJNcGecpjFgfKNYkn4nm1eVIkiY9zK/o57iqsLWXVmO
         aSy0pElkCG6Se4J7PXOHsgoZDiidGWtu7GRPtEmUqpOaQ3bwe4Zryn+yiNFLGecCcvjj
         ieUl+R3dYVm3WLwLwO6XvOQJQKjPfygLGMl9jmIowzTFjTAX9j6ih6gooho/VXCfGBtR
         YTVrDYlpZhUZxs3giUF33uvLcJqV0sKo8fmO2Z0pUyOyJriC6k9Htpe91i8r32CQQYxj
         G1DDBloB5hcQSoYd4bQmGKbF6fL6UWJLVJ+RZUrCpFl0i29vwLeJ/dV+eCxnkribZFfa
         GO3g==
X-Gm-Message-State: AOAM531+J926OIMNmuZbSfcOgGB1ou6rep3fcdmBGESTMvMdvZfJu3s/
        BupJrUOtgYE/LYzHC65ratHQ+P1EahQ=
X-Google-Smtp-Source: ABdhPJwYQMVxQKdhV8nW/6dbogFQJx6ocBClutZfAV72iMoUoa4pOkScgRqxf6ZvcXyEHR/AFtIXgw==
X-Received: by 2002:a17:90a:8e82:: with SMTP id f2mr2567222pjo.142.1601958307262;
        Mon, 05 Oct 2020 21:25:07 -0700 (PDT)
Received: from garuda.localnet ([122.167.153.52])
        by smtp.gmail.com with ESMTPSA id c67sm1590162pfa.209.2020.10.05.21.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 21:25:06 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, david@fromorbit.com
Subject: Re: [PATCH V5 12/12] xfs: Introduce error injection to allocate only minlen size extents for files
Date:   Tue, 06 Oct 2020 09:55:03 +0530
Message-ID: <2322881.G0kAUReszQ@garuda>
In-Reply-To: <20201003055633.9379-13-chandanrlinux@gmail.com>
References: <20201003055633.9379-1-chandanrlinux@gmail.com> <20201003055633.9379-13-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 3 October 2020 11:26:33 AM IST Chandan Babu R wrote:
> This commit adds XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag which
> helps userspace test programs to get xfs_bmap_btalloc() to always
> allocate minlen sized extents.
> 
> This is required for test programs which need a guarantee that minlen
> extents allocated for a file do not get merged with their existing
> neighbours in the inode's BMBT. "Inode fork extent overflow check" for
> Directories, Xattrs and extension of realtime inodes need this since the
> file offset at which the extents are being allocated cannot be
> explicitly controlled from userspace.
> 
> One way to use this error tag is to,
> 1. Consume all of the free space by sequentially writing to a file.
> 2. Punch alternate blocks of the file. This causes CNTBT to contain
>    sufficient number of one block sized extent records.
> 3. Inject XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag.
> After step 3, xfs_bmap_btalloc() will issue space allocation
> requests for minlen sized extents only.
> 
> ENOSPC error code is returned to userspace when there aren't any "one
> block sized" extents left in any of the AGs.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c    | 46 ++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_alloc.h    |  1 +
>  fs/xfs/libxfs/xfs_bmap.c     | 26 ++++++++++++++------
>  fs/xfs/libxfs/xfs_errortag.h |  4 +++-
>  fs/xfs/xfs_error.c           |  3 +++
>  5 files changed, 72 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 852b536551b5..d8d8ab1478db 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2473,6 +2473,45 @@ xfs_defer_agfl_block(
>  	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
>  }
>  
> +STATIC int
> +minlen_freespace_available(
> +	struct xfs_alloc_arg	*args,
> +	struct xfs_buf		*agbp,
> +	int			*stat)
> +{
> +	xfs_btree_cur_t		*cnt_cur;
> +	xfs_agblock_t		fbno;
> +	xfs_extlen_t		flen;
> +	int			btree_error = XFS_BTREE_NOERROR;
> +	int			error = 0;
> +
> +	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, agbp,
> +			args->agno, XFS_BTNUM_CNT);
> +	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->minlen, stat);
> +	if (error) {
> +		btree_error = XFS_BTREE_ERROR;
> +		goto out;
> +	}
> +
> +	ASSERT(*stat == 1);
> +
> +	error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, stat);
> +	if (error) {
> +		btree_error = XFS_BTREE_ERROR;
> +		goto out;
> +	}
> +
> +	if (flen == args->minlen)
> +		*stat = 1;
> +	else
> +		*stat = 0;
> +
> +out:
> +	xfs_btree_del_cursor(cnt_cur, btree_error);
> +
> +	return error;
> +}
> +
>  /*
>   * Decide whether to use this allocation group for this allocation.
>   * If so, fix up the btree freelist's size.
> @@ -2490,6 +2529,7 @@ xfs_alloc_fix_freelist(
>  	struct xfs_alloc_arg	targs;	/* local allocation arguments */
>  	xfs_agblock_t		bno;	/* freelist block */
>  	xfs_extlen_t		need;	/* total blocks needed in freelist */
> +	int			i;
>  	int			error = 0;
>  
>  	/* deferred ops (AGFL block frees) require permanent transactions */
> @@ -2544,6 +2584,12 @@ xfs_alloc_fix_freelist(
>  	if (!xfs_alloc_space_available(args, need, flags))
>  		goto out_agbp_relse;
>  
> +	if (args->alloc_minlen_only) {
> +		error = minlen_freespace_available(args, agbp, &i);
> +		if (error || !i)
> +			goto out_agbp_relse;
> +	}
> +
>  	/*
>  	 * Make the freelist shorter if it's too long.
>  	 *
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 6c22b12176b8..1d04089b7fb4 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -75,6 +75,7 @@ typedef struct xfs_alloc_arg {
>  	char		wasfromfl;	/* set if allocation is from freelist */
>  	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
>  	enum xfs_ag_resv_type	resv;	/* block reservation to use */
> +	bool		alloc_minlen_only;
>  } xfs_alloc_arg_t;
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 5156cbd476f2..fab4097e7492 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3510,12 +3510,19 @@ xfs_bmap_btalloc(
>  		ASSERT(ap->length);
>  	}
>  
> +	memset(&args, 0, sizeof(args));
> +
> +	args.alloc_minlen_only = XFS_TEST_ERROR(false, mp,
> +					XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
>  
>  	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
>  	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
>  							ap->tp->t_firstblock);
>  	if (nullfb) {
> -		if ((ap->datatype & XFS_ALLOC_USERDATA) &&
> +		if (args.alloc_minlen_only) {
> +			ag = 0;
> +			ap->blkno = XFS_AGB_TO_FSB(mp, ag, 0);
> +		} else if ((ap->datatype & XFS_ALLOC_USERDATA) &&
>  		    xfs_inode_is_filestream(ap->ip)) {
>  			ag = xfs_filestream_lookup_ag(ap->ip);
>  			ag = (ag != NULLAGNUMBER) ? ag : 0;
> @@ -3523,10 +3530,12 @@ xfs_bmap_btalloc(
>  		} else {
>  			ap->blkno = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
>  		}
> -	} else
> +	} else {
>  		ap->blkno = ap->tp->t_firstblock;
> +	}
>  
> -	xfs_bmap_adjacent(ap);
> +	if (!args.alloc_minlen_only)
> +		xfs_bmap_adjacent(ap);
>  
>  	/*
>  	 * If allowed, use ap->blkno; otherwise must use firstblock since
> @@ -3540,7 +3549,6 @@ xfs_bmap_btalloc(
>  	 * Normal allocation, done through xfs_alloc_vextent.
>  	 */
>  	tryagain = isaligned = 0;
> -	memset(&args, 0, sizeof(args));
>  	args.tp = ap->tp;
>  	args.mp = mp;
>  	args.fsbno = ap->blkno;
> @@ -3549,7 +3557,10 @@ xfs_bmap_btalloc(
>  	/* Trim the allocation back to the maximum an AG can fit. */
>  	args.maxlen = min(ap->length, mp->m_ag_max_usable);
>  	blen = 0;
> -	if (nullfb) {
> +	if (args.alloc_minlen_only) {
> +		args.type = XFS_ALLOCTYPE_START_AG;

The above should have been,

args.type = XFS_ALLOCTYPE_FIRST_AG;

In my experiments, I had introduced a new args.type value and had later
realized that XFS_ALLOCTYPE_FIRST_AG would suffice for my requirements. I had
tested the changed version (which was in my git stash) and forgot to apply
that to this commit after testing was completed. Hence I ended up sending a
slightly stale patch. I am sorry about this. I will resend the series.

-- 
chandan



