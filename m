Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EB6247CBF
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 15:36:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CB355304032
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 13:36:11 -0700 (PDT)
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
	by cuda.sgi.com with ESMTP id 9faNEquCqXibA5Zv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 19 Jun 2013 13:36:09 -0700 (PDT)
From: ebiederm@xmission.com (Eric W. Biederman)
References: <20130619110948.0bfafa2b@oracle.com>
Date: Wed, 19 Jun 2013 13:35:30 -0700
In-Reply-To: <20130619110948.0bfafa2b@oracle.com> (Dwight Engen's message of
	"Wed, 19 Jun 2013 11:09:48 -0400")
Message-ID: <8761x9x2i5.fsf@xmission.com>
MIME-Version: 1.0
Subject: Re: [PATCH] userns: Convert xfs to use kuid/kgid where appropriate
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, xfs@oss.sgi.com


I am copying my gmail address so I have a chance of seeing replies from
Dave Chiner.  So far the only way I have been able to read his replies
has been to read mailling lists.  Which has not be conductive to having
this code discussed properly.  Hopefully copying my gmail address will
allow us to have a reasonable and timely conversation.


Dwight Engen <dwight.engen@oracle.com> writes:

> Use uint32 from init_user_ns for xfs internal uid/gid representation in
> acl, xfs_icdinode. 

>From my review of the code earlier that just isn't safe.  It allows all
kinds of things to slip through.

> Conversion of kuid/gid is done at the vfs boundary,
> other user visible xfs specific interfaces (bulkstat, eofblocks filter)
> expect uint32 init_user_ns uid/gid values.

>From my earlier review of the code conversion at the vfs boundary is
not safe.    

First off kuid_t and kgid_t are not a vfs concepts, they are linux
kernel concepts, and xfs is in the linux kernel.  What makes this
relevant is not all filesystem accesses are through the vfs so all of
the necessary conversions for security and a consistent user experience
can be had by only performing conversions at the user/kernel boundary.

In particular by being sloppy and not pushing kuid_t/kgid_t further down
you did not handle all of the conversions needed at the user/kernel
boundary in XFS_IOC_FREE_EOFBLOCKS.  Which can be called by an
unprivileged user.

I am little dubious about XFS_IOC_FREE_EOFBLOCKS allowing any
user to affect any other user.  Your changes just seem to make
it guaranteed that when called from a user namespace the wrong
user will be affected.

I honestly don't think avoiding the push down of kuid_t and kgid_t to
all of the xfs in-core data structures is safe.  Even if the initial
patch is safe I expect there will be silent breakage when the next ioctl
that bypasses the vfs is added.

Eric

> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> ---
>  fs/xfs/xfs_acl.c      | 24 ++++++++++++++++++++----
>  fs/xfs/xfs_fs.h       |  4 ++--
>  fs/xfs/xfs_icache.c   |  2 +-
>  fs/xfs/xfs_inode.c    |  6 +++---
>  fs/xfs/xfs_ioctl.c    |  2 +-
>  fs/xfs/xfs_iops.c     | 38 ++++++++++++++++++++------------------
>  fs/xfs/xfs_qm.c       | 16 ++++++++--------
>  fs/xfs/xfs_quota.h    |  9 +++++----
>  fs/xfs/xfs_symlink.c  |  4 +++-
>  fs/xfs/xfs_vnodeops.c |  4 +++-
>  init/Kconfig          | 13 -------------
>  11 files changed, 66 insertions(+), 56 deletions(-)
>
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 306d883..fd2854e 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -68,14 +68,17 @@ xfs_acl_from_disk(
>  
>  		switch (acl_e->e_tag) {
>  		case ACL_USER:
> +			acl_e->e_uid = make_kuid(&init_user_ns,
> +						 be32_to_cpu(ace->ae_id));
> +			break;
>  		case ACL_GROUP:
> -			acl_e->e_id = be32_to_cpu(ace->ae_id);
> +			acl_e->e_gid = make_kgid(&init_user_ns,
> +						 be32_to_cpu(ace->ae_id));
>  			break;
>  		case ACL_USER_OBJ:
>  		case ACL_GROUP_OBJ:
>  		case ACL_MASK:
>  		case ACL_OTHER:
> -			acl_e->e_id = ACL_UNDEFINED_ID;
>  			break;
>  		default:
>  			goto fail;
> @@ -101,7 +104,20 @@ xfs_acl_to_disk(struct xfs_acl *aclp, const struct posix_acl *acl)
>  		acl_e = &acl->a_entries[i];
>  
>  		ace->ae_tag = cpu_to_be32(acl_e->e_tag);
> -		ace->ae_id = cpu_to_be32(acl_e->e_id);
> +		switch (acl_e->e_tag) {
> +		case ACL_USER:
> +			ace->ae_id = cpu_to_be32(
> +				from_kuid(&init_user_ns, acl_e->e_uid));
> +			break;
> +		case ACL_GROUP:
> +			ace->ae_id = cpu_to_be32(
> +				from_kgid(&init_user_ns, acl_e->e_gid));
> +			break;
> +		default:
> +			ace->ae_id = cpu_to_be32(ACL_UNDEFINED_ID);
> +			break;
> +		}
> +
>  		ace->ae_perm = cpu_to_be16(acl_e->e_perm);
>  	}
>  }
> @@ -360,7 +376,7 @@ xfs_xattr_acl_set(struct dentry *dentry, const char *name,
>  		return -EINVAL;
>  	if (type == ACL_TYPE_DEFAULT && !S_ISDIR(inode->i_mode))
>  		return value ? -EACCES : 0;
> -	if ((current_fsuid() != inode->i_uid) && !capable(CAP_FOWNER))
> +	if (!inode_owner_or_capable(inode))
>  		return -EPERM;
>  
>  	if (!value)
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index d046955..bf0a6f8 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -347,8 +347,8 @@ typedef struct xfs_error_injection {
>  struct xfs_eofblocks {
>  	__u32		eof_version;
>  	__u32		eof_flags;
> -	uid_t		eof_uid;
> -	gid_t		eof_gid;
> +	__u32		eof_uid;
> +	__u32		eof_gid;
>  	prid_t		eof_prid;
>  	__u32		pad32;
>  	__u64		eof_min_file_size;
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 96e344e..70ba410 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -617,7 +617,7 @@ restart:
>  
>  /*
>   * Background scanning to trim post-EOF preallocated space. This is queued
> - * based on the 'background_prealloc_discard_period' tunable (5m by default).
> + * based on the 'speculative_prealloc_lifetime' tunable (5m by default).
>   */
>  STATIC void
>  xfs_queue_eofblocks(
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 7f7be5f..8049976 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1268,8 +1268,8 @@ xfs_ialloc(
>  	ip->i_d.di_onlink = 0;
>  	ip->i_d.di_nlink = nlink;
>  	ASSERT(ip->i_d.di_nlink == nlink);
> -	ip->i_d.di_uid = current_fsuid();
> -	ip->i_d.di_gid = current_fsgid();
> +	ip->i_d.di_uid = from_kuid(&init_user_ns, current_fsuid());
> +	ip->i_d.di_gid = from_kgid(&init_user_ns, current_fsgid());
>  	xfs_set_projid(ip, prid);
>  	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
>  
> @@ -1308,7 +1308,7 @@ xfs_ialloc(
>  	 */
>  	if ((irix_sgid_inherit) &&
>  	    (ip->i_d.di_mode & S_ISGID) &&
> -	    (!in_group_p((gid_t)ip->i_d.di_gid))) {
> +	    (!in_group_p(make_kgid(&init_user_ns, ip->i_d.di_gid)))) {
>  		ip->i_d.di_mode &= ~S_ISGID;
>  	}
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 5e99968..daa6127 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -981,7 +981,7 @@ xfs_ioctl_setattr(
>  	 * to the file owner ID, except in cases where the
>  	 * CAP_FSETID capability is applicable.
>  	 */
> -	if (current_fsuid() != ip->i_d.di_uid && !capable(CAP_FOWNER)) {
> +	if (!inode_owner_or_capable(&ip->i_vnode)) {
>  		code = XFS_ERROR(EPERM);
>  		goto error_return;
>  	}
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index ca9ecaa..bf96cf8 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -420,8 +420,8 @@ xfs_vn_getattr(
>  	stat->dev = inode->i_sb->s_dev;
>  	stat->mode = ip->i_d.di_mode;
>  	stat->nlink = ip->i_d.di_nlink;
> -	stat->uid = ip->i_d.di_uid;
> -	stat->gid = ip->i_d.di_gid;
> +	stat->uid = make_kuid(&init_user_ns, ip->i_d.di_uid);
> +	stat->gid = make_kgid(&init_user_ns, ip->i_d.di_gid);
>  	stat->ino = ip->i_ino;
>  	stat->atime = inode->i_atime;
>  	stat->mtime = inode->i_mtime;
> @@ -488,8 +488,8 @@ xfs_setattr_nonsize(
>  	int			mask = iattr->ia_valid;
>  	xfs_trans_t		*tp;
>  	int			error;
> -	uid_t			uid = 0, iuid = 0;
> -	gid_t			gid = 0, igid = 0;
> +	kuid_t			uid = GLOBAL_ROOT_UID, iuid = GLOBAL_ROOT_UID;
> +	kgid_t			gid = GLOBAL_ROOT_GID, igid = GLOBAL_ROOT_GID;
>  	struct xfs_dquot	*udqp = NULL, *gdqp = NULL;
>  	struct xfs_dquot	*olddquot1 = NULL, *olddquot2 = NULL;
>  
> @@ -522,13 +522,13 @@ xfs_setattr_nonsize(
>  			uid = iattr->ia_uid;
>  			qflags |= XFS_QMOPT_UQUOTA;
>  		} else {
> -			uid = ip->i_d.di_uid;
> +			uid = make_kuid(&init_user_ns, ip->i_d.di_uid);
>  		}
>  		if ((mask & ATTR_GID) && XFS_IS_GQUOTA_ON(mp)) {
>  			gid = iattr->ia_gid;
>  			qflags |= XFS_QMOPT_GQUOTA;
>  		}  else {
> -			gid = ip->i_d.di_gid;
> +			gid = make_kgid(&init_user_ns, ip->i_d.di_gid);
>  		}
>  
>  		/*
> @@ -538,8 +538,10 @@ xfs_setattr_nonsize(
>  		 */
>  		ASSERT(udqp == NULL);
>  		ASSERT(gdqp == NULL);
> -		error = xfs_qm_vop_dqalloc(ip, uid, gid, xfs_get_projid(ip),
> -					 qflags, &udqp, &gdqp);
> +		error = xfs_qm_vop_dqalloc(ip, from_kuid(&init_user_ns, uid),
> +					   from_kgid(&init_user_ns, gid),
> +					   xfs_get_projid(ip),
> +					   qflags, &udqp, &gdqp);
>  		if (error)
>  			return error;
>  	}
> @@ -561,8 +563,8 @@ xfs_setattr_nonsize(
>  		 * while we didn't have the inode locked, inode's dquot(s)
>  		 * would have changed also.
>  		 */
> -		iuid = ip->i_d.di_uid;
> -		igid = ip->i_d.di_gid;
> +		iuid = make_kuid(&init_user_ns, ip->i_d.di_uid);
> +		igid = make_kgid(&init_user_ns, ip->i_d.di_gid);
>  		gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
>  		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
>  
> @@ -571,8 +573,8 @@ xfs_setattr_nonsize(
>  		 * going to change.
>  		 */
>  		if (XFS_IS_QUOTA_RUNNING(mp) &&
> -		    ((XFS_IS_UQUOTA_ON(mp) && iuid != uid) ||
> -		     (XFS_IS_GQUOTA_ON(mp) && igid != gid))) {
> +		    ((XFS_IS_UQUOTA_ON(mp) && !uid_eq(iuid, uid)) ||
> +		     (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)))) {
>  			ASSERT(tp);
>  			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
>  						capable(CAP_FOWNER) ?
> @@ -602,17 +604,17 @@ xfs_setattr_nonsize(
>  		 * Change the ownerships and register quota modifications
>  		 * in the transaction.
>  		 */
> -		if (iuid != uid) {
> +		if (!uid_eq(iuid, uid)) {
>  			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_UQUOTA_ON(mp)) {
>  				ASSERT(mask & ATTR_UID);
>  				ASSERT(udqp);
>  				olddquot1 = xfs_qm_vop_chown(tp, ip,
>  							&ip->i_udquot, udqp);
>  			}
> -			ip->i_d.di_uid = uid;
> +			ip->i_d.di_uid = from_kuid(&init_user_ns, uid);
>  			inode->i_uid = uid;
>  		}
> -		if (igid != gid) {
> +		if (!gid_eq(igid, gid)) {
>  			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_GQUOTA_ON(mp)) {
>  				ASSERT(!XFS_IS_PQUOTA_ON(mp));
>  				ASSERT(mask & ATTR_GID);
> @@ -620,7 +622,7 @@ xfs_setattr_nonsize(
>  				olddquot2 = xfs_qm_vop_chown(tp, ip,
>  							&ip->i_gdquot, gdqp);
>  			}
> -			ip->i_d.di_gid = gid;
> +			ip->i_d.di_gid = from_kgid(&init_user_ns, gid);
>  			inode->i_gid = gid;
>  		}
>  	}
> @@ -1172,8 +1174,8 @@ xfs_setup_inode(
>  
>  	inode->i_mode	= ip->i_d.di_mode;
>  	set_nlink(inode, ip->i_d.di_nlink);
> -	inode->i_uid	= ip->i_d.di_uid;
> -	inode->i_gid	= ip->i_d.di_gid;
> +	inode->i_uid	= make_kuid(&init_user_ns, ip->i_d.di_uid);
> +	inode->i_gid	= make_kgid(&init_user_ns, ip->i_d.di_gid);
>  
>  	switch (inode->i_mode & S_IFMT) {
>  	case S_IFBLK:
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index b75c9bb..94a2a8f 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1651,8 +1651,8 @@ xfs_qm_write_sb_changes(
>  int
>  xfs_qm_vop_dqalloc(
>  	struct xfs_inode	*ip,
> -	uid_t			uid,
> -	gid_t			gid,
> +	__uint32_t		di_uid,
> +	__uint32_t		di_gid,
>  	prid_t			prid,
>  	uint			flags,
>  	struct xfs_dquot	**O_udqpp,
> @@ -1670,7 +1670,7 @@ xfs_qm_vop_dqalloc(
>  	xfs_ilock(ip, lockflags);
>  
>  	if ((flags & XFS_QMOPT_INHERIT) && XFS_INHERIT_GID(ip))
> -		gid = ip->i_d.di_gid;
> +		di_gid = ip->i_d.di_gid;
>  
>  	/*
>  	 * Attach the dquot(s) to this inode, doing a dquot allocation
> @@ -1686,7 +1686,7 @@ xfs_qm_vop_dqalloc(
>  
>  	uq = gq = NULL;
>  	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
> -		if (ip->i_d.di_uid != uid) {
> +		if (ip->i_d.di_uid != di_uid) {
>  			/*
>  			 * What we need is the dquot that has this uid, and
>  			 * if we send the inode to dqget, the uid of the inode
> @@ -1697,7 +1697,7 @@ xfs_qm_vop_dqalloc(
>  			 * holding ilock.
>  			 */
>  			xfs_iunlock(ip, lockflags);
> -			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t) uid,
> +			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)di_uid,
>  						 XFS_DQ_USER,
>  						 XFS_QMOPT_DQALLOC |
>  						 XFS_QMOPT_DOWARN,
> @@ -1721,9 +1721,9 @@ xfs_qm_vop_dqalloc(
>  		}
>  	}
>  	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
> -		if (ip->i_d.di_gid != gid) {
> +		if (ip->i_d.di_gid != di_gid) {
>  			xfs_iunlock(ip, lockflags);
> -			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)gid,
> +			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)di_gid,
>  						 XFS_DQ_GROUP,
>  						 XFS_QMOPT_DQALLOC |
>  						 XFS_QMOPT_DOWARN,
> @@ -1842,7 +1842,7 @@ xfs_qm_vop_chown_reserve(
>  			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
>  
>  	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
> -	    ip->i_d.di_uid != (uid_t)be32_to_cpu(udqp->q_core.d_id)) {
> +	    ip->i_d.di_uid != be32_to_cpu(udqp->q_core.d_id)) {
>  		delblksudq = udqp;
>  		/*
>  		 * If there are delayed allocation blocks, then we have to
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index c38068f..0464d77 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -320,8 +320,8 @@ extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
>  		struct xfs_mount *, struct xfs_dquot *,
>  		struct xfs_dquot *, long, long, uint);
>  
> -extern int xfs_qm_vop_dqalloc(struct xfs_inode *, uid_t, gid_t, prid_t, uint,
> -		struct xfs_dquot **, struct xfs_dquot **);
> +extern int xfs_qm_vop_dqalloc(struct xfs_inode *, __uint32_t, __uint32_t,
> +		prid_t, uint, struct xfs_dquot **, struct xfs_dquot **);
>  extern void xfs_qm_vop_create_dqattach(struct xfs_trans *, struct xfs_inode *,
>  		struct xfs_dquot *, struct xfs_dquot *);
>  extern int xfs_qm_vop_rename_dqattach(struct xfs_inode **);
> @@ -341,8 +341,9 @@ extern void xfs_qm_unmount_quotas(struct xfs_mount *);
>  
>  #else
>  static inline int
> -xfs_qm_vop_dqalloc(struct xfs_inode *ip, uid_t uid, gid_t gid, prid_t prid,
> -		uint flags, struct xfs_dquot **udqp, struct xfs_dquot **gdqp)
> +xfs_qm_vop_dqalloc(struct xfs_inode *ip, __uint32_t uid, __uint32_t gid,
> +		prid_t prid, uint flags, struct xfs_dquot **udqp,
> +		struct xfs_dquot **gdqp)
>  {
>  	*udqp = NULL;
>  	*gdqp = NULL;
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 195a403..3f7cfb3 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -384,7 +384,9 @@ xfs_symlink(
>  	/*
>  	 * Make sure that we have allocated dquot(s) on disk.
>  	 */
> -	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
> +	error = xfs_qm_vop_dqalloc(dp,
> +			from_kuid(&init_user_ns, current_fsuid()),
> +			from_kgid(&init_user_ns, current_fsgid()), prid,
>  			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
>  	if (error)
>  		goto std_return;
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index 0176bb2..37e9d4a 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -515,7 +515,9 @@ xfs_create(
>  	/*
>  	 * Make sure that we have allocated dquot(s) on disk.
>  	 */
> -	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
> +	error = xfs_qm_vop_dqalloc(dp,
> +			from_kuid(&init_user_ns, current_fsuid()),
> +			from_kgid(&init_user_ns, current_fsgid()), prid,
>  			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
>  	if (error)
>  		return error;
> diff --git a/init/Kconfig b/init/Kconfig
> index 9d3a788..fe29801 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1065,7 +1065,6 @@ config IPC_NS
>  
>  config USER_NS
>  	bool "User namespace"
> -	depends on UIDGID_CONVERTED
>  	select UIDGID_STRICT_TYPE_CHECKS
>  
>  	default n
> @@ -1099,20 +1098,8 @@ config NET_NS
>  
>  endif # NAMESPACES
>  
> -config UIDGID_CONVERTED
> -	# True if all of the selected software conmponents are known
> -	# to have uid_t and gid_t converted to kuid_t and kgid_t
> -	# where appropriate and are otherwise safe to use with
> -	# the user namespace.
> -	bool
> -	default y
> -
> -	# Filesystems
> -	depends on XFS_FS = n
> -
>  config UIDGID_STRICT_TYPE_CHECKS
>  	bool "Require conversions between uid/gids and their internal representation"
> -	depends on UIDGID_CONVERTED
>  	default n
>  	help
>  	 While the nececessary conversions are being added to all subsystems this option allows

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
