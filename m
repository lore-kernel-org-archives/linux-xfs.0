Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D8D827CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 08:02:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 54183AC005
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 06:02:17 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 0shhvcrTgM3admho (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 06:02:15 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: fail ->bmap for reflink inodes
Date: Thu, 26 May 2016 15:02:04 +0200
Message-Id: <1464267724-31423-2-git-send-email-hch@lst.de>
In-Reply-To: <1464267724-31423-1-git-send-email-hch@lst.de>
References: <1464267724-31423-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9137788772451426816=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: darrick.wong@oracle.com
Cc: linux-mm@kvack.org, xfs@oss.sgi.com

--===============9137788772451426816==
Content-Type: text/plain; charset=a
Content-Transfer-Encoding: 8bit

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a955552..d053a9e 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1829,6 +1829,17 @@ xfs_vm_bmap(
 
 	trace_xfs_vm_bmap(XFS_I(inode));
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
+
+	/*
+	 * The swap code (ab-)uses ->bmap to get a block mapping and then
+	 * bypasseѕ the file system for actual I/O.  We really can't allow
+	 * that on reflinks inodes, so we have to skip out here.  And yes,
+	 * 0 is the magic code for a bmap error..
+	 */
+	if (xfs_is_reflink_inode(ip)) {
+		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+		return 0;
+	}
 	filemap_write_and_wait(mapping);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 	return generic_block_bmap(mapping, block, xfs_get_blocks);
-- 
2.1.4


--===============9137788772451426816==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9137788772451426816==--
