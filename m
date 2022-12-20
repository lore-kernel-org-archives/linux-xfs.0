Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E103C4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 00:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiLTAB1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 19:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiLTABY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 19:01:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCE42678;
        Mon, 19 Dec 2022 16:01:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53CF2B81047;
        Tue, 20 Dec 2022 00:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183F9C433D2;
        Tue, 20 Dec 2022 00:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671494481;
        bh=xpryf+HUH4ukVMf6blbU+BdCHMxVjAUxWheoYhXuQFA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LaeTJ0c+0HnktKZCes4Wq9d0VpE1S31LvS1PSqcIjAccXy1tq9ZcMEE74yt3oTk6M
         7H3mnpr5do2BGCzwgrCHd5dyc0mC5MnhlW2Up/rMVdyMbUmqcQm/QgKI3A1uZgYpTN
         4vIqDSD7wxOWdFD0Qis7nPBg631sOSKBpHNsWRb4g9xEa4hPHI/GbFqBN+7fp8kYmm
         /BJn5g9gIbiVbhGHjFbO7oTD0Qf4p24CdZkSWpu3BAO4TXCgrAgNQsTwz+TLZGRdy8
         RY2uPAQNGCgRuDhNs9niyd3jf1aeF+xcoNVIDztgk6r/idOCcmutcl8LPIUyAJ2rXd
         s07CvysbkNkBw==
Subject: [PATCH 3/8] report: capture the time zone in the test report
 timestamp
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com
Date:   Mon, 19 Dec 2022 16:01:20 -0800
Message-ID: <167149448068.332657.14583277548579655582.stgit@magnolia>
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

Make sure we put the time zone of the system running the test in the
timestamp that is recorded in the xunit report.  `date "+%F %T"' reports
the local time zone, not UTC.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/report |    9 ++++++---
 doc/xunit.xsd |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)


diff --git a/common/report b/common/report
index 1d84650270..1817132d51 100644
--- a/common/report
+++ b/common/report
@@ -38,6 +38,7 @@ _xunit_make_section_report()
 	local bad_count="$3"
 	local notrun_count="$4"
 	local sect_time="$5"
+	local timestamp
 
 	if [ $sect_name == '-no-sections-' ]; then
 		sect_name='global'
@@ -45,8 +46,10 @@ _xunit_make_section_report()
 	local report=$tmp.report.xunit.$sect_name.xml
 	# Header
 	echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $REPORT_DIR/result.xml
-	if [ -z "$date_time" ]; then
-		date_time=$(date +"%F %T")
+	if [ -n "$date_time" ]; then
+		timestamp="$(date -Iseconds --date="$date_time")"
+	else
+		timestamp="$(date -Iseconds)"
 	fi
 
 	local fstests_ns="https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git"
@@ -58,7 +61,7 @@ _xunit_make_section_report()
 
  name="xfstests"
  failures="$bad_count" skipped="$notrun_count" tests="$tests_count" time="$sect_time"
- hostname="$HOST" timestamp="${date_time/ /T}">
+ hostname="$HOST" timestamp="$timestamp">
 ENDL
 
 	# Properties
diff --git a/doc/xunit.xsd b/doc/xunit.xsd
index 0aef8a9839..67f586b816 100644
--- a/doc/xunit.xsd
+++ b/doc/xunit.xsd
@@ -12,7 +12,7 @@
 	<xs:element name="testsuite" type="testsuite"/>
 	<xs:simpleType name="ISO8601_DATETIME_PATTERN">
 		<xs:restriction base="xs:dateTime">
-			<xs:pattern value="[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}"/>
+			<xs:pattern value="[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}[+-][0-9]{2}:[0-9]{2}"/>
 		</xs:restriction>
 	</xs:simpleType>
 	<xs:element name="testsuites">

