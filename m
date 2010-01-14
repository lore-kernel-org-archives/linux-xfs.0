Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EKHUhw032484 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 14:17:30 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55AFDF0B626
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 12:18:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tnE5k9bnGME7V8gn for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2010 12:18:26 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0EKIP91003145
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 15:18:25 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o0EKIOAK022214
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 15:18:24 -0500
Message-ID: <4B4F7C0F.9010004@sandeen.net>
Date: Thu, 14 Jan 2010 14:18:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] mkfs: fix mkfs when blkid fails
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

When trying to mkfs something that blkid doesn't grok:

# mkfs.xfs fsfile 
warning: unable to probe device toplology for device fsfile
illegal sector size 0
Usage: mkfs.xfs
...

mkfs fails.  :(

Brown-paper-bag: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 9a8eff3..faaafed 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1574,7 +1574,7 @@ main(
 		 * Unless specified manually on the command line use the
 		 * advertised sector size of the device.
 		 */
-		sectorsize = ft.sectorsize;
+		sectorsize = ft.sectorsize ? ft.sectorsize : XFS_MIN_SECTORSIZE;
 	}
 
 	if (ft.sectoralign || !ssflag) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
