Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D644C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiF1Ute (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiF1Utd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:49:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA562DD49
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:49:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 502E86182E
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88F8C341C8;
        Tue, 28 Jun 2022 20:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449371;
        bh=dCD7lyDrmHv9tQE7sbPU/duYdjv6u5D2DvDpYVzcRks=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qgmKfWC7lb6XGIede4Rcwow+Jjjc0SjYoXFaj6c6NVfJpR6+E3+A91n52WRxUyTxm
         S5r45bNMHnOhSd7coHUeaPWEZ7OoUvBDtCLJQc7x5uZy/LZS5SE/GO7GyqjEX1+LGA
         Ya0SVfAzFX/inCtKgN1VmI9e96dTSIhc8KO1mJp8E7OHrBnuZNDmZKZ/GCwsKnEUKn
         nfDqa6iNICSl0KzjseyMJbi/m3b22Q6Mv7PEz454QNVZrWXbA7OwCeFg3FWVbCJ61k
         HSZQxqKXv+p/zVdFedjBwGGO7EXLjwVORVPZ/F0ug5VagUieEos17X0HSTp/0e+bol
         sdsWcevmomp2w==
Subject: [PATCH 3/6] xfs_repair: detect and fix padding fields that changed
 with nrext64
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:49:31 -0700
Message-ID: <165644937131.1089996.4905575997482466323.stgit@magnolia>
In-Reply-To: <165644935451.1089996.13716062701488693755.stgit@magnolia>
References: <165644935451.1089996.13716062701488693755.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Detect incorrectly set padding fields when large extent counts are
enabled or disabled on v3 inodes.

Found by fuzzing v3.flags2 = zeroes with xfs/374 and an nrext64=1
filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index 547c5833..1c92bfbd 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2709,6 +2709,26 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			}
 		}
 
+		if (xfs_dinode_has_large_extent_counts(dino)) {
+			if (dino->di_nrext64_pad) {
+				if (!no_modify) {
+					do_warn(_("fixing bad nrext64_pad.\n"));
+					dino->di_nrext64_pad = 0;
+					*dirty = 1;
+				} else
+					do_warn(_("would fix bad nrext64_pad.\n"));
+			}
+		} else if (dino->di_version >= 3) {
+			if (dino->di_v3_pad) {
+				if (!no_modify) {
+					do_warn(_("fixing bad v3_pad.\n"));
+					dino->di_v3_pad = 0;
+					*dirty = 1;
+				} else
+					do_warn(_("would fix bad v3_pad.\n"));
+			}
+		}
+
 		if (!verify_mode && flags2 != be64_to_cpu(dino->di_flags2)) {
 			if (!no_modify) {
 				do_warn(_("fixing bad flags2.\n"));

