Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67DF3C61DA4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 01:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbjBOBp4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 20:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjBOBpz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 20:45:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7230734C35;
        Tue, 14 Feb 2023 17:45:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE739B81F88;
        Wed, 15 Feb 2023 01:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB50C4339C;
        Wed, 15 Feb 2023 01:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676425550;
        bh=6xuL0iZpbpNe1aGEaEvrrl+l0+uunevUefzRUNb0YhY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nJNQPZ5aLgGqVHkFSj2ebg7XF+SqTEBMxvOhfgYdDDz6wjKh9GASY7Ns4atxRicvS
         a2rEoP1q1lUrE8Jx9EGN53QzIe/y9+84FkU55RQJrW1Dqdfqw6+on541qdjLD54c+B
         TYO0t4KpH8ys1kwWjSEkdiHnqj788NPyG9ZUODyz6c2u8hZlU/68E3cdjT1tmk7QRy
         JrfQcrPKt+05l+zMs+nfVVD4wROXCfYvLfWPQtygqq/vXRWw86UEc+vgSSmJ3dctnI
         e0SLaqjm2IpBRS3GwTlUhOnn9/k15zCfP2thUSDd4KSS6NBFtDwjEdmpUx7L9qKBbS
         1iI/ob0YDJNhg==
Subject: [PATCH 02/14] report: derive an xml schema for the xunit report
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Feb 2023 17:45:50 -0800
Message-ID: <167642555019.2118945.6370812393585562210.stgit@magnolia>
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

The "xunit" report format emits an XML document that more or less
follows the junit xml schema.  However, there are two major exceptions:

1. fstests does not emit an @errors attribute on the testsuite element
because we don't have the concept of unanticipated errors such as
"unchecked throwables".

2. The system-out/system-err elements sound like they belong under the
testcase element, though the schema itself imprecisely says "while the
test was executed".  The schema puts them under the top-level testsuite
element, but we put them under the testcase element.

Define an xml schema for the xunit report format, and update the xml
headers to link to the schema file.  This enables consumers of the
reports to check mechanically that the incoming document follows the
format.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/report |   15 +++-
 doc/xunit.xsd |  226 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 238 insertions(+), 3 deletions(-)
 create mode 100644 doc/xunit.xsd


diff --git a/common/report b/common/report
index 64f9c86648..1d84650270 100644
--- a/common/report
+++ b/common/report
@@ -48,9 +48,18 @@ _xunit_make_section_report()
 	if [ -z "$date_time" ]; then
 		date_time=$(date +"%F %T")
 	fi
-	local stats="failures=\"$bad_count\" skipped=\"$notrun_count\" tests=\"$tests_count\" time=\"$sect_time\""
-	local hw_info="hostname=\"$HOST\" timestamp=\"${date_time/ /T}\" "
-	echo "<testsuite name=\"xfstests\" $stats  $hw_info >" >> $REPORT_DIR/result.xml
+
+	local fstests_ns="https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git"
+	cat >> $REPORT_DIR/result.xml << ENDL
+<testsuite
+ xmlns="$fstests_ns"
+ xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
+ xsi:schemaLocation="$fstests_ns $fstests_ns/tree/doc/xunit.xsd"
+
+ name="xfstests"
+ failures="$bad_count" skipped="$notrun_count" tests="$tests_count" time="$sect_time"
+ hostname="$HOST" timestamp="${date_time/ /T}">
+ENDL
 
 	# Properties
 	echo -e "\t<properties>" >> $REPORT_DIR/result.xml
diff --git a/doc/xunit.xsd b/doc/xunit.xsd
new file mode 100644
index 0000000000..ba97ccd67d
--- /dev/null
+++ b/doc/xunit.xsd
@@ -0,0 +1,226 @@
+<?xml version="1.0" encoding="UTF-8"?>
+<xs:schema
+ xmlns="https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git"
+ xmlns:xs="http://www.w3.org/2001/XMLSchema"
+
+ targetNamespace="https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git"
+ elementFormDefault="qualified"
+ attributeFormDefault="unqualified">
+    <xs:annotation>
+        <xs:documentation xml:lang="en">fstests xunit test result schema, derived from https://github.com/windyroad/JUnit-Schema</xs:documentation>
+    </xs:annotation>
+    <xs:element name="testsuite" type="testsuite"/>
+    <xs:simpleType name="ISO8601_DATETIME_PATTERN">
+        <xs:restriction base="xs:dateTime">
+            <xs:pattern value="[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}"/>
+        </xs:restriction>
+    </xs:simpleType>
+    <xs:element name="testsuites">
+        <xs:annotation>
+            <xs:documentation xml:lang="en">Contains an aggregation of testsuite results</xs:documentation>
+        </xs:annotation>
+        <xs:complexType>
+            <xs:sequence>
+                <xs:element name="testsuite" minOccurs="0" maxOccurs="unbounded">
+                    <xs:complexType>
+                        <xs:complexContent>
+                            <xs:extension base="testsuite">
+                                <xs:attribute name="package" type="xs:token" use="required">
+                                    <xs:annotation>
+                                        <xs:documentation xml:lang="en">Derived from testsuite/@name in the non-aggregated documents</xs:documentation>
+                                    </xs:annotation>
+                                </xs:attribute>
+                                <xs:attribute name="id" type="xs:int" use="required">
+                                    <xs:annotation>
+                                        <xs:documentation xml:lang="en">Starts at '0' for the first testsuite and is incremented by 1 for each following testsuite</xs:documentation>
+                                    </xs:annotation>
+                                </xs:attribute>
+                            </xs:extension>
+                        </xs:complexContent>
+                    </xs:complexType>
+                </xs:element>
+            </xs:sequence>
+        </xs:complexType>
+    </xs:element>
+    <xs:complexType name="testsuite">
+        <xs:annotation>
+            <xs:documentation xml:lang="en">Contains the results of executing a testsuite</xs:documentation>
+        </xs:annotation>
+        <xs:sequence>
+            <xs:element name="properties">
+                <xs:annotation>
+                    <xs:documentation xml:lang="en">Properties (e.g., environment settings) set during test execution</xs:documentation>
+                </xs:annotation>
+                <xs:complexType>
+                    <xs:sequence>
+                        <xs:element name="property" minOccurs="0" maxOccurs="unbounded">
+                            <xs:complexType>
+                                <xs:attribute name="name" use="required">
+                                    <xs:simpleType>
+                                        <xs:restriction base="xs:token">
+                                            <xs:minLength value="1"/>
+                                        </xs:restriction>
+                                    </xs:simpleType>
+                                </xs:attribute>
+                                <xs:attribute name="value" type="xs:string" use="required"/>
+                            </xs:complexType>
+                        </xs:element>
+                    </xs:sequence>
+                </xs:complexType>
+            </xs:element>
+            <xs:element name="testcase" minOccurs="0" maxOccurs="unbounded">
+                <xs:complexType>
+                    <xs:sequence>
+                        <xs:choice minOccurs="0" maxOccurs="1">
+                            <xs:element name="skipped" minOccurs="0" maxOccurs="1">
+                                <xs:annotation>
+                                    <xs:documentation xml:lang="en">Indicates that the test was skipped.</xs:documentation>
+                                </xs:annotation>
+                                <xs:complexType>
+                                    <xs:simpleContent>
+                                        <xs:extension base="pre-string">
+                                            <xs:attribute name="message" type="xs:string">
+                                                <xs:annotation>
+                                                    <xs:documentation xml:lang="en">The message specifying why the test case was skipped</xs:documentation>
+                                                </xs:annotation>
+                                            </xs:attribute>
+                                        </xs:extension>
+                                    </xs:simpleContent>
+                                </xs:complexType>
+                            </xs:element>
+                            <xs:element name="error" minOccurs="0" maxOccurs="1">
+                                <xs:annotation>
+                                    <xs:documentation xml:lang="en">Indicates that the test errored.  An errored test is one that had an unanticipated problem. e.g., an unchecked throwable; or a problem with the implementation of the test. Contains as a text node relevant data for the error, e.g., a stack trace</xs:documentation>
+                                </xs:annotation>
+                                <xs:complexType>
+                                    <xs:simpleContent>
+                                        <xs:extension base="pre-string">
+                                            <xs:attribute name="message" type="xs:string">
+                                                <xs:annotation>
+                                                    <xs:documentation xml:lang="en">The error message. e.g., if a java exception is thrown, the return value of getMessage()</xs:documentation>
+                                                </xs:annotation>
+                                            </xs:attribute>
+                                            <xs:attribute name="type" type="xs:string" use="required">
+                                                <xs:annotation>
+                                                    <xs:documentation xml:lang="en">The type of error that occured. e.g., if a java execption is thrown the full class name of the exception.</xs:documentation>
+                                                </xs:annotation>
+                                            </xs:attribute>
+                                        </xs:extension>
+                                    </xs:simpleContent>
+                                </xs:complexType>
+                            </xs:element>
+                            <xs:element name="failure">
+                                <xs:annotation>
+                                    <xs:documentation xml:lang="en">Indicates that the test failed. A failure is a test which the code has explicitly failed by using the mechanisms for that purpose. e.g., via an assertEquals. Contains as a text node relevant data for the failure, e.g., a stack trace</xs:documentation>
+                                </xs:annotation>
+                                <xs:complexType>
+                                    <xs:simpleContent>
+                                        <xs:extension base="pre-string">
+                                            <xs:attribute name="message" type="xs:string">
+                                                <xs:annotation>
+                                                    <xs:documentation xml:lang="en">The message specified in the assert</xs:documentation>
+                                                </xs:annotation>
+                                            </xs:attribute>
+                                            <xs:attribute name="type" type="xs:string" use="required">
+                                                <xs:annotation>
+                                                    <xs:documentation xml:lang="en">The type of the assert.</xs:documentation>
+                                                </xs:annotation>
+                                            </xs:attribute>
+                                        </xs:extension>
+                                    </xs:simpleContent>
+                                </xs:complexType>
+                            </xs:element>
+                        </xs:choice>
+                        <xs:choice minOccurs="0" maxOccurs="2">
+                            <xs:element name="system-out" minOccurs="0" maxOccurs="1">
+                                <xs:annotation>
+                                    <xs:documentation xml:lang="en">Data that was written to the .full log file while the test was executed.</xs:documentation>
+                                </xs:annotation>
+                                <xs:simpleType>
+                                    <xs:restriction base="pre-string">
+                                        <xs:whiteSpace value="preserve"/>
+                                    </xs:restriction>
+                                </xs:simpleType>
+                            </xs:element>
+                            <xs:element name="system-err" minOccurs="0" maxOccurs="1">
+                                <xs:annotation>
+                                    <xs:documentation xml:lang="en">Kernel log or data that was compared to the golden output file after the test was executed.</xs:documentation>
+                                </xs:annotation>
+                                <xs:simpleType>
+                                    <xs:restriction base="pre-string">
+                                        <xs:whiteSpace value="preserve"/>
+                                    </xs:restriction>
+                                </xs:simpleType>
+                            </xs:element>
+                        </xs:choice>
+                    </xs:sequence>
+                    <xs:attribute name="name" type="xs:token" use="required">
+                        <xs:annotation>
+                            <xs:documentation xml:lang="en">Name of the test method</xs:documentation>
+                        </xs:annotation>
+                    </xs:attribute>
+                    <xs:attribute name="classname" type="xs:token" use="required">
+                        <xs:annotation>
+                            <xs:documentation xml:lang="en">Full class name for the class the test method is in.</xs:documentation>
+                        </xs:annotation>
+                    </xs:attribute>
+                    <xs:attribute name="time" type="xs:decimal" use="required">
+                        <xs:annotation>
+                            <xs:documentation xml:lang="en">Time taken (in seconds) to execute the test</xs:documentation>
+                        </xs:annotation>
+                    </xs:attribute>
+                </xs:complexType>
+            </xs:element>
+        </xs:sequence>
+        <xs:attribute name="name" use="required">
+            <xs:annotation>
+                <xs:documentation xml:lang="en">Full class name of the test for non-aggregated testsuite documents. Class name without the package for aggregated testsuites documents</xs:documentation>
+            </xs:annotation>
+            <xs:simpleType>
+                <xs:restriction base="xs:token">
+                    <xs:minLength value="1"/>
+                </xs:restriction>
+            </xs:simpleType>
+        </xs:attribute>
+        <xs:attribute name="timestamp" type="ISO8601_DATETIME_PATTERN" use="required">
+            <xs:annotation>
+                <xs:documentation xml:lang="en">when the test was executed. Timezone may not be specified.</xs:documentation>
+            </xs:annotation>
+        </xs:attribute>
+        <xs:attribute name="hostname" use="required">
+            <xs:annotation>
+                <xs:documentation xml:lang="en">Host on which the tests were executed. 'localhost' should be used if the hostname cannot be determined.</xs:documentation>
+            </xs:annotation>
+            <xs:simpleType>
+                <xs:restriction base="xs:token">
+                    <xs:minLength value="1"/>
+                </xs:restriction>
+            </xs:simpleType>
+        </xs:attribute>
+        <xs:attribute name="tests" type="xs:int" use="required">
+            <xs:annotation>
+                <xs:documentation xml:lang="en">The total number of tests in the suite</xs:documentation>
+            </xs:annotation>
+        </xs:attribute>
+        <xs:attribute name="failures" type="xs:int" use="required">
+            <xs:annotation>
+                <xs:documentation xml:lang="en">The total number of tests in the suite that failed. A failure is a test which the code has explicitly failed by using the mechanisms for that purpose. e.g., via an assertEquals</xs:documentation>
+            </xs:annotation>
+        </xs:attribute>
+        <xs:attribute name="skipped" type="xs:int" use="optional">
+            <xs:annotation>
+                <xs:documentation xml:lang="en">The total number of ignored or skipped tests in the suite.</xs:documentation>
+            </xs:annotation>
+        </xs:attribute>
+        <xs:attribute name="time" type="xs:decimal" use="required">
+            <xs:annotation>
+                <xs:documentation xml:lang="en">Time taken (in seconds) to execute the tests in the suite</xs:documentation>
+            </xs:annotation>
+        </xs:attribute>
+    </xs:complexType>
+    <xs:simpleType name="pre-string">
+        <xs:restriction base="xs:string">
+            <xs:whiteSpace value="preserve"/>
+        </xs:restriction>
+    </xs:simpleType>
+</xs:schema>

