Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D355C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 22:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AD0360FE6
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 22:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239509AbhHaWpf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 18:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhHaWpe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 18:45:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF84E60FF2;
        Tue, 31 Aug 2021 22:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630449879;
        bh=B05HRiZtGhLpkyYRP9i0O1OVRE3wU80JjIJ6RKO1gEA=;
        h=Date:From:To:Cc:Subject:From;
        b=aHCDDcOK1YCxaSvjqfKW/itDsSAmY7zojYCue1b5pBIB7lftqJUElOcfPQDjzMX+j
         TsvnwlpgCPYfZgLJ7KQ1yD17xOstMD8XeGWZL3jWaJMYJY5ahFIAH1n6CVy9mh/P8C
         eL0BOoWR/9hddFh57nOFhZFr+E9JOTYYcjLzn6//kgkjDDXCJ95ABQh4V+mEebjp5g
         AFlaUJ9kz3mhS6QXZPQMdqaht/sLTf9mQnugSEsd39gl69hwzFRXyQMKNhNYu70xc8
         EyiwB3Y+Y9FFXU2LvCUVMHXWcrew9avVA/5q/kHpbdjKDhJcqe5SpCfAP80h9pAVuq
         Z4ftxG71NGeWA==
Date:   Tue, 31 Aug 2021 15:44:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] mkfs: warn about V4 deprecation when creating new V4
 filesystems
Message-ID: <20210831224438.GB9942@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The V4 filesystem format is deprecated in the upstream Linux kernel.  In
September 2025 it will be turned off by default in the kernel and five
years after that, support will be removed entirely.  Warn people
formatting new filesystems with the old format, particularly since V4 is
not the default.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 53904677..b8c11ce9 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2103,6 +2103,15 @@ _("Directory ftype field always enabled on CRC enabled filesystems\n"));
 		}
 
 	} else {	/* !crcs_enabled */
+		/*
+		 * The V4 filesystem format is deprecated in the upstream Linux
+		 * kernel.  In September 2025 it will be turned off by default
+		 * in the kernel and in September 2030 support will be removed
+		 * entirely.
+		 */
+		fprintf(stdout,
+_("V4 filesystems are deprecated and will not be supported by future versions.\n"));
+
 		/*
 		 * The kernel doesn't support crc=0,finobt=1 filesystems.
 		 * If crcs are not enabled and the user has not explicitly
