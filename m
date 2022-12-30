Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4319DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236095AbiLaB3V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235752AbiLaB3U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:29:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B93F1C93A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:29:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E890AB81DF6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAD2C433EF;
        Sat, 31 Dec 2022 01:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450157;
        bh=H8PO59YUb5fVpa4deZx/Xh1fE9TenlGDCeufENoCXOA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=atOimetyaj0IQH6I6hv4GaI55kmVkH9ucoAl6dRcTR8T+2rg4MgTgpW+E22wElvQz
         Vsfjb4BU8RFpKNloJUvC6qvP+zyWK4ksNQmTY2N6WAmFhvfcjbQu0YT2V7UpzEsap7
         z/LH2b+XsNn+laBazBvef4tI1ehBHLBDkmuqmuGvc+HUH6I07nx3p94chqBfJSpukd
         lKRIYm3wGXm815/L6xSmnk/sHKXbJO2bIiFX+Gu/TqbLKnXUL8XmaB1vua5eCFEn1S
         M/bppU900uBQAe2kC7ns2Jp/30tYBy8APuQn5VZUdQ01jK0OWJm81snD/FBqYwFJfr
         RxeKEuwzlF0cg==
Subject: [PATCH 07/22] xfs: always update secondary rt supers when we update
 secondary fs supers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:53 -0800
Message-ID: <167243867370.712847.5894942816627973910.stgit@magnolia>
In-Reply-To: <167243867242.712847.10106105868862621775.stgit@magnolia>
References: <167243867242.712847.10106105868862621775.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that any update to the secondary superblocks in the data
section are also echoed to the secondary superblocks in the realtime
section.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c |    4 ++++
 fs/xfs/xfs_ioctl.c |    3 +++
 2 files changed, 7 insertions(+)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 13851c0d640b..2da86f05e0e5 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -21,6 +21,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_trace.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Write new AG headers to disk. Non-transactional, but need to be
@@ -306,6 +307,9 @@ xfs_growfs_data(
 
 	/* Update secondary superblocks now the physical grow has completed */
 	error = xfs_update_secondary_sbs(mp);
+	if (error)
+		goto out_error;
+	error = xfs_rtgroup_update_secondary_sbs(mp);
 
 out_error:
 	/*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index e3e6d377d958..46deb26b7cc5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -39,6 +39,7 @@
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
@@ -1719,6 +1720,8 @@ xfs_ioc_setlabel(
 	 */
 	mutex_lock(&mp->m_growlock);
 	error = xfs_update_secondary_sbs(mp);
+	if (!error)
+		error = xfs_rtgroup_update_secondary_sbs(mp);
 	mutex_unlock(&mp->m_growlock);
 
 	invalidate_bdev(bdev);

