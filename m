Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A26267CA2
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 21:26:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8EC0A304039
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 19:26:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JhFSVGnlpHd8nWiy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 29 Jan 2016 19:26:29 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id EBD07C0D78EA
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2016 03:26:28 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u0U3QRlP017241
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 22:26:28 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: lock bitmap/summary inodes in xfs_rtbuf_get()
Message-ID: <56AC2D64.2080907@redhat.com>
Date: Fri, 29 Jan 2016 21:26:28 -0600
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

Commit eef334e added an ASSERT that the inode was locked in
some way in xfs_bmapi_read(), but on realtime paths through
xfs_rtbuf_get() this isn't the case; fix that.

Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I think we need the data_map_shared gyrations here, but not certain...

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 9b59ffa..e6da0b2 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -57,11 +57,14 @@ xfs_rtbuf_get(
 	xfs_inode_t	*ip;		/* bitmap or summary inode */
 	xfs_bmbt_irec_t	map;
 	int		nmap = 1;
+	int		lock_mode;
 	int		error;		/* error value */
 
 	ip = issum ? mp->m_rsumip : mp->m_rbmip;
 
+	lock_mode = xfs_ilock_data_map_shared(ip);
 	error = xfs_bmapi_read(ip, block, 1, &map, &nmap, XFS_DATA_FORK);
+	xfs_iunlock(ip, lock_mode);
 	if (error)
 		return error;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
