Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9902F7F78
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 07:23:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 85623304043
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 05:23:08 -0800 (PST)
Received: from mail-pa0-f52.google.com (mail-pa0-f52.google.com
	[209.85.220.52]) by cuda.sgi.com with ESMTP id 9G2HuU8mFBn0K6bK
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Jan 2015 05:23:07 -0800 (PST)
Received: by mail-pa0-f52.google.com with SMTP id kx10so39000497pab.11
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 05:23:07 -0800 (PST)
Received: from dhruv-MacBookAir ([14.97.215.112])
	by mx.google.com with ESMTPSA id qs3sm7834185pbc.28.2015.01.29.05.23.04
	for <xfs@oss.sgi.com> (version=TLSv1 cipher=RC4-SHA bits=128/128);
	Thu, 29 Jan 2015 05:23:06 -0800 (PST)
Message-ID: <54ca343a.43df440a.3c11.4474@mx.google.com>
From: Dhruvesh Rathore <adrscube@gmail.com>
Date: Thu, 29 Jan 2015 18:53:01 +0530
Subject: [PATCH 1/4] xfs: Accounting for AGFL blocks in xfs_spaceman
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


The xfs_spaceman utility previously failed to account for AGFL blocks.
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

-------------------------------------------------------------------------------------------

Signed-off-by: Dhruvesh Rathore <dhruvesh_r@outlook.com>
Signed-off-by: Amey Ruikar <ameyruikar@yahoo.com>
Signed-off-by: Somdeep Dey <somdeepdey10@gmail.com>
---
fs/xfs/libxfs/xfs_alloc.c | 69 ++++++++++++++++
1 file changed, 69 insertions(+)

--- a/fs/xfs/libxfs/xfs_alloc.c	2015-01-29 09:07:07.116439198 +0530
+++ b/fs/xfs/libxfs/xfs_alloc.c	2015-01-29 09:06:39.664440229 +0530

@@ -2698,6 +2698,71 @@
 }
 
 
+/*
+ * When we map free space we need to take into account the blocks
+ * that are indexed by the AGFL. They aren't found by walking the
+ * free space btrees, so we have to walk each AGFL to find them.
+ */
+static int
+xfs_alloc_agfl_freespace_map(
+	struct xfs_mount	*mp,
+	struct xfs_agf		*agf,
+	struct fiemap_extent_info *fieinfo,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		sagbno,
+	xfs_agblock_t		eagbno)
+{
+	xfs_buf_t		*agflbp;
+	__be32			*agfl_bno;
+	int			i;
+	int			error = 0;
+
+	error = xfs_alloc_read_agfl(mp, NULL, be32_to_cpu(agf->agf_seqno), &agflbp);
+
+	if (error)
+		return error;
+
+	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
+
+	for(i = be32_to_cpu(agf->agf_flfirst);
+		i <= be32_to_cpu(agf->agf_fllast);) {
+
+		xfs_agblock_t	fbno;
+		xfs_extlen_t	flen;
+		xfs_daddr_t	dbno;
+		xfs_fileoff_t	dlen;	
+		int		flags = 0;
+
+		fbno = be32_to_cpu(agfl_bno[i]);
+		flen = 1;
+
+		/* range check - must be wholly withing requested range */
+		if (fbno < sagbno ||
+			(eagbno != NULLAGBLOCK && fbno + flen > eagbno)) {
+		xfs_warn(mp, "10: %d/%d, %d/%d", sagbno, eagbno, fbno, flen);
+			continue;
+		}
+
+		/*
+		 * Use daddr format for all range/len calculations as that is
+		 * the format the range/len variables are supplied in by
+		 * userspace.
+		 */
+
+		dbno = XFS_AGB_TO_DADDR(mp, agno, fbno);
+		dlen = XFS_FSB_TO_BB(mp, flen);
+
+		error = -fiemap_fill_next_extent(fieinfo,BBTOB(dbno),
+						BBTOB(dbno), BBTOB(dlen), flags);
+	
+		if (error)
+			break;
+		if (++i == XFS_AGFL_SIZE(mp))
+			i = 0;
+	}
+	xfs_buf_relse(agflbp);
+	return error;
+}
 
 /*
  * Map the freespace from the requested range in the requested order.
@@ -2804,6 +2869,10 @@
 		}
 		XFS_WANT_CORRUPTED_GOTO(i == 1, del_cursor);
 
+		/* Account for the free blocks in AGFL */
+		error = xfs_alloc_agfl_freespace_map(mp, XFS_BUF_TO_AGF(agbp), fieinfo, agno, sagbno,
+						agno == eagno ? eagbno : NULLAGBLOCK);
+
 		if (!bycnt) {
 			/*
 			 * if we are doing a bno ordered lookup, we can just

-------------------------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
