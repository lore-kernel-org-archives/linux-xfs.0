Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 May 2007 09:47:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4HGlOfB004777
	for <xfs@oss.sgi.com>; Thu, 17 May 2007 09:47:25 -0700
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 218051807A959
	for <xfs@oss.sgi.com>; Thu, 17 May 2007 11:47:24 -0500 (CDT)
Message-ID: <464C871B.3090402@sandeen.net>
Date: Thu, 17 May 2007 11:47:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] fix up xfstests a bit for linux+udf
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

udf on linux doesn't support acls or attrs, so prevent those tests from running.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: xfstests/020
===================================================================
--- xfstests.orig/020
+++ xfstests/020
@@ -65,7 +65,7 @@ _attr_list()
 
 
 # real QA test starts here
-_supported_fs xfs udf
+_supported_fs xfs
 _supported_os Linux
 
 [ -x /usr/bin/attr ] || _notrun "attr is not installed"
Index: xfstests/051
===================================================================
--- xfstests.orig/051
+++ xfstests/051
@@ -56,7 +56,7 @@ _cleanup()
 #
 
 # real QA test starts here
-_supported_fs xfs udf
+_supported_fs xfs
 _supported_os Linux
 
 [ -x /usr/bin/chacl ] || _notrun "chacl executable not found"
Index: xfstests/062
===================================================================
--- xfstests.orig/062
+++ xfstests/062
@@ -102,7 +102,7 @@ _create_test_bed()
 }
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs xfs nfs
 _supported_os Linux
 
 _require_scratch
Index: xfstests/070
===================================================================
--- xfstests.orig/070
+++ xfstests/070
@@ -33,6 +33,7 @@ _cleanup()
 _supported_fs xfs udf nfs
 _supported_os IRIX Linux
 
+[ "$FSTYP" == udf -a "$HOSTOS" == Linux ] && _notrun "Linux UDF does not support extended attributes"
 _setup_testdir
 
 $FSSTRESS_PROG \
Index: xfstests/105
===================================================================
--- xfstests.orig/105
+++ xfstests/105
@@ -35,6 +35,8 @@ _cleanup()
 _supported_fs xfs udf
 _supported_os IRIX Linux
 
+[ "$FSTYP" == udf -a "$HOSTOS" == Linux ] && _notrun "Linux UDF does not support ACLS"
+
 # real QA test starts here
 
 rm -f $seq.full
