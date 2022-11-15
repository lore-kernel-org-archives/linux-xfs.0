Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF2CC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Nov 2022 01:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiKOBbU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Nov 2022 20:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiKOBbD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2022 20:31:03 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6EC6316
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 17:30:51 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id l6so11986030pjj.0
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 17:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QPTCsd0eA+I5KaPEF+DZNzfuYfjq5r3zeLN8iU677T4=;
        b=eihiAlIsgjvCrNWa8JrS6H38mJ/UEoAacjHim7UhA+iAtxVhj24acVvGLzOVkiRJbA
         yLhiOLQBwe/tLqyoQCcl/1apHj/a8UcPcGuoi1W0mBNwxqDAbS/XaiOFQC/6xqA2KDfx
         ZA0Xu3/BdVL1dShgBtAz5cm5jDnLtErIaIYZk/tS2qsk3CwcEq1gm67lMq5Kpa3NaDR+
         2OxgvL14stpxuNJtUUfVpkc3/ncy5xe0kNDEOL28Js6dAiFrlRXweXJosvUJ9Ll6a5sH
         wvI9K4UdubwtjJUlWCn+/zaWf6SKm5vLUio70lOs/argYADx4yb1Lg+ZhI2Hoy34go91
         W9Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QPTCsd0eA+I5KaPEF+DZNzfuYfjq5r3zeLN8iU677T4=;
        b=fty7Mo88aJOKb10/azCnceD2dIeEp4BrJyqao2euqoPUetp40TzfmXh/nPILvuMleR
         mg4ESs1lzdXl56pZdxuqPryjxmG+ayZ/zT4dqG8Wak0nCUzZw7DCm9p3Ig60aVrvSKJq
         qJR7+/D3y1ZeXZ1QuJrWakvyaSwuOSuAbI5Vg7Yv9YlozmpCLOepa+uLyKq5uL6y1Jmo
         tS+TyiCGHH9Mv3uulcrDNrbn6qPeANtfLXUquaHA9p19QnETH9JXgCaAPILENCPMPgNE
         SLRpGcxnISyzJTeBrqeYWoURKvdLs/90/LslCHX7CzB6KOUXVw7Sa/IH/m4mju/YIGaT
         COCA==
X-Gm-Message-State: ANoB5pn7N/+SfygosbWfnM/hwd/8kIZZC1Vd+A6ikHCmiSoe3H5iRrva
        0Usrb4ebtXIsUXJfWcFXDDNWksxa8D4F7A==
X-Google-Smtp-Source: AA0mqf5iWxCgy606h4XYwR+zCca2X+upA7f7ZysX/ph9qzrPhhq0LQOr3GgGIzJnWppkUwPp7JATGw==
X-Received: by 2002:a17:902:b48d:b0:188:b8cf:85b with SMTP id y13-20020a170902b48d00b00188b8cf085bmr1696179plr.126.1668475851202;
        Mon, 14 Nov 2022 17:30:51 -0800 (PST)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id 34-20020a630d62000000b0046feca0883fsm6457285pgn.64.2022.11.14.17.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 17:30:50 -0800 (PST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oukmj-00EKFy-Bv; Tue, 15 Nov 2022 12:30:45 +1100
Received: from dave by discord.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1oukmj-001VpQ-15;
        Tue, 15 Nov 2022 12:30:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 4/9] xfs: use byte ranges for write cleanup ranges
Date:   Tue, 15 Nov 2022 12:30:38 +1100
Message-Id: <20221115013043.360610-5-david@fromorbit.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221115013043.360610-1-david@fromorbit.com>
References: <20221115013043.360610-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_buffered_write_iomap_end() currently converts the byte ranges
passed to it to filesystem blocks to pass them to the bmap code to
punch out delalloc blocks, but then has to convert filesytem
blocks back to byte ranges for page cache truncate.

We're about to make the page cache truncate go away and replace it
with a page cache walk, so having to convert everything to/from/to
filesystem blocks is messy and error-prone. It is much easier to
pass around byte ranges and convert to page indexes and/or
filesystem blocks only where those units are needed.

In preparation for the page cache walk being added, add a helper
that converts byte ranges to filesystem blocks and calls
xfs_bmap_punch_delalloc_range() and convert
xfs_buffered_write_iomap_end() to calculate limits in byte ranges.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iomap.c | 40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index a2e45ea1b0cb..7bb55dbc19d3 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1120,6 +1120,20 @@ xfs_buffered_write_iomap_begin(
 	return error;
 }
 
+static int
+xfs_buffered_write_delalloc_punch(
+	struct inode		*inode,
+	loff_t			start_byte,
+	loff_t			end_byte)
+{
+	struct xfs_mount	*mp = XFS_M(inode->i_sb);
+	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, start_byte);
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end_byte);
+
+	return xfs_bmap_punch_delalloc_range(XFS_I(inode), start_fsb,
+				end_fsb - start_fsb);
+}
+
 static int
 xfs_buffered_write_iomap_end(
 	struct inode		*inode,
@@ -1129,10 +1143,9 @@ xfs_buffered_write_iomap_end(
 	unsigned		flags,
 	struct iomap		*iomap)
 {
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_fileoff_t		start_fsb;
-	xfs_fileoff_t		end_fsb;
+	struct xfs_mount	*mp = XFS_M(inode->i_sb);
+	loff_t			start_byte;
+	loff_t			end_byte;
 	int			error = 0;
 
 	if (iomap->type != IOMAP_DELALLOC)
@@ -1157,13 +1170,13 @@ xfs_buffered_write_iomap_end(
 	 * the range.
 	 */
 	if (unlikely(!written))
-		start_fsb = XFS_B_TO_FSBT(mp, offset);
+		start_byte = round_down(offset, mp->m_sb.sb_blocksize);
 	else
-		start_fsb = XFS_B_TO_FSB(mp, offset + written);
-	end_fsb = XFS_B_TO_FSB(mp, offset + length);
+		start_byte = round_up(offset + written, mp->m_sb.sb_blocksize);
+	end_byte = round_up(offset + length, mp->m_sb.sb_blocksize);
 
 	/* Nothing to do if we've written the entire delalloc extent */
-	if (start_fsb >= end_fsb)
+	if (start_byte >= end_byte)
 		return 0;
 
 	/*
@@ -1173,15 +1186,12 @@ xfs_buffered_write_iomap_end(
 	 * leave dirty pages with no space reservation in the cache.
 	 */
 	filemap_invalidate_lock(inode->i_mapping);
-	truncate_pagecache_range(VFS_I(ip), XFS_FSB_TO_B(mp, start_fsb),
-				 XFS_FSB_TO_B(mp, end_fsb) - 1);
-
-	error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
-				       end_fsb - start_fsb);
+	truncate_pagecache_range(inode, start_byte, end_byte - 1);
+	error = xfs_buffered_write_delalloc_punch(inode, start_byte, end_byte);
 	filemap_invalidate_unlock(inode->i_mapping);
 	if (error && !xfs_is_shutdown(mp)) {
-		xfs_alert(mp, "%s: unable to clean up ino %lld",
-			__func__, ip->i_ino);
+		xfs_alert(mp, "%s: unable to clean up ino 0x%llx",
+			__func__, XFS_I(inode)->i_ino);
 		return error;
 	}
 	return 0;
-- 
2.37.2

