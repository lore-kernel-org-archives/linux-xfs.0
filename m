Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 21:57:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9T4vKpx005646
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 21:57:21 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D2ADF556CAA
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 21:57:19 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id DrXceA856oO2pCng for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 21:57:19 -0700 (PDT)
Date: Wed, 29 Oct 2008 15:57:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
Message-ID: <20081029045707.GF17077@disturbed>
References: <20081028144715.683011000@suse.de> <20081028153953.GB3082@wotan.suse.de> <20081028222746.GB4985@disturbed> <20081029001653.GF15599@wotan.suse.de> <20081029031645.GE4985@disturbed> <20081029032601.GF4985@disturbed> <20081029041112.GC17624@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029041112.GC17624@wotan.suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <npiggin@suse.de>
Cc: akpm@linux-foundation.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>

On Wed, Oct 29, 2008 at 05:11:12AM +0100, Nick Piggin wrote:
> On Wed, Oct 29, 2008 at 02:26:01PM +1100, Dave Chinner wrote:
> > On Wed, Oct 29, 2008 at 02:16:45PM +1100, Dave Chinner wrote:
> > > On Wed, Oct 29, 2008 at 01:16:53AM +0100, Nick Piggin wrote:
> > > > XFS: fix fsync errors not being propogated back to userspace.
> > > > ---
> > > > Index: linux-2.6/fs/xfs/xfs_vnodeops.c
> > > > ===================================================================
> > > > --- linux-2.6.orig/fs/xfs/xfs_vnodeops.c
> > > > +++ linux-2.6/fs/xfs/xfs_vnodeops.c
> > > > @@ -715,7 +715,7 @@ xfs_fsync(
> > > >  	/* capture size updates in I/O completion before writing the inode. */
> > > >  	error = filemap_fdatawait(VFS_I(ip)->i_mapping);
> > > >  	if (error)
> > > > -		return XFS_ERROR(error);
> > > > +		return XFS_ERROR(-error);
> > > 
> > > <groan>
> > > 
> > > Yeah, that'd do it. Good catch. I can't believe I recently fixed a
> > > bug that touched these lines of code without noticing the inversion.
> > > Sometimes I wonder if we should just conver the entire of XFS to
> > > return negative errors - mistakes in handling negative error numbers
> > > in the core XFS code happen all the time.
> > 
> > Ok, I was right - these problems happen all the time. The above call
> > should really call xfs_flush_pages() to do the flush and wait. I
> > note that xfs_flush_pages() returns negative errors, and all the
> > callers expect positive errors. I bet the same occurs for
> > xfs_flushinval_pages() and xfs_tosspages() which are the wrappers
> > that core XFS code is supposed to be using for flushing and
> > invalidating file ranges....
> 
> Just be careful -- in your xfs_flush_pages, I think after the first
> filemap_fdatawrite, the mapping may no longer be tagged with
> PAGECACHE_TAG_DIRTY, so you may not pick up those writeback ones
> you need to wait on.

Yes, I realised this as soon as I looked at the code.
I added xfs_wait_on_pages() to do this wait. ;)

> Might need a different variant, or we could just bite the bullet and
> push through the ->fsync conversion so you get full control of the
> writeout.

Not important right now, though....

> BTW. the Linux pagecache APIs should support range operations quite
> nicely for these. Any reason not to use them (it looks like the
> wrappers can take ranges)?

Because I haven't got around to modifying these wrappers now that
the range primitives are in place - XFS inherited the range
operations from Irix and have sat unimplemented since being ported
to Linux.

The patch below should fix this entire class of error value screwup
in XFS. I've just started running it through XFSQA, so it's not
really tested yet.

FWIW, your entire patch series made it through XFSQA without any new
regressions, so it looks good from that POV.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

XFS: fix error inversion problems with data flushing

XFS gets the sign of the error wrong in several places when
gathering the error from generic linux functions. These functions
return negative error values, while the core XFS code returns
positive error values. Hence when XFS inverts the error to be
returned to the VFS, it can incorrectly invert a negative
error and this error will be ignored by the syscall return.

Fix all the problems related to calling filemap_* functions.

Problem initially identified by Nick Piggin in xfs_fsync().

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_fs_subr.c |   23 ++++++++++++++++++++---
 fs/xfs/linux-2.6/xfs_lrw.c     |    2 +-
 fs/xfs/linux-2.6/xfs_super.c   |   13 +++++++++----
 fs/xfs/xfs_vnodeops.c          |    2 +-
 fs/xfs/xfs_vnodeops.h          |    1 +
 5 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_fs_subr.c b/fs/xfs/linux-2.6/xfs_fs_subr.c
index 36caa6d..5aeb777 100644
--- a/fs/xfs/linux-2.6/xfs_fs_subr.c
+++ b/fs/xfs/linux-2.6/xfs_fs_subr.c
@@ -24,6 +24,10 @@ int  fs_noerr(void) { return 0; }
 int  fs_nosys(void) { return ENOSYS; }
 void fs_noval(void) { return; }
 
+/*
+ * note: all filemap functions return negative error codes. These
+ * need to be inverted before returning to the xfs core functions.
+ */
 void
 xfs_tosspages(
 	xfs_inode_t	*ip,
@@ -53,7 +57,7 @@ xfs_flushinval_pages(
 		if (!ret)
 			truncate_inode_pages(mapping, first);
 	}
-	return ret;
+	return -ret;
 }
 
 int
@@ -72,10 +76,23 @@ xfs_flush_pages(
 		xfs_iflags_clear(ip, XFS_ITRUNCATED);
 		ret = filemap_fdatawrite(mapping);
 		if (flags & XFS_B_ASYNC)
-			return ret;
+			return -ret;
 		ret2 = filemap_fdatawait(mapping);
 		if (!ret)
 			ret = ret2;
 	}
-	return ret;
+	return -ret;
+}
+
+int
+xfs_wait_on_pages(
+	xfs_inode_t	*ip,
+	xfs_off_t	first,
+	xfs_off_t	last)
+{
+	struct address_space *mapping = VFS_I(ip)->i_mapping;
+
+	if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
+		return -filemap_fdatawait(mapping);
+	return 0;
 }
diff --git a/fs/xfs/linux-2.6/xfs_lrw.c b/fs/xfs/linux-2.6/xfs_lrw.c
index 1957e53..4959c87 100644
--- a/fs/xfs/linux-2.6/xfs_lrw.c
+++ b/fs/xfs/linux-2.6/xfs_lrw.c
@@ -243,7 +243,7 @@ xfs_read(
 
 	if (unlikely(ioflags & IO_ISDIRECT)) {
 		if (inode->i_mapping->nrpages)
-			ret = xfs_flushinval_pages(ip, (*offset & PAGE_CACHE_MASK),
+			ret = -xfs_flushinval_pages(ip, (*offset & PAGE_CACHE_MASK),
 						    -1, FI_REMAPF_LOCKED);
 		mutex_unlock(&inode->i_mutex);
 		if (ret) {
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 9dc977d..c5cfc1e 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1012,21 +1012,26 @@ xfs_fs_write_inode(
 	struct inode		*inode,
 	int			sync)
 {
+	struct xfs_inode	*ip = XFS_I(inode);
 	int			error = 0;
 	int			flags = 0;
 
-	xfs_itrace_entry(XFS_I(inode));
+	xfs_itrace_entry(ip);
 	if (sync) {
-		filemap_fdatawait(inode->i_mapping);
+		error = xfs_wait_on_pages(ip, 0, -1);
+		if (error)
+			goto out_error;
 		flags |= FLUSH_SYNC;
 	}
-	error = xfs_inode_flush(XFS_I(inode), flags);
+	error = xfs_inode_flush(ip, flags);
+
+out_error:
 	/*
 	 * if we failed to write out the inode then mark
 	 * it dirty again so we'll try again later.
 	 */
 	if (error)
-		xfs_mark_inode_dirty_sync(XFS_I(inode));
+		xfs_mark_inode_dirty_sync(ip);
 
 	return -error;
 }
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 2e2fbd9..5809c42 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -713,7 +713,7 @@ xfs_fsync(
 		return XFS_ERROR(EIO);
 
 	/* capture size updates in I/O completion before writing the inode. */
-	error = filemap_fdatawait(VFS_I(ip)->i_mapping);
+	error = xfs_wait_on_pages(ip, 0, -1);
 	if (error)
 		return XFS_ERROR(error);
 
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index e932a96..f9cd376 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -78,5 +78,6 @@ int xfs_flushinval_pages(struct xfs_inode *ip, xfs_off_t first,
 		xfs_off_t last, int fiopt);
 int xfs_flush_pages(struct xfs_inode *ip, xfs_off_t first,
 		xfs_off_t last, uint64_t flags, int fiopt);
+int xfs_wait_on_pages(struct xfs_inode *ip, xfs_off_t first, xfs_off_t last);
 
 #endif /* _XFS_VNODEOPS_H */
