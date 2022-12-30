Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE7CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbiLaAGd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235621AbiLaAGc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:06:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503E71B1D4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:06:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CBD6B81DEC
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21E6C433EF;
        Sat, 31 Dec 2022 00:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445189;
        bh=NTBaJAE/DOH61sX9qllU7ErApPpj3Y9xTzqaF5QenSI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sulNfqEJJap8Yfkt05ljU9uIRayGkLYd/GYYSVSt9UnPizwZsJGcq5e3LFnA/nQwL
         RvvLneArc8UxgjJc9+626Z57zT0akUhCcfepes1aaKcmmFeh0EjX0ijBwD9gFdtvb/
         0LSqRXnxw5pUYgc/GA+UuOLro76C9UkJXsMNVn71OLv0JTzhepDWWJzNb7AnWgNDql
         TF8ftBIZghdzeIczkbdp+i7gFjOWzuPisrTNeGauu67ywwCwY9D6ArmF6Jkk7V4aWS
         Df67mo4XUtFXaRIylFRgMjzAraIy40X61icTTxinzLkQUxUGrorMNaa8xGYybmZ9PW
         Ch3ZVdD0zjBWg==
Subject: [PATCH 1/3] xfs: allow userspace to rebuild metadata structures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:22 -0800
Message-ID: <167243864265.707991.3461580373977289965.stgit@magnolia>
In-Reply-To: <167243864252.707991.14471233385651088983.stgit@magnolia>
References: <167243864252.707991.14471233385651088983.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a new (superuser-only) flag to the online metadata repair ioctl to
force it to rebuild structures, even if they're not broken.  We will use
this to move metadata structures out of the way during a free space
defragmentation operation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h                     |    6 +++++-
 man/man2/ioctl_xfs_scrub_metadata.2 |    5 +++++
 2 files changed, 10 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 1cfd5bc6520..920fd4513fc 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -741,7 +741,11 @@ struct xfs_scrub_metadata {
  */
 #define XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED (1u << 7)
 
-#define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_IFLAG_REPAIR)
+/* i: Rebuild the data structure. */
+#define XFS_SCRUB_IFLAG_FORCE_REBUILD	(1 << 31)
+
+#define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_IFLAG_REPAIR | \
+				 XFS_SCRUB_IFLAG_FORCE_REBUILD)
 #define XFS_SCRUB_FLAGS_OUT	(XFS_SCRUB_OFLAG_CORRUPT | \
 				 XFS_SCRUB_OFLAG_PREEN | \
 				 XFS_SCRUB_OFLAG_XFAIL | \
diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 046e3e3657b..42bf1e1cac5 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -216,6 +216,11 @@ The checker was unable to complete its check of all records.
 The checker encountered a metadata object with potentially problematic
 records.
 However, the records were not obviously corrupt.
+.TP
+.B XFS_SCRUB_IFLAG_FORCE_REBUILD
+Force the kernel to rebuild the specified piece of metadata, even if it's
+healthy.
+This can only be specified by the system administrator.
 .RE
 .PP
 For metadata checkers that operate on inodes or inode metadata, the fields

