Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99EFFC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjBPVHi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbjBPVHi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:07:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D63C505D9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:07:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED8CD60C48
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55427C433EF;
        Thu, 16 Feb 2023 21:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581656;
        bh=Qv6PJB7DqyvyXSmPKdwv/o5AzNrgdLf28MPwceisRzs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jqG8S2DJAMKp7TJAfwGhfEP3DyevsRvXyUSkMlE6uWGlhK2yy7TzNfISZlPUMAATX
         YCZc8k3OhxPvQuwKZviDPffCWWT+vUkkYBOJdrZ7rAC3W4RtDSFUVxJk3/9g0XNHDC
         4bAiw/u3STCOEmENJCIQoCG2fhPij09GtY3xYKIMm3+IoQtWvV9sQHmWJOw7ZqjIzB
         85KKbwMyLRs25ddTlpZnNOZVILPTueYmKZm+zCC9tTfDnLCJKxWvIcjpMLHKJBfFLQ
         gl8sa9/Z+KTkd+EF/4B8h6mhTz76k7+vw1LACiWCgFR4UIgBSqr5aLemI5gJ6Inncj
         m6kaKlNzUZxiA==
Date:   Thu, 16 Feb 2023 13:07:35 -0800
Subject: [PATCH 3/3] xfs: add hooks to do directory updates
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657881064.3477513.15240825511730043370.stgit@magnolia>
In-Reply-To: <167657881025.3477513.15490690754847111370.stgit@magnolia>
References: <167657881025.3477513.15490690754847111370.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While we're scanning the filesystem, we still need to keep the tempdir
up to date with whatever changes get made to the you know what.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_dir2.c |    2 +-
 libxfs/xfs_dir2.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 4bbe83f9..9742ba65 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -439,7 +439,7 @@ int
 xfs_dir_removename(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
-	struct xfs_name		*name,
+	const struct xfs_name	*name,
 	xfs_ino_t		ino,
 	xfs_extlen_t		total,		/* bmap's total block count */
 	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index ac360c0b..6ed86b7b 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -46,7 +46,7 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
-				struct xfs_name *name, xfs_ino_t ino,
+				const struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot,
 				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,

