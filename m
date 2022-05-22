Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 576D2C433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 22 May 2022 15:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347920AbiEVP2a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 May 2022 11:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241366AbiEVP2a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 May 2022 11:28:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A3038BF6
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 08:28:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3DB4ECE0DE8
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 15:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93056C34113;
        Sun, 22 May 2022 15:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653233305;
        bh=yv9VbFTpFEaGB2loKWXeaCgzElbmldeQm4GiPSQ99Q0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nttZNA7Zd1zPsdyRkFe7qq61JK/JzhMG9XcoQx/fWt2sM2Jk/CR2kRvklVPqD3HxC
         Y6M4xrjYspjnHLOvqILU3KdQf7/523ODsy0H3kEVT0igHnJ3thsiJkcqkJJVCZQDEI
         QA24FLlVHXYSP5OUtT90bqOihJ2nSU3+JPUXY1bXIihBWgmwjq1EXvE2Sid4zVvtdF
         htR8NnsK3kI/KsivpzA741e2zHdNIU1ZHZqMnkfxSuC0DYZED4UEG8Z9S/zhKCRngG
         5UHuEiUMr+gd40Bwg48K4IxN6uRXLowGAwK/S9bK7ptivmEi1C5IbpQlvq7JLQSFYK
         HHt01e6/4A9+g==
Subject: [PATCH 2/5] xfs: refactor the code to warn about something once per
 day
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 22 May 2022 08:28:25 -0700
Message-ID: <165323330510.78886.17859336222096396508.stgit@magnolia>
In-Reply-To: <165323329374.78886.11371349029777433302.stgit@magnolia>
References: <165323329374.78886.11371349029777433302.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Refactor the code that warns about something once per day, so that we
actually do this consistently -- emit the warning once per day.  Don't
bother emitting the "XXXX messages suppressed" messages because it's
hard to associate the suppression message with the message suppressed
when the period is very long.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/scrub.c |   17 ++---------------
 fs/xfs/xfs_fsops.c   |    7 +------
 fs/xfs/xfs_message.h |   12 ++++++++++++
 3 files changed, 15 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index b11870d07c56..1fc3247fb594 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -340,20 +340,6 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 	},
 };
 
-/* This isn't a stable feature, warn once per day. */
-static inline void
-xchk_experimental_warning(
-	struct xfs_mount	*mp)
-{
-	static struct ratelimit_state scrub_warning = RATELIMIT_STATE_INIT(
-			"xchk_warning", 86400 * HZ, 1);
-	ratelimit_set_flags(&scrub_warning, RATELIMIT_MSG_ON_RELEASE);
-
-	if (__ratelimit(&scrub_warning))
-		xfs_alert(mp,
-"EXPERIMENTAL online scrub feature in use. Use at your own risk!");
-}
-
 static int
 xchk_validate_inputs(
 	struct xfs_mount		*mp,
@@ -478,7 +464,8 @@ xfs_scrub_metadata(
 	if (error)
 		goto out;
 
-	xchk_experimental_warning(mp);
+	xfs_warn_daily(mp,
+ "EXPERIMENTAL online scrub feature in use. Use at your own risk!");
 
 	sc = kmem_zalloc(sizeof(struct xfs_scrub), KM_NOFS | KM_MAYFAIL);
 	if (!sc) {
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 888839e75d11..88b1cc6f9d51 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -149,12 +149,7 @@ xfs_growfs_data_private(
 		error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
 						  delta, &lastag_extended);
 	} else {
-		static struct ratelimit_state shrink_warning = \
-			RATELIMIT_STATE_INIT("shrink_warning", 86400 * HZ, 1);
-		ratelimit_set_flags(&shrink_warning, RATELIMIT_MSG_ON_RELEASE);
-
-		if (__ratelimit(&shrink_warning))
-			xfs_alert(mp,
+		xfs_warn_daily(mp,
 	"EXPERIMENTAL online shrink feature in use. Use at your own risk!");
 
 		error = xfs_ag_shrink_space(mp, &tp, nagcount - 1, -delta);
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 55ee464ab59f..24336e18dff2 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -55,6 +55,15 @@ do {									\
 		func(dev, fmt, ##__VA_ARGS__);				\
 } while (0)
 
+#define xfs_printk_daily(func, dev, fmt, ...)				\
+do {									\
+	static DEFINE_RATELIMIT_STATE(_rs, 86400 * HZ, 1);		\
+									\
+	ratelimit_set_flags(&_rs, RATELIMIT_MSG_ON_RELEASE);		\
+	if (__ratelimit(&_rs))						\
+		func(dev, fmt, ##__VA_ARGS__);				\
+} while (0)
+
 #define xfs_printk_once(func, dev, fmt, ...)			\
 	DO_ONCE_LITE(func, dev, fmt, ##__VA_ARGS__)
 
@@ -75,6 +84,9 @@ do {									\
 #define xfs_debug_ratelimited(dev, fmt, ...)				\
 	xfs_printk_ratelimited(xfs_debug, dev, fmt, ##__VA_ARGS__)
 
+#define xfs_warn_daily(dev, fmt, ...)				\
+	xfs_printk_daily(xfs_warn, dev, fmt, ##__VA_ARGS__)
+
 #define xfs_warn_once(dev, fmt, ...)				\
 	xfs_printk_once(xfs_warn, dev, fmt, ##__VA_ARGS__)
 #define xfs_notice_once(dev, fmt, ...)				\

