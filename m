Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51490 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751398AbdJJK4X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Oct 2017 06:56:23 -0400
Date: Tue, 10 Oct 2017 06:56:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] generic: test race between block map change and writeback
Message-ID: <20171010105622.GA23057@bfoster.bfoster>
References: <20170831040237.16022-1-eguan@redhat.com>
 <20171009161255.GA19847@bfoster.bfoster>
 <20171010043649.GI10593@eguan.usersys.redhat.com>
 <20171010052459.GB15067@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171010052459.GB15067@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Oct 10, 2017 at 04:24:59PM +1100, Dave Chinner wrote:
> On Tue, Oct 10, 2017 at 12:36:49PM +0800, Eryu Guan wrote:
> > On Mon, Oct 09, 2017 at 12:12:55PM -0400, Brian Foster wrote:
> > > On Thu, Aug 31, 2017 at 12:02:37PM +0800, Eryu Guan wrote:
> > > > Run delalloc writes & append writes & non-data-integrity syncs
> > > > concurrently to test the race between block map change vs writeback.
> > > > 
> > > > This is to cover an XFS bug that data could be written to wrong
> > > > block and delay allocated blocks are leaked because the block map
> > > > was changed due to the removal of speculative allocated eofblocks
> > > > when writeback is in progress.
> > > > 
> > > > And this test partially mimics what lustre-racer[1] test does, using
> > > > which this bug was first found.
> > > > 
> > > > [1] https://git.hpdd.intel.com/?p=fs/lustre-release.git;a=tree;f=lustre/tests/racer;hb=HEAD
> > > > 
> > > > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > > > ---
> > > > 
> > > > This may not reproduce the bug on all hosts, but it does reproduce the XFS
> > > > corruption issue reliably on my different test hosts.
> > > > 
> > > 
> > > Was this problem fixed already or are we still waiting on a fix?
> > 
> > It's still an unfixed problem. Dave provided a test patch (which did fix
> > the bug for me)
> 
> The test patch I provided broken the COW writeback path, primarily
> because it's a separate mapping path and the change I made doesn't
> work at all well with it....
> 
> > then Christoph suggested a fix based on seqlock, and
> > things stalled there.
> 
> I had a look at doing that and got stalled on the fact that, again,
> the COW writeback is completely separate to the existing block
> mapping during writeback path and so applying a seqlock algorithm is
> pretty difficult.
> 
> Basically, to fix the problem, we first need to merge the COW and
> delalloc paths in the writepage code and then we'll have a sane base
> on which to apply a proper fix...
> 
> (we need to do this to get rid of the bufferhead dependency, anyway)
> 
> > (I'm happy to pick up the work, but I'm not that
> > familiar with all the allocation paths that could change the extent map,
> > so I may need some guidance and time to play with it.)
> 
> There's some black magic in amongst it all. I'll spend some time on
> it again over the next week and see what I come up with...
> 

Hmm, is this[1] the test patch/thread associated with this test case? If
so, I'm still wondering why we can't just trim the mapping to eof like
the previous code had effectively done for so long..? Eryu, does the
appended diff address this test case?

Note that I'm not saying that there isn't also a similar mapping
validation issue associated with user interaction (as opposed to
eofblocks), but if so, I am skeptical that this test reproduces it. IOW,
I think the latter should be independently verified (I don't see any
follow up to that in the previous thread) and may very well warrant a
unique test.

Brian

[1] https://marc.info/?l=linux-xfs&m=150407819630651&w=2

--- 8< ---

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 044a363..dd3fb7b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3852,6 +3852,17 @@ xfs_trim_extent(
 	}
 }
 
+/* trim extent to within eof */
+void
+xfs_trim_extent_eof(
+	struct xfs_bmbt_irec	*irec,
+	struct xfs_inode	*ip)
+
+{
+	xfs_trim_extent(irec, 0, XFS_B_TO_FSB(ip->i_mount,
+					      i_size_read(VFS_I(ip))));
+}
+
 /*
  * Trim the returned map to the required bounds
  */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 851982a..502e0d8 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -208,6 +208,7 @@ void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
 
 void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
+void	xfs_trim_extent_eof(struct xfs_bmbt_irec *, struct xfs_inode *);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
 void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 1dbc5cf..3ab6d9d 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -423,7 +423,7 @@ xfs_map_blocks(
 				imap);
 		if (!error)
 			trace_xfs_map_blocks_alloc(ip, offset, count, type, imap);
-		return error;
+		goto out_trim;
 	}
 
 #ifdef DEBUG
@@ -435,7 +435,9 @@ xfs_map_blocks(
 #endif
 	if (nimaps)
 		trace_xfs_map_blocks_found(ip, offset, count, type, imap);
-	return 0;
+out_trim:
+	xfs_trim_extent_eof(imap, ip);
+	return error;
 }
 
 STATIC bool
