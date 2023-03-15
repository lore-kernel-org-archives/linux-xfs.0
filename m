Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D913C6FD1F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Mar 2023 00:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjCOAxl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 20:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCOAxk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 20:53:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FF42007D;
        Tue, 14 Mar 2023 17:53:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65B0B61AA3;
        Wed, 15 Mar 2023 00:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA03C433D2;
        Wed, 15 Mar 2023 00:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678841618;
        bh=ZhIzbDwUl8nk/wvJRijfR3fmg5j+ZuK4A7Q/zgfwFJc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TXcaiDv9Mox6r1cRFPPeqCOpQzCZo2RxwpaZl3U6bJeDkdccGerWUajGlftwpqB2n
         RM8y0lNVwSXA/NarVY+ZeCsWdEqAFSTEPnKlIpzek7nnLZPI4fOe6xN8JrlGNAzs3l
         nYHlCMnW3RvQtt5OuHu7SCRhOQ2qi+UHq/RAbmkydSTX2XiIsOTf4g0F364T9VrXxI
         gVJRtN0FjaSLA1TCo4FcMyY+kaE6nNhb7DuUh57ZnohJvLMORb0IToruV9L5rTCa0W
         8/B1PSX6eLc+tuAwgqaqv9MMPok85STNrmECfOjTvs6lAnWyxeKHZEY9MBWVBcyJzB
         5r7x1ls/gwhQg==
Subject: [PATCH 12/15] report: record optional environment variables
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Mar 2023 17:53:38 -0700
Message-ID: <167884161838.2482843.6219764673500069919.stgit@magnolia>
In-Reply-To: <167884155064.2482843.4310780034948240980.stgit@magnolia>
References: <167884155064.2482843.4310780034948240980.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

These environment variables are documented as being significant, but
optional.  If they're set to a non-empty string, record them in the
reports.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/report |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/common/report b/common/report
index 90d4f980d1..af3c04db56 100644
--- a/common/report
+++ b/common/report
@@ -9,6 +9,11 @@ REPORT_ENV_LIST=("SECTION" "FSTYP" "PLATFORM" "MKFS_OPTIONS" "MOUNT_OPTIONS" \
 		 "TIME_FACTOR" "LOAD_FACTOR" "TEST_DIR" "TEST_DEV" \
 		 "SCRATCH_DEV" "SCRATCH_MNT" "OVL_UPPER" "OVL_LOWER" "OVL_WORK")
 
+# Variables that are captured in the report /if/ they are set.
+REPORT_ENV_LIST_OPT=("TAPE_DEV" "RMT_TAPE_DEV" "FSSTRES_AVOID" "FSX_AVOID"
+		     "KCONFIG_PATH" "PERF_CONFIGNAME" "MIN_FSSIZE"
+		     "IDMAPPED_MOUNTS")
+
 encode_xml()
 {
 	cat -v | \
@@ -58,6 +63,11 @@ __generate_report_vars() {
 
 	__generate_blockdev_report_vars "TEST_DEV"
 	__generate_blockdev_report_vars "SCRATCH_DEV"
+
+	# Optional environmental variables
+	for varname in "${REPORT_ENV_LIST_OPT[@]}"; do
+		test -n "${!varname}" && REPORT_VARS["${varname}"]="${!varname}"
+	done
 }
 
 #

