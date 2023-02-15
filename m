Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C040EC6379F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 01:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbjBOBrD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 20:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjBOBrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 20:47:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72312360A9;
        Tue, 14 Feb 2023 17:46:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A123B81F5F;
        Wed, 15 Feb 2023 01:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32E8C433D2;
        Wed, 15 Feb 2023 01:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676425612;
        bh=IjLD1uAs6SW+6/Dfvt99sAzccmGrcAGEKSAz3MpO6hE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=krKpngcNoytE6Eb5gOL6LhZu/WBJog+1DMwyOzro1ydbcIxKAnAhQBd54DgNIfpfM
         sLjEYOGEg/5yI1/7LxSz1xrTbvaCezi71f+Nt166A2ZSOwu0XovJ8V4y6YmBP2zTqo
         c//O5V2Ryp2jRRLHWAnZd/BeXu1JjDqhBY2xOL2tdRA5Lh96HtUFPEfEbak4NyzYJd
         ovgVw4X19V88L46PbBHCACLaOWt4ebbRjdcuEb+XVJuDtw3HmVr+kDrvaqCy20bLoc
         NTF/o0tSlE1VdPpLQcj7qp8zzfohVtDKUJvDUYCgLYeNNlCRvUy1HH2MUtfe2VN6OB
         oUiDpcg6ySC/w==
Subject: [PATCH 13/14] report: record ext*-specific information about a test
 run
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Feb 2023 17:46:52 -0800
Message-ID: <167642561224.2118945.2761688312094018100.stgit@magnolia>
In-Reply-To: <167642553879.2118945.15448815976865210889.stgit@magnolia>
References: <167642553879.2118945.15448815976865210889.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Report various ext* specific information about a test run.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/ext4   |    5 +++++
 common/report |    1 +
 2 files changed, 6 insertions(+)


diff --git a/common/ext4 b/common/ext4
index 8fd6dbc682..3dcbfe17c9 100644
--- a/common/ext4
+++ b/common/ext4
@@ -2,6 +2,11 @@
 # ext4 specific common functions
 #
 
+__generate_ext4_report_vars() {
+	__generate_blockdev_report_vars TEST_LOGDEV
+	__generate_blockdev_report_vars SCRATCH_LOGDEV
+}
+
 _setup_large_ext4_fs()
 {
 	local fs_size=$1
diff --git a/common/report b/common/report
index d538fc38a9..e22e2f8558 100644
--- a/common/report
+++ b/common/report
@@ -60,6 +60,7 @@ __generate_report_vars() {
 	__generate_blockdev_report_vars "SCRATCH_DEV"
 
 	test "$FSTYP" = "xfs" && __generate_xfs_report_vars
+	[[ "$FSTYP" == ext[0-9]* ]] && __generate_ext4_report_vars
 }
 
 #

