Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70521ECAAA1
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Nov 2022 00:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiKAAeZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Oct 2022 20:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiKAAeV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Oct 2022 20:34:21 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC50115A29
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 17:34:19 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id z5-20020a17090a8b8500b00210a3a2364fso436296pjn.0
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 17:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QPTCsd0eA+I5KaPEF+DZNzfuYfjq5r3zeLN8iU677T4=;
        b=BUtQZ7nzbn6cI6DNVzSo069FmCM3AST52NoUCQ6PihDGNsgfP/r5BeNhqgdZ8Syoec
         qOqen9E/xi604EjlH/Nw65nTQ+fBezIy7bC1vSgCAM+vm+rUcK86ZHGO1h7bkqQ7ezq4
         4wSh8lOsa2+/tj0xYAi+bdrzaeb1vxbyWua3fzap7FHrcNhSq0WA1MuE/MGTD6a0H08e
         SXtqFDdDgIBY11WpPOMhgYjLTJTmXty+vHV/Ej654qKSwRFsgOJLrH9BgHUkMMu2Bv7W
         dVSgOK0kmQ2YiFsqdZRHn6jQUYRCK89C8O3PN1D6CoMH/dd6kKhi94Y8ts4G+/5o2yx4
         4aAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QPTCsd0eA+I5KaPEF+DZNzfuYfjq5r3zeLN8iU677T4=;
        b=LLkIy4tcl3PBToraK7eHfrlRP3msGeMk3PrQPcVZA1iLjB7jmRd8Fvp6fPuqfgGjPI
         DQQ3VNqIVVcZQxz2ZRSqawtLSdpyAP41w1Ce96qUmLg3tAXWW1JlFrDfRPACkDW3gSYt
         61Ihg3IZgJ9EvHNSnd4zNDgql/ep9ylHg0Slm6QUYLjBuJtlo5sbfZQe4tAJ06Hua4Xs
         9gYtw1IlQ5waFp5aVz4lShM7p8/Rp/E1VNlHEncNP5eAYOf+HUAZlFz2qxLhL2CTwaGE
         VYxwp5Ioz8J/BM+15Bdb9e6PJAQI3UR53m6ryhb6vmFO0qJLwHmeDshT7P3+16RY7pBN
         0XFQ==
X-Gm-Message-State: ACrzQf0d2M3tCqfhxnJ4m6nvkqwbKbx9DAvDIQAkusmnVymFqXPrusTU
        gL79DskqdWVixgoYhrJSm0/FFKRYeLYGbA==
X-Google-Smtp-Source: AMsMyM7d+400J9eughdJc4e1QrBYICtQju6nFmCLwPMMv85b1tskyT99l68rGzu94HWFab6/Atakiw==
X-Received: by 2002:a17:90b:388a:b0:213:d1ce:2592 with SMTP id mu10-20020a17090b388a00b00213d1ce2592mr10777549pjb.53.1667262859158;
        Mon, 31 Oct 2022 17:34:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id b16-20020a170902e95000b00178b06fea7asm5006840pll.148.2022.10.31.17.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 17:34:17 -0700 (PDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1opfEN-008muM-5e; Tue, 01 Nov 2022 11:34:15 +1100
Received: from dave by discord.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1opfEN-00G7de-0T;
        Tue, 01 Nov 2022 11:34:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/7] xfs: use byte ranges for write cleanup ranges
Date:   Tue,  1 Nov 2022 11:34:08 +1100
Message-Id: <20221101003412.3842572-4-david@fromorbit.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221101003412.3842572-1-david@fromorbit.com>
References: <20221101003412.3842572-1-david@fromorbit.com>
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

