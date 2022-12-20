Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45269C001B2
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 00:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbiLTABl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 19:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbiLTABj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 19:01:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD89A2613;
        Mon, 19 Dec 2022 16:01:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A5666117E;
        Tue, 20 Dec 2022 00:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77F2C433D2;
        Tue, 20 Dec 2022 00:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671494497;
        bh=3WVr78pi6CwfpZxITi+fPNPnolf+nJlIy6DgEKcOyO0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sVYKkKLcV8IG0Si2lexhLkPIk9svdC4LfLbH+g3b2pc20UziK436Ue4tniqcFfzx6
         zC+zdOqmc8dGUZH6kF9JzoMH+0/pyjFP433tVFj8xDw4tKO4NcY71eE126HrRTXAv7
         KjPKL0Nzj1iPvzaW6L53ewxzsTlFAk/Q5eh0xJuYO+wMRwvgPctQds9ljr/W6zTklQ
         ve8h9HUV7AMbEIkCMhwC/5NaHQXuMemuPTsEXDsOmC2sJo9WnHk0WhVK7m5vfnX7+U
         2RU5Zq5Ox40feb9olSasNl1dOrSU3vaGDeeU5LsNGe6JcFgOJh16HDuxCZZY5bNk8N
         TX1avkz2Dxaow==
Subject: [PATCH 6/8] report: collect basic information about a test run
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com
Date:   Mon, 19 Dec 2022 16:01:37 -0800
Message-ID: <167149449737.332657.1308561091226926848.stgit@magnolia>
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

Record various generic information about an fstests run when generating
a junit xml report.  This includes the cpu architecture, the kernel
revision, the CPU, memory, and numa node counts, and some information
about the block devices passed in.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/report |   44 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)


diff --git a/common/report b/common/report
index 642e0426a6..68646a7709 100644
--- a/common/report
+++ b/common/report
@@ -19,6 +19,42 @@ encode_xml()
 		-e 's/"/\&quot;/g'
 }
 
+# Fill out REPORT_VARS with information about the block device referred to by
+# the passed-in bash variable.
+__generate_blockdev_report_vars() {
+	local bdev_var="$1"
+	local bdev="${!bdev_var}"
+
+	test -z "$bdev" && return
+	test -b "$bdev" || return
+	local sysfs_bdev="$(_sysfs_dev "$bdev")"
+
+	REPORT_VARS["${bdev_var}_SIZE_KB"]="$(( "$(blockdev --getsz "$bdev")" / 2 ))"
+	REPORT_VARS["${bdev_var}_ROTATIONAL"]="$(cat "$sysfs_bdev/queue/rotational" 2>/dev/null)"
+	REPORT_VARS["${bdev_var}_DAX"]="$(cat "$sysfs_bdev/queue/dax" 2>/dev/null)"
+	REPORT_VARS["${bdev_var}_DISCARD"]="$(sed -e 's/[1-9][0-9]*/1/g' "$sysfs_bdev/queue/discard_max_bytes" 2>/dev/null)"
+	REPORT_VARS["${bdev_var}_WRITE_ZEROES"]="$(sed -e 's/[1-9][0-9]*/1/g' "$sysfs_bdev/queue/write_zeroes_max_bytes" 2>/dev/null)"
+	REPORT_VARS["${bdev_var}_PHYS_BLOCK_BYTES"]="$(cat "$sysfs_bdev/queue/physical_block_size" 2>/dev/null)"
+	REPORT_VARS["${bdev_var}_LBA_BYTES"]="$(cat "$sysfs_bdev/queue/logical_block_size" 2>/dev/null)"
+	REPORT_VARS["${bdev_var}_ZONES"]="$(cat "$sysfs_bdev/queue/nr_zones" 2>/dev/null)"
+}
+
+# Fill out REPORT_VARS with tidbits about our test runner configuration.
+# Caller is required to declare REPORT_VARS to be an associative array.
+__generate_report_vars() {
+	REPORT_VARS["ARCH"]="$(uname -m)"
+	REPORT_VARS["KERNEL"]="$(uname -r)"
+	REPORT_VARS["CPUS"]="$(getconf _NPROCESSORS_ONLN 2>/dev/null)"
+	REPORT_VARS["MEM_KB"]="$(grep MemTotal: /proc/meminfo | awk '{print $2}')"
+	REPORT_VARS["SWAP_KB"]="$(grep SwapTotal: /proc/meminfo | awk '{print $2}')"
+
+	test -e /sys/devices/system/node/possible && \
+		REPORT_VARS["NUMA_NODES"]="$(cat /sys/devices/system/node/possible 2>/dev/null)"
+
+	__generate_blockdev_report_vars "TEST_DEV"
+	__generate_blockdev_report_vars "SCRATCH_DEV"
+}
+
 #
 # Xunit format report functions
 _xunit_add_property()
@@ -64,11 +100,17 @@ _xunit_make_section_report()
  hostname="$HOST" timestamp="$timestamp">
 ENDL
 
+	declare -A REPORT_VARS
+	__generate_report_vars
+
 	# Properties
 	echo -e "\t<properties>" >> $REPORT_DIR/result.xml
+	(for key in "${!REPORT_VARS[@]}"; do
+		_xunit_add_property "$key" "${REPORT_VARS["$key"]}"
+	done;
 	for p in "${REPORT_ENV_LIST[@]}"; do
 		_xunit_add_property "$p" "${!p}"
-	done | sort >> $REPORT_DIR/result.xml
+	done) | sort >> $REPORT_DIR/result.xml
 	echo -e "\t</properties>" >> $REPORT_DIR/result.xml
 	if [ -f $report ]; then
 		cat $report >> $REPORT_DIR/result.xml

