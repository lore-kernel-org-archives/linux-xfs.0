Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEAF2C6FD1F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Mar 2023 00:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjCOAxh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 20:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCOAxh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 20:53:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09FC2007D;
        Tue, 14 Mar 2023 17:53:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72911B81C37;
        Wed, 15 Mar 2023 00:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C05C433EF;
        Wed, 15 Mar 2023 00:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678841613;
        bh=i7xX0hc8MsLy1WOFx+zcMT7yce6kJuM32RN5aTkt17s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=f4N8Gfz5U6wFjJAh496mY1l9wm40+LbzN9zVLZr2+uO1o1Tu+vyf71aQVxSS6/kBm
         e6WHtd1LuDdDtRFzPd/4cNrpsm42RTcHOO5uzPnr6KsB2sXwGUYUILmiYpeJVQ1q27
         fsiIEVGgSsHorHlmnxzrnrQeK8MjEtrxzpg9mkGp+51YSLTZrBEGrFgLRNHHH1VvlK
         wmD1c3zXaE649KZdPvtAO4fcsembznYDCrD+8YS2L8M1YFKu617pWfH2bfCaZCbunp
         sFDooTLCOG9RCj/svcbWMQynIlbMCQaa32khK8XgMEjsQfFNnL0DApfjgtNCpKAHfT
         eLZno9UDya9EQ==
Subject: [PATCH 11/15] report: collect basic information about a test run
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Mar 2023 17:53:32 -0700
Message-ID: <167884161278.2482843.3263104858658925696.stgit@magnolia>
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

