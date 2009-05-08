Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n481CQXo241638 for <xfs@oss.sgi.com>; Thu, 7 May 2009 20:12:27 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E26D1252069
	for <xfs@oss.sgi.com>; Thu,  7 May 2009 18:16:41 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id XsRivOdcusEmXqXJ for
	<xfs@oss.sgi.com>; Thu, 07 May 2009 18:16:41 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 25D7BA9B0C4
	for <xfs@oss.sgi.com>; Thu,  7 May 2009 20:12:30 -0500 (CDT)
Message-ID: <4A0386FD.7000108@sandeen.net>
Date: Thu, 07 May 2009 20:12:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests 042: point xfs_fsr right at the fragmented file
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

Somehow 042 as it stands isn't actually defragging the fragmented
file we created (see 042.full post-run)

Probably need to look into that as well, but for now this should
make the call to fsr actually _do_ something.

This has let 2 fsr bugs slip through qa in the past few months.  :(

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/042 b/042
index 6628040..1ad81e4 100755
--- a/042
+++ b/042
@@ -114,7 +114,7 @@ _do "sum $SCRATCH_MNT/fragmented >$tmp.sum1"
 _do "Remove other files" "rm -rf $SCRATCH_MNT/{pad,hole*}"
 
 # defragment
-_do "Run xfs_fsr on filesystem" "$XFS_FSR_PROG -v $SCRATCH_DEV"
+_do "Run xfs_fsr on filesystem" "$XFS_FSR_PROG -v $SCRATCH_MNT/fragmented"
 _do "xfs_bmap -v $SCRATCH_MNT/fragmented"
 _do "Check 4k files" "src/fill2fs_check $tmp.manifest"
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
