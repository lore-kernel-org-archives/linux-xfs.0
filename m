Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38802 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfFTWLL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 18:11:11 -0400
Date: Thu, 20 Jun 2019 15:09:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/6] vfs: flush and wait for io when setting the
 immutable flag via SETFLAGS
Message-ID: <20190620220940.GC5375@magnolia>
References: <156022836912.3227213.13598042497272336695.stgit@magnolia>
 <156022838496.3227213.3771632042609589318.stgit@magnolia>
 <20190620140028.GH30243@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620140028.GH30243@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, ard.biesheuvel@linaro.org, josef@toxicpanda.com, clm@fb.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, jk@ozlabs.org, reiserfs-devel@vger.kernel.org, linux-efi@vger.kernel.org, devel@lists.orangefs.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Thu, Jun 20, 2019 at 04:00:28PM +0200, Jan Kara wrote:
> On Mon 10-06-19 21:46:25, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we're using FS_IOC_SETFLAGS to set the immutable flag on a file, we
> > need to ensure that userspace can't continue to write the file after the
> > file becomes immutable.  To make that happen, we have to flush all the
> > dirty pagecache pages to disk to ensure that we can fail a page fault on
> > a mmap'd region, wait for pending directio to complete, and hope the
> > caller locked out any new writes by holding the inode lock.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> ...
> 
> > diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> > index 6aa1df1918f7..a05341b94d98 100644
> > --- a/fs/ext4/ioctl.c
> > +++ b/fs/ext4/ioctl.c
> > @@ -290,6 +290,9 @@ static int ext4_ioctl_setflags(struct inode *inode,
> >  	jflag = flags & EXT4_JOURNAL_DATA_FL;
> >  
> >  	err = vfs_ioc_setflags_check(inode, oldflags, flags);
> > +	if (err)
> > +		goto flags_out;
> > +	err = vfs_ioc_setflags_flush_data(inode, flags);
> >  	if (err)
> >  		goto flags_out;
> >  
> 
> ...
> 
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 8dad3c80b611..9c899c63957e 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -3548,7 +3548,41 @@ static inline struct sock *io_uring_get_socket(struct file *file)
> >  
> >  int vfs_ioc_setflags_check(struct inode *inode, int oldflags, int flags);
> >  
> > +/*
> > + * Do we need to flush the file data before changing attributes?  When we're
> > + * setting the immutable flag we must stop all directio writes and flush the
> > + * dirty pages so that we can fail the page fault on the next write attempt.
> > + */
> > +static inline bool vfs_ioc_setflags_need_flush(struct inode *inode, int flags)
> > +{
> > +	if (S_ISREG(inode->i_mode) && !IS_IMMUTABLE(inode) &&
> > +	    (flags & FS_IMMUTABLE_FL))
> > +		return true;
> > +
> > +	return false;
> > +}
> > +
> > +/*
> > + * Flush file data before changing attributes.  Caller must hold any locks
> > + * required to prevent further writes to this file until we're done setting
> > + * flags.
> > + */
> > +static inline int inode_flush_data(struct inode *inode)
> > +{
> > +	inode_dio_wait(inode);
> > +	return filemap_write_and_wait(inode->i_mapping);
> > +}
> > +
> > +/* Flush file data before changing attributes, if necessary. */
> > +static inline int vfs_ioc_setflags_flush_data(struct inode *inode, int flags)
> > +{
> > +	if (vfs_ioc_setflags_need_flush(inode, flags))
> > +		return inode_flush_data(inode);
> > +	return 0;
> > +}
> > +
> 
> But this is racy at least for page faults, isn't it? What protects you
> against write faults just after filemap_write_and_wait() has finished?
> So either you need to set FS_IMMUTABLE_FL before flushing data or you need
> to get more protection from the fs than just i_rwsem. In the case of ext4
> that would be i_mmap_rwsem but other filesystems don't have equivalent
> protection...

Yes, I see that now.  I think it'll work to set S_IMMUTABLE before
trying the flush, so long as I am careful to put the call sites right
before we update the inode flags.

--D

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
