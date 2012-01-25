Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0PLBf3f071760 for <xfs@oss.sgi.com>; Wed, 25 Jan 2012 15:11:42 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id JsDk6EwdZeC51zvM for <xfs@oss.sgi.com>;
	Wed, 25 Jan 2012 13:11:40 -0800 (PST)
Message-ID: <4F20700B.8060307@sandeen.net>
Date: Wed, 25 Jan 2012 15:11:39 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfstests: mount other filesystems with selinux context
	as well
References: <4ECD3262.105@redhat.com> <20111128110228.GC13766@infradead.org>
	<4F1862FC.1050401@sandeen.net>
	<20120124174500.GB9853@infradead.org>
In-Reply-To: <20120124174500.GB9853@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>, ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

For some reason, non-xfs filesystems aren't getting mounted with
the selinux context; perhaps because none of the xattr tests used
to work on anything but xfs?

Anyway, 062 fails for extN unless we mount with the fs-wide
context.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

ps: eparis says this should work for NFS as well, let's go for
it and if infrequently tested filesystems have trouble we can
exclude them as necessary.

diff --git a/common.rc b/common.rc
index 6231457..602513a 100644
--- a/common.rc
+++ b/common.rc
@@ -72,11 +72,11 @@ _mount_opts()
     # nfs_t is a "liberal" context so we can use it.
     if [ -x /usr/sbin/selinuxenabled ] && /usr/sbin/selinuxenabled; then
 	SELINUX_MOUNT_OPTIONS="-o context=system_u:object_r:nfs_t:s0"
+	export SELINUX_MOUNT_OPTIONS
     fi
 
     case $FSTYP in
     xfs)
-	export SELINUX_MOUNT_OPTIONS
 	export MOUNT_OPTIONS=$XFS_MOUNT_OPTIONS
 	;;
     udf)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
