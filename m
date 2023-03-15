Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09330C6FD1D
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Mar 2023 00:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjCOAx6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 20:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjCOAx5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 20:53:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A390319C72;
        Tue, 14 Mar 2023 17:53:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40D0361A8D;
        Wed, 15 Mar 2023 00:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3D7C433EF;
        Wed, 15 Mar 2023 00:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678841635;
        bh=djGUBsNNLaiAk71y23+h1TexBx0pNbwBkGur7nq4Y1Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BpuXKUz2gGVRnQErRIH2yXlCNoqJh+9O19xmHMvHJFEJNkqZ+W01GA9rCTjz8v2bY
         XejTSSbg1w69a2rLDf9D6SRTH7socEQ9I5lBxLZR5hYW4xseJ117jUA0wT53BZn80g
         +bNjal7PjljvnzkYYh6+3JDmXnj8CkqCNrF3mbKSK1i48uBNEGl1OqoV94w/gzT8fI
         ZjtwEJaqpnUeLZ1NBFYTeebdiYXhgheId5fp6SPR3iyJ0Tl/ddITa7tY3BkPUl52o1
         XwJ/6El6utmvKp+RFLAfj28Ro8EqTByzCOgcrt3IV3W7b9iMozAUrNcnymutzLhhaC
         zu52NhxdVdXKg==
Subject: [PATCH 15/15] report: allow test runners to inject arbitrary values
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Mar 2023 17:53:55 -0700
Message-ID: <167884163520.2482843.13683454023771021049.stgit@magnolia>
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
index 1ca506492b..4ee877a962 100644
--- a/README
+++ b/README
@@ -268,6 +268,9 @@ Misc:
    this option is supported for all filesystems currently only -overlay is
    expected to run without issues. For other filesystems additional patches
    and fixes to the test suite might be needed.
+ - Set REPORT_VARS_FILE to a file containing colon-separated name-value pairs
+   that will be recorded in the test section report.  Names must be unique.
+   Whitespace surrounding the colon will be removed.
 
 ______________________
 USING THE FSQA SUITE
diff --git a/common/report b/common/report
index db15aec54f..23ddbb096d 100644
--- a/common/report
+++ b/common/report
@@ -49,9 +49,19 @@ __generate_blockdev_report_vars() {
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

