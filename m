Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2NFpCtD102214 for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 10:51:17 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 404C61B5CB42
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 08:54:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jUCseEQVBXX2Sw9b for
	<xfs@oss.sgi.com>; Wed, 23 Mar 2011 08:54:12 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2NFsCnK018611
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 11:54:12 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p2NFrvvV024096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 11:54:05 -0400
Message-ID: <4D8A1795.3080401@redhat.com>
Date: Wed, 23 Mar 2011 10:53:57 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests 249: use -F option for xfs_io
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

Test 249 was appearing to pass on ext4, but it wasn't really
exercising the test due to lack of "-F" in the xfs_io arguments.

Without -F the files were created (oddly enough); neither pwrite
nor sendfile were executed, and the diff of the two (empty)
files passed, resulting in a passed test without testing anything.

So add the -F, capture the output, and test the result of each
xfs_io invocation.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/249 b/249
index 6fc972e..3b3a64d
--- a/249
+++ b/249
@@ -52,9 +52,12 @@ echo "Feel the serenity."
 
 SRC=$TEST_DIR/$seq.src
 DST=$TEST_DIR/$seq.dst
+rm -f $seq.full
 
-$XFS_IO_PROG -f -c "pwrite -S 0xa5a55a5a 0 32768k" -c fsync $SRC > /dev/null 2>&1
-$XFS_IO_PROG -f -c "sendfile -i $SRC 0 32768k" -c fsync $DST > /dev/null 2>&1
+$XFS_IO_PROG -F -f -c "pwrite -S 0xa5a55a5a 0 32768k" -c fsync $SRC >> $seq.full 2>&1
+[ $? -ne 0 ] && _fail "xfs_io pwrite failed"
+$XFS_IO_PROG -F -f -c "sendfile -i $SRC 0 32768k" -c fsync $DST >> $seq.full 2>&1
+[ $? -ne 0 ] && _fail "xfs_io sendfile failed"
 
 diff $SRC $DST
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
