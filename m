Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22GuJgp107733 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 10:56:20 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sxyObSOSgHhTOYbA for
	<xfs@oss.sgi.com>; Fri, 02 Mar 2012 08:56:18 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q22GuIH7025587
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 11:56:18 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q22GuHk2002214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 11:56:18 -0500
Message-ID: <4F50FBB1.1090107@redhat.com>
Date: Fri, 02 Mar 2012 10:56:17 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: add freeze and dangerous groups
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Add 2 new test groups:

freeze: tests which test filesystem freeze
dangerous: tests which may hang or oops

The 2nd may be useful for automated testing to do i.e.

./check -g auto -x dangerous
./check -g auto,dangerous

to try to get fuller coverage before running into tests
which may panic or hang the box and stop the test cycle.

I doubt I have all the potential dangerous tests, but
they can be added later when found.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/group b/group
index 01f406d..90b7a84 100644
--- a/group
+++ b/group
@@ -1,4 +1,3 @@
-#
 # QA groups control file
 # Defines test groups and nominal group owners
 # - do not start group names with a digit
@@ -104,6 +103,12 @@ atime
 # Test preallocation calls
 prealloc
 
+# Test filesystem freeze
+freeze
+
+# Tests which may oops or hang
+dangerous
+
 # Old tests that we won't spend any effort trying to run and make work
 # on current systems
 deprecated
@@ -178,7 +183,7 @@ deprecated
 065 dump auto
 066 dump ioctl auto quick
 067 acl attr auto quick
-068 other auto
+068 other auto freeze dangerous
 069 rw udf auto quick
 070 attr udf auto quick
 071 rw
@@ -229,7 +234,7 @@ deprecated
 116 quota auto quick
 117 attr auto quick
 118 quota auto quick
-119 log v2log auto
+119 log v2log auto freeze dangerous
 120 other auto quick
 121 log auto quick
 122 other auto quick
@@ -393,4 +398,4 @@ deprecated
 277 auto ioctl quick metadata
 278 repair auto
 279 auto mkfs
-280 auto quota
+280 auto quota freeze dangerous

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
