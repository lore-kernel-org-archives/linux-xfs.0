Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B165C05027
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 01:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbjBOBqK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 20:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjBOBqJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 20:46:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84FC3344E;
        Tue, 14 Feb 2023 17:46:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 442EE6199D;
        Wed, 15 Feb 2023 01:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88CFC433EF;
        Wed, 15 Feb 2023 01:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676425567;
        bh=W2HFy7gevwuyCLmk5A6qMgfDk4GwnyEbZWcPH1HRhGk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Yx5U4x5VUqN1cyW+RqhdE9PRadLTgotk8q3TRNQlbbWGhMX3lYqvJIWEAuAm4aTuT
         HTxwY35eomp5e/blMD8iTNuxdgJ/PCAwutrnZln4DEuv4/5zmwy81TqgHuZZhkCBs7
         k9Po6adCLHL2hLkkizMl485rY0Nb/nmkFDpNnRJlNZ8ucbQCh4oEkJds6E5znEti8N
         Z4qO6pt0M0CvaZozkOsa2X14TtV3bpXn9KvjxAUHiqhRWBjfk2z7EMooZEE4AWcNJw
         /4GV6l2752X+9RnyTvAZwsWkwPHDe9OTPdv/MpIgI/JN2c4VJwcrWcbXtflDfWtxpI
         F0lRU3y2ZUrnQ==
Subject: [PATCH 05/14] report: record fstests start and report generation
 timestamps
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Feb 2023 17:46:07 -0800
Message-ID: <167642556710.2118945.13688640580029423327.stgit@magnolia>
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

Report two new timestamps in the xml report: the time that ./check was
started, and the time that the report was generated.  We introduce new
timestamps to minimize breakage with parsing scripts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 check         |    1 +
 common/report |    4 +++-
 doc/xunit.xsd |   10 ++++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)


diff --git a/check b/check
index f2be3d7d7d..1a58a2b269 100755
--- a/check
+++ b/check
@@ -668,6 +668,7 @@ _run_seq() {
 
 _detect_kmemleak
 _prepare_test_list
+fstests_start_time="$(date +"%F %T")"
 
 if $OPTIONS_HAVE_SECTIONS; then
 	trap "_summary; exit \$status" 0 1 2 3 15
diff --git a/common/report b/common/report
index 8e19e9f557..be991b55f5 100644
--- a/common/report
+++ b/common/report
@@ -62,7 +62,9 @@ _xunit_make_section_report()
  name="xfstests"
  failures="$bad_count" skipped="$notrun_count" tests="$tests_count" time="$sect_time"
  hostname="$HOST"
- timestamp="$timestamp"
+  start_timestamp="$(date -Iseconds --date="$fstests_start_time")"
+        timestamp="$timestamp"
+ report_timestamp="$(date -Iseconds)"
 >
 ENDL
 
diff --git a/doc/xunit.xsd b/doc/xunit.xsd
index 653f486871..3ed72f2f86 100644
--- a/doc/xunit.xsd
+++ b/doc/xunit.xsd
@@ -187,6 +187,16 @@
                 <xs:documentation xml:lang="en">Time that the last testcase was started. If no tests are started, this is the time the report was generated. Timezone must be specified as an offset from UTC.</xs:documentation>
             </xs:annotation>
         </xs:attribute>
+        <xs:attribute name="report_timestamp" type="ISO8601_DATETIME_PATTERN" use="required">
+            <xs:annotation>
+                <xs:documentation xml:lang="en">Time that the report was generated.</xs:documentation>
+            </xs:annotation>
+        </xs:attribute>
+        <xs:attribute name="start_timestamp" type="ISO8601_DATETIME_PATTERN" use="required">
+            <xs:annotation>
+                <xs:documentation xml:lang="en">Time that fstests was started.</xs:documentation>
+            </xs:annotation>
+        </xs:attribute>
         <xs:attribute name="hostname" use="required">
             <xs:annotation>
                 <xs:documentation xml:lang="en">Host on which the tests were executed. 'localhost' should be used if the hostname cannot be determined.</xs:documentation>

