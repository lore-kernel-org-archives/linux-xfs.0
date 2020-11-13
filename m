Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE0CC388F9
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 06:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F3DE20B80
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 06:35:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YnSxouKV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgKMGfg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 01:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgKMGfg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 01:35:36 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D92EC0613D1
        for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2020 22:35:36 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id r186so6332444pgr.0
        for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2020 22:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G2ItJLPaySVH8yVL8bt4nFpt+dWdcU41XH8LeTZ6RtI=;
        b=YnSxouKVRWW6FhntFHLlxer06PmRTYUlnNX/y0SWaVdt9gZR/Vpn5pobIhtVuynio0
         oOkjqEWSBfln4SUtGLid9kxWaDoSK3rC3Z2l1eoZjrWFTqlxl1B7PItu5hH0dOjfPlt2
         stvpNCATldLnizqwdlPjmZgRFkV3y76wUt7pcz83KlZWOPxew1luWQBdloMLse6KAbY0
         uQnHuwKg5sqhKeIGTQfQFwXQhxi8cdbAtO70ik/OY3nKAiJ6sAa+t3OZnjbneaKOUPSh
         ZtTSjc4HXdQP9MX4SoXiHsSDnhBK1PGwZAH78XDTq5WS4ucFqwp93pOfoxWVJaoyWALk
         LObg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G2ItJLPaySVH8yVL8bt4nFpt+dWdcU41XH8LeTZ6RtI=;
        b=Bzd46OTALVi3PQR5Jf/l2LpnY6SEqIq59F0pxb5R9YwxhL3W00Z7ysa54zmVJ9qAfn
         Ylg7FUWvT8jxj533snxLKzfk1r+64Jlw9ArOIJNbCSSz79oCYBfYV5dPedsfxMvpuNgw
         taQZFE480LDaI63vlVm1wVbZ8S/gTepC7l9JdT9lYUehcF1Kb73OnOVYR+CcqRYsnWTF
         k4pzQ3BHmil+E21UJvTmJ7ScceJrbDg12RVvpIS/WuWaakwuMBI+2MpfD6N91/U4akYA
         MaqIAysAlASLAeuWLZteIuJstuG3vgLTvQ5awKo3yhAcDVjjMaEpx5rqowpOOrReqsJY
         sTBQ==
X-Gm-Message-State: AOAM531OxAibgNTJ6XGLK3rKm+68fLVe7n408pCEKMKfjbDFlV1PivQO
        ddfUUOxOh4atvDYupDBfzEKBV09HXbo=
X-Google-Smtp-Source: ABdhPJx+0eWFi17AdjYKKrm7xcXlfV4cpmQ5qlLgpxXHuxtSwGSgmaggTylCb1h+8hxABosbs7+oFg==
X-Received: by 2002:a17:90a:ce88:: with SMTP id g8mr1226714pju.75.1605249335671;
        Thu, 12 Nov 2020 22:35:35 -0800 (PST)
Received: from garuda.localnet ([122.172.185.167])
        by smtp.gmail.com with ESMTPSA id l9sm812275pjj.28.2020.11.12.22.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 22:35:35 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/4] xfs: fix the minrecs logic when dealing with inode root child blocks
Date:   Fri, 13 Nov 2020 12:05:32 +0530
Message-ID: <1911194.Ks6Zr3F47T@garuda>
In-Reply-To: <160494586556.772802.12631379595730474933.stgit@magnolia>
References: <160494585293.772802.13326482733013279072.stgit@magnolia> <160494586556.772802.12631379595730474933.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 9 November 2020 11:47:45 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The comment and logic in xchk_btree_check_minrecs for dealing with
> inode-rooted btrees isn't quite correct.  While the direct children of
> the inode root are allowed to have fewer records than what would
> normally be allowed for a regular ondisk btree block, this is only true
> if there is only one child block and the number of records don't fit in
> the inode root.
>

The code changes are consistent with rules provided in the comments.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Fixes: 08a3a692ef58 ("xfs: btree scrub should check minrecs")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/btree.c |   45 +++++++++++++++++++++++++++------------------
>  1 file changed, 27 insertions(+), 18 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index f52a7b8256f9..debf392e0515 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -452,32 +452,41 @@ xchk_btree_check_minrecs(
>  	int			level,
>  	struct xfs_btree_block	*block)
>  {
> -	unsigned int		numrecs;
> -	int			ok_level;
> -
> -	numrecs = be16_to_cpu(block->bb_numrecs);
> +	struct xfs_btree_cur	*cur = bs->cur;
> +	unsigned int		root_level = cur->bc_nlevels - 1;
> +	unsigned int		numrecs = be16_to_cpu(block->bb_numrecs);
>  
>  	/* More records than minrecs means the block is ok. */
> -	if (numrecs >= bs->cur->bc_ops->get_minrecs(bs->cur, level))
> +	if (numrecs >= cur->bc_ops->get_minrecs(cur, level))
>  		return;
>  
>  	/*
> -	 * Certain btree blocks /can/ have fewer than minrecs records.  Any
> -	 * level greater than or equal to the level of the highest dedicated
> -	 * btree block are allowed to violate this constraint.
> -	 *
> -	 * For a btree rooted in a block, the btree root can have fewer than
> -	 * minrecs records.  If the btree is rooted in an inode and does not
> -	 * store records in the root, the direct children of the root and the
> -	 * root itself can have fewer than minrecs records.
> +	 * For btrees rooted in the inode, it's possible that the root block
> +	 * contents spilled into a regular ondisk block because there wasn't
> +	 * enough space in the inode root.  The number of records in that
> +	 * child block might be less than the standard minrecs, but that's ok
> +	 * provided that there's only one direct child of the root.
>  	 */
> -	ok_level = bs->cur->bc_nlevels - 1;
> -	if (bs->cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
> -		ok_level--;
> -	if (level >= ok_level)
> +	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
> +	    level == cur->bc_nlevels - 2) {
> +		struct xfs_btree_block	*root_block;
> +		struct xfs_buf		*root_bp;
> +		int			root_maxrecs;
> +
> +		root_block = xfs_btree_get_block(cur, root_level, &root_bp);
> +		root_maxrecs = cur->bc_ops->get_dmaxrecs(cur, root_level);
> +		if (be16_to_cpu(root_block->bb_numrecs) != 1 ||
> +		    numrecs <= root_maxrecs)
> +			xchk_btree_set_corrupt(bs->sc, cur, level);
>  		return;
> +	}
>  
> -	xchk_btree_set_corrupt(bs->sc, bs->cur, level);
> +	/*
> +	 * Otherwise, only the root level is allowed to have fewer than minrecs
> +	 * records or keyptrs.
> +	 */
> +	if (level < root_level)
> +		xchk_btree_set_corrupt(bs->sc, cur, level);
>  }
>  
>  /*
> 
> 


-- 
chandan



