Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0959C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 05:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbiEXFg3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 01:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbiEXFg1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 01:36:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B1F186EC
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 22:36:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D764661484
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 05:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB7FC385AA;
        Tue, 24 May 2022 05:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653370586;
        bh=/8GHbawCsNAbBNrjumypRir8qz/Tf5jiGFWOTxY7SC8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nWglDYvUTEALtAIfY+dEXBqefayNJ+npY8OeEThTCVd+Ioqe6S/0NA9CqDM13P9bG
         JtC8CACDI4nSW5rD3ITnPZHKvXEk/WYSI32PD88Y4Jp3PrLyHVUSWVCz5QPhvAvnib
         znnOft0D8KEl94U+DAlCtZmdw+JBLmJL++ASFBiqK9zD6ndbcq9qh/1KUOUgTEUmts
         wp8FDbMK73VrsLiOFh0dFNP4D/kXIDQqKqNcB4Qs7OXAGyT6k2U6mxoey5lyKZpXw5
         9FoUVzz+ZM3RH4gnKS5AGb8dNzgdDPR43AakAL1iHoJl7Zt/Vznp6wCnm/fknzYV60
         qeU8Y5mQ4BESw==
Subject: [PATCH 1/5] xfs: don't log every time we clear the log incompat flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Mon, 23 May 2022 22:36:25 -0700
Message-ID: <165337058586.994444.2832013222792677840.stgit@magnolia>
In-Reply-To: <165337058023.994444.12794741176651030531.stgit@magnolia>
References: <165337058023.994444.12794741176651030531.stgit@magnolia>
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

