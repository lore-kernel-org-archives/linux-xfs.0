Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE7CC76196
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Mar 2023 00:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjCOAxb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 20:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjCOAxa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 20:53:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B04B3D93C;
        Tue, 14 Mar 2023 17:53:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A358C61A8D;
        Wed, 15 Mar 2023 00:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FD9C433D2;
        Wed, 15 Mar 2023 00:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678841602;
        bh=FA4EEx8gfdDz4k6GWGgK8hBjfnTqt2wh6MFCE1JniaM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=R1wney6T0tITevVQTazuCIWy2tRWxSK2bijlffdC2anP3lwh2aXLQvqdgAXWBghLJ
         ImpCJv5gak2cAYOXjr3vOmXlz3lRLdyIPla8G1HA7MbiyEfBov/ciKjPk6LwXnfJxR
         AZK7OL3dyK/cB4yYL/LSjIagmmycUWxk8gWmcsZ9qDTdwSNnodVDn7RayCMybHNPGG
         cilKYwuNZYfY52jWPPgDhcvmnkRpIrZ9/j8MT4kRuNIAkiq6V79bZoUpKQhK1/ONXD
         Hb+g3PVfNahtoB2WEZKS9IRjsSHfd8H/1yMIJQBac0l7rHhZEvhBZ7gqrHwgCuC/mj
         P6ZBzFS/OIKFQ==
Subject: [PATCH 09/15] report: pass property value to _xunit_add_property
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Mar 2023 17:53:21 -0700
Message-ID: <167884160159.2482843.3272337401757797525.stgit@magnolia>
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

