Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7C8957F3F
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 18:25:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F08C4AC006
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 16:25:41 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dNkXFVEbFFHLcfOI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2015 16:25:37 -0800 (PST)
Date: Thu, 8 Jan 2015 19:25:33 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: inodes are new until the dentry cache is set up
Message-ID: <20150109002532.GA45173@bfoster.bfoster>
References: <1420667576-7592-1-git-send-email-david@fromorbit.com>
	<20150108153205.GE33789@bfoster.bfoster>
	<20150108232328.GM25000@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150108232328.GM25000@dastard>
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

On Fri, Jan 09, 2015 at 10:23:28AM +1100, Dave Chinner wrote:
> On Thu, Jan 08, 2015 at 10:32:05AM -0500, Brian Foster wrote:
> > On Thu, Jan 08, 2015 at 08:52:56AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Al Viro noticed a generic set of issues to do with filehandle lookup
> > > racing with dentry cache setup. They involve a filehandle lookup
> > > occurring while an inode is being created and the filehandle lookup
> > > racing with the dentry creation for the real file. This can lead to
> > > multiple dentries for the one path being instantiated. There are a
> > > host of other issues around this same set of paths.
> > > 
> > > The underlying cause is that file handle lookup only waits on inode
> > > cache instantiation rather than full dentry cache instantiation. XFS
> > > is mostly immune to the problems discovered due to it's own internal
> > > inode cache, but there are a couple of corner cases where races can
> > > happen.
> > > 
> > > We currently clear the XFS_INEW flag when the inode is fully set up
> > > after insertion into the cache. Newly allocated inodes are inserted
> > > locked and so aren't usable until the allocation transaction
> > > commits. This, however, occurs before the dentry and security
> > > information is fully initialised and hence the inode is unlocked and
> > > available for lookups to find too early.
> > > 
> > > To solve the problem, only clear the XFS_INEW flag for newly created
> > > inodes once the dentry is fully instantiated. This means lookups
> > > will retry until the XFS_INEW flag is removed from the inode and
> > > hence avoids the race conditions in questions.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ....
> > > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > > index ce80eeb..8be5bb5 100644
> > > --- a/fs/xfs/xfs_iops.c
> > > +++ b/fs/xfs/xfs_iops.c
> > > @@ -186,6 +186,8 @@ xfs_generic_create(
> > >  	else
> > >  		d_instantiate(dentry, inode);
> > >  
> > > +	xfs_finish_inode_setup(ip);
> > > +
> > >   out_free_acl:
> > >  	if (default_acl)
> > >  		posix_acl_release(default_acl);
> > > @@ -194,6 +196,7 @@ xfs_generic_create(
> > >  	return error;
> > >  
> > >   out_cleanup_inode:
> > > +	xfs_finish_inode_setup(ip);
> > >  	if (!tmpfile)
> > >  		xfs_cleanup_inode(dir, inode, dentry);
> > >  	iput(inode);
> > > @@ -366,9 +369,11 @@ xfs_vn_symlink(
> > >  		goto out_cleanup_inode;
> > >  
> > >  	d_instantiate(dentry, inode);
> > > +	xfs_finish_inode_setup(cip);
> > >  	return 0;
> > >  
> > >   out_cleanup_inode:
> > > +	xfs_finish_inode_setup(cip);
> > >  	xfs_cleanup_inode(dir, inode, dentry);
> > >  	iput(inode);
> > >   out:
> > 
> > Ok, but what about post-inode-allocation failure conditions down in
> > xfs_create()? I don't know if there's any real harm in releasing an
> > I_NEW inode, but iput_final() does throw a warning. Same general
> > question applies to xfs_create_tmpfile(), etc..
> 
> Ah, good point, I missed those.
> 
> Where/how are you getting warnings thrown? I'm not seeing anything
> from xfstests runs?
> 

Oh, I hadn't reproduced warnings as such. I was just digging down that
path and came across this in iput_final():

	WARN_ON(inode->i_state & I_NEW);

Brian

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
