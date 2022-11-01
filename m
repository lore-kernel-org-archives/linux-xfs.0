Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BD7FA3743
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Nov 2022 09:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbiKAJei (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Nov 2022 05:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiKAJe3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2022 05:34:29 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A085819004
        for <linux-xfs@vger.kernel.org>; Tue,  1 Nov 2022 02:34:27 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c24so13033825pls.9
        for <linux-xfs@vger.kernel.org>; Tue, 01 Nov 2022 02:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C0XLH6YyEbVm2Z6h5s13YZtEQu0aHxoi9jUbOAeZzMA=;
        b=MTIZBkpQ1AJ926SViIChs8XqH4br4rHBewQYn0WqUlDIV9ULmYWNtD30sSdpApONyR
         Gs0DlVVG7XryC9wI0hdtSDlEH7zVQl6hwFmg9lEhgkN5WFMULzfJ6yY3A2ytjcFs6fDn
         LpPrGX84of+QOz9DKYI5WfxA576gfbuuCXbmn7+/m5fYC9ZXjROiEfjiFaw65BRp9khS
         me1r+X5kEE5zQckfEMplZj7klnLnoFV7VW/xfytEeSzA3wyuVLRJ5ynhppQXQ2yrjVOC
         82UpbTgzJo5kIYj3cAyqEjFP7I6CC5PwNW+pHBVZdFoZYCpgP/c8Gl/5kEyRL5fAw1Au
         /5MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C0XLH6YyEbVm2Z6h5s13YZtEQu0aHxoi9jUbOAeZzMA=;
        b=40SXKatp0rQYipgpg4a1VjsrAAFGkmvFogUQBh98amRpv9N82PYZtdG7OMy1o6nIaP
         gvJMW2eZ+Pexbkm5ZsHwxNEi2nW6xAOmAQ1dxGS2yRmsPVnYaSW1i27CuWYWA9UQL4xN
         frsyrrFZuFoeCda78aHrK+A1Gkkpk2JGtx2nJE/au9sgc3V4n69Ae3mVYcSmH3cSZOEi
         0eeRTTDQqQaXPxXnlTcPQTREwup1phIVZSYtnkG76/QGhljGw2uk/wjafunDHFwhHBoe
         eeZlUOUHeMkl6IPQInNoYlRbbznU/q5trLD7q8hBambWilMk5Sy1wQS02/iXG6sretb2
         c5YQ==
X-Gm-Message-State: ACrzQf0dvET5ZjPXzZalfhgiXNledQaev6rhh/9YbuIBdGN3lOKfcPB/
        lNHLp4yUKIoTGV3kDFcmY3CIRg==
X-Google-Smtp-Source: AMsMyM4O4afEojXTF5wq0P2O3SrchQKBUxntq3oJARVNe7hoAHJO9RhjpJZi0VSMdVQGLNxwrhrH2Q==
X-Received: by 2002:a17:903:11c4:b0:178:634b:1485 with SMTP id q4-20020a17090311c400b00178634b1485mr18001827plh.142.1667295267042;
        Tue, 01 Nov 2022 02:34:27 -0700 (PDT)
Received: from HTW5T2C6VL.bytedance.net ([139.177.225.226])
        by smtp.gmail.com with ESMTPSA id b189-20020a621bc6000000b0056b818142a2sm6080300pfb.109.2022.11.01.02.34.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 01 Nov 2022 02:34:26 -0700 (PDT)
From:   changfengnan <changfengnan@bytedance.com>
To:     willy@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, viro@zeniv.linux.org.uk, djwong@kernel.org,
        dchinner@redhat.com, chandan.babu@oracle.com,
        linux-xfs@vger.kernel.org
Cc:     changfengnan <changfengnan@bytedance.com>
Subject: [PATCH] mm: remove filemap_fdatawait_keep_errors
Date:   Tue,  1 Nov 2022 17:34:13 +0800
Message-Id: <20221101093413.5871-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.37.0 (Apple Git-136)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

use filemap_fdatawait_range_keep_errors to instead of
filemap_fdatawait_keep_errors, no functional change.

Signed-off-by: changfengnan <changfengnan@bytedance.com>
---
 block/bdev.c            |  5 +++--
 fs/fs-writeback.c       |  5 +++--
 fs/xfs/scrub/bmap.c     |  3 ++-
 include/linux/pagemap.h |  1 -
 mm/filemap.c            | 21 ---------------------
 5 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index ce05175e71ce..f600b10017cd 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1055,10 +1055,11 @@ void sync_bdevs(bool wait)
 			/*
 			 * We keep the error status of individual mapping so
 			 * that applications can catch the writeback error using
-			 * fsync(2). See filemap_fdatawait_keep_errors() for
+			 * fsync(2). See filemap_fdatawait_range_keep_errors for
 			 * details.
 			 */
-			filemap_fdatawait_keep_errors(inode->i_mapping);
+			filemap_fdatawait_range_keep_errors(inode->i_mapping,
+								0, LLONG_MAX);
 		} else {
 			filemap_fdatawrite(inode->i_mapping);
 		}
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 443f83382b9b..d417cdb4505a 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2582,9 +2582,10 @@ static void wait_sb_inodes(struct super_block *sb)
 		/*
 		 * We keep the error status of individual mapping so that
 		 * applications can catch the writeback error using fsync(2).
-		 * See filemap_fdatawait_keep_errors() for details.
+		 * See filemap_fdatawait_range_keep_errors for details.
 		 */
-		filemap_fdatawait_keep_errors(mapping);
+		filemap_fdatawait_range_keep_errors(inode->i_mapping,
+							0, LLONG_MAX);
 
 		cond_resched();
 
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index f0b9cb6506fd..6be0433eaa51 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -64,7 +64,8 @@ xchk_setup_inode_bmap(
 		 */
 		error = filemap_fdatawrite(mapping);
 		if (!error)
-			error = filemap_fdatawait_keep_errors(mapping);
+			error = filemap_fdatawait_range_keep_errors(mapping,
+								0, LLONG_MAX);
 		if (error && (error != -ENOSPC && error != -EIO))
 			goto out;
 	}
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0178b2040ea3..75536967f57b 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -33,7 +33,6 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 int write_inode_now(struct inode *, int sync);
 int filemap_fdatawrite(struct address_space *);
 int filemap_flush(struct address_space *);
-int filemap_fdatawait_keep_errors(struct address_space *mapping);
 int filemap_fdatawait_range(struct address_space *, loff_t lstart, loff_t lend);
 int filemap_fdatawait_range_keep_errors(struct address_space *mapping,
 		loff_t start_byte, loff_t end_byte);
diff --git a/mm/filemap.c b/mm/filemap.c
index 15800334147b..b4932493175b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -600,27 +600,6 @@ int file_fdatawait_range(struct file *file, loff_t start_byte, loff_t end_byte)
 }
 EXPORT_SYMBOL(file_fdatawait_range);
 
-/**
- * filemap_fdatawait_keep_errors - wait for writeback without clearing errors
- * @mapping: address space structure to wait for
- *
- * Walk the list of under-writeback pages of the given address space
- * and wait for all of them.  Unlike filemap_fdatawait(), this function
- * does not clear error status of the address space.
- *
- * Use this function if callers don't handle errors themselves.  Expected
- * call sites are system-wide / filesystem-wide data flushers: e.g. sync(2),
- * fsfreeze(8)
- *
- * Return: error status of the address space.
- */
-int filemap_fdatawait_keep_errors(struct address_space *mapping)
-{
-	__filemap_fdatawait_range(mapping, 0, LLONG_MAX);
-	return filemap_check_and_keep_errors(mapping);
-}
-EXPORT_SYMBOL(filemap_fdatawait_keep_errors);
-
 /* Returns true if writeback might be needed or already in progress. */
 static bool mapping_needs_writeback(struct address_space *mapping)
 {
-- 
2.37.0 (Apple Git-136)

