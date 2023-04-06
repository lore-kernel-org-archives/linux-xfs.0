Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B0E2C77B6C
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236784AbjDFT2h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236901AbjDFT2a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:28:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E2B93D2
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:28:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B327C64B85
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19293C433EF;
        Thu,  6 Apr 2023 19:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809308;
        bh=ElaVYMZBbDg8l5uFfqLtJF3UmRqzlEE5i55Tof63KKI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=fL6OB1ctlHuXDC3Q5pAjUBZa60QJyeomEFInPPgU9zEVQfYCueH1HN+KTFnqcA8sr
         9DVBHAw7RB479u+wq7mTvI0m0uuBvMZkA8nzIpYph/f6OOlx+XZm6xY4xdadYWx2oN
         3TzNt7wcEGtvtQBquVuuWW+2BDga4sFEpmIGnUZKQiLMBiSXcr6NfJMdaoGeKZ9Arv
         L7hNt1wnjIcqNj9mI4CIf2AvkTpR0U9JUrIufjOP1ihnKzycb8uum7rXrhVsdtl9m+
         hMPEWhaWVCiO1UbZN8za7SuwtbU0V3TjY76qoVLrfRejQCRLy6A/+dbZbDJ3tXUVGh
         9Hj4kNIZ68PRA==
Date:   Thu, 06 Apr 2023 12:28:27 -0700
Subject: [PATCH 3/3] xfs: compare generated and existing parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080825997.616003.14559155042175014294.stgit@frogsfrogsfrogs>
In-Reply-To: <168080825953.616003.8753146482699125345.stgit@frogsfrogsfrogs>
References: <168080825953.616003.8753146482699125345.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Check our work to make sure we found all the parent pointers that the
original file had.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/parent_repair.c |   29 +++++++++++++++++++++++++++--
 fs/xfs/scrub/trace.h         |    1 +
 2 files changed, 28 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 293d9e931018..1f83e0f85dc0 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -486,7 +486,10 @@ xrep_pptr_scan_dirtree(
 	return 0;
 }
 
-/* Dump a parent pointer from the temporary file. */
+/*
+ * Dump a parent pointer from the temporary file and check it against the file
+ * we're rebuilding.  We are not committing any of this.
+ */
 STATIC int
 xrep_pptr_dump_tempptr(
 	struct xfs_scrub	*sc,
@@ -500,6 +503,8 @@ xrep_pptr_dump_tempptr(
 {
 	struct xrep_pptrs	*rp = priv;
 	const struct xfs_parent_name_rec *rec = (const void *)name;
+	struct xfs_inode	*other_ip;
+	int			error;
 
 	if (!(attr_flags & XFS_ATTR_PARENT))
 		return 0;
@@ -508,10 +513,26 @@ xrep_pptr_dump_tempptr(
 	    !xfs_parent_valuecheck(sc->mp, value, valuelen))
 		return -EFSCORRUPTED;
 
+	if (ip == sc->ip)
+		other_ip = sc->tempip;
+	else if (ip == sc->tempip)
+		other_ip = sc->ip;
+	else
+		return -EFSCORRUPTED;
+
 	xfs_parent_irec_from_disk(&rp->pptr, rec, value, valuelen);
 
 	trace_xrep_pptr_dumpname(sc->tempip, &rp->pptr);
-	return 0;
+
+	error = xfs_parent_lookup(sc->tp, other_ip, &rp->pptr,
+			&rp->pptr_scratch);
+	if (error == -ENOATTR) {
+		trace_xrep_pptr_checkname(other_ip, &rp->pptr);
+		ASSERT(error != -ENOATTR);
+		return -EFSCORRUPTED;
+	}
+
+	return error;
 }
 
 /*
@@ -590,6 +611,10 @@ xrep_pptr_rebuild_tree(
 	if (error)
 		return error;
 
+	error = xchk_xattr_walk(sc, sc->ip, xrep_pptr_dump_tempptr, rp);
+	if (error)
+		return error;
+
 	return xchk_xattr_walk(sc, sc->tempip, xrep_pptr_dump_tempptr, rp);
 }
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 5b070c177d48..87e400096245 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1374,6 +1374,7 @@ DEFINE_EVENT(xrep_pptr_class, name, \
 DEFINE_XREP_PPTR_CLASS(xrep_pptr_createname);
 DEFINE_XREP_PPTR_CLASS(xrep_pptr_removename);
 DEFINE_XREP_PPTR_CLASS(xrep_pptr_dumpname);
+DEFINE_XREP_PPTR_CLASS(xrep_pptr_checkname);
 
 DECLARE_EVENT_CLASS(xrep_pptr_scan_class,
 	TP_PROTO(struct xfs_inode *ip, const struct xfs_inode *dp,

