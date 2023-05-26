Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70CC3C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjEZAmq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjEZAmq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:42:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027A1194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:42:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9003F64BE0
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAF7C433D2;
        Fri, 26 May 2023 00:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061764;
        bh=Apoa+1si1uAqHlnZqWI1PQ8H15Xw8ymcRIDlRdJeaaE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=UbYLeLu/3uq0nDak7L96nxsKngVA+J5i3oWycwAPvyKMVbfNsnuEPNH4ee6KGuFIF
         FL8g/DrOzAd3RM/fUGRor6n2elGvK9l2VofJlJwq7cLZJRBZlE0j1n70H5bNyszvDL
         NWHws/MOlJXVX2A+rI5XT2tIh9Wekt7fjO6gBJzNp/O3NcDPzSWoLHjb36D4WiHmYX
         ReFHErOMYJgoR309+XswaxRKsJq0SKBkIaYlzBl/qq4e0XcBog8LdUfcGedoFwK4XN
         YvazwCnJ+YLQTYJggm0dZvds4W9K8aAMCqtRakdHmghaFvyxobD6pN+dPbRfKQDaV3
         33+VfeOFmxzNw==
Date:   Thu, 25 May 2023 17:42:43 -0700
Subject: [PATCH 6/7] xfs: validate fsmap offsets specified in the query keys
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506055283.3727958.5119853282331664912.stgit@frogsfrogsfrogs>
In-Reply-To: <168506055189.3727958.722711918040129046.stgit@frogsfrogsfrogs>
References: <168506055189.3727958.722711918040129046.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Improve the validation of the fsmap offset fields in the query keys and
move the validation to the top of the function now that we have pushed
the low key adjustment code downwards.

Also fix some indenting issues that aren't worth a separate patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index ae20aba6ebfe..10403ba9b58f 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -802,6 +802,19 @@ xfs_getfsmap_check_keys(
 	struct xfs_fsmap		*low_key,
 	struct xfs_fsmap		*high_key)
 {
+	if (low_key->fmr_flags & (FMR_OF_SPECIAL_OWNER | FMR_OF_EXTENT_MAP)) {
+		if (low_key->fmr_offset)
+			return false;
+	}
+	if (high_key->fmr_flags != -1U &&
+	    (high_key->fmr_flags & (FMR_OF_SPECIAL_OWNER |
+				    FMR_OF_EXTENT_MAP))) {
+		if (high_key->fmr_offset && high_key->fmr_offset != -1ULL)
+			return false;
+	}
+	if (high_key->fmr_length && high_key->fmr_length != -1ULL)
+		return false;
+
 	if (low_key->fmr_device > high_key->fmr_device)
 		return false;
 	if (low_key->fmr_device < high_key->fmr_device)
@@ -845,15 +858,15 @@ xfs_getfsmap_check_keys(
  * ----------------
  * There are multiple levels of keys and counters at work here:
  * xfs_fsmap_head.fmh_keys	-- low and high fsmap keys passed in;
- * 				   these reflect fs-wide sector addrs.
+ *				   these reflect fs-wide sector addrs.
  * dkeys			-- fmh_keys used to query each device;
- * 				   these are fmh_keys but w/ the low key
- * 				   bumped up by fmr_length.
+ *				   these are fmh_keys but w/ the low key
+ *				   bumped up by fmr_length.
  * xfs_getfsmap_info.next_daddr	-- next disk addr we expect to see; this
  *				   is how we detect gaps in the fsmap
 				   records and report them.
  * xfs_getfsmap_info.low/high	-- per-AG low/high keys computed from
- * 				   dkeys; used to query the metadata.
+ *				   dkeys; used to query the metadata.
  */
 int
 xfs_getfsmap(
@@ -874,6 +887,8 @@ xfs_getfsmap(
 	if (!xfs_getfsmap_is_valid_device(mp, &head->fmh_keys[0]) ||
 	    !xfs_getfsmap_is_valid_device(mp, &head->fmh_keys[1]))
 		return -EINVAL;
+	if (!xfs_getfsmap_check_keys(&head->fmh_keys[0], &head->fmh_keys[1]))
+		return -EINVAL;
 
 	use_rmap = xfs_has_rmapbt(mp) &&
 		   has_capability_noaudit(current, CAP_SYS_ADMIN);
@@ -919,15 +934,8 @@ xfs_getfsmap(
 	 * other mapping for the same physical block range.
 	 */
 	dkeys[0] = head->fmh_keys[0];
-	if (dkeys[0].fmr_flags & (FMR_OF_SPECIAL_OWNER | FMR_OF_EXTENT_MAP)) {
-		if (dkeys[0].fmr_offset)
-			return -EINVAL;
-	}
 	memset(&dkeys[1], 0xFF, sizeof(struct xfs_fsmap));
 
-	if (!xfs_getfsmap_check_keys(dkeys, &head->fmh_keys[1]))
-		return -EINVAL;
-
 	info.next_daddr = head->fmh_keys[0].fmr_physical +
 			  head->fmh_keys[0].fmr_length;
 	info.fsmap_recs = fsmap_recs;

