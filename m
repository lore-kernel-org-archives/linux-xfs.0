Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2AD5C05027
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 01:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbjBOBp6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 20:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjBOBp6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 20:45:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEF133462;
        Tue, 14 Feb 2023 17:45:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC21E6199D;
        Wed, 15 Feb 2023 01:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5950CC433D2;
        Wed, 15 Feb 2023 01:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676425556;
        bh=Qik54vovpc327jWLgD9UI6QzowU+B6J69BoZPVm2b8I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GPNKgSDk6eTLhDxlepOXTgKvhwRFiCXWSs9UMkIdxiEW67jKsplhPgAeIuLqnpVWS
         GT32ya2W9xk8qR+7YqjOjoSrIF0LNKgyqbJ5fX2q7s1WQAgJC0iyQfA78OhyXaz2mU
         pJLNkfUuFFnoQIBvuhqCQFFGGVvKV4KXL+zplqyky40l78WfMbFZ2OXr1yBIors5Mx
         bAqszw8LISSpSWUwwcMcI9Lb6LHMRwHMrSJYHV72TWlD+bnw84mKZ4smmA69TsE6qa
         6FsDyk7UmqTf56fUJAirjNatcOmPZ6RmeZ7ZOuHXoBG6OodFvtJZ7nDPRSMoOhSlkj
         2ava0u6fgWsKA==
Subject: [PATCH 03/14] report: capture the time zone in the test report
 timestamp
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     Qu Wenruo <wqu@suse.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, leah.rumancik@gmail.com,
        quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Feb 2023 17:45:55 -0800
Message-ID: <167642555589.2118945.10596092258523998280.stgit@magnolia>
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

Make sure we put the time zone of the system running the test in the
timestamp that is recorded in the xunit report.  `date "+%F %T"' reports
the local time zone, not UTC.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Qu Wenruo <wqu@suse.com>
---
 common/report |    9 ++++++---
 doc/xunit.xsd |    4 ++--
 2 files changed, 8 insertions(+), 5 deletions(-)


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
index ba97ccd67d..9295c5dc82 100644
--- a/doc/xunit.xsd
+++ b/doc/xunit.xsd
@@ -12,7 +12,7 @@
     <xs:element name="testsuite" type="testsuite"/>
     <xs:simpleType name="ISO8601_DATETIME_PATTERN">
         <xs:restriction base="xs:dateTime">
-            <xs:pattern value="[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}"/>
+            <xs:pattern value="[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}[+-][0-9]{2}:[0-9]{2}"/>
         </xs:restriction>
     </xs:simpleType>
     <xs:element name="testsuites">
@@ -184,7 +184,7 @@
         </xs:attribute>
         <xs:attribute name="timestamp" type="ISO8601_DATETIME_PATTERN" use="required">
             <xs:annotation>
-                <xs:documentation xml:lang="en">when the test was executed. Timezone may not be specified.</xs:documentation>
+                <xs:documentation xml:lang="en">when the test was executed. Timezone must be specified as an offset from UTC.</xs:documentation>
             </xs:annotation>
         </xs:attribute>
         <xs:attribute name="hostname" use="required">

