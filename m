Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A87F9C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiF1UuO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiF1UuN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:50:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973193120B
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32ECC6184B
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C835C341C8;
        Tue, 28 Jun 2022 20:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449411;
        bh=IlpRUPuNP/pL95DreIqNDlj5g/KFZEHjiMkHTx19pfc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=D0P99UX86SrWvLpyNZslZNx0flnRDqyUiWWvp0iPy/xfPZswAx5L/sk7+S7zkQ9dn
         3aLl9z7O0goQHClQC4yLD6f2ypLYv4SasbQAmd9Qujggv5xZrydU19cumehTo2tPk7
         Xlc5HhQCiHqBv88RewhAmaC6/CpTEm+HN+fg1R6HWsXFdp088WGw9sAnNkcIpnyLWH
         M7392b6H5ypghr+cKy+gBsiGnt+Kny8YOF7U12sgxzshjlUSNM/CZNNsVFBYe+4sBW
         NXyzKMwan+l89Fml3g8paIZpdZ7mcjbq2WVK+/7XeAyMYyzeiFc7pB17hc5TCiKzKO
         ng9Bghh73dzAw==
Subject: [PATCH 1/3] xfs_repair: check free rt extent count
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:50:11 -0700
Message-ID: <165644941118.1091513.9162627272860306485.stgit@magnolia>
In-Reply-To: <165644940561.1091513.10430076522811115702.stgit@magnolia>
References: <165644940561.1091513.10430076522811115702.stgit@magnolia>
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
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

