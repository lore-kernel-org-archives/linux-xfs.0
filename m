Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0257C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbjEZBnZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjEZBnY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:43:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEC7189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:43:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4192A64B2A
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C0DC433EF;
        Fri, 26 May 2023 01:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065401;
        bh=jaTUlVathxKf6654hpRm62ZfZDhF3OI5AVs8z7uCvms=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=uDAD4G7ITFRYF/gJIgg+BqZQPC4KluYYb0KZJgpYbf9haW5F5FalD0Pbx4bWm1UVP
         9NWOU84p6kH+GIQflmZPFxC1bhFEajYEZ0SS6lze/PLdpANxLC4iCgIq/u5t2+AVX+
         43/yUY2gp/rq6mWHGRAJ19/RMSTzXc1C5GEW/nz/phv1MJGC+W7DyzBcEjtAATGGNS
         QCSN7fdaC8cVUrb9fgKR5YJQAWBTgrx2TW3/qOU95JikbKTpIn5BWsQjA3b9knr2Oq
         uUepcgk5gyqVl7xqOLdFhEHipuLeYZhCQtSVrwjXsTcYuT6D5K+jnLuDNYuW72yMh5
         twn662nNpVZSA==
Date:   Thu, 25 May 2023 18:43:21 -0700
Subject: [PATCH 4/6] xfs_scrub: add missing repair types to the mustfix and
 difficulty assessment
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506071720.3742978.3592107572998651293.stgit@frogsfrogsfrogs>
In-Reply-To: <168506071665.3742978.12693465390096953510.stgit@frogsfrogsfrogs>
References: <168506071665.3742978.12693465390096953510.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a few scrub types that ought to trigger a mustfix (such as AGI
corruption) and all the AG space metadata to the repair difficulty
assessment.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/scrub/repair.c b/scrub/repair.c
index 5d2d0684b7b..a68383cf05a 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -299,6 +299,7 @@ action_list_find_mustfix(
 		if (!(aitem->flags & XFS_SCRUB_OFLAG_CORRUPT))
 			continue;
 		switch (aitem->type) {
+		case XFS_SCRUB_TYPE_AGI:
 		case XFS_SCRUB_TYPE_FINOBT:
 		case XFS_SCRUB_TYPE_INOBT:
 			alist->nr--;
@@ -325,11 +326,17 @@ action_list_difficulty(
 		case XFS_SCRUB_TYPE_RMAPBT:
 			ret |= REPAIR_DIFFICULTY_SECONDARY;
 			break;
+		case XFS_SCRUB_TYPE_SB:
+		case XFS_SCRUB_TYPE_AGF:
+		case XFS_SCRUB_TYPE_AGFL:
+		case XFS_SCRUB_TYPE_AGI:
 		case XFS_SCRUB_TYPE_FINOBT:
 		case XFS_SCRUB_TYPE_INOBT:
 		case XFS_SCRUB_TYPE_BNOBT:
 		case XFS_SCRUB_TYPE_CNTBT:
 		case XFS_SCRUB_TYPE_REFCNTBT:
+		case XFS_SCRUB_TYPE_RTBITMAP:
+		case XFS_SCRUB_TYPE_RTSUM:
 			ret |= REPAIR_DIFFICULTY_PRIMARY;
 			break;
 		}

