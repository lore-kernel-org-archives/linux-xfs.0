Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBD5C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Nov 2022 05:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbiKWF62 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Nov 2022 00:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235552AbiKWF6V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2022 00:58:21 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944A2D2352
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 21:58:19 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id y10so14544809plp.3
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 21:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aO/cv4YV2OVecAaYjInPMlsbv9t1F4p45l8FdZlzeH0=;
        b=7zKMkUmxxck9sYt8qCN8HACcp4QafN3Aly4PN6cDaD9Ar10bg8ATXok1nCUtdccfZh
         z71uDb/tOQwdSGqge3Kl1jTG1eZcWyrQmN66xtuhCxsbImMFwpAJE7qaBn2wJ54+0fCU
         ujqUe5XJsbympJGJUt0P/DjtYnJQTG23AnMNYyc7JN/GM9valeDPfBlxz4ntJ1D63kET
         Trrgzz4uCfdmuOZKyvw3I1aRGpYYsz62JCvPU0reO26FbhNi+LMtYW6FENE1joDJ4w6H
         /6HRoWYMy9nFS0tymsb6qGCUbVIuLpRadgLjIkk4iNlGj/d7a2AUe+bQ9QrEb1tDSBN8
         UD6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aO/cv4YV2OVecAaYjInPMlsbv9t1F4p45l8FdZlzeH0=;
        b=KYmv50QN6Z4Lgzikq1sLfRR5jZnpy/R9Kv6fUgHdHmF1Pr/5hc++KYlzdfr7O7X0Gk
         DyBYF0SeayRBZ4b4i5sKxexyp0HXSJ7MASYlnUqKk2VAaPZY9RgQiET11f2d1Ub42C5c
         yI+uOXfOT8egIC+mIsqmWwzPJ+OX6gOuZ/d/3kqfHE+liGSU5iAqkpSmdGha0pVaWHz7
         yh8PstVeeLt/AV1qHzgTQvoTWUwlRljD/jzDdTaOTIzl1o4LuWmj5whd6+zcfjo2xXsY
         /G+Smo/PtRNPZMqlRF51AgcohH92CEAS/MxlBxsoDjWkUPt7YLYgPpPjEugzehWN1g+Z
         zjsw==
X-Gm-Message-State: ANoB5pmhGnDeFNJ4UQPnb8vXnlyvHexZLex3IxA9oCzTO6W6Em1NOUVL
        IqsJB6keSPY4lpmNXBFQihKMb9agG4BPZw==
X-Google-Smtp-Source: AA0mqf4OGzUflRd9fgiSOHv/QmLRQ49vTu/kJBWf1xJ9O92lR3q2aBKk41oca29nJE+lSQnlAj4CKQ==
X-Received: by 2002:a17:90a:9904:b0:213:6442:232a with SMTP id b4-20020a17090a990400b002136442232amr35487209pjp.117.1669183099069;
        Tue, 22 Nov 2022 21:58:19 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id a8-20020aa78e88000000b0056e15b7138esm11623198pfr.157.2022.11.22.21.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 21:58:17 -0800 (PST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oxily-00HYSW-EL; Wed, 23 Nov 2022 16:58:14 +1100
Received: from dave by discord.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1oxily-003A1u-1K;
        Wed, 23 Nov 2022 16:58:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/9] xfs: use byte ranges for write cleanup ranges
Date:   Wed, 23 Nov 2022 16:58:06 +1100
Message-Id: <20221123055812.747923-4-david@fromorbit.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221123055812.747923-1-david@fromorbit.com>
References: <20221123055812.747923-1-david@fromorbit.com>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

