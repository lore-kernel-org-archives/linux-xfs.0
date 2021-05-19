Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C416C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53BB96124C
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353441AbhESMks (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 08:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353440AbhESMkr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 08:40:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19833C06175F
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 05:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=P53im0PB84j2ShmE5xmImhFdw/1jUerSXIiJ1pjl1FI=; b=VzDFwCvKC41I6+dquh8CjJvgTK
        lYnFPLxT0Trdbiidzn+9hYTMeU3MPSeT8QZrsJ3T0tl+172LY5UO4TuLMQHJ+6a5IW1/AIWbNXceQ
        lLxpIvJOwVexY4S9N8CCz9WX6Lr+IMxcHEuKkDO6iVIiwpc8qHbd6J4eZtdW1eaDdbFPMstQ1bmum
        byMb87RKH6FjKhqHJK1BZT+LBjXdPH/DNGT/vtOFg0WXhdenRKGsBogDJ7PNSmVBbv0ksu7ZVlzAR
        Zw+7szv6rHTafbFLzskB2V9S85hMY7R40G9Z3ZPO9j5qsxDIhX2TLy0ZjTd3+w/hPHNK9LC8YyuB7
        ZdaV8UxA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ljLSl-00EwOp-G4; Wed, 19 May 2021 12:38:27 +0000
Date:   Wed, 19 May 2021 13:38:11 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Lukas Herbolt <lukas@herbolt.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: Print XFS UUID on mount and umount events.
Message-ID: <YKUGs81af325hy18@infradead.org>
References: <20210519093752.1670018-1-lukas@herbolt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519093752.1670018-1-lukas@herbolt.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 11:37:52AM +0200, Lukas Herbolt wrote:
> As of now only device names are pritend out over __xfs_printk().
> The device names are not persistent across reboots which in case
> of searching for origin of corruption brings another task to properly
> indetify the devices. This patch add XFS UUID upon every mount/umount
> event which will make the identification much easier.

This looks sensible, but please avoid the pointless casts and overly
long lines.  i.e. something like this:

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c19a82adea1edb..2089177168f487 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -572,12 +572,14 @@ xfs_log_mount(
 	int		min_logfsbs;
 
 	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY)) {
-		xfs_notice(mp, "Mounting V%d Filesystem",
-			   XFS_SB_VERSION_NUM(&mp->m_sb));
+		xfs_notice(mp, "Mounting V%d Filesystem %pU",
+			   XFS_SB_VERSION_NUM(&mp->m_sb),
+			   &mp->m_sb.sb_uuid);
 	} else {
 		xfs_notice(mp,
-"Mounting V%d filesystem in no-recovery mode. Filesystem will be inconsistent.",
-			   XFS_SB_VERSION_NUM(&mp->m_sb));
+"Mounting V%d filesystem %pU in no-recovery mode. Filesystem will be inconsistent.",
+			   XFS_SB_VERSION_NUM(&mp->m_sb),
+			   &mp->m_sb.sb_uuid);
 		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
 	}
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f7f70438d98703..fa4589d391a892 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1043,7 +1043,7 @@ xfs_fs_put_super(
 	if (!sb->s_fs_info)
 		return;
 
-	xfs_notice(mp, "Unmounting Filesystem");
+	xfs_notice(mp, "Unmounting Filesystem %pU", &mp->m_sb.sb_uuid);
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
 
