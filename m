Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D18C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjBPVGU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjBPVGT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:06:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDCC505D3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:06:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6CDF60C69
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3081FC433EF;
        Thu, 16 Feb 2023 21:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581578;
        bh=ENq+QlZjsUfJkzc0ic9Y/rGVYdquRMVSvOp8sZ1Ms8c=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=MLO+qJ0CDAjraesXE6Nz5tq1v61jQZMTrnCsuAvix9a88t6+fT7bAzoL8Y9fHoy+4
         SdQRlMxoljRelQVZGlIfRxHAiwd/e3xX+W7XzUep0/4ye3IUaGvyztDfdT7dXMJke/
         xXHCwDzLlr3JcXMZamjLLAViKH5fErbUnfEriPwfudE/VdyPepDI2Rlb7yObfffWci
         YLEiIXiTudog9Ejfr+P1EDdDPUaNAWOvqeD58s41aIY/7dVNm98iX6YIU8B3mRebhC
         j22B0DPbSL1c7az3GwJ+JsVngi3eTFYP2RYKCtCDX2TWzZAmmjMnujWx135A3W+TIl
         TNviYOmNwTxew==
Date:   Thu, 16 Feb 2023 13:06:17 -0800
Subject: [PATCH 2/4] xfs: track file link count updates during live nlinks
 fsck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657880707.3477371.12711120588680798848.stgit@magnolia>
In-Reply-To: <167657880680.3477371.18364607478868446486.stgit@magnolia>
References: <167657880680.3477371.18364607478868446486.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create the necessary hooks in the file create/unlink/rename code so that
our live nlink scrub code can stay up to date with the rest of the
filesystem.  This will be the means to keep our shadow link count
information up to date while the scan runs in real time.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_dir2.c |    6 ++++++
 libxfs/xfs_dir2.h |    1 +
 repair/phase6.c   |    4 ----
 3 files changed, 7 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 43b4e46b..4bbe83f9 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -24,6 +24,12 @@ const struct xfs_name xfs_name_dotdot = {
 	.type	= XFS_DIR3_FT_DIR,
 };
 
+const struct xfs_name xfs_name_dot = {
+	.name	= (const unsigned char *)".",
+	.len	= 1,
+	.type	= XFS_DIR3_FT_DIR,
+};
+
 /*
  * Convert inode mode to directory entry filetype
  */
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index ff59f009..ac360c0b 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -22,6 +22,7 @@ struct xfs_dir3_icfree_hdr;
 struct xfs_dir3_icleaf_hdr;
 
 extern const struct xfs_name	xfs_name_dotdot;
+extern const struct xfs_name	xfs_name_dot;
 
 /*
  * Convert inode mode to directory entry filetype
diff --git a/repair/phase6.c b/repair/phase6.c
index e202398e..0d253701 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -23,10 +23,6 @@ static struct cred		zerocr;
 static struct fsxattr 		zerofsx;
 static xfs_ino_t		orphanage_ino;
 
-static struct xfs_name		xfs_name_dot = {(unsigned char *)".",
-						1,
-						XFS_DIR3_FT_DIR};
-
 /*
  * Data structures used to keep track of directories where the ".."
  * entries are updated. These must be rebuilt after the initial pass

