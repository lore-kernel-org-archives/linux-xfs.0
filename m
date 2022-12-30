Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 722EAC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236301AbiLaC74 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbiLaC7z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:59:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221411929B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:59:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC84DB81E71
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C22C433EF;
        Sat, 31 Dec 2022 02:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455592;
        bh=l8n0Td43JvJZm28WR++wEceD+AteyaPxt3lysr6uvj0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oHNfVIQ1thSE8eYWtyO3DIII2ONb7t0USdo5pj9Jxjy7YsoEtFdpbnhUlo6hHJPeU
         YXP8OWriyIHAL57kFk5+1iyY79oqp5vhttzueyCNs22DJc1PakWd9ipqoMvOjXGMJr
         pZjzondqrDZYb9H8L0jAA3A4Z+aUUTehBpaqnlCwR42RPEssyQ4u/8EPtDzA1jmRTs
         io9CxgawZ+JCf99mplSFM5BqMc2wGS5pftt8i6f9zV7ZwDp7UIac4yh46wL885prUW
         D4/viJQ1FG2EKF4+QcOaEbEV1AzxOVB6U9yP2pO/o0T7lwJxE/GU6qS3CbnN5tYkny
         pwc8IvYwxKS+g==
Subject: [PATCH 22/41] xfs: online repair of the realtime refcount btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:10 -0800
Message-ID: <167243881061.734096.10201002796333432202.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Port the data device's refcount btree repair code to the realtime
refcount btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_refcount.c |    2 +-
 libxfs/xfs_refcount.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index b96472a2fe2..c286bb3e3b5 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -153,7 +153,7 @@ xfs_refcount_check_perag_irec(
 	return NULL;
 }
 
-static inline xfs_failaddr_t
+inline xfs_failaddr_t
 xfs_refcount_check_rtgroup_irec(
 	struct xfs_rtgroup		*rtg,
 	const struct xfs_refcount_irec	*irec)
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index c7907119d10..790d7fe9e67 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -132,6 +132,8 @@ extern void xfs_refcount_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_refcount_irec *irec);
 xfs_failaddr_t xfs_refcount_check_perag_irec(struct xfs_perag *pag,
 		const struct xfs_refcount_irec *irec);
+xfs_failaddr_t xfs_refcount_check_rtgroup_irec(struct xfs_rtgroup *rtg,
+		const struct xfs_refcount_irec *irec);
 xfs_failaddr_t xfs_refcount_check_irec(struct xfs_btree_cur *cur,
 		const struct xfs_refcount_irec *irec);
 extern int xfs_refcount_insert(struct xfs_btree_cur *cur,

