Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C4E6C07E95
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D26461416
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhGCDAX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 23:00:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230215AbhGCDAX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Jul 2021 23:00:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D29261424;
        Sat,  3 Jul 2021 02:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625281070;
        bh=H6Lb6O9iKbPEdLhCCXKNfDBzDwLDnc57H1SWKoBIV2s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WJAomKy5YfF8i3cRZacBjXREpOMI5DH/po6g1LqXZhva9OXonCn9II2G3fICRH06p
         xU6BpjfmsJl6Wh0WpznlSwHjrq4A/MPm455oXF0ktFaIc9YqMyHWZwUIQbOlbfGhja
         3w3XurYhgyA92SzLoAiLdgYOKRdiV8YrW57pk/p5kIWw0mKv+0T/wDhy4GJ9JaDcSe
         /iCS42QSotEKW7iBsOlyQgIRnGUAaFJqkitoy1DuH/D8GMEOPIxzmdZZLip8rV5VcN
         BT4MYC59EgyNp47O9k8JL2BwEyFpcqzJrI+g4UaAIjKO0K+coGW3Y2yjGs+wfTlZ4c
         4KTn8klYNFKdw==
Subject: [PATCH 1/2] xfs_repair: validate alignment of inherited rt extent
 hints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@infradead.org
Date:   Fri, 02 Jul 2021 19:57:50 -0700
Message-ID: <162528107024.36302.9037961042426880362.stgit@locust>
In-Reply-To: <162528106460.36302.18265535074182102487.stgit@locust>
References: <162528106460.36302.18265535074182102487.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we encounter a directory that has been configured to pass on an
extent size hint to a new realtime file and the hint isn't an integer
multiple of the rt extent size, we should turn off the hint because that
is a misconfiguration.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 291c5807..1275c90b 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2178,6 +2178,31 @@ _("Bad %s nsec %u on inode %" PRIu64 ", "), name, be32_to_cpu(t->t_nsec), lino);
 		*dirty = 1;
 	}
 }
+/*
+ * Inode verifiers on older kernels don't check that the extent size hint is an
+ * integer multiple of the rt extent size on a directory with both rtinherit
+ * and extszinherit flags set.  If we encounter a directory that is
+ * misconfigured in this way, or a regular file that inherited a bad hint from
+ * a directory, clear the hint.
+ */
+static bool
+zap_bad_rt_extsize_hint(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dino)
+{
+	uint16_t		diflags = be16_to_cpu(dino->di_flags);
+
+	if (!(diflags & XFS_DIFLAG_REALTIME) &&
+	    !(diflags & XFS_DIFLAG_RTINHERIT))
+		return false;
+
+	if (!(diflags & XFS_DIFLAG_EXTSIZE) &&
+	    !(diflags & XFS_DIFLAG_EXTSZINHERIT))
+		return false;
+
+	return (be32_to_cpu(dino->di_extsize) % mp->m_sb.sb_rextsize) != 0;
+}
+
 
 /*
  * returns 0 if the inode is ok, 1 if the inode is corrupt
@@ -2694,7 +2719,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 	 * only regular files with REALTIME or EXTSIZE flags set can have
 	 * extsize set, or directories with EXTSZINHERIT.
 	 */
-	if (libxfs_inode_validate_extsize(mp,
+	if (zap_bad_rt_extsize_hint(mp, dino) ||
+	    libxfs_inode_validate_extsize(mp,
 			be32_to_cpu(dino->di_extsize),
 			be16_to_cpu(dino->di_mode),
 			be16_to_cpu(dino->di_flags)) != NULL) {

