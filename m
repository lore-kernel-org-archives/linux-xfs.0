Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1BAB97F37
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 12:25:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E4592304048
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 10:25:39 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qPIyBcWZCYXbv8Pz for
	<xfs@oss.sgi.com>; Wed, 13 Nov 2013 10:25:35 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rADIPZp4026492
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 13:25:35 -0500
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id rADIPXX9004518
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 13:25:34 -0500
Message-ID: <5283C41D.7070503@redhat.com>
Date: Wed, 13 Nov 2013 12:25:33 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH RFC] xfs: set block device logical sector size on xfs_buftarg
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

Pure RFC; this might be crazy.  Here's the problem I'm trying to solve:

Today, mkfs.xfs will select a 4k sector size for a 4k physical / 512 logical
drive.  (that change was done by me).  The thought was that it'd be an
efficiency gain to not make the drive do the (possible) RMW cycles on
512-byte log IO, primarily.

However, now this restricts all DIO to 4k alignment, not the otherwise-
possible 512.

This came up when qemu-kvm, in cache=none mode, tries to boot off an
image hosted on such a filesystem, and its bios wants to do a 512 byte
direct IO read off the disk - it fails.

But I'm wondering - the buftarg's bt_sshift and bt_smask are only used
in a few places.  

XFS_IOC_DIOINFO - to get the minimum io size
xfs_file_aio_read() and xfs_file_dio_aio_write() to check alignment
_xfs_buf_find() to be sure we aren't doing sub-sector IO.

So what I'm wondering is:  Can we somehow separate the "sector size"
that i.e. primarily the xfs log does its IO in, based on sb_sectsize,
from the actual, hard-minimum possible IO, in the buftarg bt_sshift &
bt_smask.


Something like this, though untested, and I'm probably missing something.

Our other option, I guess, is to just revert the mkfs change which
picks the physical rather than logical sector size, and go back to 
512 if it's available as a logical size.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8968f50..58ce036 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -814,10 +814,12 @@ STATIC int
 xfs_setup_devices(
 	struct xfs_mount	*mp)
 {
+	xfs_buftarg_t		btp;
 	int			error;
 
+	btp = mp->m_ddev_targp;
 	error = xfs_setsize_buftarg(mp->m_ddev_targp, mp->m_sb.sb_blocksize,
-				    mp->m_sb.sb_sectsize);
+				    bdev_logical_block_size(btp));
 	if (error)
 		return error;
 
@@ -833,9 +835,10 @@ xfs_setup_devices(
 			return error;
 	}
 	if (mp->m_rtdev_targp) {
+		btp = mp->m_rtdev_targp;
 		error = xfs_setsize_buftarg(mp->m_rtdev_targp,
 					    mp->m_sb.sb_blocksize,
-					    mp->m_sb.sb_sectsize);
+					    bdev_logical_block_size(btp));
 		if (error)
 			return error;
 	}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
