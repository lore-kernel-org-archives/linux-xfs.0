Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C17AC29DF8
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 15:02:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2F68FAC009
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2014 13:01:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QYwVRngxvEYKpvw5 for
	<xfs@oss.sgi.com>; Thu, 12 Jun 2014 13:01:45 -0700 (PDT)
Date: Thu, 12 Jun 2014 16:01:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [DISCUSS] Planning for new dev cycle (3.17)
Message-ID: <20140612200139.GD3148@laptop.bfoster>
References: <20140609223320.GE9508@dastard>
	<20140610115857.GC46344@bfoster.bfoster>
	<20140610214850.GH9508@dastard> <20140611091020.GO4453@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140611091020.GO4453@dastard>
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
Cc: xfs@oss.sgi.com

On Wed, Jun 11, 2014 at 07:10:20PM +1000, Dave Chinner wrote:
> On Wed, Jun 11, 2014 at 07:48:50AM +1000, Dave Chinner wrote:
> > On Tue, Jun 10, 2014 at 07:58:57AM -0400, Brian Foster wrote:
> > > On Tue, Jun 10, 2014 at 08:33:20AM +1000, Dave Chinner wrote:
> > > > The issue is the negative error number patchset, and how to handle
> > > > review and testing. The patchset is already 62 patches long and it
> > > > converts roughly half the code base. It'll take me another couple of
> > > > days to convert the rest of the code, and that will probably take
> > > > another 60 patches.
> > > > 
> > > > I understand that reviewing 100+ patches is going to be a pain, but
> > > > each patch currently averages about +/- 10 lines. The current
> > > > diffstat is:
> > > > 
> > > > 	37 files changed, 723 insertions(+), 722 deletions(-)
> > > > 
> > > > And that will probably double, so it's still going to be a fair
> > > > amount of change.
> > > 
> > > Is there any sort of more coarse logical breakdown of this series, or do
> > > we want/need to convert the entire codebase all at once? The individual
> > > patches sound relatively small... is there a particular method at play
> > > there? E.g., a patch per function? file? call chain?
> > 
> > I'm doing it layer by layer, starting from the linux interface
> > layers and working my way down. e.g. fs/xfs/xfs_file.c first,
> > the fs/xfs/xfs_iops.c, and so on, and there are multiple patches per
> > file for each (roughly) logical change. e.g. converting xfs_iops.c:
> [...]
> 
> I've decided that there really is too much unnecessary code churn
> from this approach. I end up converting all the call sites to negate
> the error sign, and then end up converting them back to the original
> code some time later, leaving only the source of the errors with a
> changed sign.
> 
> So, I stopped doing that to see just what the brute force, change
> source and conversions only, and I found with a few simple searches
> I could identify all the locations that need changing. So, in a
> couple of hours I churned out the patch that converted everything.
> Still pretty large, even though it only changes error values and
> conversion points.
> 
> 67 files changed, 879 insertions(+), 884 deletions(-)
> 
> Not sure how I could break this up - it really is an all-or-nothing
> patch this Big Hammer approach....
> 

Yeah, now that I look at it, it's kind of hard to review as any other
way as well. I've done some grepping and made a pass through all of the
changes. I noticed some very minor things like not all of the comments
being converted and some multi-line parameter lists going out of
alignment, but I didn't bother to even make notes of those.

I've gone through an xfstests run without any explosions as well.

A couple general observations:

- I assume the xfs_buf->b_error type change is intentional..?
- Same for the change in value for the ASSERT(error <=0 && error >=
  -1000) assert in xfs_buf_ioerror (previously it used 64k).

... and I saw a few spots that looked like could still need conversion.
A diff is inlined below.

Brian

---8<---

diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index e76f687..62db83a 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -648,6 +648,6 @@ xfs_attr_list(
 	alist->al_offset[0] = context.bufsize;
 
 	error = xfs_attr_list_int(&context);
-	ASSERT(error >= 0);
+	ASSERT(error <= 0);
 	return error;
 }
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 7207e9d..e65ea67 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -376,7 +376,7 @@ xfs_compat_attrlist_by_handle(
 		goto out_dput;
 
 	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
-	error = -xfs_attr_list(XFS_I(dentry->d_inode), kbuf, al_hreq.buflen,
+	error = xfs_attr_list(XFS_I(dentry->d_inode), kbuf, al_hreq.buflen,
 					al_hreq.flags, cursor);
 	if (error)
 		goto out_kfree;
@@ -515,7 +515,7 @@ xfs_compat_fssetdm_by_handle(
 		goto out;
 	}
 
-	error = -xfs_set_dmattrs(XFS_I(dentry->d_inode), fsd.fsd_dmevmask,
+	error = xfs_set_dmattrs(XFS_I(dentry->d_inode), fsd.fsd_dmevmask,
 				 fsd.fsd_dmstate);
 
 out:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
