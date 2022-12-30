Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B32C3C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbiLaAL2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiLaAL0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:11:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B75102E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:11:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D870161CD5
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4306BC433EF;
        Sat, 31 Dec 2022 00:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445485;
        bh=QqsP5YDPHGnXJiIQ/WonwsuNHD9JxZoqfKQUtOFqgKA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TRJGQLONuH57pFbqpqFTRGDohtEzDkJ/ZarZpqaPk2E8YxSbMUEdQx7NohWRnHVpb
         G4RvFtX51uuRAaQzt7kpafL3Vd9MOoCh+S0boOYchTjtz+eit8mHnmiRiex6F4+8ss
         /V1oIbZLJM2SHsR7bJkJiYxYT02MAFldx1RfZf7Ipt3Catm0KuiNxG9gQU04qTYWc3
         C+owOFO4xxuIkmW8LqLboAFfpuTysBpHP8ct0JBIpySggbm/Py0oatZ2mI1zLID4e1
         yISa9GygueN9KI8fao5Qz+e/PDlkKMpUbHEER0IzIPlTExDURAO4+/loXfIGdPPufK
         2qGf6Ro6bLy+w==
Subject: [PATCH 1/9] libxfs: clean up xfs_da_unmount usage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:41 -0800
Message-ID: <167243866170.711834.15916685233545164856.stgit@magnolia>
In-Reply-To: <167243866153.711834.17585439086893346840.stgit@magnolia>
References: <167243866153.711834.17585439086893346840.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Replace the open-coded xfs_da_unmount usage in libxfs_umount and teach
libxfs_mount not to leak the dir/attr geometry structures when the mount
attempt fails.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 93dc1f1c599..f21dbc6732b 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -842,7 +842,7 @@ libxfs_mount(
 	if (error) {
 		fprintf(stderr, _("%s: data size check failed\n"), progname);
 		if (!xfs_is_debugger(mp))
-			return NULL;
+			goto out_da;
 	} else
 		libxfs_buf_relse(bp);
 
@@ -856,7 +856,7 @@ libxfs_mount(
 			fprintf(stderr, _("%s: log size checks failed\n"),
 					progname);
 			if (!xfs_is_debugger(mp))
-				return NULL;
+				goto out_da;
 		}
 		if (bp)
 			libxfs_buf_relse(bp);
@@ -865,8 +865,8 @@ libxfs_mount(
 	/* Initialize realtime fields in the mount structure */
 	if (rtmount_init(mp)) {
 		fprintf(stderr, _("%s: realtime device init failed\n"),
-			progname);
-			return NULL;
+				progname);
+			goto out_da;
 	}
 
 	/*
@@ -884,7 +884,7 @@ libxfs_mount(
 			fprintf(stderr, _("%s: read of AG %u failed\n"),
 						progname, sbp->sb_agcount);
 			if (!xfs_is_debugger(mp))
-				return NULL;
+				goto out_da;
 			fprintf(stderr, _("%s: limiting reads to AG 0\n"),
 								progname);
 			sbp->sb_agcount = 1;
@@ -902,6 +902,9 @@ libxfs_mount(
 	xfs_set_perag_data_loaded(mp);
 
 	return mp;
+out_da:
+	xfs_da_unmount(mp);
+	return NULL;
 }
 
 void
@@ -1024,9 +1027,7 @@ libxfs_umount(
 	if (xfs_is_perag_data_loaded(mp))
 		libxfs_free_perag(mp);
 
-	kmem_free(mp->m_attr_geo);
-	kmem_free(mp->m_dir_geo);
-
+	xfs_da_unmount(mp);
 	kmem_free(mp->m_rtdev_targp);
 	if (mp->m_logdev_targp != mp->m_ddev_targp)
 		kmem_free(mp->m_logdev_targp);

