Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614E9C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 00:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiLTABx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 19:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiLTABw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 19:01:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885672613;
        Mon, 19 Dec 2022 16:01:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42954B80ED7;
        Tue, 20 Dec 2022 00:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A5DC433D2;
        Tue, 20 Dec 2022 00:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671494509;
        bh=m3HrovVCofOfCjGm0j6I8S2e13RlE/wl0/sN7owzzho=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pDMkrPp3hWRiS86HQyujQEI24gWsHwWy7t0FVJZLyXFWVwRHhwuyMiDkLOQ267cBf
         FGRkC/SCXKdeVOV9wh83QmrQoPzrZHLAHjBVzi32Ot2UYmjAgzxpDVLeu52VZapzhk
         VPX8aBGclpgyabnFmkUQgolQxLhYgtc70zF+np8LcDvxYcrYHJY56viHM7vV8MZ0F8
         lD8Yb3vnv2fkIT/HzzPW9r2kzMAXUR5xixhtxOMf4tOtRFYlgik86bpxMu5r3FoN+g
         NOEIIGbmUc4DmAcKZFpIuocsLQl0EFPFZ9ftH6W9O+afKXd3S9nhVdM50cDl2qGr+f
         26iRZxQBnYhxw==
Subject: [PATCH 8/8] report: record ext*-specific information about a test run
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com
Date:   Mon, 19 Dec 2022 16:01:48 -0800
Message-ID: <167149450855.332657.5873316810748864701.stgit@magnolia>
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
index f2b60c317e..199851084c 100644
--- a/common/report
+++ b/common/report
@@ -55,6 +55,7 @@ __generate_report_vars() {
 	__generate_blockdev_report_vars "SCRATCH_DEV"
 
 	test "$FSTYP" = "xfs" && __generate_xfs_report_vars
+	[[ "$FSTYP" == ext[0-9]* ]] && __generate_ext4_report_vars
 }
 
 #

