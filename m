Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70BF1C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjEZBi7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjEZBi6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:38:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A031F198
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36CC460ADA
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C39EC433EF;
        Fri, 26 May 2023 01:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065136;
        bh=JocWq+BmGptCbEfaPqelyUAaDhi9y8/yeQHl/W/3b3U=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=mUi3LW5SYeCjL4zdu7OVTmcstMc/PiOLbDgNXUNFWywWFoY8WwXO+0EAyNNZ2EiOA
         JVh8ygHGRPJkwpatDA2RCMaiLs9IocHSiGDAJodOAfsyrrCOPsRREMY5vdnYWlBYnm
         D1P+alkV+jjJ8JN3UxuHZW++MlRYXEsFA+r14tGxuey5CHPvfBDRNySla30yz0uHt4
         nS5JIv4qL7fekJVXpERBWaAParpLDv/t2uA5Eo2uLjsx/RrRdu+UxLtUeRdmniRHg+
         taYU+3g8VXJ67jDZBixce5k6nIH0jXQ79Ayft10GOnJ/HAXe94/2Cfzg7OdY+Y6sbN
         mkALKHElEYveQ==
Date:   Thu, 25 May 2023 18:38:56 -0700
Subject: [PATCH 1/3] xfs: check unused nlink fields in the ondisk inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506069386.3738323.10710589847228255400.stgit@frogsfrogsfrogs>
In-Reply-To: <168506069368.3738323.11092090063491926432.stgit@frogsfrogsfrogs>
References: <168506069368.3738323.11092090063491926432.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

v2/v3 inodes use di_nlink and not di_onlink; and v1 inodes use di_onlink
and not di_nlink.  Whichever field is not in use, make sure its contents
are zero, and teach xfs_scrub to fix that if it is.

This clears a bunch of missing scrub failure errors in xfs/385 for
core.onlink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    8 ++++++++
 fs/xfs/scrub/inode_repair.c   |   11 +++++++++++
 2 files changed, 19 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 454f40b29249..22f8604d98b5 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -488,6 +488,14 @@ xfs_dinode_verify(
 			return __this_address;
 	}
 
+	if (dip->di_version > 1) {
+		if (dip->di_onlink)
+			return __this_address;
+	} else {
+		if (dip->di_nlink)
+			return __this_address;
+	}
+
 	/* don't allow invalid i_size */
 	di_size = be64_to_cpu(dip->di_size);
 	if (di_size & (1ULL << 63))
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 37b228a4b5ae..16771944e325 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1192,6 +1192,16 @@ xrep_dinode_zap_forks(
 	}
 }
 
+STATIC void
+xrep_dinode_nlinks(
+	struct xfs_dinode	*dip)
+{
+	if (dip->di_version > 1)
+		dip->di_onlink = 0;
+	else
+		dip->di_nlink = 0;
+}
+
 /* Inode didn't pass verifiers, so fix the raw buffer and retry iget. */
 STATIC int
 xrep_dinode_core(
@@ -1233,6 +1243,7 @@ xrep_dinode_core(
 	/* Fix everything the verifier will complain about. */
 	dip = xfs_buf_offset(bp, ri->imap.im_boffset);
 	xrep_dinode_header(sc, dip);
+	xrep_dinode_nlinks(dip);
 	xrep_dinode_mode(ri, dip);
 	xrep_dinode_flags(sc, dip, ri->rt_extents > 0);
 	xrep_dinode_size(sc, dip);

