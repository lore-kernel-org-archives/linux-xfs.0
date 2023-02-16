Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D96C3C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjBPVRe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjBPVRd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:17:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39FD3B864;
        Thu, 16 Feb 2023 13:17:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2D4C6CE2D87;
        Thu, 16 Feb 2023 21:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBB0C433EF;
        Thu, 16 Feb 2023 21:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676582249;
        bh=zYRO7r+SwI2mPlJoKhgq5W0hdNeoj4wIsL8E2RVqWyc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qUuXsiIjo7sC58SqOzeStDsrnOxiPx0p4FDQsH5LTSwY2M7uEva8p1BScQ7m1vUp5
         fU7jKGlM0Z+95ZnSaD52kByQAhEyKvLKorE2EoW9yVmeXF6lECC+2Pmn8yal1M0ocp
         +Y4hGQyhLI5pmAXpO8FYcRRCY698SztCDbALRNTbif1L3y5DtejLk5T1zWdNEXDLz2
         DhNylAEJ+rJUDao+9HC2CrtxVeem0gHY9pOIsodtcEgxjlhUu5WDIVECDYUR9KmNv9
         q0uhyeQPCOZ1NTgXPOBgBHSX/19xXuW26bGOBkY62kV+mer876pXNoTQNT4jIpvs8D
         vAnOU0+O/dbZA==
Date:   Thu, 16 Feb 2023 13:17:29 -0800
Subject: [PATCH 1/4] misc: adjust for parent pointers with namehashes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657884992.3481738.2422247894183594548.stgit@magnolia>
In-Reply-To: <167657884979.3481738.5353655058338554587.stgit@magnolia>
References: <167657884979.3481738.5353655058338554587.stgit@magnolia>
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
 tests/xfs/021.out.parent |    8 ++++----
 tests/xfs/122.out        |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/tests/xfs/021.out.parent b/tests/xfs/021.out.parent
index 661d130239..e7ed72fc27 100644
--- a/tests/xfs/021.out.parent
+++ b/tests/xfs/021.out.parent
@@ -19,9 +19,9 @@ size of attr value = 65536
 
 *** unmount FS
 *** dump attributes (1)
-a.sfattr.hdr.totsize = 53
+a.sfattr.hdr.totsize = 113
 a.sfattr.hdr.count = 3
-a.sfattr.list[0].namelen = 16
+a.sfattr.list[0].namelen = 76
 a.sfattr.list[0].valuelen = 10
 a.sfattr.list[0].root = 0
 a.sfattr.list[0].value = "testfile.1"
@@ -40,7 +40,7 @@ hdr.info.forw = 0
 hdr.info.back = 0
 hdr.info.magic = 0xfbee
 hdr.count = 4
-hdr.usedbytes = 84
+hdr.usedbytes = 144
 hdr.firstused = FIRSTUSED
 hdr.holes = 0
 hdr.freemap[0-2] = [base,size] [FREEMAP..]
@@ -54,7 +54,7 @@ nvlist[1].valuelen = 65535
 nvlist[1].namelen = 2
 nvlist[1].name = "a3"
 nvlist[2].valuelen = 10
-nvlist[2].namelen = 16
+nvlist[2].namelen = 76
 nvlist[2].value = "testfile.2"
 nvlist[3].valuelen = 8
 nvlist[3].namelen = 7
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index c5958d1b99..97be93274e 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -109,8 +109,8 @@ sizeof(struct xfs_legacy_timestamp) = 8
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_log_legacy_timestamp) = 8
 sizeof(struct xfs_map_extent) = 32
-sizeof(struct xfs_parent_name_irec) = 32
-sizeof(struct xfs_parent_name_rec) = 16
+sizeof(struct xfs_parent_name_irec) = 96
+sizeof(struct xfs_parent_name_rec) = 76
 sizeof(struct xfs_parent_ptr) = 280
 sizeof(struct xfs_phys_extent) = 16
 sizeof(struct xfs_pptr_info) = 104

