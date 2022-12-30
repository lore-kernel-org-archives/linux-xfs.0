Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02F1CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbiLaDDu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbiLaDDt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:03:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A44A15FD6
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:03:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C5ABB81E9F
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E100C433D2;
        Sat, 31 Dec 2022 03:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455826;
        bh=JhG04/jZtlTGKP1gDo0TBuDVSSRxfODhdTxxFIw58/k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gPe2AvwYN4ijh2f+1l/kIptl2WePaR42iz+vpjcjP/iWFiMLe2Pg6fIAtfV8Y+4TI
         IbsM000cFXoeQPNK01EyfTjP4Vdei9UMUZZ0L+HMIjpRys6869b5dKlmBMDDlL/6By
         hJcbepiifSF8xRcWanUN5hur4JgNXs4AK/N58BItoQHT1fQX+V5OgpFxkTSAf7dZiX
         jcBbpZDTywWW6Hzc4ZeoY6B0tmsxsxRwbWXiJ8HDLDNemoQyCeBDBRpl2BRzszy8bt
         zosQ8hPQeWipynJA91ndw56Zf6ofAsaM33nSud9RBTSCU/2UdY2YbjQ7XN1OLWT/aT
         ++UZB6SeiBQQA==
Subject: [PATCH 37/41] xfs_repair: allow realtime files to have the reflink
 flag set
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:12 -0800
Message-ID: <167243881259.734096.4454780130261127675.stgit@magnolia>
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

Now that we allow reflink on the realtime volume, allow that combination
of inode flags if the feature's enabled.  Note that we now allow inodes
to have rtinherit even if there's no realtime volume, since the kernel
has never restricted that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 1ef93d7aa8e..09cef18f2e9 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -3186,7 +3186,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 		}
 
 		if ((flags2 & XFS_DIFLAG2_REFLINK) &&
-		    (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT))) {
+		    !xfs_has_rtreflink(mp) &&
+		    (flags & XFS_DIFLAG_REALTIME)) {
 			if (!uncertain) {
 				do_warn(
 	_("Cannot have a reflinked realtime inode %" PRIu64 "\n"),
@@ -3218,7 +3219,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 		}
 
 		if ((flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
-		    (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT))) {
+		    !xfs_has_rtreflink(mp) &&
+		    (flags & XFS_DIFLAG_REALTIME)) {
 			if (!uncertain) {
 				do_warn(
 	_("Cannot have CoW extent size hint on a realtime inode %" PRIu64 "\n"),

