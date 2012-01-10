Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0AGcPWc087965 for <xfs@oss.sgi.com>; Tue, 10 Jan 2012 10:38:25 -0600
Received: from mail-yx0-f181.google.com (mail-yx0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	j8F0EnyBrqS3kZMJ for <xfs@oss.sgi.com>;
	Tue, 10 Jan 2012 08:38:24 -0800 (PST)
Received: by yenm3 with SMTP id m3so3013369yen.26
	for <xfs@oss.sgi.com>; Tue, 10 Jan 2012 08:38:23 -0800 (PST)
From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] xfstests 273: Create lost+found to pass _check_scratch_fs
Date: Wed, 11 Jan 2012 00:37:49 +0800
Message-Id: <1326213469-22687-2-git-send-email-guaneryu@gmail.com>
In-Reply-To: <1326213469-22687-1-git-send-email-guaneryu@gmail.com>
References: <1326213469-22687-1-git-send-email-guaneryu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eryu Guan <guaneryu@gmail.com>

fsck.extN will complain lost+found is missing and fail 273.
So create lost+found explicitly after removing everything in
$SCRATCH_MNT.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 273 |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/273 b/273
index 2965132..9ecb2d3 100755
--- a/273
+++ b/273
@@ -36,6 +36,7 @@ _cleanup()
 {
 	cd /
 	rm -rf $SCRATCH_MNT/* $tmp.*
+	mkdir -p $SCRATCH_MNT/lost+found
 	_scratch_unmount
 }
 
@@ -107,6 +108,7 @@ _do_workload()
 	_pid=1
 	
 	rm -rf $SCRATCH_MNT/*
+	mkdir -p $SCRATCH_MNT/lost+found
 
 	_threads_set
 	_file_create
-- 
1.7.8.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
