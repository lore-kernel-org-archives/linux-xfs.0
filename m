Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50106 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753074AbeDSS5Z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Apr 2018 14:57:25 -0400
Date: Thu, 19 Apr 2018 14:57:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/11] xfs: superblock scrub should use uncached buffers
Message-ID: <20180419185723.GA26938@bfoster.bfoster>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
 <152401922015.11465.14941366292853283272.stgit@magnolia>
 <20180419125546.GA25844@bfoster.bfoster>
 <20180419172548.GY24738@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180419172548.GY24738@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 19, 2018 at 10:25:48AM -0700, Darrick J. Wong wrote:
> On Thu, Apr 19, 2018 at 08:55:47AM -0400, Brian Foster wrote:
> > On Tue, Apr 17, 2018 at 07:40:20PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > We've never cached buffers when reading or writing superblocks, so we
> > > need to change scrub to do likewise or risk screwing up the uncached sb
> > > buffer usage everywhere else.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > 
> > Hmm, so this goes back to this[1] thread, right?
> 
> Yep.
> 
> > IIRC, we wanted to end up with an lru-bypassing uncached buffer lookup
> > mechanism to provide uncached behavior for resource-saving purposes
> > but without introducing serialization issues between multiple users of
> > uncached buffers.
> 
> Right.
> 
> > On a quick look back, growfs currently uses cached buffers for secondary
> > superblocks and the associated patch was looking to change that to
> > something like the above. Don't we have the same requirement here (since
> > growfs currently still uses cached buffers)?
> 
> Correct, this patch is contingent on landing Dave's "tableise growfs"
> series that converts growfs to use uncached buffers for writing out the
> new secondary supers.  If I manage to land Dave's growfs thing before
> repair then I'll keep this; if repair goes first I'll defer it to that
> series.
> 

Ok, though I'm not sure I see the need for the higher level series
dependency. Don't one of these patches just need to fold in a helper[1]
to set the lru reference appropriately and start to use it?

Brian

[1] I.e., untested:

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index d9b94bd5f689..19ffe2819bb2 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -972,3 +972,24 @@ xfs_fs_geometry(
 
 	return 0;
 }
+
+int
+xfs_read_secondary_sb(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_buf		*bp;
+	int			error;
+
+	ASSERT(agno != NULLAGNUMBER);
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
+			XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
+			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
+	if (error)
+		return error;
+	xfs_buf_set_ref(bp, XFS_SSB_REF);
+	*bpp = bp;
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index d0b84da0cb1e..d23f33c02f64 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -127,6 +127,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_ATTR_BTREE_REF	1
 #define	XFS_DQUOT_REF		1
 #define	XFS_REFC_BTREE_REF	1
+#define	XFS_SSB_REF		0
 
 /*
  * Flags for xfs_trans_ichgtime().
