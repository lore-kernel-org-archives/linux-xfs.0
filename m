Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D150ACE7A97
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjIYV6m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjIYV6m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:58:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3A0AF
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:58:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B042C433C7;
        Mon, 25 Sep 2023 21:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695679115;
        bh=Ciwsg4ldfdTrqZkLrz5MoNuR1rQqb/yS+uwQfjskMOI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YVRUoPJybOaEwiVVep/pla99yl0OnbjB8Uv6KBEPo1bI4vJdzk3GXsSDVoZwtMxu7
         4t1Ibze087KqF5puOg/fx4RgEGMtQVpe00E7wnoN1gKhRBJKJ7hZ3YAZ9b9070HXmP
         M8KCJaQQgDO4HmTia70MXfBMXjcKREYzBdGya10YZwNYy+dFZcAsEsq3NVmz1nml+G
         yQ/0x4u8kofV1qzxHkMG82uwxZEXpKBI8x4sTC+/64d203Fi3VfGeBeDXbDwMjvsEP
         L8ToJstOv3VwUxGhdsyL57nzuoofoEAv3VCd79UVMfzpP18QY15jLRE8GbduBLftJg
         vJeePyyoEMxyg==
Subject: [PATCH 4/5] xfs: fix log recovery when unknown rocompat bits are set
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 25 Sep 2023 14:58:35 -0700
Message-ID: <169567911508.2318286.1922354533616393640.stgit@frogsfrogsfrogs>
In-Reply-To: <169567909240.2318286.10628058261852886648.stgit@frogsfrogsfrogs>
References: <169567909240.2318286.10628058261852886648.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 67d6e8dba5aef1662ec9aaecdc701e515db9e734

Log recovery has always run on read only mounts, even where the primary
superblock advertises unknown rocompat bits.  Due to a misunderstanding
between Eric and Darrick back in 2018, we accidentally changed the
superblock write verifier to shutdown the fs over that exact scenario.
As a result, the log cleaning that occurs at the end of the mounting
process fails if there are unknown rocompat bits set.

As we now allow writing of the superblock if there are unknown rocompat
bits set on a RO mount, we no longer want to turn off RO state to allow
log recovery to succeed on a RO mount.  Hence we also remove all the
(now unnecessary) RO state toggling from the log recovery path.

Fixes: 9e037cb7972f ("xfs: check for unknown v5 feature bits in superblock write verifier"
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_sb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 1e71d43d0a4..01935017cb6 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -264,7 +264,8 @@ xfs_validate_sb_write(
 		return -EFSCORRUPTED;
 	}
 
-	if (xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
+	if (!xfs_is_readonly(mp) &&
+	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
 		xfs_alert(mp,
 "Corruption detected in superblock read-only compatible features (0x%x)!",
 			(sbp->sb_features_ro_compat &

