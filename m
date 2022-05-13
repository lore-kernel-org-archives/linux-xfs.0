Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 128D7C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 13 May 2022 20:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358807AbiEMUeS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 May 2022 16:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384553AbiEMUeM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 May 2022 16:34:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8C712AE6
        for <linux-xfs@vger.kernel.org>; Fri, 13 May 2022 13:34:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D19CB831C2
        for <linux-xfs@vger.kernel.org>; Fri, 13 May 2022 20:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A009C34100;
        Fri, 13 May 2022 20:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652474045;
        bh=Z4KJH12uKNL3C5yHTceB7tMn8v8zd5geELc7bF5IlYU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ululLGikerUkuQ/LyVxZgR3+x1ui2QzJ6nK3vAEYnAW4lgoZZpQr3BDsGR+MTY+AV
         mrrodIhBoL8rtOz1g2DqcaGmKnYTUm/029rTBHoro7SAZtYOw0UZQXN01NiW74IcaC
         yhYuxOdzFJZQdb0tW+JthPN3fLb/6WIqFuloBgVhM11WEE31IfVz4zIDEuv4M3nL+J
         y0MCbERG5PLpmZT0m3g75tTHCYIwsp9BS0a/YZ5ZTXkZgeyPmIFCPyMe5jLUvnCcgr
         owNvrqGZYwbdTqe1Ubbf861Gt1bs4mUtfdzdfKNPHoWA+Ttc11zSvLeMOp7QPXNszh
         LiihHJEB1xMNA==
Subject: [PATCH 2/4] xfs_repair: check free rt extent count
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 13 May 2022 13:34:04 -0700
Message-ID: <165247404480.275439.7642632291214731611.stgit@magnolia>
In-Reply-To: <165247403337.275439.13973873324817048674.stgit@magnolia>
References: <165247403337.275439.13973873324817048674.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Check the superblock's free rt extent count against what we observed.
This increases the runtime and memory usage, but we can now report
undercounting frextents as a result of a logging bug in the kernel.
Note that repair has always fixed the undercount, but it no longer does
that silently.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase5.c     |   11 +++++++++--
 repair/protos.h     |    1 +
 repair/rt.c         |    5 +++++
 repair/xfs_repair.c |    7 +++++--
 4 files changed, 20 insertions(+), 4 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 74b1dcb9..273f51a8 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -602,6 +602,14 @@ inject_lost_extent(
 	return -libxfs_trans_commit(tp);
 }
 
+void
+check_rtmetadata(
+	struct xfs_mount	*mp)
+{
+	rtinit(mp);
+	generate_rtinfo(mp, btmcompute, sumcompute);
+}
+
 void
 phase5(xfs_mount_t *mp)
 {
@@ -671,8 +679,7 @@ phase5(xfs_mount_t *mp)
 	if (mp->m_sb.sb_rblocks)  {
 		do_log(
 		_("        - generate realtime summary info and bitmap...\n"));
-		rtinit(mp);
-		generate_rtinfo(mp, btmcompute, sumcompute);
+		check_rtmetadata(mp);
 	}
 
 	do_log(_("        - reset superblock...\n"));
diff --git a/repair/protos.h b/repair/protos.h
index 83734e85..03ebae14 100644
--- a/repair/protos.h
+++ b/repair/protos.h
@@ -36,6 +36,7 @@ void	phase1(struct xfs_mount *);
 void	phase2(struct xfs_mount *, int);
 void	phase3(struct xfs_mount *, int);
 void	phase4(struct xfs_mount *);
+void	check_rtmetadata(struct xfs_mount *mp);
 void	phase5(struct xfs_mount *);
 void	phase6(struct xfs_mount *);
 void	phase7(struct xfs_mount *, int);
diff --git a/repair/rt.c b/repair/rt.c
index d663a01d..3a065f4b 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -111,6 +111,11 @@ generate_rtinfo(xfs_mount_t	*mp,
 		sumcompute[offs]++;
 	}
 
+	if (mp->m_sb.sb_frextents != sb_frextents) {
+		do_warn(_("sb_frextents %" PRIu64 ", counted %" PRIu64 "\n"),
+				mp->m_sb.sb_frextents, sb_frextents);
+	}
+
 	return(0);
 }
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index de8617ba..d08b0cec 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1174,9 +1174,12 @@ main(int argc, char **argv)
 	phase4(mp);
 	phase_end(4);
 
-	if (no_modify)
+	if (no_modify) {
 		printf(_("No modify flag set, skipping phase 5\n"));
-	else {
+
+		if (mp->m_sb.sb_rblocks > 0)
+			check_rtmetadata(mp);
+	} else {
 		phase5(mp);
 	}
 	phase_end(5);

