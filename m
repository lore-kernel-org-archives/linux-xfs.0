Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33201 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751719AbdGUEkS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:40:18 -0400
From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 10/15] README: remove IRIX-specific documentation
Date: Thu, 20 Jul 2017 21:38:48 -0700
Message-Id: <20170721043853.364-11-ebiggers3@gmail.com>
In-Reply-To: <20170721043853.364-1-ebiggers3@gmail.com>
References: <20170721043853.364-1-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

From: Eric Biggers <ebiggers@google.com>

xfstests is no longer supported on IRIX, so remove the IRIX-specific
instructions for building and running xfstests.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 README | 51 ++++++++++++++++++++++-----------------------------
 1 file changed, 22 insertions(+), 29 deletions(-)

diff --git a/README b/README
index 11bf6a94..9456fa76 100644
--- a/README
+++ b/README
@@ -2,44 +2,37 @@ _______________________
 BUILDING THE FSQA SUITE
 _______________________
 
-Building Linux:
-	- cd into the xfstests directory
-	- install prerequisite packages
-	  For example, for Ubuntu:
-		sudo apt-get install xfslibs-dev uuid-dev libtool-bin \
-		e2fsprogs automake gcc libuuid1 quota attr libattr1-dev make \
-		libacl1-dev libaio-dev xfsprogs libgdbm-dev gawk fio dbench \
-		uuid-runtime
-	  For Fedora, RHEL, or CentOS:
-		yum install acl attr automake bc dbench dump e2fsprogs fio \
-		gawk gcc indent libtool lvm2 make psmisc quota sed \
-		xfsdump xfsprogs \
-		libacl-devel libattr-devel libaio-devel libuuid-devel \
-		xfsprogs-devel btrfs-progs-devel
-		(Older distributions may require xfsprogs-qa-devel as well.)
-		(Note that for RHEL and CentOS, you may need the EPEL repo.)
-	- run make
-	- run make install
-	- create fsgqa test user ("sudo useradd fsgqa")
-	- create 123456-fsgqa test user ("sudo useradd 123456-fsgqa")
+- cd into the xfstests directory
+- install prerequisite packages
+  For example, for Ubuntu:
+	sudo apt-get install xfslibs-dev uuid-dev libtool-bin \
+	e2fsprogs automake gcc libuuid1 quota attr libattr1-dev make \
+	libacl1-dev libaio-dev xfsprogs libgdbm-dev gawk fio dbench \
+	uuid-runtime
+  For Fedora, RHEL, or CentOS:
+	yum install acl attr automake bc dbench dump e2fsprogs fio \
+	gawk gcc indent libtool lvm2 make psmisc quota sed \
+	xfsdump xfsprogs \
+	libacl-devel libattr-devel libaio-devel libuuid-devel \
+	xfsprogs-devel btrfs-progs-devel
+	(Older distributions may require xfsprogs-qa-devel as well.)
+	(Note that for RHEL and CentOS, you may need the EPEL repo.)
+- run make
+- run make install
+- create fsgqa test user ("sudo useradd fsgqa")
+- create 123456-fsgqa test user ("sudo useradd 123456-fsgqa")
 	
-Building IRIX:
-	- cd into the xfstests directory 
-	- set the ROOT and TOOLROOT env variables for IRIX appropriately
-	- run ./make_irix
-
 ______________________
 USING THE FSQA SUITE
 ______________________
 
-Preparing system for tests (IRIX and Linux):
+Preparing system for tests:
 
     - compile XFS into your kernel or load XFS modules
     - install administrative tools specific to the filesystem you wish to test
     - If you wish to run the udf components of the suite install
-      mkfs_udf and udf_db for IRIX and mkudffs for Linux. Also download and 
-      build the Philips UDF Verification Software from 
-      http://www.extra.research.philips.com/udf/, then copy the udf_test 
+      mkudffs. Also download and build the Philips UDF Verification Software
+      from http://www.extra.research.philips.com/udf/, then copy the udf_test
       binary to xfstests/src/. If you wish to disable UDF verification test
       set the environment variable DISABLE_UDF_TEST to 1.
 	
-- 
2.13.3

