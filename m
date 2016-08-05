Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 904A47CB9
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 15:22:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 621B58F8040
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 13:22:08 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Z3vrAAnXoXbTpKST (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 05 Aug 2016 13:22:06 -0700 (PDT)
Date: Fri, 5 Aug 2016 13:22:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: remove OWN_AG rmap when allocating a block from the AGFL
Message-ID: <20160805202202.GJ25565@birch.djwong.org>
References: <20160805202104.GB8590@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160805202104.GB8590@birch.djwong.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <xfs@oss.sgi.com>

[resend, cc list this time]

I ftrace'd the rmap code while trying to repro the g/299 assert you
saw.  Eventually I got it to reproduce and it looks like a block would
go onto the AGFL and we'd add an OWN_AG rmap for the block.  ~20s
later the block mysteriously ends up being mapped in a second time as
some inode's BMBT block without the OWN_AG rmap being removed.  So I
looked around for anything that grabbed a block off the AGFL and
noticed that the regular allocation function can do that if we get
really tight on space.  I also noticed that it doesn't remove the
OWN_AG rmap, nor does it credit the per-AG reservation for the block
it used.  So here's a test patch that updates the rmap.  (The per-AG
stuff is in the reflink patchset so we don't need it here.)

---
When we're really tight on space, xfs_alloc_ag_vextent_small() can
allocate a block from the AGFL and give it to the caller.  Since the
caller is never the AGFL-fixing method, we must remove the OWN_AG
reverse mapping because it will clash with whatever rmap the caller
wants to set up.  This bug was discovered by running generic/299
repeatedly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index af1a72e..3dd8f1d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1582,6 +1582,7 @@ xfs_alloc_ag_vextent_small(
 	xfs_extlen_t	*flenp,	/* result length */
 	int		*stat)	/* status: 0-freelist, 1-normal/none */
 {
+	struct xfs_owner_info	oinfo;
 	int		error;
 	xfs_agblock_t	fbno;
 	xfs_extlen_t	flen;
@@ -1624,6 +1625,18 @@ xfs_alloc_ag_vextent_small(
 				error0);
 			args->wasfromfl = 1;
 			trace_xfs_alloc_small_freelist(args);
+
+			/*
+			 * If we're feeding an AGFL block to something that
+			 * doesn't live in the free space, we need to clear
+			 * out the OWN_AG rmap.
+			 */
+			xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
+			error = xfs_rmap_free(args->tp, args->agbp, args->agno,
+					fbno, 1, &oinfo);
+			if (error)
+				goto error0;
+
 			*stat = 0;
 			return 0;
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
