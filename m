Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE55C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjBPVEb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:04:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjBPVEb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:04:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C663505E5
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:04:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1ED560C48
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0FDC433D2;
        Thu, 16 Feb 2023 21:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581469;
        bh=5SWiYleLjl/Ndx+8NVKipwN9A6CL7ESRIEpDgJu0MX8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=QmmYQjs3jR86CRQ5EaLt9nFsQ5PEpkI++pAOjvM2hDEr/OIqyaGwuOvxQEwbJOzmQ
         flAsUPRc//C3Ubgc/eMTt5ds9a4VtH97TGTLnmTiBpGq69y4cBebZFCE83wxfKJ9AC
         H1CIIyLqAngOg2K3vyf8vVv893QuSLS0sYC/4sGU3m1d2p4sJh55KjrVIsQEAsyYre
         of6BqPwojYaOSZuWMnBWe2pEPI3S1QGdjjU5OhHt9mN6XAnu/80IE7pG8sTpDf4Hk7
         14+ULCTGcdzGnWoZdOYWexR1ViiFFZjLuarsOt8NAS3eaFxiKGfriunAutUtyBLUH+
         3WsjRWsczEVig==
Date:   Thu, 16 Feb 2023 13:04:26 -0800
Subject: [PATCH 05/10] libfrog: fix indenting errors in xfss_pptr_alloc
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657880324.3477097.4962218122860520315.stgit@magnolia>
In-Reply-To: <167657880257.3477097.11495108667073036392.stgit@magnolia>
References: <167657880257.3477097.11495108667073036392.stgit@magnolia>
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
 libfrog/pptrs.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)


diff --git a/libfrog/pptrs.c b/libfrog/pptrs.c
index 66a34246..5a3a7e2b 100644
--- a/libfrog/pptrs.c
+++ b/libfrog/pptrs.c
@@ -13,17 +13,17 @@
 
 /* Allocate a buffer large enough for some parent pointer records. */
 static inline struct xfs_pptr_info *
-xfs_pptr_alloc(
-      size_t                  nr_ptrs)
+alloc_pptr_buf(
+	size_t			nr_ptrs)
 {
-      struct xfs_pptr_info    *pi;
+	struct xfs_pptr_info	*pi;
 
-      pi = malloc(xfs_pptr_info_sizeof(nr_ptrs));
-      if (!pi)
-              return NULL;
-      memset(pi, 0, sizeof(struct xfs_pptr_info));
-      pi->pi_ptrs_size = nr_ptrs;
-      return pi;
+	pi = malloc(xfs_pptr_info_sizeof(nr_ptrs));
+	if (!pi)
+		return NULL;
+	memset(pi, 0, sizeof(struct xfs_pptr_info));
+	pi->pi_ptrs_size = nr_ptrs;
+	return pi;
 }
 
 /* Walk all parents of the given file handle. */
@@ -39,7 +39,7 @@ handle_walk_parents(
 	unsigned int		i;
 	ssize_t			ret = -1;
 
-	pi = xfs_pptr_alloc(4);
+	pi = alloc_pptr_buf(4);
 	if (!pi)
 		return -1;
 

