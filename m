Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 564DCC6FD1F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Mar 2023 00:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjCOAx3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 20:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjCOAx0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 20:53:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D22925966;
        Tue, 14 Mar 2023 17:53:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 195F6B81C39;
        Wed, 15 Mar 2023 00:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2415C433EF;
        Wed, 15 Mar 2023 00:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678841590;
        bh=aDoHPwIX71sr2bOvQRnxSv2gH4rLK/XOdaCIF4+rU80=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lNtX6z7vFl3U2oHhkdA/76CZuXT+u6npK/+GFfqQ6jApcZwecDVBqNaCcEIC3gKcQ
         p50aohBMPuusvbJYvbWvlvsuWcO1AX5pNP0Dz1EtXZGYeqTM84gYW92dCHFgfaexm7
         D2wUpSkNw4KY7dZzoy5yPzpssstYIOlzDmuFnmew7A5kR71F1Qory0jAWK72wYXcxT
         P322Jp47iw0TT+HuL6T0KerBTaTf3iH9aahOLxm3j57qxSbgjt9HJ025Se4YXihac8
         bXrmQmsPtdnjcGJmZPPzrqNhGaScTEbxoEcCbL2kJSrLlMoqOeKFIZfkDYXEefg5zj
         qclK9yDjDLE1g==
Subject: [PATCH 07/15] report: encode the kernel log as a separate xml element
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Mar 2023 17:53:10 -0700
Message-ID: <167884159031.2482843.9926414972357367277.stgit@magnolia>
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

