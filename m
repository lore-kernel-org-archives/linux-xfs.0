Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Mar 2008 23:37:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2V6baxQ010681
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2008 23:37:39 -0700
Message-ID: <47F086C8.7070400@sgi.com>
Date: Mon, 31 Mar 2008 17:38:00 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] fix attr fit checking for filesystems which have
 lost their attr2
References: <47EDCBF9.4070102@sandeen.net> <47F035E3.1030004@sgi.com> <47F06A8B.4090609@sgi.com>
In-Reply-To: <47F06A8B.4090609@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric,

So probably need something like this for xfs_bmap_compute_maxlevels()...


--Tim

===========================================================================
Index: fs/xfs/xfs_bmap.c
===========================================================================

--- a/fs/xfs/xfs_bmap.c	2008-03-31 16:32:24.000000000 +1000
+++ b/fs/xfs/xfs_bmap.c	2008-03-31 16:21:11.439806073 +1000
@@ -4154,16 +4154,21 @@ xfs_bmap_compute_maxlevels(
  	 * number of leaf entries, is controlled by the type of di_nextents
  	 * (a signed 32-bit number, xfs_extnum_t), or by di_anextents
  	 * (a signed 16-bit number, xfs_aextnum_t).
+	 *
+	 * Note that we can no longer assume that if we are in ATTR1 that
+	 * the fork offset of all the inodes will be (m_attroffset >> 3)
+	 * because we could have mounted with ATTR2 and then mounted back
+	 * with ATTR1, keeping the di_forkoff's fixed but probably at
+	 * various positions. Therefore, for both ATTR1 and ATTR2
+	 * we have to assume the worst case scenario of a minimum size
+	 * available.
  	 */
  	if (whichfork == XFS_DATA_FORK) {
  		maxleafents = MAXEXTNUM;
-		sz = (mp->m_flags & XFS_MOUNT_ATTR2) ?
-			XFS_BMDR_SPACE_CALC(MINDBTPTRS) : mp->m_attroffset;
+		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
  	} else {
  		maxleafents = MAXAEXTNUM;
-		sz = (mp->m_flags & XFS_MOUNT_ATTR2) ?
-			XFS_BMDR_SPACE_CALC(MINABTPTRS) :
-			mp->m_sb.sb_inodesize - mp->m_attroffset;
+		sz = XFS_BMDR_SPACE_CALC(MINABTPTRS);
  	}
  	maxrootrecs = (int)XFS_BTREE_BLOCK_MAXRECS(sz, xfs_bmdr, 0);
  	minleafrecs = mp->m_bmap_dmnr[0];
