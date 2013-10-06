Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 395347F52
	for <xfs@oss.sgi.com>; Sun,  6 Oct 2013 15:42:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 03EFD304059
	for <xfs@oss.sgi.com>; Sun,  6 Oct 2013 13:42:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id q23RoHjo3GjJnFPB for
	<xfs@oss.sgi.com>; Sun, 06 Oct 2013 13:42:33 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r96KgWIb031222
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sun, 6 Oct 2013 16:42:32 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r96KgVVV023722
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 6 Oct 2013 16:42:31 -0400
Message-ID: <5251CB37.2040406@redhat.com>
Date: Sun, 06 Oct 2013 15:42:31 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: mkfs scratch device in generic/294
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
To: xfs-oss <xfs@oss.sgi.com>

test 294 is using the scratch device w/o mkfs-ing it first,
this runs the risk of following a test which completely
fills the fs, causing 294 to fail.

add "rm -f $seqres.full" as well, it was growing on every run.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/tests/generic/294 b/tests/generic/294
index fa7f339..3fa6ba2 100755
--- a/tests/generic/294
+++ b/tests/generic/294
@@ -48,6 +48,9 @@ _supported_fs generic
 _supported_os Linux
 _require_scratch
 
+rm -f $seqres.full
+_scratch_mkfs > $seqres.full 2>&1 || _fail "Could not mkfs scratch device"
+
 THIS_TEST_DIR=$SCRATCH_MNT/$seq.test
 
 _create_files()

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
