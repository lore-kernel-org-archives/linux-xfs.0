Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF48C6379F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 01:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbjBOBrK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 20:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbjBOBrJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 20:47:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E673526F;
        Tue, 14 Feb 2023 17:46:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0798E6196F;
        Wed, 15 Feb 2023 01:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FB0C433EF;
        Wed, 15 Feb 2023 01:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676425618;
        bh=B3ZvG4KdM4h96XRkeLA3WAYBfYJMmcm31BrKP84ZO78=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MRqGGpgXOz+i0980wF+1Sm1kWqY7lTgj2r59/KBWG5bwYtYkiB3EuLotdAN87xYzw
         a7PIefW/qpuZr+vWZwxNHkg8wX0sL+KyShb5N5JcZ2GGq3WDQ1s9x8Z+AYpfM/Zovl
         MkCCldwYTeg4+flZ2Gu/DpcOuRFP7+nhg73r9lRisB85njt0WHVLDaEDfB8gB8WSJP
         V/ref2mNhmH5p/k3AasSA7uI5W1PoQNdi1cul5zxfNPN40SX3FBE6y9kTfuAhdN/cc
         gxkyqCKeHau+4o97mAISVkFpb3/hZoWmOW7KKBq9ZyCc/OWkk5XHFw6rA0QMTsSwJZ
         9XH2ArrWPHQWA==
Subject: [PATCH 14/14] report: allow test runners to inject arbitrary values
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Feb 2023 17:46:57 -0800
Message-ID: <167642561790.2118945.13068111127264406746.stgit@magnolia>
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

Per Ted's request, add to the test section reporting code the ability
for test runners to point to a file containing colon-separated key value
pairs.  These key value pairs will be recorded in the report file as
extra properties.

Requested-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 README        |    3 +++
 common/report |   10 ++++++++++
 2 files changed, 13 insertions(+)


diff --git a/README b/README
index 4c4f22f853..a8c67cea4d 100644
--- a/README
+++ b/README
@@ -245,6 +245,9 @@ Misc:
    this option is supported for all filesystems currently only -overlay is
    expected to run without issues. For other filesystems additional patches
    and fixes to the test suite might be needed.
+ - Set REPORT_VARS_FILE to a file containing colon-separated name-value pairs
+   that will be recorded in the test section report.  Names must be unique.
+   Whitespace surrounding the colon will be removed.
 
 ______________________
 USING THE FSQA SUITE
diff --git a/common/report b/common/report
index e22e2f8558..4b45f7c803 100644
--- a/common/report
+++ b/common/report
@@ -44,9 +44,19 @@ __generate_blockdev_report_vars() {
 	REPORT_VARS["${bdev_var}_ZONES"]="$(cat "$sysfs_bdev/queue/nr_zones" 2>/dev/null)"
 }
 
+__import_report_vars() {
+	local fname="$1"
+
+	while IFS=':' read key value; do
+		REPORT_VARS["${key%% }"]="${value## }"
+	done < "$1"
+}
+
 # Fill out REPORT_VARS with tidbits about our test runner configuration.
 # Caller is required to declare REPORT_VARS to be an associative array.
 __generate_report_vars() {
+	test "$REPORT_VARS_FILE" && __import_report_vars "$REPORT_VARS_FILE"
+
 	REPORT_VARS["ARCH"]="$(uname -m)"
 	REPORT_VARS["KERNEL"]="$(uname -r)"
 	REPORT_VARS["CPUS"]="$(getconf _NPROCESSORS_ONLN 2>/dev/null)"

