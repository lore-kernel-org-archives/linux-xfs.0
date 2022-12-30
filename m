Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCCACC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbiLaDEg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236269AbiLaDEf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:04:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444FB15F27
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:04:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E75AEB81EA2
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3730C433EF;
        Sat, 31 Dec 2022 03:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455872;
        bh=JQDNM7RCViqOw00iNF0ZPjoGyrXDDhBAy+sU7AW3BRY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FROnQ3ttFErET1cX3OhIWgc+60URSxndlVh1G0Cx1fYYpBvy1weMzwX8J5p/2YrjB
         zJPR2SbPJNW8q7Q/ZPQF67CMlVO9yYWUXlmPxZcu/z4GwVOlH7tfMjEuc+9GPHIniD
         xngN9Cq6MHTx7eYqh3uBjViI26mGBNH3MTApPoDFhFCoS8WWcrsEq6Xrz974FXZ7A0
         VZGORlUEFX+iSPwFYae+Mck0mFkGipL+L8YMmbse3Aml1mPBuFUCfmqvf1Y/JVItNP
         n5fZyU/Gph/TCUQ76DFi7OfZurM8++JOYITiR+VvbAFuwZIoTsfQC09vFLip0D5rfU
         kaV7dtrJIsM7Q==
Subject: [PATCH 40/41] mkfs: validate CoW extent size hint when rtinherit is
 set
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:13 -0800
Message-ID: <167243881299.734096.2713571769622643052.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Extent size hints exist to nudge the behavior of the file data block
allocator towards trying to make aligned allocations.  Therefore, it
doesn't make sense to allow a hint that isn't a multiple of the
fundamental allocation unit for a given file.

This means that if the sysadmin is formatting with rtinherit set on the
root dir, validate_cowextsize_hint needs to check the hint value on a
simulated realtime file to make sure that it's correct.  This hasn't
been necessary in the past since one cannot have a CoW hint without a
reflink filesystem, and we previously didn't allow rt reflink
filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index eebcade7d1a..dcce3d0136e 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2669,6 +2669,26 @@ _("illegal CoW extent size hint %lld, must be less than %u.\n"),
 				min(XFS_MAX_BMBT_EXTLEN, mp->m_sb.sb_agblocks / 2));
 		usage();
 	}
+
+	/*
+	 * If the value is to be passed on to realtime files, revalidate with
+	 * a realtime file so that we know the hint and flag that get passed on
+	 * to realtime files will be correct.
+	 */
+	if (!(cli->fsx.fsx_xflags & FS_XFLAG_RTINHERIT))
+		return;
+
+	fa = libxfs_inode_validate_cowextsize(mp, cli->fsx.fsx_cowextsize,
+			S_IFREG, XFS_DIFLAG_REALTIME, flags2);
+
+	if (fa) {
+		fprintf(stderr,
+_("illegal CoW extent size hint %lld, must be less than %u and a multiple of %u. %p\n"),
+				(long long)cli->fsx.fsx_cowextsize,
+				min(XFS_MAX_BMBT_EXTLEN, mp->m_sb.sb_agblocks / 2),
+				mp->m_sb.sb_rextsize, fa);
+		usage();
+	}
 }
 
 /* Complain if this filesystem is not a supported configuration. */

