Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EKiYjk034576 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 14:44:34 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3FC15F0B315
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 12:45:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PQBfhMsi4KQT2yF4 for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2010 12:45:30 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0EKjUWe031625
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 15:45:30 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o0EKjTBS026300
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 15:45:29 -0500
Message-ID: <4B4F8269.50305@sandeen.net>
Date: Thu, 14 Jan 2010 14:45:29 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fix up mkfs.gfs2 args for test 032
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
To: xfs mailing list <xfs@oss.sgi.com>

Looks like gfs2 (recently?) needs more arguments for the
mkfs overwrite test.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/032 b/032
index f81196c..5db89ad 100755
--- a/032
+++ b/032
@@ -58,7 +58,7 @@ do
 	# these folks prompt before writing
 	[ $fs = jfs ] && preop="echo Y |"
 	[ $fs = gfs ] && preop="echo y |" && preargs="-p lock_nolock -j 1"
-	[ $fs = gfs2 ] && preop="echo y |"
+	[ $fs = gfs2 ] && preop="echo y |" && preargs="-p lock_nolock -j 1"
 	[ $fs = reiserfs ] && preop="echo y |" && preargs="-f"
 	# cramfs mkfs requires a directory argument
 	[ $fs = cramfs ] && preargs=/proc/fs/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
