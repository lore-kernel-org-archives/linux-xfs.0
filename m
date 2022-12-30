Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F77C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236219AbiLaCWE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbiLaCWC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:22:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6DA19C12
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:22:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24AC661C31
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6C9C433D2;
        Sat, 31 Dec 2022 02:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453320;
        bh=nyKqIR4xQ0u9byPhB7wUPV3dA2lftW+AqkrF02lvLhg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=M2k/m6IiswzkyfT/vPeclTnPWfoW2s37KaeMeGyfX8y+y2PL7b3abNz3TN4EukfXm
         rUYYudvBgjUTo5Kf5bY3nIQe38yfToSuM1peKwfDuM7Ajb5+wSgc2wKhN6IIvkUFxw
         +3aey46wz0+vQhJqjbmEQ2OQmVZw9pI1TSWYKMszpduy53LjrThc2EqKQfdP2zPw6g
         tHAx0p09DUgmdHZQP0/857/xCxYls5Eis6ehqO7fuJoffb8quQMzDHiwiWEOOw9GEN
         OgyJLmYzEhMVV+RcJcv4hmr2KjOUy4UpGlDZjibmqzyvP7AhA1Vtzu6DAoW9WtjzWJ
         Z+bNCAPx6aAXw==
Subject: [PATCH 01/10] xfs: create a helper to convert rtextents to rtblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:28 -0800
Message-ID: <167243876829.727509.12593553022316443491.stgit@magnolia>
In-Reply-To: <167243876812.727509.17144221830951566022.stgit@magnolia>
References: <167243876812.727509.17144221830951566022.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a helper to convert a realtime extent to a realtime block.  Later
on we'll change the helper to use bit shifts when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtbitmap.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 5e2afb7fea0..099ea8902aa 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -6,6 +6,22 @@
 #ifndef __XFS_RTBITMAP_H__
 #define	__XFS_RTBITMAP_H__
 
+static inline xfs_rtblock_t
+xfs_rtx_to_rtb(
+	struct xfs_mount	*mp,
+	xfs_rtxnum_t		rtx)
+{
+	return rtx * mp->m_sb.sb_rextsize;
+}
+
+static inline xfs_extlen_t
+xfs_rtxlen_to_extlen(
+	struct xfs_mount	*mp,
+	xfs_rtxlen_t		rtxlen)
+{
+	return rtxlen * mp->m_sb.sb_rextsize;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */

