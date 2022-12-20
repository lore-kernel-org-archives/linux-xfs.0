Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A3E4C001B2
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 00:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbiLTABr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 19:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbiLTABq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 19:01:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A3D2614;
        Mon, 19 Dec 2022 16:01:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B26C9B80ED7;
        Tue, 20 Dec 2022 00:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDA3C433D2;
        Tue, 20 Dec 2022 00:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671494503;
        bh=LvuwLi4xewL992WDyJbgDS8QS3Kn+O6Rns7/6pVlOx4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OLoeJLJXjFaWW64VWYMXS1ZRUCKbuPzt3crVE9dIxcBt14ndRqCEtCbtHEQjC0EGE
         NKuqgbjrTB3iCDIPvtKP6FRCVfIx3Kzm1038e3Zj4u5DauwNkUZXG720HZ4itCpPSo
         MX66GaV/d+r/Dbk81uPRnWUbUVZ+8iBP1gywvnKsSuahCnUPDN0PMIxwJZ3WZ9Lg0C
         dl2C/l1NXYLVbxGYOnH10EIK/pZlCaHz3UaBmalfECfnVX95J0ulyONQmDIlK8+Fyf
         j+/uy/yoRSYG4Ay3+VnCD0an4k8HrN2nD9t2jwnuwwIAuE8FdcO0HPRptJvfePdlo5
         OzPbCoxcWplAA==
Subject: [PATCH 7/8] report: record xfs-specific information about a test run
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com
Date:   Mon, 19 Dec 2022 16:01:42 -0800
Message-ID: <167149450292.332657.3110931385669293441.stgit@magnolia>
In-Reply-To: <167149446381.332657.9402608531757557463.stgit@magnolia>
References: <167149446381.332657.9402608531757557463.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Report various XFS-specific information about a test run.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/report |    2 ++
 common/xfs    |   10 ++++++++++
 2 files changed, 12 insertions(+)


diff --git a/common/report b/common/report
index 68646a7709..f2b60c317e 100644
--- a/common/report
+++ b/common/report
@@ -53,6 +53,8 @@ __generate_report_vars() {
 
 	__generate_blockdev_report_vars "TEST_DEV"
 	__generate_blockdev_report_vars "SCRATCH_DEV"
+
+	test "$FSTYP" = "xfs" && __generate_xfs_report_vars
 }
 
 #
diff --git a/common/xfs b/common/xfs
index 7eee76c0ee..add3a42fa4 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2,6 +2,16 @@
 # XFS specific common functions.
 #
 
+__generate_xfs_report_vars() {
+	__generate_blockdev_report_vars TEST_RTDEV
+	__generate_blockdev_report_vars TEST_LOGDEV
+	__generate_blockdev_report_vars SCRATCH_RTDEV
+	__generate_blockdev_report_vars SCRATCH_LOGDEV
+
+	REPORT_VARS["XFS_ALWAYS_COW"]="$(cat /sys/fs/xfs/debug/always_cow 2>/dev/null)"
+	REPORT_VARS["XFS_LARP"]="$(cat /sys/fs/xfs/debug/larp 2>/dev/null)"
+}
+
 _setup_large_xfs_fs()
 {
 	fs_size=$1

