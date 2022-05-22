Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9699C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 22 May 2022 15:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347842AbiEVP2X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 May 2022 11:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241366AbiEVP2X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 May 2022 11:28:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A8138BF6
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 08:28:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37A63B80AC0
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 15:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8605C385AA;
        Sun, 22 May 2022 15:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653233300;
        bh=/8GHbawCsNAbBNrjumypRir8qz/Tf5jiGFWOTxY7SC8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=m4esT92JtW8NSXxB6xq1ncWoOxRzQ5BDvkcLMJhnALK3yvhWBr2aiJRV1HqGV+kAc
         CHxFbXQTvQPHi6U5uuOdxg5r78qoXIkqur/uiCyzqk8AWjBqJYHF+mlSZR9Ri2jwe8
         ROFPnnIWx9ZnT3WUfHyw1p0J9ErY0O8o18/Fv9q2oclAcI5K1p8OJvR42lIbm7pY1y
         eNmbOh/AfTGMaEySsZaw0r0KA1dOo4eysWMn5jiAgbFRTz9WLKEcAYjnH00oaCYLbw
         gcpiO/aszNCAoHg7KmawiptZ1WyEIm8XsPqrLaHqZSFen902nvhRSR74IZLKEdQbqJ
         4traMXkXegqyA==
Subject: [PATCH 1/5] xfs: don't log every time we clear the log incompat flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 22 May 2022 08:28:19 -0700
Message-ID: <165323329941.78886.16737485896297508351.stgit@magnolia>
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

There's no need to spam the logs every time we clear the log incompat
flags -- if someone is periodically using one of these features, they'll
be cleared every time the log tries to clean itself, which can get
pretty chatty:

$ dmesg | grep -i clear
[ 5363.894711] XFS (sdd): Clearing log incompat feature flags.
[ 5365.157516] XFS (sdd): Clearing log incompat feature flags.
[ 5369.388543] XFS (sdd): Clearing log incompat feature flags.
[ 5371.281246] XFS (sdd): Clearing log incompat feature flags.

These aren't high value messages either -- nothing's gone wrong, and
nobody's trying anything tricky.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.c |    1 -
 1 file changed, 1 deletion(-)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 0c0bcbd4949d..daa8d29c46b4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1356,7 +1356,6 @@ xfs_clear_incompat_log_features(
 
 	if (xfs_sb_has_incompat_log_feature(&mp->m_sb,
 				XFS_SB_FEAT_INCOMPAT_LOG_ALL)) {
-		xfs_info(mp, "Clearing log incompat feature flags.");
 		xfs_sb_remove_incompat_log_features(&mp->m_sb);
 		ret = true;
 	}

