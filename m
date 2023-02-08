Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BBF4C636D3
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Feb 2023 17:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjBHRwx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 12:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjBHRww (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 12:52:52 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA5C5278
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 09:52:51 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id bx22so16242146pjb.3
        for <linux-xfs@vger.kernel.org>; Wed, 08 Feb 2023 09:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SorP1JhlIcCEY/LuSUdYfh3iN08Qb7cjYiI47fg8YOw=;
        b=VPQO49Ed0XX+A7bcTOgjfBEF7PteVpjkaKCtOlusdZdSBk+R+5Jn5qUYS8TsRmlT5H
         mTdYCQ/KP2MEU0fuQRJBwH9YPHSXTY06WQuXMAxnhxvboRhPVMjwrqnK2HdVYrYEPNX7
         +IDjdmZQZgqYIQsrZr6KhkDmc4HD5WmK/7kauHhUbDpUh8cJLc8AF1J7qzs3Cr2w4yrb
         v7uxI5FJ/C+e1GxjTd6oRxNZ93YJNPGIRghQ3Ry04mhrJrokWqglRO1ZPWEqIrrFY//Q
         +htNccxyfMR1SxROhj/9AmWdDP0qISYfO+Qh/p5xAwHRugwWXZ4wTqFcgerx02Zsy8jD
         MaEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SorP1JhlIcCEY/LuSUdYfh3iN08Qb7cjYiI47fg8YOw=;
        b=WWtTneTM0+aNrMXdPFXSZOFHZ8b6kHriYc0wSca7R4ebn1fLyqehj0DwbhnWsZyFco
         nZGflyo+k1vL+IhGXlM0VUFm2E5wZE7Q9YYKaamFdQjMmveKu4yQxrCDunFMiZBLjvwV
         ihIm4zLD8gCCBlQXwrMY3jAriIrI6+pZcjJpLibUbjsVRn4r7buQedlyr+OFI5NoblGc
         0fVVMQt87aptZmrypVl3oaeYJ846x9f+5ud07jWOZpca0/a4seE3igNSokKGcsvDbBap
         kBwZw6Ex0MWTPdoca7lMSKwabdqlN+pGzXiB0Jz4t+ve+b9jlVNGS0UlHd82zKEjqAtJ
         VLcQ==
X-Gm-Message-State: AO0yUKWVgDbbwDLImhJyp9peLsxDLISecKhIeldR9FzMFZexqGMpjb4p
        NuEhznC2MakXtWqwvuNNZUwwz5tIL+oL5w==
X-Google-Smtp-Source: AK7set9FrqWqayJkx8EprojrPF9LFkf0U5CfFGn+fWjDJ8WEKL+VG28GHJbHsmDGYuW0I0s75F1wtg==
X-Received: by 2002:a17:902:da8b:b0:199:bd4:9fbb with SMTP id j11-20020a170902da8b00b001990bd49fbbmr9599157plx.43.1675878770995;
        Wed, 08 Feb 2023 09:52:50 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:726:5e6d:fcde:4245])
        by smtp.gmail.com with ESMTPSA id y17-20020a170902d65100b00198e397994bsm10911452plh.136.2023.02.08.09.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 09:52:50 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 10/10] xfs: don't leak btree cursor when insrec fails after a split
Date:   Wed,  8 Feb 2023 09:52:28 -0800
Message-Id: <20230208175228.2226263-11-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
In-Reply-To: <20230208175228.2226263-1-leah.rumancik@gmail.com>
References: <20230208175228.2226263-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit a54f78def73d847cb060b18c4e4a3d1d26c9ca6d ]

The recent patch to improve btree cycle checking caused a regression
when I rebased the in-memory btree branch atop the 5.19 for-next branch,
because in-memory short-pointer btrees do not have AG numbers.  This
produced the following complaint from kmemleak:

unreferenced object 0xffff88803d47dde8 (size 264):
  comm "xfs_io", pid 4889, jiffies 4294906764 (age 24.072s)
  hex dump (first 32 bytes):
    90 4d 0b 0f 80 88 ff ff 00 a0 bd 05 80 88 ff ff  .M..............
    e0 44 3a a0 ff ff ff ff 00 df 08 06 80 88 ff ff  .D:.............
  backtrace:
    [<ffffffffa0388059>] xfbtree_dup_cursor+0x49/0xc0 [xfs]
    [<ffffffffa029887b>] xfs_btree_dup_cursor+0x3b/0x200 [xfs]
    [<ffffffffa029af5d>] __xfs_btree_split+0x6ad/0x820 [xfs]
    [<ffffffffa029b130>] xfs_btree_split+0x60/0x110 [xfs]
    [<ffffffffa029f6da>] xfs_btree_make_block_unfull+0x19a/0x1f0 [xfs]
    [<ffffffffa029fada>] xfs_btree_insrec+0x3aa/0x810 [xfs]
    [<ffffffffa029fff3>] xfs_btree_insert+0xb3/0x240 [xfs]
    [<ffffffffa02cb729>] xfs_rmap_insert+0x99/0x200 [xfs]
    [<ffffffffa02cf142>] xfs_rmap_map_shared+0x192/0x5f0 [xfs]
    [<ffffffffa02cf60b>] xfs_rmap_map_raw+0x6b/0x90 [xfs]
    [<ffffffffa0384a85>] xrep_rmap_stash+0xd5/0x1d0 [xfs]
    [<ffffffffa0384dc0>] xrep_rmap_visit_bmbt+0xa0/0xf0 [xfs]
    [<ffffffffa0384fb6>] xrep_rmap_scan_iext+0x56/0xa0 [xfs]
    [<ffffffffa03850d8>] xrep_rmap_scan_ifork+0xd8/0x160 [xfs]
    [<ffffffffa0385195>] xrep_rmap_scan_inode+0x35/0x80 [xfs]
    [<ffffffffa03852ee>] xrep_rmap_find_rmaps+0x10e/0x270 [xfs]

I noticed that xfs_btree_insrec has a bunch of debug code that return
out of the function immediately, without freeing the "new" btree cursor
that can be returned when _make_block_unfull calls xfs_btree_split.  Fix
the error return in this function to free the btree cursor.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_btree.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 482a4ccc6568..dffe4ca58493 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3266,7 +3266,7 @@ xfs_btree_insrec(
 	struct xfs_btree_block	*block;	/* btree block */
 	struct xfs_buf		*bp;	/* buffer for block */
 	union xfs_btree_ptr	nptr;	/* new block ptr */
-	struct xfs_btree_cur	*ncur;	/* new btree cursor */
+	struct xfs_btree_cur	*ncur = NULL;	/* new btree cursor */
 	union xfs_btree_key	nkey;	/* new block key */
 	union xfs_btree_key	*lkey;
 	int			optr;	/* old key/record index */
@@ -3346,7 +3346,7 @@ xfs_btree_insrec(
 #ifdef DEBUG
 	error = xfs_btree_check_block(cur, block, level, bp);
 	if (error)
-		return error;
+		goto error0;
 #endif
 
 	/*
@@ -3366,7 +3366,7 @@ xfs_btree_insrec(
 		for (i = numrecs - ptr; i >= 0; i--) {
 			error = xfs_btree_debug_check_ptr(cur, pp, i, level);
 			if (error)
-				return error;
+				goto error0;
 		}
 
 		xfs_btree_shift_keys(cur, kp, 1, numrecs - ptr + 1);
@@ -3451,6 +3451,8 @@ xfs_btree_insrec(
 	return 0;
 
 error0:
+	if (ncur)
+		xfs_btree_del_cursor(ncur, error);
 	return error;
 }
 
-- 
2.39.1.519.gcb327c4b5f-goog

