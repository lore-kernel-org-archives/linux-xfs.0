Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A88EC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 08:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20ECC60FA0
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 08:24:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbhG1IYU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 04:24:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35734 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235091AbhG1IYT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jul 2021 04:24:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627460656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LNrpHRQFsRWtZYhNoQG8aHSM9mON8qWOD0qd3b274WU=;
        b=UHj8ehLk7dr2iCIkm616cmivD+f4fWBWHoT694dvKJ4jTuodPKaVeFEe+s+fnZUvHUYNHx
        wLzJ+a9Ao9DheWGltguvXIzptFPurQDDyctsfvsm9R5FSBsVQNJF1WhCzswGhzXKfHeu+T
        nT+gEcOKxWJzO+MKWWG8nQBq5LECv7g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-SapczHHfN_yK6X66VBvvOA-1; Wed, 28 Jul 2021 04:24:14 -0400
X-MC-Unique: SapczHHfN_yK6X66VBvvOA-1
Received: by mail-wm1-f69.google.com with SMTP id g187-20020a1c20c40000b02902458d430db6so142160wmg.9
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jul 2021 01:24:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=LNrpHRQFsRWtZYhNoQG8aHSM9mON8qWOD0qd3b274WU=;
        b=AqCzR5nXL+8BPRFahaTa9hjDZQwGsgQvOP3ACn51hJsw2QtcVJACEDxF/XB0lp3pbl
         iGmNyN14iQaUwgjko2QboNSLbi9ZT2OuxfzFbm/Y2YTBYpTx7ZSRw0TXOpoQjD2Tea7U
         FughL1BCsQ6Akq+DQY01dFMRAObN3WREogVjRd/+7C7ZyyijXnNZFov8/bFN4G1AEhZ6
         Wwirm54B7heuYJCdh0KeUzCgz8lsYGBbCq7kUWe97LVbPcNPKO0UAbU/vM96XwkL+ie7
         KPnY47uMhFoHIFiD4fX01KOdymq1TK1IxvsQx96eaXKrc8AZzhf7M83R+1nWPSAma3Mo
         rVWQ==
X-Gm-Message-State: AOAM533FrSEm97uzvdIVVUtIEX63B5s6NCwbzg6sVBLaC3zu1Je3zdpi
        ITIv5Rrp5OHx+BZ6D4OsSvsqz8dAasdP6H6LDYbFMDMMNbpqT4bw+xQ0nwUbApHMJ2LFH1zU6kK
        g9wt7tiBFrHGG1vwbsxW2
X-Received: by 2002:a5d:63d1:: with SMTP id c17mr24506091wrw.328.1627460653565;
        Wed, 28 Jul 2021 01:24:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYmASOqV99s+nK2sgUeLzzfzEwEA7WdB94bzo14cozil0gxJHlPuqDkdgFW2I1Egg3kAoDRA==
X-Received: by 2002:a5d:63d1:: with SMTP id c17mr24506070wrw.328.1627460653347;
        Wed, 28 Jul 2021 01:24:13 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id h14sm2214254wrp.55.2021.07.28.01.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 01:24:12 -0700 (PDT)
Date:   Wed, 28 Jul 2021 10:24:11 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: prevent spoofing of rtbitmap blocks when recovering
 buffers
Message-ID: <20210728082411.35726k6okjg7nk6i@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210727235641.GA559212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727235641.GA559212@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 27, 2021 at 04:56:41PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While reviewing the buffer item recovery code, the thought occurred to
> me: in V5 filesystems we use log sequence number (LSN) tracking to avoid
> replaying older metadata updates against newer log items.  However, we
> use the magic number of the ondisk buffer to find the LSN of the ondisk
> metadata, which means that if an attacker can control the layout of the
> realtime device precisely enough that the start of an rt bitmap block
> matches the magic and UUID of some other kind of block, they can control
> the purported LSN of that spoofed block and thereby break log replay.
> 
> Since realtime bitmap and summary blocks don't have headers at all, we
> have no way to tell if a block really should be replayed.  The best we
> can do is replay unconditionally and hope for the best.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> ---
>  fs/xfs/xfs_buf_item_recover.c |   14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 05fd816edf59..4775485b4062 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -698,7 +698,8 @@ xlog_recover_do_inode_buffer(
>  static xfs_lsn_t
>  xlog_recover_get_buf_lsn(
>  	struct xfs_mount	*mp,
> -	struct xfs_buf		*bp)
> +	struct xfs_buf		*bp,
> +	struct xfs_buf_log_format *buf_f)
>  {
>  	uint32_t		magic32;
>  	uint16_t		magic16;
> @@ -706,11 +707,20 @@ xlog_recover_get_buf_lsn(
>  	void			*blk = bp->b_addr;
>  	uuid_t			*uuid;
>  	xfs_lsn_t		lsn = -1;
> +	uint16_t		blft;
>  
>  	/* v4 filesystems always recover immediately */
>  	if (!xfs_sb_version_hascrc(&mp->m_sb))
>  		goto recover_immediately;
>  
> +	/*
> +	 * realtime bitmap and summary file blocks do not have magic numbers or
> +	 * UUIDs, so we must recover them immediately.
> +	 */
> +	blft = xfs_blft_from_flags(buf_f);
> +	if (blft == XFS_BLFT_RTBITMAP_BUF || blft == XFS_BLFT_RTSUMMARY_BUF)
> +		goto recover_immediately;
> +
>  	magic32 = be32_to_cpu(*(__be32 *)blk);
>  	switch (magic32) {
>  	case XFS_ABTB_CRC_MAGIC:
> @@ -920,7 +930,7 @@ xlog_recover_buf_commit_pass2(
>  	 * the verifier will be reset to match whatever recover turns that
>  	 * buffer into.
>  	 */
> -	lsn = xlog_recover_get_buf_lsn(mp, bp);
> +	lsn = xlog_recover_get_buf_lsn(mp, bp, buf_f);
>  	if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
>  		trace_xfs_log_recover_buf_skip(log, buf_f);
>  		xlog_recover_validate_buf_type(mp, bp, buf_f, NULLCOMMITLSN);
> 

-- 
Carlos

