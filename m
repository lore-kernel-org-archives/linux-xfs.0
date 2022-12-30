Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435B1C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbiLaDFz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiLaDFy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:05:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E912DDFA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:05:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2CA2B81EA8
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B678C433EF;
        Sat, 31 Dec 2022 03:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455950;
        bh=Bt57fd7ZfCOo59EYeSLCkPUULYA1YDFg5I96GhEifSw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nNa736cAvkPLvDpKyPy4648zGYM2icUMSBBF55tLEMcktyd87N4Doyv+RVKn4i2kx
         KeKM6yn9UDTRdEeVILZQldhU1Qk1CAshc50ylv3T8V7tSpVJFJGV2UenCJL15++c42
         tbiZ79f/eNjBt+8kh4J9mUJ70PzTw6jmYBeomW7IAAlzOvOBtZWr4Eu/szOX1y8yFd
         2PYXmGJkjS5xlw2+QYTPZAryFXMJvvV/kzV7C2M0APZYEFBPT555/F9Z2qXFeky0Bb
         pVu5yDwbXthd84SqUtretaIDu17UO96mx86RiB8dGaOsR25K+h8EorUW8m8i3PAQNV
         kqpVQGRnmI7Gw==
Subject: [PATCH 1/1] xfs_quota: report warning limits for realtime space
 quotas
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:19 -0800
Message-ID: <167243881939.735184.11258120793213103815.stgit@magnolia>
In-Reply-To: <167243881927.735184.9698389452163804435.stgit@magnolia>
References: <167243881927.735184.9698389452163804435.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Report the number of warnings that a user will get for exceeding the
soft limit of a realtime volume.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xqm.h |    5 ++++-
 quota/state.c |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)


diff --git a/include/xqm.h b/include/xqm.h
index 573441db986..045af9b67fd 100644
--- a/include/xqm.h
+++ b/include/xqm.h
@@ -184,7 +184,10 @@ struct fs_quota_statv {
 	__s32			qs_rtbtimelimit;/* limit for rt blks timer */
 	__u16			qs_bwarnlimit;	/* limit for num warnings */
 	__u16			qs_iwarnlimit;	/* limit for num warnings */
-	__u64			qs_pad2[8];	/* for future proofing */
+	__u16			qs_rtbwarnlimit;/* limit for rt blks warnings */
+	__u16			qs_pad3;
+	__u32			qs_pad4;
+	__u64			qs_pad2[7];	/* for future proofing */
 };
 
 #endif	/* __XQM_H__ */
diff --git a/quota/state.c b/quota/state.c
index 260ef51db18..43fb700f9a7 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -244,6 +244,7 @@ state_quotafile_stat(
 	state_warnlimit(fp, XFS_INODE_QUOTA, sv->qs_iwarnlimit);
 
 	state_timelimit(fp, XFS_RTBLOCK_QUOTA, sv->qs_rtbtimelimit);
+	state_warnlimit(fp, XFS_RTBLOCK_QUOTA, sv->qs_rtbwarnlimit);
 }
 
 static void

