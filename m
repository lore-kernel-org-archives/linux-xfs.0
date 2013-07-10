Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 123237F3F
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 08:23:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0488F8F8039
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 06:23:10 -0700 (PDT)
Date: Wed, 10 Jul 2013 10:22:58 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] Subject: [PATCH] xfs: fix sgid inheritance for
	subdirectories inheriting default acls [V3]
Message-ID: <20130710132257.GE11948@andromeda.usersys.redhat.com>
References: <1371836753-3327-1-git-send-email-cmaiolino@redhat.com>
	<20130708211121.GI20932@sgi.com> <20130708234235.GD3438@dastard>
	<20130709170608.GR20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130709170608.GR20932@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 09, 2013 at 12:06:08PM -0500, Ben Myers wrote:
> On Tue, Jul 09, 2013 at 09:42:35AM +1000, Dave Chinner wrote:
> > On Mon, Jul 08, 2013 at 04:11:21PM -0500, Ben Myers wrote:
> > > On Fri, Jun 21, 2013 at 02:45:53PM -0300, Carlos Maiolino wrote:
> > > > XFS removes sgid bits of subdirectories under a directory containing a default
> > > > acl.
> > > > 
> > > > When a default acl is set, it implies xfs to call xfs_setattr_nonsize() in its
> > > > code path. Such function is shared among mkdir and chmod system calls, and
> > > > does some checks unneeded by mkdir (calling inode_change_ok()). Such checks
> > > > remove sgid bit from the inode after it has been granted.
> > > > 
> > > > With this patch, we extend the meaning of XFS_ATTR_NOACL flag to avoid these
> > > > checks when acls are being inherited (thanks hch).
> > > > 
> > > > Also, xfs_setattr_mode, doesn't need to re-check for group id and capabilities
> > > > permissions, this only implies in another try to remove sgid bit from the
> > > > directories. Such check is already done either on inode_change_ok() or
> > > > xfs_setattr_nonsize().
> > > > 
> > > > Changelog:
> > > > 
> > > > V2: Extends the meaning of XFS_ATTR_NOACL instead of wrap the tests into another
> > > >     function
> > > > 
> > > > V3: Remove S_ISDIR check in xfs_setattr_nonsize() from the patch
> > > > 
> > > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > >  
> > > > -	if (mp->m_flags & XFS_MOUNT_RDONLY)
> > > > -		return XFS_ERROR(EROFS);
> > > > +	/* If acls are being inherited, we already have this checked */
> > > > +	if (!(flags & XFS_ATTR_NOACL)) {
> > > > +		if (mp->m_flags & XFS_MOUNT_RDONLY)
> > > > +			return XFS_ERROR(EROFS);
> > > >  
> > > > -	if (XFS_FORCED_SHUTDOWN(mp))
> > > > -		return XFS_ERROR(EIO);
> > > > +		if (XFS_FORCED_SHUTDOWN(mp))
> > > > +			return XFS_ERROR(EIO);
> > > >  
> > > > -	error = -inode_change_ok(inode, iattr);
> > > > -	if (error)
> > > > -		return XFS_ERROR(error);
> > > > +		error = -inode_change_ok(inode, iattr);
> > > > +		if (error)
> > > > +			return XFS_ERROR(error);
> > > > +	}
> > > 
> > > I'm not so sure about this change yet.  Looks like the two relevant callers are:
> > > 
> > > .set - xattr_handler
> > >   xfs_xattr_acl_set
> > >     xfs_set_mode
> > >       xfs_setattr_nonsize(..., XFS_ATTR_NOACL);
> > > 
> > > and
> > > 
> > > xfs_vn_mknod
> > >   xfs_inherit_acl
> > >     xfs_set_mode
> > >       xfs_setattr_nonsize(..., XFS_ATTR_NOACL);
> > > 
> > > I suggest moving the forced shutdown and readonly checks outside of the
> > > XFS_ATTR_NOACL conditional.  I'm not seeing those checks in xfs_attr_acl_set or
> > > xfs_vn_mknod and it won't hurt to be careful.
> > 
> > In both cases, the read-only checks are done at much higher layers
> > and so we don't ever get to xfs_setattr_nonsize() through these
> > paths with a read-only filesystem. Shutdown doesn't really matter -
> > the transaction commit will fail if the filesystem is shut down...
> > 
> > > It also seems like inode_change_ok might have some other checks that are
> > > necessary to determine whether it is ok to update the mode and ctime here.  A
> > > call to inode_owner_or_capable as is done in inode_change_ok would cover this
> > > possibility.
> > 
> > The inode permission checks are already done by xfs_xattr_acl_set():
> > 
> > 	if ((current_fsuid() != inode->i_uid) && !capable(CAP_FOWNER))
> > 		return -EPERM;
> > 
> > and in the case of xfs_inherit_acl() the user has just created the
> > file so they - by definition - have permission to inherit the ACL
> > and modify the mode of the inode they just created.
> > 
> > So there is no need for changes to inode_change_ok() here.
> 
> Carlos, if you agree with Dave's assessment consider this 
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>
> 
> let me know what you think and I'll pull it in.
> 
> Thanks,
> 	Ben
> 
Hi Ben,

Yes, I agree with Dave's statements, I removed the unneeded checks, because they
were done at higher layers.

please, feel free to pull it in, my apologies to have not answered it on IRC, it
was holiday here and I just saw your message late this morning.

Cheers,

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
