Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3A0487F55
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 06:12:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 196C2304032
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 04:12:59 -0800 (PST)
Received: from mail-pa0-f50.google.com (mail-pa0-f50.google.com
	[209.85.220.50]) by cuda.sgi.com with ESMTP id ZD0Q8uDyYLOuEWbT
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Jan 2015 04:12:54 -0800 (PST)
Received: by mail-pa0-f50.google.com with SMTP id bj1so23949077pad.9
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 04:12:54 -0800 (PST)
Received: from dhruv-MacBookAir ([14.97.30.63])
	by mx.google.com with ESMTPSA id
	hc10sm3946552pbd.78.2015.01.16.04.12.51 for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=RC4-SHA bits=128/128);
	Fri, 16 Jan 2015 04:12:53 -0800 (PST)
Message-ID: <54b90045.8a14450a.6bff.ffffbfdd@mx.google.com>
From: Dhruvesh Rathore <adrscube@gmail.com>
Date: Fri, 16 Jan 2015 17:40:40 +0530
Subject: [PATCH 2/2] xfs_spaceman: Accounting for AGFL blocks
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Here is the original discussion that Dave wrote for xfs_spaceman:

http://oss.sgi.com/archives/xfs/2012-10/msg00363.html

These patches were not posted and were just forward ported to a current 
3.18-rc7+ for-next XFS tree and were pushed to the fiemapfs branch in Dave's
kernel tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

The original xfs_spaceman tool that Dave wrote is here:

http://oss.sgi.com/archives/xfs/2012-10/msg00366.html

Dave just updated it to the 3.2.2 code base and pushed it to the
spaceman branch in this tree:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

This xfs_spaceman utility previously failed to account for AGFL blocks.
Old output (Before changes).

$ sudo xfs_spaceman -c "freesp" /media/xfs
   from      to extents  blocks    pct
   1024    2047       1    1262   0.04
   4096    8191       1    5126   0.15
   8192   16383       3   35344   1.05
  32768   65535       1   43989   1.31
 262144  524287       3 1334894  39.78
 524288  967428       2 1934840  57.66

As you can see the AGFL blocks were unaccounted (4 per AG, and there 
were 4 AGs in this filesystem).

This patch is concerned with adding a new function which will walk the free
extents in AGFL and account for these AGFL blocks, while file system scanning.

New output (After implementing this patch).

$ uname -a
Linux dhruv-MacBookAir 3.18.0-rc7+ #3 SMP Thu Dec 25 15:29:59 IST 2014 x86_64 x86_64 x86_64 GNU/Linux
$ sudo xfs_spaceman -V
xfs_spaceman version 3.2.2
$ sudo xfs_spaceman -c "freesp" /media/xfs
   from      to extents  blocks    pct
      1       1      16      16   0.00
   1024    2047       1    1262   0.04
   4096    8191       1    5126   0.15
   8192   16383       3   35344   1.05
  32768   65535       1   43989   1.31
 262144  524287       3 1334894  39.78
 524288  967428       2 1934840  57.66

Please do comment.

Signed-off-by: 
Dhruvesh Rathore <dhruvesh_r@outlook.com>
Amey Ruikar <ameyruikar@yahoo.com>
Somdeep Dey <somdeepdey10@gmail.com>
---
linux-xfs/fs/xfs/libxfs/xfs_alloc.c | 81 +++
1 file changed, 81 insertions(+)

-------------------------------------------------------------------------------------------

--- a/linux-xfs/fs/xfs/libxfs/xfs_alloc.c	2015-01-08 19:34:52.927862215 +0530
+++ b/linux-xfs/fs/xfs/libxfs/xfs_alloc.c	2015-01-09 14:25:23.853599350 +0530
@@ -2697,6 +2697,83 @@
 
 }
 
+
+/*
+ * Walk the free extents in the AGFL (AG Free List) of each AG, and dump
+ * them all into the fieinfo.
+ * 
+ * With a freshly made filesystem, 4 blocks are reserved immediately after
+ * the free space B+tree root blocks (blocks 4 to 7). As they are used up
+ * additional blocks are reserved from the AG and added to the free list
+ * array. A typical device will have space for 128 elements in the array.
+ * The actual size can be determined using XFS_AGFL_SIZE macro. The array
+ * is maintained as a circular list and active elements are pointed by 
+ * AGF's agf_flfirst, agf_fllast and agf_flcount values.
+ */
+static int
+xfs_alloc_agfl_freespace_map(
+	struct xfs_buf		**agbp,	/* buffer for a.g. freelist header */
+	struct xfs_btree_cur    *cur,
+	struct fiemap_extent_info *fieinfo,
+	xfs_agblock_t		sagbno,
+	xfs_agblock_t		eagbno)
+{
+	xfs_agf_t	*agf;		/* a.g. freespace structure */
+	xfs_buf_t	*agflbp;	/* buffer for a.g. freelist structure */
+	__be32		*agfl_bno;	/* Reference to freelist block */
+	int	 	j;
+	int 		index;
+	int 		error = 0;
+
+	agf = XFS_BUF_TO_AGF(*agbp);
+	error = xfs_alloc_read_agfl(cur->bc_mp, NULL, be32_to_cpu(agf->agf_seqno),
+				    &agflbp);
+	if (error)
+		return error;
+
+	agfl_bno = XFS_BUF_TO_AGFL_BNO(cur->bc_mp, agflbp);
+	
+	index = be32_to_cpu(agf->agf_flfirst);
+	
+	for(j=1 ; j<=be32_to_cpu(agf->agf_flcount); j++)
+        {
+	 xfs_agblock_t	fbno;
+	 xfs_extlen_t	flen;
+	 xfs_daddr_t	dbno;
+	 xfs_fileoff_t	dlen;	
+	 int		flags = 0;
+
+	/* Relative AG block number */
+	 fbno = be32_to_cpu(agfl_bno[index]);
+	/* Each entry in the AGFL is a single entry i.e length is 1 block */ 
+	 flen = 1;
+
+	/*
+	 * AGFL is maintained as a circular list. Following is needed
+	 * to handle array wrapping correctly.
+	 */	
+         if( index == ( (XFS_AGFL_SIZE(cur->bc_mp))-1 ) )
+	  index = 0;	/* First index of AGFL */
+         else
+          index++;	/* Next index in AGFL */
+        
+	/*
+	 * Use daddr format for all range/len calculations as that is
+	 * the format the range/len variables are supplied in by
+	 * userspace.
+	 */
+	 dbno = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_private.a.agno, fbno);
+	 dlen = XFS_FSB_TO_BB(cur->bc_mp, flen);
+	 error = -fiemap_fill_next_extent(fieinfo, BBTOB(dbno),
+			                  BBTOB(dbno), BBTOB(dlen), flags);
+	 if (error)
+	   break;
+	}
+	xfs_buf_relse(agflbp);	/* Release the buffer */
+	return error;
+
+}
+
 /*
  * Map the freespace from the requested range in the requested order.
  *
@@ -2802,6 +2879,10 @@
 		}
 		XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
 
+		/* Account for the free blocks in AGFL */		
+		error = xfs_alloc_agfl_freespace_map(&agbp, cur, fieinfo, sagno,
+					agno == eagno ? eagbno : NULLAGBLOCK);
+
 		if (!bycnt) {
 			/*
 			 * if we are doing a bno ordered lookup, we can just

------------------------------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
