Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Jan 2007 15:05:54 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l07N5jqw015757
	for <xfs@oss.sgi.com>; Sun, 7 Jan 2007 15:05:47 -0800
Date: Mon, 8 Jan 2007 10:04:36 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: BUG: warning at mm/truncate.c:60/cancel_dirty_page()
Message-ID: <20070107230436.GU33919298@melbourne.sgi.com>
References: <20070106023907.GA7766@m.safari.iki.fi> <Pine.LNX.4.64.0701062051570.24997@blonde.wat.veritas.com> <20070107222341.GT33919298@melbourne.sgi.com> <20070107144812.96357ff9.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070107144812.96357ff9.akpm@osdl.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@osdl.org>
Cc: David Chinner <dgc@sgi.com>, Hugh Dickins <hugh@veritas.com>, Sami Farin <7atbggg02@sneakemail.com>, xfs@oss.sgi.com, Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org

On Sun, Jan 07, 2007 at 02:48:12PM -0800, Andrew Morton wrote:
> On Mon, 8 Jan 2007 09:23:41 +1100
> David Chinner <dgc@sgi.com> wrote:
> 
> > How are you supposed to invalidate a range of pages in a mapping for
> > this case, then? invalidate_mapping_pages() would appear to be the
> > candidate (the generic code uses this), but it _skips_ pages that
> > are already mapped.
> 
> unmap_mapping_range()?

/me looks at how it's used in invalidate_inode_pages2_range() and
decides it's easier not to call this directly.

> > So, am I correct in assuming we should be calling invalidate_inode_pages2_range()
> > instead of truncate_inode_pages()?
> 
> That would be conventional.

.... in that case the following patch should fix the warning:

---
 fs/xfs/linux-2.6/xfs_fs_subr.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_fs_subr.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_fs_subr.c	2006-12-12 12:05:17.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_fs_subr.c	2007-01-08 09:30:22.056571711 +1100
@@ -21,6 +21,8 @@ int  fs_noerr(void) { return 0; }
 int  fs_nosys(void) { return ENOSYS; }
 void fs_noval(void) { return; }
 
+#define XFS_OFF_TO_PCSIZE(off)	\
+	(((off) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT)
 void
 fs_tosspages(
 	bhv_desc_t	*bdp,
@@ -32,7 +34,9 @@ fs_tosspages(
 	struct inode	*ip = vn_to_inode(vp);
 
 	if (VN_CACHED(vp))
-		truncate_inode_pages(ip->i_mapping, first);
+		invalidate_inode_pages2_range(ip->i_mapping,
+					XFS_OFF_TO_PCSIZE(first),
+					XFS_OFF_TO_PCSIZE(last));
 }
 
 void
@@ -49,7 +53,9 @@ fs_flushinval_pages(
 		if (VN_TRUNC(vp))
 			VUNTRUNCATE(vp);
 		filemap_write_and_wait(ip->i_mapping);
-		truncate_inode_pages(ip->i_mapping, first);
+		invalidate_inode_pages2_range(ip->i_mapping,
+					XFS_OFF_TO_PCSIZE(first),
+					XFS_OFF_TO_PCSIZE(last));
 	}
 }
 

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
