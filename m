Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59554 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755024AbcLAXIQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Dec 2016 18:08:16 -0500
Subject: [PATCH 2/2] xfs: handle cow fork in xfs_bmap_trace_exlist
References: <1a77ccd9-ec67-f5b7-f786-35c913334337@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d1637505-38e7-f855-c5fb-58d5f85bc05f@sandeen.net>
Date: Thu, 1 Dec 2016 17:08:15 -0600
MIME-Version: 1.0
In-Reply-To: <1a77ccd9-ec67-f5b7-f786-35c913334337@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

By inspection, xfs_bmap_trace_exlist isn't handling cow forks,
and will trace the data fork instead.

Fix this by setting state appropriately if whichfork
== XFS_COW_FORK.

()___()
< @ @ >
 |   |      
 {o_o}
  (|)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b085f9b..93df173 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -504,7 +504,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 xfs_bmap_trace_exlist(
 	xfs_inode_t	*ip,		/* incore inode pointer */
 	xfs_extnum_t	cnt,		/* count of entries in the list */
-	int		whichfork,	/* data or attr fork */
+	int		whichfork,	/* data or attr or cow fork */
 	unsigned long	caller_ip)
 {
 	xfs_extnum_t	idx;		/* extent record index */
@@ -513,6 +513,8 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 
 	if (whichfork == XFS_ATTR_FORK)
 		state |= BMAP_ATTRFORK;
+	else if (whichfork == XFS_COW_FORK)
+		state |= BMAP_COWFORK;
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(cnt == (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)));

