Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 17 Aug 2008 17:33:38 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7I0XaMK007768
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2008 17:33:36 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E1DA1BC6374
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2008 17:34:55 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id Ic7nWFsweJiXUaOP for <xfs@oss.sgi.com>; Sun, 17 Aug 2008 17:34:55 -0700 (PDT)
Date: Mon, 18 Aug 2008 10:34:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/7] XFS: Combine the XFS and Linux inodes.
Message-ID: <20080818003451.GG19760@disturbed>
References: <1218698083-11226-1-git-send-email-david@fromorbit.com> <1218698083-11226-7-git-send-email-david@fromorbit.com> <20080814200006.GC12237@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814200006.GC12237@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Aug 14, 2008 at 04:00:06PM -0400, Christoph Hellwig wrote:
> > +	if (!(inode->i_state & I_CLEAR)) {
> >  		ip->i_d.di_atime.t_sec = (__int32_t)inode->i_atime.tv_sec;
> >  		ip->i_d.di_atime.t_nsec = (__int32_t)inode->i_atime.tv_nsec;
> >  	}
> 
> Actually we can just do this unconditionally, as the atime values don't
> become invalid just because the VFS doesn't know about the inode
> anymore.  And two useless because already previously updated assignments
> are cheaper than a branch.

Ok, I'll make it unconditional.

> > + * We are always called with an uninitialised linux inode here.
> > + * We need to initialise the necessary fields and take a reference
> > + * on it.
> >   */
> >  void
> >  xfs_setup_inode(
> >  	struct xfs_inode	*ip)
> >  {
> > -	struct inode		*inode = ip->i_vnode;
> > +	struct inode		*inode = &ip->i_vnode;
> 
> VFS_I?

Yup, I thought I caught all of them :/

> 
> > +	inode->i_ino = ip->i_ino;
> > +	inode->i_state = I_NEW|I_LOCK;
> > +	inode_used(ip->i_mount->m_super, inode);
> > +	ASSERT(atomic_read(&inode->i_count) == 1);
> 
> Where does inode_used come from?  (It's also a rather ugly name..)

Ah, separate patch not sent. basically does:

void inode_used(struct super_block *sb, struct inode *inode)
{
       spin_lock(&inode_lock);
       inodes_stat.nr_inodes++;
       list_add(&inode->i_list, &inode_in_use);
       list_add(&inode->i_sb_list, &sb->s_inodes);
       spin_unlock(&inode_lock);
}

> > +/* XXX: development debug only */
> >  STATIC struct inode *
> >  xfs_fs_alloc_inode(
> >  	struct super_block	*sb)
> >  {
> > -	return kmem_zone_alloc(xfs_vnode_zone, KM_SLEEP);
> > +	BUG();
> >  }
> 
> Actually keeping this one is a good idea, even if it's just to catch
> really dumb things like the iget_locked OpenAFS's cache manager does on
> random filesystems..

Ok, I'll leave that in.

> > -void
> > -xfs_inode_init_once(
> > +STATIC void
> > +xfs_fs_inode_init_once(
> 
> might be a good idea to already use that name in the patch that
> introduces it :)

The problem was that we have two init functions at this point;
one for the vnode, one for the inode....

> >  /*
> > + * we need to provide an empty inode free function to prevent
> > + * the generic code from trying to free ouuur combined inode.
> > + */
> > +STATIC void
> > +xfs_fs_destroy_inode(
> > +	struct inode		*inode)
> > +{
> > +	return;
> > +}
> 
> Why it's this kept in the original place, close to alloc_inode?

Just the way things happened. I'll move it back.

> Also the return statement is superflous.

Yup.

> >  /* convert from xfs inode to vfs inode */
> >  static inline struct inode *VFS_I(struct xfs_inode *ip)
> >  {
> > -	return (struct inode *)ip->i_vnode;
> > +	return (struct inode *)&ip->i_vnode;
> >  }
> 
> No need for the cast in either version..

Ok, I'll kill it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
