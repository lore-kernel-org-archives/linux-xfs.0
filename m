Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C550C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381648AbiEEQJl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381644AbiEEQIk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:08:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFAC5C37E
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:04:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1ACB7B82DEE
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FDBC385A8;
        Thu,  5 May 2022 16:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766694;
        bh=lGNcKsbrORDPLg4F3cP84bR/e2XuHp7ABd6hk7xvvJQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nGQpnb1+tMnEAr47NWWTvfFGDwYTjSqAO05EezELxHIRQC0xLFyWpU1LvdAeQ0hBH
         b8Aic2hKPnhyKZD9dY4wyfPGVNqTje+0/EVzRu64ZXHiED+rqC6uLWmMVFu1tEYx1a
         aGcjcMNU8cnLj7JLnh2eoqLssct3r9/uxtrNhJmYeCXgqw9zmYeQ6Lruc6QGEQeolL
         mBlnajScTJ7/V1Xjb6wpQZfqyPSCmVPtwdBZaOcGUstmCQ8hE6OjfGLlqJTEWrHcZ6
         akSA/+L38XbzxmeOozAcZfTSs3itw41GuI1AaNe1AANySry5kCfzHFR4s3yDE9s5EX
         kHLFuWo6maxGQ==
Subject: [PATCH 2/4] xfs_repair: check free rt extent count
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:04:54 -0700
Message-ID: <165176669425.247207.10108411720464005906.stgit@magnolia>
In-Reply-To: <165176668306.247207.13169734586973190904.stgit@magnolia>
References: <165176668306.247207.13169734586973190904.stgit@magnolia>
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
 repair/phase5.c     |   11 +++++++++++
 repair/rt.c         |    5 +++++
 repair/xfs_repair.c |    6 +-----
 3 files changed, 17 insertions(+), 5 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 74b1dcb9..f097f0fe 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -610,6 +610,17 @@ phase5(xfs_mount_t *mp)
 	xfs_agnumber_t		agno;
 	int			error;
 
+	if (no_modify) {
+		printf(_("No modify flag set, skipping phase 5\n"));
+
+		if (mp->m_sb.sb_rblocks) {
+			rtinit(mp);
+			generate_rtinfo(mp, btmcompute, sumcompute);
+		}
+
+		return;
+	}
+
 	do_log(_("Phase 5 - rebuild AG headers and trees...\n"));
 	set_progress_msg(PROG_FMT_REBUILD_AG, (uint64_t)glob_agcount);
 
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
index de8617ba..ef2a6ff1 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1174,11 +1174,7 @@ main(int argc, char **argv)
 	phase4(mp);
 	phase_end(4);
 
-	if (no_modify)
-		printf(_("No modify flag set, skipping phase 5\n"));
-	else {
-		phase5(mp);
-	}
+	phase5(mp);
 	phase_end(5);
 
 	/*

