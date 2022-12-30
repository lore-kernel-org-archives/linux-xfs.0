Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F797C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbiLaCXi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236215AbiLaCXh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:23:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A754919C12
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:23:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 507BDB81E0E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CDBC433D2;
        Sat, 31 Dec 2022 02:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453414;
        bh=GLz7od4ocL289uRHQQCdRtTVz9WOkpG5uBHiZTHWO+k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=V6SCJU7YIEwwCtTvDuqeizbWmpqmXgbQ60Yw2DM8iWuGL8tYJJtiF6LUlXvGFRJkp
         7X7s+OgCyERftcOxoBBvT2UKuyZTmJq0K2o80NySsfRfPopQ9okwkvdQwTxQjHa6aY
         8FU7/cbMe51mlOc17OoKNaCcJZ1zxmCOFyj+z4Fj9cOHoGCXxKxUhTU4PaxrMVY30L
         ZxHTxB8cRNBoyyT4GYyzxc1MRn7SZu+yWNSgkaslsM1gcF2VkM59F0CaF8O7U13z+D
         xIk1HzJo2cYdSDBTttF1kqw5UPGvV+Wbx8y4wWKkkxRd28DNzLOl9dgVZzrYOGtVeq
         oSJ+Z2fzWsSUQ==
Subject: [PATCH 07/10] xfs: create rt extent rounding helpers for realtime
 extent blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:29 -0800
Message-ID: <167243876908.727509.5702400227090536615.stgit@magnolia>
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

Create a pair of functions to round rtblock numbers up or down to the
nearest rt extent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/div64.h       |   14 ++++++++++++++
 libxfs/libxfs_priv.h  |    8 --------
 libxfs/xfs_rtbitmap.h |   18 ++++++++++++++++++
 3 files changed, 32 insertions(+), 8 deletions(-)


diff --git a/libfrog/div64.h b/libfrog/div64.h
index 265487916fc..9317b28aad4 100644
--- a/libfrog/div64.h
+++ b/libfrog/div64.h
@@ -66,4 +66,18 @@ div64_u64_rem(uint64_t dividend, uint64_t divisor, uint64_t *remainder)
 	return dividend / divisor;
 }
 
+static inline uint64_t rounddown_64(uint64_t x, uint32_t y)
+{
+	do_div(x, y);
+	return x * y;
+}
+
+static inline uint64_t
+roundup_64(uint64_t x, uint32_t y)
+{
+	x += y - 1;
+	do_div(x, y);
+	return x * y;
+}
+
 #endif /* LIBFROG_DIV64_H_ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 49441ac787f..71abfdbe401 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -363,14 +363,6 @@ roundup_pow_of_two(uint v)
 	return 0;
 }
 
-static inline uint64_t
-roundup_64(uint64_t x, uint32_t y)
-{
-	x += y - 1;
-	do_div(x, y);
-	return x * y;
-}
-
 static inline uint64_t
 howmany_64(uint64_t x, uint32_t y)
 {
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index bdd4858a794..bc51d3bfc7c 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -56,6 +56,24 @@ xfs_rtb_to_rtxt(
 	return div_u64(rtbno, mp->m_sb.sb_rextsize);
 }
 
+/* Round this rtblock up to the nearest rt extent size. */
+static inline xfs_rtblock_t
+xfs_rtb_roundup_rtx(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return roundup_64(rtbno, mp->m_sb.sb_rextsize);
+}
+
+/* Round this rtblock down to the nearest rt extent size. */
+static inline xfs_rtblock_t
+xfs_rtb_rounddown_rtx(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return rounddown_64(rtbno, mp->m_sb.sb_rextsize);
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */

