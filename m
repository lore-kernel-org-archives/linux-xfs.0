Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA692C61DA4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 01:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbjBOBqH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 20:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjBOBqG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 20:46:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C4934028;
        Tue, 14 Feb 2023 17:46:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C43CB81F5F;
        Wed, 15 Feb 2023 01:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B32C433D2;
        Wed, 15 Feb 2023 01:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676425562;
        bh=2dLtk/dgWRSizQWYnWSkBBdxwheAzIh/VcgGY5g7LpY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WBB4tYPmxHZ0iL+B/ikqtZHwR5ZRJP1DOJQHMk8U8Sk2+plo4yssumpDcj9yM+Yav
         Ct5qnE/7V3/fUCNd4FcysvRJYSgaOt6mSHKW8R5OECbIOJu9Dli6RiLz927x5rsTeI
         2BuOaOH3+MYtRZPQ4TnBhsPGwT6KynbEv31Umm1U5PnrhWsxtkVHXIlafqFOV1yP42
         6yLTDAGh9AGNF63MiautTToEmk6H1a2WaVFEtmSI8Qvk/ITa4Lw9Hb/iDXLlr2vt4y
         9OUUmXZdmDMmDozkZAh0nbAkcF7FGOSWc1xCgtoh81Z5HygOHKHJ208ENK723gZNFC
         yFK2iz+sKVVSw==
Subject: [PATCH 04/14] report: clarify the meaning of the timestamp attribute
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Feb 2023 17:46:01 -0800
Message-ID: <167642556151.2118945.10705623662883054692.stgit@magnolia>
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

We've never specified what the timestamp attribute of the testsuite
element actually means, and it history is rather murky.

Prior to the introduction of the xml report format in commit f9fde7db2f,
the "date_time" variable was used only to scrape dmesg via the /dev/kmsg
device after each test.  If /dev/kmsg was not a writable path, the
variable was not set at all.  In this case, the report timestamp would
be blank.

In commit ffdecf7498a1, Ted changed the xunit report code to handle
empty date_time values by setting date_time to the time of report
generation.  This change was done to handle the case where no tests are
run at all.  However, it did not change the behavior that date_time is
not set if /dev/kmsg is not writable.

Clear up all this confusion by defining the timestamp attribute to
reflect the start time of the most recent test, regardless of the state
of /dev/kmsg.  If no tests are run, then define the attribute to be the
time of report generation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 check         |    1 +
 common/report |    8 +++++---
 doc/xunit.xsd |    2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)


diff --git a/check b/check
index 14b398fd73..f2be3d7d7d 100755
--- a/check
+++ b/check
@@ -917,6 +917,7 @@ function run_section()
 		# to be reported for each test
 		(echo 1 > $DEBUGFS_MNT/clear_warn_once) > /dev/null 2>&1
 
+		test_start_time="$(date +"%F %T")"
 		if [ "$DUMP_OUTPUT" = true ]; then
 			_run_seq 2>&1 | tee $tmp.out
 			# Because $? would get tee's return code
diff --git a/common/report b/common/report
index 1817132d51..8e19e9f557 100644
--- a/common/report
+++ b/common/report
@@ -46,8 +46,8 @@ _xunit_make_section_report()
 	local report=$tmp.report.xunit.$sect_name.xml
 	# Header
 	echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $REPORT_DIR/result.xml
-	if [ -n "$date_time" ]; then
-		timestamp="$(date -Iseconds --date="$date_time")"
+	if [ -n "$test_start_time" ]; then
+		timestamp="$(date -Iseconds --date="$test_start_time")"
 	else
 		timestamp="$(date -Iseconds)"
 	fi
@@ -61,7 +61,9 @@ _xunit_make_section_report()
 
  name="xfstests"
  failures="$bad_count" skipped="$notrun_count" tests="$tests_count" time="$sect_time"
- hostname="$HOST" timestamp="$timestamp">
+ hostname="$HOST"
+ timestamp="$timestamp"
+>
 ENDL
 
 	# Properties
diff --git a/doc/xunit.xsd b/doc/xunit.xsd
index 9295c5dc82..653f486871 100644
--- a/doc/xunit.xsd
+++ b/doc/xunit.xsd
@@ -184,7 +184,7 @@
         </xs:attribute>
         <xs:attribute name="timestamp" type="ISO8601_DATETIME_PATTERN" use="required">
             <xs:annotation>
-                <xs:documentation xml:lang="en">when the test was executed. Timezone must be specified as an offset from UTC.</xs:documentation>
+                <xs:documentation xml:lang="en">Time that the last testcase was started. If no tests are started, this is the time the report was generated. Timezone must be specified as an offset from UTC.</xs:documentation>
             </xs:annotation>
         </xs:attribute>
         <xs:attribute name="hostname" use="required">

