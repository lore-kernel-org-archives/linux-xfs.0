Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB01C67871
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 23:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiJXXMp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 19:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiJXXMU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 19:12:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71089F752
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 14:33:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CD51615C2
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 21:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD933C433C1;
        Mon, 24 Oct 2022 21:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666647138;
        bh=8s0hKk0Z/T43b3xhGakn1BjmwUXrTzEKBvsf0syOS9Y=;
        h=Date:From:To:Cc:Subject:From;
        b=VV2DOSCrwfFzEt2UbWc9JLdxjhbRmcZ9gJKyPCCDNA55I0Zjuq1sdrAZ7oZmyB6ln
         68DZXFGKOFyxkVwYbKeNEZhVEqnxRjuS6LWqR5EOjkRnqhDmM2vl/XJt8h++rikEG+
         u4nxZ2gWis1uRDbFvc2iBo4dLV0U9jejrt/OEJHfZn0t5AMPyzw6SnX9rpg4W1gh0U
         165liIkfgwHHH0cjyx0Zttn/gV4Rr3HRx5mCisOXIZBFqVdCdEXocqK9dwf0uKiXB9
         fKACXansolI5JT//YmqGk8hPRDMbQiUdu8NXKV9l/gf/5k1R3ySPDV2hvNwApxqJtV
         ZnrICvuVVQ+/g==
Date:   Mon, 24 Oct 2022 14:32:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH] xfs: fix incorrect return type for fsdax fault handlers
Message-ID: <Y1cEYs4TK/kED/52@magnolia>
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

Fix the incorrect return type for these two functions, and make the
!fsdax version return SIGBUS since there is no vm_fault_t that maps to
zero.

Fixes: ea6c49b784f0 ("xfs: support CoW in fsdax mode")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c6c80265c0b2..6b328ffaf629 100644
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
@@ -1274,14 +1274,14 @@ xfs_dax_fault(
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
+	return VM_FAULT_SIGBUS;
 }
 #endif
 
