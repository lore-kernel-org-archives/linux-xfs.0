Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 55A8E7F57
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 16:11:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3B5E78F8078
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 14:11:54 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id fhDnOyatsEWYiLpt for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 14:11:49 -0800 (PST)
Date: Mon, 2 Dec 2013 23:11:46 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs: fix iversion handling
Message-ID: <20131202221146.GH12253@quack.suse.cz>
References: <20131119151707.GA13412@infradead.org>
	<20131202173636.GA17724@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131202173636.GA17724@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon 02-12-13 09:36:36, Christoph Hellwig wrote:
> ping?
> 
> On Tue, Nov 19, 2013 at 07:17:07AM -0800, Christoph Hellwig wrote:
> > Currently notify_change directly updates i_version for size updates,
> > which not only is counter to how all other fields are updated through
> > struct iattr, but also breaks XFS, which need inode updates to happen
> > under its own lock, and synchronized to the structure that gets written
> > to the log.
> > 
> > Remove the update in the common code, and it to btrfs and ext4,
> > XFS already does a proper updaste internally and currently gets a
> > double update with the existing code.
> > 
> > IMHO this is 3.13 and -stable material and should go in through the XFS
> > tree.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
  Feel free to add my:
Acked-by: Jan Kara <jack@suse.cz>
  for the ext4 part.

								Honza

> > 
> > Index: xfs/fs/attr.c
> > ===================================================================
> > --- xfs.orig/fs/attr.c	2013-11-19 16:08:42.275415189 +0100
> > +++ xfs/fs/attr.c	2013-11-19 16:08:51.803414994 +0100
> > @@ -182,11 +182,6 @@ int notify_change(struct dentry * dentry
> >  			return -EPERM;
> >  	}
> >  
> > -	if ((ia_valid & ATTR_SIZE) && IS_I_VERSION(inode)) {
> > -		if (attr->ia_size != inode->i_size)
> > -			inode_inc_iversion(inode);
> > -	}
> > -
> >  	if ((ia_valid & ATTR_MODE)) {
> >  		umode_t amode = attr->ia_mode;
> >  		/* Flag setting protected by i_mutex */
> > Index: xfs/fs/btrfs/inode.c
> > ===================================================================
> > --- xfs.orig/fs/btrfs/inode.c	2013-11-19 16:08:42.275415189 +0100
> > +++ xfs/fs/btrfs/inode.c	2013-11-19 16:08:51.803414994 +0100
> > @@ -4345,8 +4345,12 @@ static int btrfs_setsize(struct inode *i
> >  	 * these flags set.  For all other operations the VFS set these flags
> >  	 * explicitly if it wants a timestamp update.
> >  	 */
> > -	if (newsize != oldsize && (!(mask & (ATTR_CTIME | ATTR_MTIME))))
> > -		inode->i_ctime = inode->i_mtime = current_fs_time(inode->i_sb);
> > +	if (newsize != oldsize) {
> > +		inode_inc_iversion(inode);
> > +		if (!(mask & (ATTR_CTIME | ATTR_MTIME)))
> > +			inode->i_ctime = inode->i_mtime =
> > +				current_fs_time(inode->i_sb);
> > +	}
> >  
> >  	if (newsize > oldsize) {
> >  		truncate_pagecache(inode, newsize);
> > Index: xfs/fs/ext4/inode.c
> > ===================================================================
> > --- xfs.orig/fs/ext4/inode.c	2013-11-19 16:08:42.275415189 +0100
> > +++ xfs/fs/ext4/inode.c	2013-11-19 16:08:51.803414994 +0100
> > @@ -4594,6 +4594,10 @@ int ext4_setattr(struct dentry *dentry,
> >  			if (attr->ia_size > sbi->s_bitmap_maxbytes)
> >  				return -EFBIG;
> >  		}
> > +
> > +		if (IS_I_VERSION(inode) && attr->ia_size != inode->i_size)
> > +			inode_inc_iversion(inode);
> > +
> >  		if (S_ISREG(inode->i_mode) &&
> >  		    (attr->ia_size < inode->i_size)) {
> >  			if (ext4_should_order_data(inode)) {
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> ---end quoted text---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
