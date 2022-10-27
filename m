Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96903ECAAA1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 21:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbiJ0VM7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 17:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237327AbiJ0VMa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 17:12:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A0B4360A
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:11:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D86F621EE
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 21:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A3CC433D6;
        Thu, 27 Oct 2022 21:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666905083;
        bh=BhZ6z496BwbpyOyYA4lzzBgpjk0Y3duhYvgNZFYG5H4=;
        h=Date:From:To:Cc:Subject:From;
        b=izGCEgEqDRo0hiNr+W3kc+9IUoR0tWMb27UuTCQP/ZrA5/wlDquyvyVocFKNHxwyF
         WsTyD8Lj9HSBACrcxDzsL7W/ZQ/qt+HB/8CvIFdMUbGox6YaljeGnCJFC+PjoXz0Iw
         eidwf+f5/rCDD3jmOdQfCsoKtWdWwBeX9/3HcayqDHTW6msLZcOJQXFBzZ3kDPh/gT
         ZTqNc3ZTNB/oA3VDwzyEyKIhUYjujmhbT8H0bhHjHaKNFEqgIrJqOEdZ+2ttEhesf7
         1AthNVHCfmeEvqByzZYE8kLfm0odAbGQpbIjZXOYjYELqstK0SdVvqg2OdwzemC2ej
         WgDkA6gohZg/g==
Date:   Thu, 27 Oct 2022 14:11:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v2] xfs: fix incorrect return type for fsdax fault handlers
Message-ID: <Y1rz+qkknFIIQM04@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The kernel robot complained about this:

>> fs/xfs/xfs_file.c:1266:31: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted vm_fault_t @@
   fs/xfs/xfs_file.c:1266:31: sparse:     expected int
   fs/xfs/xfs_file.c:1266:31: sparse:     got restricted vm_fault_t
   fs/xfs/xfs_file.c:1314:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted vm_fault_t [usertype] ret @@     got int @@
   fs/xfs/xfs_file.c:1314:21: sparse:     expected restricted vm_fault_t [usertype] ret
   fs/xfs/xfs_file.c:1314:21: sparse:     got int

Fix the incorrect return type for these two functions.

While we're at it, make the !fsdax version return VM_FAULT_SIGBUS
because a zero return value will cause some callers to try to lock
vmf->page, which we never set here.

Fixes: ea6c49b784f0 ("xfs: support CoW in fsdax mode")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: less confusing commit message, add a debug assert to the !fsdax case
---
 fs/xfs/xfs_file.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c6c80265c0b2..e462d39c840e 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1261,7 +1261,7 @@ xfs_file_llseek(
 }
 
 #ifdef CONFIG_FS_DAX
-static int
+static inline vm_fault_t
 xfs_dax_fault(
 	struct vm_fault		*vmf,
 	enum page_entry_size	pe_size,
@@ -1274,14 +1274,15 @@ xfs_dax_fault(
 				&xfs_read_iomap_ops);
 }
 #else
-static int
+static inline vm_fault_t
 xfs_dax_fault(
 	struct vm_fault		*vmf,
 	enum page_entry_size	pe_size,
 	bool			write_fault,
 	pfn_t			*pfn)
 {
-	return 0;
+	ASSERT(0);
+	return VM_FAULT_SIGBUS;
 }
 #endif
 
