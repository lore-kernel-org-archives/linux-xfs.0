Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 94DD429E03
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 19:44:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7EFB38F8059
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 17:44:03 -0700 (PDT)
Received: from mail-ie0-f179.google.com (mail-ie0-f179.google.com
	[209.85.223.179]) by cuda.sgi.com with ESMTP id
	QldBMjVnSyfRvoGD (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 17:44:02 -0700 (PDT)
Received: by mail-ie0-f179.google.com with SMTP id c13so3624851ieb.24
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 17:44:02 -0700 (PDT)
Received: from [192.168.1.2] ([184.52.11.124])
	by mx.google.com with ESMTPSA id xf4sm18857735igb.8.2013.05.21.17.43.56
	for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
	Tue, 21 May 2013 17:44:01 -0700 (PDT)
Message-ID: <519C14A1.8000009@gmail.com>
Date: Tue, 21 May 2013 20:43:13 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: generic/258 questions (mount issue)...
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi!  When using xfstests generic/258 with along with $TEST_RTDEV 
$TEST_LOGDEV, it tends to scream bloody murder about corrupted 
partitions and such.  In fact, the commands in the test seem to do the 
right thing when executed by hand.  So once again, I grasped for straws 
and came up with this:

--- xfstests/tests/generic/258.orig	2013-05-21 20:19:38.430754829 -0400
+++ xfstests/tests/generic/258	2013-05-21 20:10:11.509021368 -0400
@@ -62,7 +62,7 @@
  # unmount, remount, and check the timestamp
  echo "Remounting to flush cache"
  umount $TEST_DEV
-mount $TEST_DEV $TEST_DIR
+_test_mount

  # Should yield -315593940 (prior to epoch)
  echo "Testing for negative seconds since epoch"

My questions are these:

1) Was there a better way to do this?

2) Not knowing the policy on umounting $TEST_DEV, could this have been a 
test for $SCRATCH_DEV?

This was tested only on XFS with rtdev and logdev partitions enabled.

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
