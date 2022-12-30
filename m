Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2289C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236096AbiLaB3h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235752AbiLaB3g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:29:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CA91C93A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:29:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64CEAB81DF9
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106FAC433EF;
        Sat, 31 Dec 2022 01:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450173;
        bh=t+2ExIwGmerb3jtuvbB/8014xZi47Vu3VmD00UVuz78=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ukPQW64+lBrhlMtBbN32omYkkvN/f7BDuPg8nZIEveQVs6MMZvsui5ibCB+HsaTgV
         YD+a/G/Icp1dJvnTFKa0lZN+49H2lOyEM6+DnQRhrWfioNRvWcGRpLBolStZ8m6xCV
         YoNoZIfpQB7615VtbWlzIHPBN9KaAqZMJhMyuc7Q5qcPtuOCh6hgclutlewkpWeNBe
         GIxB0K4zGZsZmA+xzlwdW0SdMuJt3Eictfvo5+Jt07H0ThAC9Dy5hE0lyt6qgd3ju9
         V/IYCNGzK40VFQZLwRJU5Hmg+BwtlsMWgrF8YzbQFAsrNFdrK9/ePZPpy31Tci/zOV
         6e/zUJZxRbRKg==
Subject: [PATCH 08/22] xfs: export realtime group geometry via XFS_FSOP_GEOM
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:53 -0800
Message-ID: <167243867383.712847.16833344594803385713.stgit@magnolia>
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

Export the realtime geometry information so that userspace can query it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h |    4 +++-
 fs/xfs/libxfs/xfs_sb.c |    5 +++++
 2 files changed, 8 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index c4995f6557d2..ba90649c54e0 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -186,7 +186,9 @@ struct xfs_fsop_geom {
 	__u32		logsunit;	/* log stripe unit, bytes	*/
 	uint32_t	sick;		/* o: unhealthy fs & rt metadata */
 	uint32_t	checked;	/* o: checked fs & rt metadata	*/
-	__u64		reserved[17];	/* reserved space		*/
+	__u32		rgblocks;	/* rtblocks in a realtime group	*/
+	__u32		rgcount;	/* number of realtime groups	*/
+	__u64		reserved[16];	/* reserved space		*/
 };
 
 #define XFS_FSOP_GEOM_SICK_COUNTERS	(1 << 0)  /* summary counters */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 2e8ec9214c6c..db88f601e24b 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1348,6 +1348,11 @@ xfs_fs_geometry(
 		return;
 
 	geo->version = XFS_FSOP_GEOM_VERSION_V5;
+
+	if (xfs_has_rtgroups(mp)) {
+		geo->rgcount = sbp->sb_rgcount;
+		geo->rgblocks = sbp->sb_rgblocks;
+	}
 }
 
 /* Read a secondary superblock. */

