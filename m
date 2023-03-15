Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89885C7618A
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Mar 2023 00:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjCOAxK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 20:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjCOAxK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 20:53:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5B83D924;
        Tue, 14 Mar 2023 17:52:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34B37B81C3D;
        Wed, 15 Mar 2023 00:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20B5C433D2;
        Wed, 15 Mar 2023 00:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678841573;
        bh=2dLtk/dgWRSizQWYnWSkBBdxwheAzIh/VcgGY5g7LpY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q0E1XaaeR14SQC7rK4bhb3P3DaTV2fm8NnCnqJXij7dQ8LAQi9LKvsu8qokymAFgc
         nezt8MozHWUQ+QQmT1sTU8/LhwIbdGSPlwlG0Mm+hLCU1lDWT3ec8Mn3xUvyzvwjUC
         42FXKSDRMfno0U1lZXwlG/N4I6qw0hWiR8UbDJ8TOGM5uvyEhTIvJpb1byngq1Bsey
         iItyOSueO66sZhAdiewrKPhqMXKenIiUmX7tN+MntiJTqvlGXEq0N3Z54theUBBXum
         FMN3KxC4wpYZlKuMR4VZH0N3F6Avdfs0tB6bmrV5OKGigDADmq4BJItvkzFkmgEiKw
         tRFTf88gqXlZw==
Subject: [PATCH 04/15] report: clarify the meaning of the timestamp attribute
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Mar 2023 17:52:53 -0700
Message-ID: <167884157344.2482843.8376813921962028640.stgit@magnolia>
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

