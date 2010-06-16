Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5GDVu9U130902 for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 08:31:57 -0500
Date: Wed, 16 Jun 2010 09:34:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Security] XFS swapext ioctl minor security issues
Message-ID: <20100616133433.GA16437@infradead.org>
References: <AANLkTilrwmh6n7yYkqyvy_y5-bgS-BEDept0WlLg5GE1@mail.gmail.com>
	<AANLkTikGFq8iv4S3QWp5ZCvXJsjuiP2tKweSl6QwHc6U@mail.gmail.com>
	<20100616121142.GA22317@infradead.org>
	<AANLkTimVtpQuRZpOJ4IGlFzRqWG6XaYGzvUnDuF06MyG@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTimVtpQuRZpOJ4IGlFzRqWG6XaYGzvUnDuF06MyG@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, security@kernel.org, aelder@sgi.com, Eugene Teo <eugeneteo@kernel.sg>, xfs@oss.sgi.com

On Wed, Jun 16, 2010 at 09:07:10AM -0400, Dan Rosenberg wrote:
> Sure thing.  This patch is against 2.6.34, but it appears that it can
> apply to >= 2.6.25.  Let me know if you need a fix for < 2.6.25.
> 
> For those new to the conversation, this patch prevents user "foo" from
> using the SWAPEXT ioctl to swap a write-only file owned by user "bar"
> into a file owned by "foo" and subsequently reading it.  It does so by
> checking that the file descriptors passed to the ioctl are also opened
> for reading.

This part is okay.  If you provide a Signed-off-by: line it
can be put into the tree ASAP.

> In addition, after swapping any suid/sgid bits should be
> cleared.

I'm still trying to understand this one.  Clearly we do not want to
simply drop the suid/sgid bits here - swapext is just supposed to
optimize file layout, but not change i_mode.  So if the suid bit
really is a risk here we need to refuse to swapext it.

What's the scenario here:

 - swapext is called by the owner and the suid bit is set, or
   the owner is member of the group and the sgid bit is set,
   this should be fine.
 - the caller is not the owner, but has write access to the file.
   an actual write to change the data by the user would already drop
   the bits, so in theory swapext should be fine.  But we might lose
   some important metadata in extended attributes that previously
   might have made the file safe, say per-file capabilities.
   I'd love to here the exact scenario, but for let's play safe and
   refuse the swapex for that case, by doing something:

/*
 * SGID without any exec bits is just a mandatory locking mark.
 */
#define is_sgid(mode) \
	(((mode) & (S_ISGID|S_IXGRP)) == (S_ISGID|S_IXGRP))

...

	struct inode *inode, *tmp_inode;

...

	inode = file->f_path.dentry->d_inode;
	tmp_inode = tmp_file->f_path.dentry->d_inode;

...

	error = XFS_ERROR(EPERM);
	if ((inode->i_mode & S_ISUID) && !is_owner_or_cap(inode))
		goto out;
	if ((tmp_inode->i_mode & S_ISUID) && !is_owner_or_cap(tmp_inode))
		goto out;
	if (is_sgid(inode->i_mode) && !in_group_p(inode->i_gid))
		goto out;
	if (is_sgid(tmp_inode->i_mode) && !in_group_p(tmp_inode->i_gid))
		goto out;
	    

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
