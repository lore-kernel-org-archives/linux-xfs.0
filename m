Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CD0847F37
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 18:02:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5972DAC007
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 16:02:52 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id B1KVOFUdKbmL28PN for
	<xfs@oss.sgi.com>; Thu, 08 Oct 2015 16:02:50 -0700 (PDT)
Date: Thu, 8 Oct 2015 17:02:42 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] xfs: clarify lock ordering comment
Message-ID: <20151008230242.GA14219@linux.intel.com>
References: <1444341481-14139-1-git-send-email-ross.zwisler@linux.intel.com>
	<20151008222450.GH32150@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151008222450.GH32150@dastard>
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
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Oct 09, 2015 at 09:24:50AM +1100, Dave Chinner wrote:
> On Thu, Oct 08, 2015 at 03:58:01PM -0600, Ross Zwisler wrote:
> > Replace "i_mmap_lock" with "mmap_lock" in the lock ordering comment above
> > xfs_filemap_page_mkwrite().  The lock in question is actually the
> > XFS_MMAPLOCK_SHARED rw_semaphore (no leading "i"), and this comment is
> 
> struct xfs_inode {
> ....
> 	        mrlock_t                i_mmaplock;     /* inode mmap IO lock */
> ....
> 
> > easily confused with the "i_mmap_lock_[read|write]" functions that operate
> > on struct address_space->i_mmap_rwsem.  This clarification is especially
> > important because address_space->i_mmap_rwsem is taken down in the DAX
> > code as part of this fault path.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > ---
> >  fs/xfs/xfs_file.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index f429662..b190033 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1477,7 +1477,7 @@ xfs_file_llseek(
> >   *
> >   * mmap_sem (MM)
> >   *   sb_start_pagefault(vfs, freeze)
> > - *     i_mmap_lock (XFS - truncate serialisation)
> > + *     mmap_lock (XFS - truncate serialisation)
> 
> As per above, the XFS lock is "i_mmaplock"...
> 
> The lock names are annotated with the subsystem the lock belongs to
> to avoid this confusion. Along with the lock ordering (inside
> sb_start_pagefault) this should indicate that it's not the
> "i_mmap_lock (MM - vma serialisation)" lock... ;)

Ah, that makes sense, thanks. :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
