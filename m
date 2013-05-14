Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BAF827F37
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 15:35:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9D4FF8F8033
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 13:35:27 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id UXwC0DHGc1UvQcBR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 May 2013 13:35:26 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 8C9817C0417
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 14:35:25 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21])
	by mx2.fusionio.com with ESMTP id WrlAD6suI32gUNJa
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 14 May 2013 14:35:24 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: 311: fsck the dmflakey device instead of the real
	device
Date: Tue, 14 May 2013 16:35:22 -0400
Message-ID: <1368563722-23452-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
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

Dave pointed out that xfs was having issues with 311 because of caching issues.
He suggested that I fsck the dm-flakey device to make sure we don't have this
problem.  This is the easiest way I could think to accomplish this, please let
me know if this is a bad idea.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/generic/311 |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tests/generic/311 b/tests/generic/311
index 2b3b569..f11119b 100644
--- a/tests/generic/311
+++ b/tests/generic/311
@@ -125,7 +125,10 @@ _run_test()
 
 	#Unmount and fsck to make sure we got a valid fs after replay
 	_unmount_flakey
+	tmp=$SCRATCH_DEV
+	SCRATCH_DEV=$FLAKEY_DEV
 	_check_scratch_fs
+	SCRATCH_DEV=$tmp
 	[ $? -ne 0 ] && _fatal "fsck failed"
 
 	_mount_flakey
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
