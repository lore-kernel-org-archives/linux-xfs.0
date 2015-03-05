Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 37C2E7F3F
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 05:05:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C7238AC01A
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 03:05:12 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id YrbXtWt3YHfkY3jP (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Mar 2015 03:05:09 -0800 (PST)
Date: Thu, 5 Mar 2015 12:05:04 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/6] xfs: add DAX file operations support
Message-ID: <20150305110504.GC2836@quack.suse.cz>
References: <1425425427-16283-1-git-send-email-david@fromorbit.com>
	<1425425427-16283-4-git-send-email-david@fromorbit.com>
	<20150304161848.GB2799@quack.suse.cz>
	<20150304220005.GV18360@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150304220005.GV18360@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Thu 05-03-15 09:00:05, Dave Chinner wrote:
> On Wed, Mar 04, 2015 at 05:18:48PM +0100, Jan Kara wrote:
> > On Wed 04-03-15 10:30:24, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Add the initial support for DAX file operations to XFS. This
> > > includes the necessary block allocation and mmap page fault hooks
> > > for DAX to function.
> > > 
> > > Note that the current block allocation code abuses the mapping
> > > buffer head to provide a completion callback for unwritten extent
> > > allocation when DAX is clearing blocks. The DAX interface needs to
> > > be changed to provide a callback similar to get_blocks for this
> > > callback.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> .....
> > > +static int
> > > +xfs_filemap_dax_page_mkwrite(
> > > +	struct vm_area_struct	*vma,
> > > +	struct vm_fault		*vmf)
> > > +{
> > > +	struct xfs_inode	*ip = XFS_I(vma->vm_file->f_mapping->host);
> > > +	int			error;
> > > +
> > > +	trace_xfs_filemap_page_mkwrite(ip);
> > > +
> > > +	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
> >   So I think the lock ordering of XFS_MMAPLOCK and freezing protection is
> > suspicious (and actually so is for normal write faults as I'm looking -
> > didn't realize that when I was first reading your MMAPLOCK patches).
> > Because you take XFS_MMAPLOCK outside of freeze protection however usually
> > we want freeze protection to be the outermost lock - in particular in
> > xfs_file_fallocate() you take XFS_MMAPLOCK inside freeze protection I
> > think.
> 
> OK, so why isn't lockdep triggering on that? lockdep is aware of
> inode locks and the freeze states, supposedly to pick up these exact
> issues...
> 
> Oh, probably because the sb freeze order is write, pagefault,
> transaction.
> 
> i.e. In the fallocate case, we do sb_start_write, MMAP_LOCK. If we are in
> a freeze case, we aren't going to freeze page faults until we've
> frozen all the writes have drained, so there isn't a lock order
> dependency there. Same for any other mnt_want_write/sb-start_write
> based modification. 
> 
> Hence the fallocate path and anything that runs through setattr will
> complete and release the mmap lock and then be prevented from taking
> it again by the time sb_start_pagefault() can block with the mmap
> lock held.  So there isn't actually a deadlock there because of the
> way freeze works, and that's why lockdep is staying silent.
  Yeah, you're right there isn't a deadlock possibility. After all the lock
ranking of your MMAP_LOCk is currently the same as of mmap_sem (and the
difficult lock ordering of that semaphore has been the reason why we have
special type of freeze protection for page faults).

> Still, I probably need to fix it so I'm not leaving a potential
> landmine around.
  I would find it easier to grasp. Yes.

> > So you'll need to do what ext4 needs to do - take freeze protection, take
> > fs specific locks, and then call do_dax_fault(). Matthew has a patch to
> > actually export do_dax_fault (as __dax_fault()) for filesystems.
> 
> pointer to it? if none, I'll just write my own....
  http://permalink.gmane.org/gmane.comp.file-systems.ext4/47866

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
