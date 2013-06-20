Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 940E57F37
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 08:53:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8406C8F8035
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 06:53:49 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id L1RjFgeabQYTcED0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 20 Jun 2013 06:53:48 -0700 (PDT)
Date: Thu, 20 Jun 2013 09:54:10 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: [PATCH] userns: Convert xfs to use kuid/kgid where appropriate
Message-ID: <20130620095410.1917d235@oracle.com>
In-Reply-To: <20130620001341.GM29338@dastard>
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
Mime-Version: 1.0
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
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, xfs@oss.sgi.com

On Thu, 20 Jun 2013 10:13:41 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Jun 19, 2013 at 11:09:48AM -0400, Dwight Engen wrote:
> > Use uint32 from init_user_ns for xfs internal uid/gid
> > representation in acl, xfs_icdinode. Conversion of kuid/gid is done
> > at the vfs boundary, other user visible xfs specific interfaces
> > (bulkstat, eofblocks filter) expect uint32 init_user_ns uid/gid
> > values.
> 
> It's minimal, but I'm not sure it's complete. I'll comment on that
> in response to Eric's comments...
> 
> > Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> ....
> > --- a/fs/xfs/xfs_fs.h
> > +++ b/fs/xfs/xfs_fs.h
> > @@ -347,8 +347,8 @@ typedef struct xfs_error_injection {
> >  struct xfs_eofblocks {
> >  	__u32		eof_version;
> >  	__u32		eof_flags;
> > -	uid_t		eof_uid;
> > -	gid_t		eof_gid;
> > +	__u32		eof_uid;
> > +	__u32		eof_gid;
> >  	prid_t		eof_prid;
> >  	__u32		pad32;
> >  	__u64		eof_min_file_size;
> 
> The patch doesn't do namespace conversion of these uid/gids, but I'm
> not sure it should...

The ids are only advisory, if the caller doesn't specify
XFS_EOF_FLAGS_?ID blocks from any inode in the fs can be reclaimed
regardless of id. Because of this, I think at a minimum we should
change XFS_IOC_FREE_EOFBLOCKS to require capable(CAP_SYS_ADMIN), which
somewhat implies init_user_ns based ids.

To make this really userns aware, I think we could:
  - leave the fields as uid_t
  - make XFS_IOC_FREE_EOFBLOCKS require nsown_capable(CAP_SYS_ADMIN)
  - check kuid_has_mapping(current_user_ns()) for each
    inode. This would be a change in behavior when called
    from !init_user_ns, limiting the scope of inodes the ioctl could
    affect.
  - change xfs_inode_match_id() to use uid_eq(VFS_I(ip)->i_uid,
    make_kuid(current_user_ns(), eofb->eof_uid))

Does that sound reasonable?

> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 96e344e..70ba410 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -617,7 +617,7 @@ restart:
> >  
> >  /*
> >   * Background scanning to trim post-EOF preallocated space. This
> > is queued
> > - * based on the 'background_prealloc_discard_period' tunable (5m
> > by default).
> > + * based on the 'speculative_prealloc_lifetime' tunable (5m by
> > default). */
> >  STATIC void
> >  xfs_queue_eofblocks(
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 7f7be5f..8049976 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1268,8 +1268,8 @@ xfs_ialloc(
> >  	ip->i_d.di_onlink = 0;
> >  	ip->i_d.di_nlink = nlink;
> >  	ASSERT(ip->i_d.di_nlink == nlink);
> > -	ip->i_d.di_uid = current_fsuid();
> > -	ip->i_d.di_gid = current_fsgid();
> > +	ip->i_d.di_uid = from_kuid(&init_user_ns, current_fsuid());
> > +	ip->i_d.di_gid = from_kgid(&init_user_ns, current_fsgid());
> 
> Why all new inodes be created in the init_user_ns? Shouldn't this be
> current_user_ns()?

current_fsuid() is the kuid_t from whatever userns current is in,
which we are converting to a flat uint32 since i_d is the on disk inode.
This field is then used in xfs_setup_inode() to populate
VFS_I(ip)->i_uid. Most other filesystems would use inode_init_owner(),
but xfs does not (I assume because it wants to handle SGID itself based
on XFS_INHERIT_GID and irix_sgid_inherit).

> Same question throughout - why do you use init_user_ns for all these
> UID conversions, when the whole point is to have awareness of
> different namespaces?

Yep, there are instances you point out below where we can just use
inode->i_uid instead of converting back from the flat value, so I'll fix
those up.

> >  	xfs_set_projid(ip, prid);
> >  	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
> >  
> > @@ -1308,7 +1308,7 @@ xfs_ialloc(
> >  	 */
> >  	if ((irix_sgid_inherit) &&
> >  	    (ip->i_d.di_mode & S_ISGID) &&
> > -	    (!in_group_p((gid_t)ip->i_d.di_gid))) {
> > +	    (!in_group_p(make_kgid(&init_user_ns,
> > ip->i_d.di_gid)))) { ip->i_d.di_mode &= ~S_ISGID;
> >  	}
> >  
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 5e99968..daa6127 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -981,7 +981,7 @@ xfs_ioctl_setattr(
> >  	 * to the file owner ID, except in cases where the
> >  	 * CAP_FSETID capability is applicable.
> >  	 */
> > -	if (current_fsuid() != ip->i_d.di_uid
> > && !capable(CAP_FOWNER)) {
> > +	if (!inode_owner_or_capable(&ip->i_vnode)) {
> 
> 				    VFS_I(ip)
> 
> >  		code = XFS_ERROR(EPERM);
> >  		goto error_return;
> >  	}
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index ca9ecaa..bf96cf8 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -420,8 +420,8 @@ xfs_vn_getattr(
> >  	stat->dev = inode->i_sb->s_dev;
> >  	stat->mode = ip->i_d.di_mode;
> >  	stat->nlink = ip->i_d.di_nlink;
> > -	stat->uid = ip->i_d.di_uid;
> > -	stat->gid = ip->i_d.di_gid;
> > +	stat->uid = make_kuid(&init_user_ns, ip->i_d.di_uid);
> > +	stat->gid = make_kgid(&init_user_ns, ip->i_d.di_gid);
> 
> Why not:
> 
> 	stat->uid = inode->i_uid;
> 	stat->gid = inode->i_gid;
> 
> >  	stat->ino = ip->i_ino;
> >  	stat->atime = inode->i_atime;
> >  	stat->mtime = inode->i_mtime;
> > @@ -488,8 +488,8 @@ xfs_setattr_nonsize(
> >  	int			mask = iattr->ia_valid;
> >  	xfs_trans_t		*tp;
> >  	int			error;
> > -	uid_t			uid = 0, iuid = 0;
> > -	gid_t			gid = 0, igid = 0;
> > +	kuid_t			uid = GLOBAL_ROOT_UID, iuid
> > = GLOBAL_ROOT_UID;
> > +	kgid_t			gid = GLOBAL_ROOT_GID, igid
> > = GLOBAL_ROOT_GID; struct xfs_dquot	*udqp = NULL, *gdqp =
> > NULL; struct xfs_dquot	*olddquot1 = NULL, *olddquot2 = NULL;
> >  
> > @@ -522,13 +522,13 @@ xfs_setattr_nonsize(
> >  			uid = iattr->ia_uid;
> >  			qflags |= XFS_QMOPT_UQUOTA;
> >  		} else {
> > -			uid = ip->i_d.di_uid;
> > +			uid = make_kuid(&init_user_ns,
> > ip->i_d.di_uid);
> 
> 			uid = VFS_I(ip)->i_uid;
> >  		}
> >  		if ((mask & ATTR_GID) && XFS_IS_GQUOTA_ON(mp)) {
> >  			gid = iattr->ia_gid;
> >  			qflags |= XFS_QMOPT_GQUOTA;
> >  		}  else {
> > -			gid = ip->i_d.di_gid;
> > +			gid = make_kgid(&init_user_ns,
> > ip->i_d.di_gid);
> 
> 			gid = VFS_I(ip)->i_gid;
> >  		}
> .....
> > @@ -561,8 +563,8 @@ xfs_setattr_nonsize(
> >  		 * while we didn't have the inode locked, inode's
> > dquot(s)
> >  		 * would have changed also.
> >  		 */
> > -		iuid = ip->i_d.di_uid;
> > -		igid = ip->i_d.di_gid;
> > +		iuid = make_kuid(&init_user_ns, ip->i_d.di_uid);
> > +		igid = make_kgid(&init_user_ns, ip->i_d.di_gid);
> >  		gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
> >  		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
> 
> Same again - you can just use VFS_I(ip)->i_uid/VFS_I(ip)->i_gid
> here.
> 
> > @@ -1172,8 +1174,8 @@ xfs_setup_inode(
> >  
> >  	inode->i_mode	= ip->i_d.di_mode;
> >  	set_nlink(inode, ip->i_d.di_nlink);
> > -	inode->i_uid	= ip->i_d.di_uid;
> > -	inode->i_gid	= ip->i_d.di_gid;
> > +	inode->i_uid	= make_kuid(&init_user_ns,
> > ip->i_d.di_uid);
> > +	inode->i_gid	= make_kgid(&init_user_ns,
> > ip->i_d.di_gid);
> 
> current name space?

I believe that is what this is doing, but I think it will be more
proper to do it the same as other filesystems:

i_uid_write(inode, ip->i_d.di_uid);
i_gid_write(inode, ip->i_d.di_gid);

> >  
> >  	switch (inode->i_mode & S_IFMT) {
> >  	case S_IFBLK:
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index b75c9bb..94a2a8f 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -1651,8 +1651,8 @@ xfs_qm_write_sb_changes(
> >  int
> >  xfs_qm_vop_dqalloc(
> >  	struct xfs_inode	*ip,
> > -	uid_t			uid,
> > -	gid_t			gid,
> > +	__uint32_t		di_uid,
> > +	__uint32_t		di_gid,
> 
> xfs_dqid_t
> 
> And there's no need to rename the variables - that just causes
> unnecessary churn, and the fact it is a dquot ID is documented by
> the type.

Yep using the type will be clearer, thanks.

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
