Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C908C43457
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 13:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D17FB2076A
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 13:18:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q2vCVc0e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgFVNSt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 09:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbgFVNSt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 09:18:49 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBA6C061573
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 06:18:48 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id j4so7569516plk.3
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 06:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nju38/nD0ZWzpncd98pRXh36Sqs5pPMMg6OR8BVTPLM=;
        b=q2vCVc0e0pOD0uuxsI9frvjQoayC5Zbnq6Lx0usuSZft95Y9Ghl++IDr8CcOdz5ngD
         OaPNDfpt5U6uV19jT9h5e3OsUiM9rcM3DM3CR45dK1RQI7nkpAWGLeQKTM9GamiXFiC7
         3j/U3yeZ9/3qBiALQ7RyqElf/sd478wyqXljuxy3ZpzxCIxlmFB51dr6RZrzRFCi6kfu
         KS23j0rX6aEdWqY8wWM+Wf0KishoeiuQsUCrpVKrTsXYUzohLpHSVU5B7X56EZ/cz7PB
         uDQvuA6UfngqjqZHogGBxGZmzN7i89e7rJgQNjuEDNDWlYBkc/0MXFqG0lL3rgEUn+nK
         jNvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nju38/nD0ZWzpncd98pRXh36Sqs5pPMMg6OR8BVTPLM=;
        b=sSTt3IwYIvo8BUWCk1dgHy73TZg7X1o4XPVLTWDQF6YdS9CSz0fKhTdQS9pRf+MD3h
         24YP2Z1l9IPrpgfy7yyn6cdNR1vF+x+4tPFLtgV4f/Y5aP4JtthHqcu8xrLTiio8CZx/
         N9SAfMbrWFLFFmeq1ICeJqH/NqeOdXbXQUQRJFOYz39umDPOfwO0eOSzCDW9HUw6Dwws
         WOozZorbCquvq5FTYC/o3bhtSfcCKhLrlTCnR28L61xZGyYRtszZ3Clnf/DtCqQIIvw7
         tb/K7hi7FHlws07tvsSdWb5FVOiICYRIQmHID75O4LWTBBcx70miWqJZqqEluetWP8V9
         jFoA==
X-Gm-Message-State: AOAM53331UHCilkdAIe/AwwcqTWwpQTM0A4Nq59eBnnTtxDgWT/weKng
        6SuPBGi+icKx27VYlS1CU94=
X-Google-Smtp-Source: ABdhPJyTHJ2zj/0c9AnpgzuNI8kruni8GfX94KOGXYHU7gxpRUpmfvHAWYkk5wuPcrGwv1KoOoOAjA==
X-Received: by 2002:a17:90a:8c14:: with SMTP id a20mr18208557pjo.83.1592831928081;
        Mon, 22 Jun 2020 06:18:48 -0700 (PDT)
Received: from garuda.localnet ([122.179.34.42])
        by smtp.gmail.com with ESMTPSA id p5sm14721248pfg.162.2020.06.22.06.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 06:18:47 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/15] xfs: move the di_dmstate field to struct xfs_inode
Date:   Mon, 22 Jun 2020 18:48:45 +0530
Message-ID: <31233967.Z9G6PBBfjt@garuda>
In-Reply-To: <20200620071102.462554-16-hch@lst.de>
References: <20200620071102.462554-1-hch@lst.de> <20200620071102.462554-16-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 20 June 2020 12:41:02 PM IST Christoph Hellwig wrote:
> Move the di_dmstate into struct xfs_inode, and thus finally kill of
> the xfs_icdinode structure.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c |  6 ++----
>  fs/xfs/libxfs/xfs_inode_buf.h | 10 ----------
>  fs/xfs/xfs_inode.c            |  2 +-
>  fs/xfs/xfs_inode.h            |  3 +--
>  fs/xfs/xfs_inode_item.c       |  3 +--
>  fs/xfs/xfs_itable.c           |  3 ---
>  6 files changed, 5 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index d361803102d0e1..e4e96a47e0bab6 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -185,7 +185,6 @@ xfs_inode_from_disk(
>  	struct xfs_inode	*ip,
>  	struct xfs_dinode	*from)
>  {
> -	struct xfs_icdinode	*to = &ip->i_d;
>  	struct inode		*inode = VFS_I(ip);
>  	int			error;
>  	xfs_failaddr_t		fa;
> @@ -247,7 +246,7 @@ xfs_inode_from_disk(
>  	ip->i_extsize = be32_to_cpu(from->di_extsize);
>  	ip->i_forkoff = from->di_forkoff;
>  	ip->i_dmevmask	= be32_to_cpu(from->di_dmevmask);
> -	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
> +	ip->i_dmstate	= be16_to_cpu(from->di_dmstate);
>  	ip->i_diflags	= be16_to_cpu(from->di_flags);
>  
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
> @@ -282,7 +281,6 @@ xfs_inode_to_disk(
>  	struct xfs_dinode	*to,
>  	xfs_lsn_t		lsn)
>  {
> -	struct xfs_icdinode	*from = &ip->i_d;
>  	struct inode		*inode = VFS_I(ip);
>  
>  	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> @@ -313,7 +311,7 @@ xfs_inode_to_disk(
>  	to->di_forkoff = ip->i_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
>  	to->di_dmevmask = cpu_to_be32(ip->i_dmevmask);
> -	to->di_dmstate = cpu_to_be16(from->di_dmstate);
> +	to->di_dmstate = cpu_to_be16(ip->i_dmstate);
>  	to->di_flags = cpu_to_be16(ip->i_diflags);
>  
>  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 0cfc1aaff6c6f3..834c8b3e917370 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -9,16 +9,6 @@
>  struct xfs_inode;
>  struct xfs_dinode;
>  
> -/*
> - * In memory representation of the XFS inode. This is held in the in-core struct
> - * xfs_inode and represents the current on disk values but the structure is not
> - * in on-disk format.  That is, this structure is always translated to on-disk
> - * format specific structures at the appropriate time.
> - */
> -struct xfs_icdinode {
> -	uint16_t	di_dmstate;	/* DMIG state info */
> -};
> -
>  /*
>   * Inode location information.  Stored in the inode and passed to
>   * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index db48c910c8d7b0..79436ed0b14e89 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -834,7 +834,7 @@ xfs_ialloc(
>  
>  	ip->i_extsize = 0;
>  	ip->i_dmevmask = 0;
> -	ip->i_d.di_dmstate = 0;
> +	ip->i_dmstate = 0;
>  	ip->i_diflags = 0;
>  
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index e64df2e7438aa0..f0537ead8bad90 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -68,8 +68,7 @@ typedef struct xfs_inode {
>  	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
>  	struct timespec64	i_crtime;	/* time created */
>  	uint32_t		i_dmevmask;	/* DMIG event mask */
> -
> -	struct xfs_icdinode	i_d;		/* most of ondisk inode */
> +	uint16_t		i_dmstate;	/* DMIG state info */
>  
>  	/* VFS inode */
>  	struct inode		i_vnode;	/* embedded VFS inode */
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 9b7860025c497d..628f8190abddca 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -301,7 +301,6 @@ xfs_inode_to_log_dinode(
>  	struct xfs_log_dinode	*to,
>  	xfs_lsn_t		lsn)
>  {
> -	struct xfs_icdinode	*from = &ip->i_d;
>  	struct inode		*inode = VFS_I(ip);
>  
>  	to->di_magic = XFS_DINODE_MAGIC;
> @@ -331,7 +330,7 @@ xfs_inode_to_log_dinode(
>  	to->di_forkoff = ip->i_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
>  	to->di_dmevmask = ip->i_dmevmask;
> -	to->di_dmstate = from->di_dmstate;
> +	to->di_dmstate = ip->i_dmstate;
>  	to->di_flags = ip->i_diflags;
>  
>  	/* log a dummy value to ensure log structure is fully initialised */
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 7945c6c4844940..cd1f09e57b9483 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -58,7 +58,6 @@ xfs_bulkstat_one_int(
>  	xfs_ino_t		ino,
>  	struct xfs_bstat_chunk	*bc)
>  {
> -	struct xfs_icdinode	*dic;		/* dinode core info pointer */
>  	struct xfs_inode	*ip;		/* incore inode pointer */
>  	struct inode		*inode;
>  	struct xfs_bulkstat	*buf = bc->buf;
> @@ -79,8 +78,6 @@ xfs_bulkstat_one_int(
>  	ASSERT(ip->i_imap.im_blkno != 0);
>  	inode = VFS_I(ip);
>  
> -	dic = &ip->i_d;
> -
>  	/* xfs_iget returns the following without needing
>  	 * further change.
>  	 */
> 


-- 
chandan



