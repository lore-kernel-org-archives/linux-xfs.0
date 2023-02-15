Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A10C05027
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 01:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbjBOBqY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 20:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbjBOBqY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 20:46:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6EE33462;
        Tue, 14 Feb 2023 17:46:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46F72B81F88;
        Wed, 15 Feb 2023 01:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAB4C433EF;
        Wed, 15 Feb 2023 01:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676425578;
        bh=aDoHPwIX71sr2bOvQRnxSv2gH4rLK/XOdaCIF4+rU80=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZRrRWAgQYuX6aMrKU8hjmjBBDlGoAAfOX72LZPz7KyoNDoTbEhd8PzbB4sS0BiFpq
         Ogm2XLwgoNXWTUxAtmrdf7KmIlWgGvLK3KaseBypU0pbQq7DiV8+t4I73Rtm3eySQv
         8Dt0JUd5rOZNECuXmxEEgEN9FPpqYDBqIpb76Rb1tFlN1PMQyliJRyK0T7X73YmjRx
         l0aVlLcxcBTkLeenC0C0jBDuO8lvI6W6NJiufSLAzrnEuuXQjREoBBF2oWzXH8PUw3
         F4tZnUYwO7uLu3k0/udnbCarGeaQL45prFGHTiZIKSJUNthYh/HbRWmKq4LUr4xh+f
         wGD2aOvYUl5Ug==
Subject: [PATCH 07/14] report: encode the kernel log as a separate xml element
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Feb 2023 17:46:18 -0800
Message-ID: <167642557848.2118945.1727380164070339363.stgit@magnolia>
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

Record the .dmesg file in a new <kernel-log> element instead of
multiplexing it with <system-err>.  This means that the xml report can
now capture kernel log and bad golden output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/report |   11 +++++------
 doc/xunit.xsd |   14 ++++++++++++--
 2 files changed, 17 insertions(+), 8 deletions(-)


diff --git a/common/report b/common/report
index eb169175bc..2e5959312a 100644
--- a/common/report
+++ b/common/report
@@ -137,15 +137,14 @@ _xunit_make_testcase_report()
 			printf ']]>\n'	>>$report
 			echo -e "\t\t</system-out>" >> $report
 		fi
-		if [ -n "$quiet" ]; then
-		   :
-		elif [ -f "$dmesg_file" ]; then
-			echo -e "\t\t<system-err>" >> $report
+		if [ -z "$quiet" -a -f "$dmesg_file" ]; then
+			echo -e "\t\t<kernel-log>" >> $report
 			printf	'<![CDATA[\n' >>$report
 			cat "$dmesg_file" | tr -dc '[:print:][:space:]' | encode_cdata >>$report
 			printf ']]>\n'	>>$report
-			echo -e "\t\t</system-err>" >> $report
-		elif [ -s "$outbad_file" ]; then
+			echo -e "\t\t</kernel-log>" >> $report
+		fi
+		if [ -z "$quiet" -a -s "$outbad_file" ]; then
 			echo -e "\t\t<system-err>" >> $report
 			printf	'<![CDATA[\n' >>$report
 			$diff "$out_src" "$outbad_file" | encode_cdata >>$report
diff --git a/doc/xunit.xsd b/doc/xunit.xsd
index 3ed72f2f86..d287eaf5a2 100644
--- a/doc/xunit.xsd
+++ b/doc/xunit.xsd
@@ -131,7 +131,7 @@
                                 </xs:complexType>
                             </xs:element>
                         </xs:choice>
-                        <xs:choice minOccurs="0" maxOccurs="2">
+                        <xs:choice minOccurs="0" maxOccurs="3">
                             <xs:element name="system-out" minOccurs="0" maxOccurs="1">
                                 <xs:annotation>
                                     <xs:documentation xml:lang="en">Data that was written to the .full log file while the test was executed.</xs:documentation>
@@ -144,7 +144,17 @@
                             </xs:element>
                             <xs:element name="system-err" minOccurs="0" maxOccurs="1">
                                 <xs:annotation>
-                                    <xs:documentation xml:lang="en">Kernel log or data that was compared to the golden output file after the test was executed.</xs:documentation>
+                                    <xs:documentation xml:lang="en">Data that was compared to the golden output file after the test was executed.</xs:documentation>
+                                </xs:annotation>
+                                <xs:simpleType>
+                                    <xs:restriction base="pre-string">
+                                        <xs:whiteSpace value="preserve"/>
+                                    </xs:restriction>
+                                </xs:simpleType>
+                            </xs:element>
+                            <xs:element name="kernel-log" minOccurs="0" maxOccurs="1">
+                                <xs:annotation>
+                                    <xs:documentation xml:lang="en">Kernel log recorded while the test was executed.</xs:documentation>
                                 </xs:annotation>
                                 <xs:simpleType>
                                     <xs:restriction base="pre-string">

