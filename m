Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D6FC64EC7
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 01:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbjBOBqo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 20:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233553AbjBOBqn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 20:46:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B8334C02;
        Tue, 14 Feb 2023 17:46:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D20D619A0;
        Wed, 15 Feb 2023 01:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E075C433D2;
        Wed, 15 Feb 2023 01:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676425601;
        bh=i7xX0hc8MsLy1WOFx+zcMT7yce6kJuM32RN5aTkt17s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bbVitDWbqiJ41lUZ9pbURoRrVLlIgM6iZU0De2b+pVy8asMA9W76Nf45DpQwZZxhN
         GYPIqLV/4/xiLuycBqLzdPQandaK5jNcRXyYGj/4U+IPFx/FHgx/A6sgwZXM7pFT3s
         Gc7YpPRH9A/+wnYPlV5JFGuE7/wRAq2YOArAki45RtnkxMNNZY1CZDHNMbAkNdjvc6
         YlB85Gec96OL/omKTInTizxasBJFTVetBPBkhvbEC7iK6klQaWM/M5bI6zbEQZM87m
         AUP6KCNRPmKyGAvNDQ229KsC1maZrXCNzg9GLln8YufnBiVFOeSzHPW9QMMeIcaQz7
         mDs+0ezJrMt8A==
Subject: [PATCH 11/14] report: collect basic information about a test run
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Feb 2023 17:46:40 -0800
Message-ID: <167642560096.2118945.2213668079344484441.stgit@magnolia>
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

Record various generic information about an fstests run when generating
a junit xml report.  This includes the cpu architecture, the kernel
revision, the CPU, memory, and numa node counts, and some information
about the block devices passed in.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/report |   44 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)


diff --git a/common/report b/common/report
index 946ee4887c..90d4f980d1 100644
--- a/common/report
+++ b/common/report
@@ -24,6 +24,42 @@ encode_cdata()
 	cat -v | sed -e 's/]]>/]]]]><![CDATA[>/g'
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
@@ -77,11 +113,17 @@ _xunit_make_section_report()
 >
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

