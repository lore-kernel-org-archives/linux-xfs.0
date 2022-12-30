Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42BCAC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiLaBdN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:33:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiLaBdM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:33:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE07DEB7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:33:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8827061CC1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A8EC433D2;
        Sat, 31 Dec 2022 01:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450391;
        bh=Uordkm4zZNGEdm1Nl3fTt8tJNL5AgifVQrvmqqZYkxE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nwEAuSwi56klH+ceNvvX98dHGms951lF8WYwD/B6C97aXATCtehtR68zB+mFLSHjX
         kpdDcIrzWVzsA5+LbvvPqW5S7nNMiEJWLhDogL45mkqNy3r1/Q4apfd1viEaJrpEBp
         dc7I9Eqo3JjFfnDa6nVDWvJNxqgLsThqKphEYh+xBRu6WbD7FD0nJhMEPA/QZysPkF
         qcOyVBvYYEJgd79hJSN0N+GHAUz3JGi76mzO52RMxBMrHeuMdJHKmcwirOUjSojUmK
         22/FritknlSzyzU2zZY3x+glpT9g2rwbgDw6fE7EKzC8UF1Bv8ZRtTPFmWSCJn0wke
         vLPHL7tC3WO3g==
Subject: [PATCH 22/22] xfs: enable realtime group feature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:55 -0800
Message-ID: <167243867582.712847.5494133812184915458.stgit@magnolia>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 7e76bedda688..e4f3b2c5c054 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -416,6 +416,7 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
 		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
+		 XFS_SB_FEAT_INCOMPAT_RTGROUPS | \
 		 XFS_SB_FEAT_INCOMPAT_METADIR)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL

