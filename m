Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8ED7C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjCPT3k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCPT3i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:29:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D74A7FD6D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:29:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6DB9B82302
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B206C433D2;
        Thu, 16 Mar 2023 19:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994973;
        bh=VmiZ+G/Lhs1LAkZJEfgh8lDUqQJzMiD0ER68EqVMlf8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=KaaRk5UZQ55EbbPLZHcu+sDThLmvpyU7FtHUp0cakrfL5wJ0xU8s9PRk0MwLN+9vr
         khJAYkZBos4QoEYKGVzY1Aylg9TcwwGhEVy11ZRPa6LyI8s3FsL9yccPVCpXauVJDI
         BYHFRKf1plnoV5UzqOMVNwpx9qu7YP/LQt08zI9uKJ9rX2QIJSwatFitaKNKRBmDBe
         tLx5boem7n0mdgxc71Pw3wxZ0PDghJLA6Fz0riI+eVUqhArPoxQ+LC8L3D41pmH+vu
         EgoC2a8OGVbvskM+KgWXK0AvljS7lgjckG+JQd79DbZt3zhGw5PFh18C7TKgjeN1En
         H6skFsUcqLRtw==
Date:   Thu, 16 Mar 2023 12:29:33 -0700
Subject: [PATCH 3/7] libfrog: fix indenting errors in xfss_pptr_alloc
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899416109.16628.17876653587515001968.stgit@frogsfrogsfrogs>
In-Reply-To: <167899416068.16628.8907331389138892555.stgit@frogsfrogsfrogs>
References: <167899416068.16628.8907331389138892555.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix some indenting problems, and get rid of the xfs_ prefix.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/pptrs.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)


diff --git a/libfrog/pptrs.c b/libfrog/pptrs.c
index 96de47b89..6a4f60cf6 100644
--- a/libfrog/pptrs.c
+++ b/libfrog/pptrs.c
@@ -13,16 +13,16 @@
 
 /* Allocate a buffer large enough for some parent pointer records. */
 static inline struct xfs_pptr_info *
-xfs_pptr_alloc(
-      size_t                  bufsize)
+alloc_pptr_buf(
+	size_t			bufsize)
 {
-      struct xfs_pptr_info    *pi;
+	struct xfs_pptr_info	*pi;
 
-      pi = calloc(bufsize, 1);
-      if (!pi)
-              return NULL;
-      pi->pi_ptrs_size = bufsize;
-      return pi;
+	pi = calloc(bufsize, 1);
+	if (!pi)
+		return NULL;
+	pi->pi_ptrs_size = bufsize;
+	return pi;
 }
 
 /* Walk all parents of the given file handle. */
@@ -38,7 +38,7 @@ handle_walk_parents(
 	unsigned int		i;
 	ssize_t			ret = -1;
 
-	pi = xfs_pptr_alloc(XFS_XATTR_LIST_MAX);
+	pi = alloc_pptr_buf(XFS_XATTR_LIST_MAX);
 	if (!pi)
 		return -1;
 

