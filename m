Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 968597F54
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 14:42:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 597FB8F8033
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 12:42:49 -0700 (PDT)
Received: from mail-qc0-f182.google.com (mail-qc0-f182.google.com
	[209.85.216.182]) by cuda.sgi.com with ESMTP id
	Ogoo5xUmsFz3Mo8b (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Sep 2013 12:42:48 -0700 (PDT)
Received: by mail-qc0-f182.google.com with SMTP id k18so1672787qcv.41
	for <xfs@oss.sgi.com>; Fri, 06 Sep 2013 12:42:47 -0700 (PDT)
Date: Fri, 6 Sep 2013 15:42:43 -0400
From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH][RESEND]  xfstests: only run generic/300 on filesystems
	supporting
Message-ID: <20130906194243.GA19286@wallace>
MIME-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-ext4@vger.kernel.org

Generic/300 fails when run on a test filesystem that does not support
fallocate(), as in the case of an ext4 filesystem created without the
extent feature.  It uses fio's falloc ioengine to generate part of its
I/O load.

Verify that the test filesystem supports fallocate() before proceeding
with the test.  Also, delete any pre-existing test output to avoid
confusion with old results.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/generic/300 |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/generic/300 b/tests/generic/300
index 7c60728..1ac763b 100755
--- a/tests/generic/300
+++ b/tests/generic/300
@@ -43,6 +43,9 @@ _supported_fs generic
 _supported_os Linux
 _need_to_be_root
 _require_scratch
+_require_xfs_io_falloc
+
+rm -f $seqres.full
 
 NUM_JOBS=$((4*LOAD_FACTOR))
 BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
