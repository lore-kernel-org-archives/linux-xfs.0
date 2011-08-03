Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73Ig2jS170958 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 13:42:02 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E79E1869301
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2011 11:42:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0DtxV65RoSjcUd4t for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2011 11:42:01 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p73Ig1Px024853
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 14:42:01 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p73Ig0HM011764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 14:42:01 -0400
Message-ID: <4E399677.1010508@redhat.com>
Date: Wed, 03 Aug 2011 13:41:59 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: skip over "rootfs" entry if mtab links to
	/proc/mounts
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

This is for RH bug 727938, xfs_fsr regression for root file system

Fedora has made /etc/mtab a symlink to /proc/mounts, but when
we issue "xfs_fsr /" and fsr's getmntany() goes looking for
the "/" entry, the first one it finds is

rootfs / rootfs rw 0 0

it says no way, that's a rootfs filesystem type, not xfs!
And it never finds this later:

/dev/sda2 / xfs rw,relatime,attr2,noquota 0 0

This patch to skip over the rootfs entry seems to fix it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 40c2e6f..eaf8ac7 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1648,6 +1648,9 @@ getmntany(FILE *fp, struct mntent *mp, struct mntent *mpref, struct stat64 *s)
 	struct stat64 ms;
 
 	while ((t = getmntent(fp))) {
+		/* skip over "rootfs / rootfs" if mtab is really /proc/mounts */
+		if (strcmp(t->mnt_type, "rootfs") == 0)
+			continue;
 		if (mpref->mnt_fsname) {	/* device */
 			if (stat64(t->mnt_fsname, &ms) < 0)
 				continue;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
