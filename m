Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 836A3C61DA4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 01:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbjBOBqc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 20:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjBOBqb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 20:46:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EC13344E;
        Tue, 14 Feb 2023 17:46:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3C6A6199D;
        Wed, 15 Feb 2023 01:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E77EC433D2;
        Wed, 15 Feb 2023 01:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676425590;
        bh=FA4EEx8gfdDz4k6GWGgK8hBjfnTqt2wh6MFCE1JniaM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ONjxZqcr3ZnoTlp5gQuU+lJ1H/Xp7n4IKwWudfcUGqvmRGPtNxvxn6kAfh+v5FE+X
         q15FovZCxk61zFdwdONMFls3tk0ReDYfK9D0YsWIk46uOxVShxNvmchQWNQcruHgj7
         8RtZ5VN2wYt5xrEcoMd0Xb4ZXf2o8M/i8DqMEZleJvTsnqs4X1PDxq1O1n3h8D2dwb
         HnjkfrebW6dYrgGasAt9h6tSJUJ52r0+1vkGXV22o1bfDadHYLf7OhZy6WI1o8kM40
         J+BW5UPEgFSvrSceAd93dyseBJpMJs3QCP/y+kSGYIt78pr4HnDclO+7OANp1zNq27
         eyRNzBABDlLCg==
Subject: [PATCH 09/14] report: pass property value to _xunit_add_property
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Feb 2023 17:46:29 -0800
Message-ID: <167642558963.2118945.5072238407025556768.stgit@magnolia>
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

Change this helper to require the caller to pass the value as the second
parameter.  This prepares us to start reporting a lot more information
about a test run, not all of which are encoded as bash variables.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/report |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)


diff --git a/common/report b/common/report
index 3ec2d88178..2ab83928db 100644
--- a/common/report
+++ b/common/report
@@ -29,12 +29,13 @@ encode_cdata()
 _xunit_add_property()
 {
 	local name="$1"
-	local value="${!name}"
+	local value="$2"
 
-	if [ ! -z "$value" ]; then
-		echo -e "\t\t<property name=\"$name\" value=\"$value\"/>"
-	fi
+	test -z "$value" && return
+
+	echo -e "\t\t<property name=\"$name\" value=\"$value\"/>"
 }
+
 _xunit_make_section_report()
 {
 	# xfstest:section ==> xunit:testsuite
@@ -76,7 +77,7 @@ ENDL
 	# Properties
 	echo -e "\t<properties>" >> $REPORT_DIR/result.xml
 	for p in "${REPORT_ENV_LIST[@]}"; do
-		_xunit_add_property "$p"
+		_xunit_add_property "$p" "${!p}"
 	done | sort >> $REPORT_DIR/result.xml
 	echo -e "\t</properties>" >> $REPORT_DIR/result.xml
 	if [ -f $report ]; then

