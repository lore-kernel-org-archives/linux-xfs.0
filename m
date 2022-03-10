Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD7BC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Mar 2022 21:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344154AbiCJVy5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Mar 2022 16:54:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344161AbiCJVy4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Mar 2022 16:54:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B7E18A793
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 13:53:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6A3161AC7
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 21:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F324C340F5;
        Thu, 10 Mar 2022 21:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646949234;
        bh=8RPstt5X16FbsX+c0JE1zx6XdINBrbNmlc+yDytv74I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DeHoPxETscujjAUpPwWsGB1s2SWeNTp9Oy9c8Mgmlo7KHYft8IRYppOatIQfWMGR1
         SRjvcv5NHwYtbmYvjRpBtKb8rZ+r90Oco4EaBWDg71TtRaWiDfFUlBW2mWs2Ay5AqY
         Kq0drhGy1Pxg/Ll4W2oyc3vZDwxmlip7H7t2SeAyuIwZ0ptxDWznZ996PXgKdUbCan
         CFe6vIqfjnAQuBLmdFCtOe5IY7eZThKCh1zNIkjzAlqUbMUiYxkL3DFTF/kNg91lKB
         kwdvPnONhocZXi+Hyyc+DimIYu4meyAPixtUag3Q1XIen5b2b9Xk0fgzLHV/cgNalS
         DAxsf0STzJsdw==
Subject: [PATCH 2/2] xfs: constify xfs_name_dotdot
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 10 Mar 2022 13:53:53 -0800
Message-ID: <164694923383.1119724.11884585401815905581.stgit@magnolia>
In-Reply-To: <164694922267.1119724.17942999738634110525.stgit@magnolia>
References: <164694922267.1119724.17942999738634110525.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The symbol xfs_name_dotdot is a global variable that the xfs codebase
uses here and there to look up directory dotdot entries.  Currently it's
a non-const variable, which means that it's a mutable global variable.
So far nobody's abused this to cause problems, but let's use the
compiler to enforce that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c |    6 +++++-
 fs/xfs/libxfs/xfs_dir2.h |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 6b531a659b1e..5f1e4799e8fa 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -19,7 +19,11 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 
-struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
+const struct xfs_name xfs_name_dotdot = {
+	.name	= (const unsigned char *)"..",
+	.len	= 2,
+	.type	= XFS_DIR3_FT_DIR,
+};
 
 /*
  * Convert inode mode to directory entry filetype
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 55e0557000db..b6df3c34b26a 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -21,7 +21,7 @@ struct xfs_dir2_data_unused;
 struct xfs_dir3_icfree_hdr;
 struct xfs_dir3_icleaf_hdr;
 
-extern struct xfs_name	xfs_name_dotdot;
+extern const struct xfs_name	xfs_name_dotdot;
 
 /*
  * Convert inode mode to directory entry filetype

