Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0CF3A7F4E
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 11:49:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F09698F8035
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 09:49:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HwHHB5C4hLU3MfHn for
	<xfs@oss.sgi.com>; Tue, 25 Jun 2013 09:49:26 -0700 (PDT)
Message-ID: <51C9C95B.30909@redhat.com>
Date: Tue, 25 Jun 2013 12:46:19 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 RFC] userns: Convert xfs to use kuid/kgid where
	appropriate
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com>
In-Reply-To: <20130624091035.6274800f@oracle.com>
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
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, xfs@oss.sgi.com

On 06/24/2013 09:10 AM, Dwight Engen wrote:
> Hi Dave, all. Here is a v2 patch that I believe addresses the previous
> comments, but I expect there to be more :) I think there are a few
> more issues to sort out before this is ready, and I want to add some
> tests to xfstests also.
> 
> I added permission checks for eofblocks in the ioctl code, but
> I don't think they are enough. Just because an unprivileged
> caller is in a group doesn't mean he can write to a file of that group,
> and I don't know how we can check for that till we get the inode in
> hand. Brian, if you or anyone else could comment on how this should work
> for the regular user and write() ENOSPC cases that'd be great.
> 

Hi Dwight,

Fair point with regard to the group. On one hand, we aren't exactly
writing to the file and from the perspective of the fs, we'd like the
ability for a user covered under a group quota to have the ability to
manage inodes covered under said quota. On the other hand, from a
userspace perspective it could imply a strange
incarnation/interpretation(/abuse) of file permissions. I'll have to
think about this some more.

Before getting too far into the code, could we break this down into
smaller, independent patches? This is starting to include logically
independent changes, and on first glance, it appears even the eofblocks
stuff could be broken down into multiple patches (i.e., the introduction
of a new structure should be its own patch, etc.). But more on that to
follow...

> The xfs code now uses inode->i_uid where possible instead of di_uid.
> The remaining uses of di_uid are where the inode is being setup,
> conversion to/from disk endianess, in dealing with quotas, and bulkstat.
> 
> We do need to decide on the di_uid that comes back from bulkstat.
> Right now it is returning on disk (== init_user_ns) uids. It looks to
> me like xfsrestore is using the normal vfs routines (chown, fchown,
> lchown) when restoring so that won't line up if the xfsrestore is run
> in !init_user_ns. We could possibly convert to userns values
> before returning them from the kernel, but I doubt that will work
> well with the xfs quotas. Should we just require that callers of bulkstat
> be in init_user_ns? Thoughts?
> 
> 
> --
> 
> Use uint32 from init_user_ns for xfs internal uid/gid representation in
> acl, xfs_icdinode, xfs_dqid_t. Conversion of kuid/gid is done for these
> structures and for the eofblocks filter. Other user visible xfs specific
> interfaces (bulkstat) expect uint32 init_user_ns uid/gid values.
> 
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> ---
>  fs/xfs/xfs_acl.c      | 20 ++++++++++++++++----
>  fs/xfs/xfs_fs.h       |  2 +-
>  fs/xfs/xfs_icache.c   |  6 +++---
>  fs/xfs/xfs_inode.c    |  6 +++---
>  fs/xfs/xfs_ioctl.c    | 37 ++++++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_iops.c     | 38 ++++++++++++++++++++------------------
>  fs/xfs/xfs_linux.h    | 35 +++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_qm.c       | 10 +++++-----
>  fs/xfs/xfs_quota.h    |  9 +++++----
>  fs/xfs/xfs_symlink.c  |  4 +++-
>  fs/xfs/xfs_vnodeops.c |  4 +++-
>  init/Kconfig          | 15 +--------------
>  12 files changed, 129 insertions(+), 57 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index d046955..6bc3da4 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -344,7 +344,7 @@ typedef struct xfs_error_injection {
>   * Speculative preallocation trimming.
>   */
>  #define XFS_EOFBLOCKS_VERSION		1
> -struct xfs_eofblocks {
> +struct xfs_ueofblocks {

We probably don't want to go and change the name of the structure
exported to userspace. This was intentionally named with the
understanding that it's user facing. If anything, I'd say leave this and
use a different name for the internal version.

FWIW, I already have some patches that create an internal version of
xfs_eofblocks for a separate purpose (adding a new internal only field).
As is, it might not completely meet the use case here, but I'm wondering
if we should combine some efforts here...

>  	__u32		eof_version;
>  	__u32		eof_flags;
>  	uid_t		eof_uid;
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 96e344e..2c35b13 100644
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
> @@ -1202,11 +1202,11 @@ xfs_inode_match_id(
>  	struct xfs_eofblocks	*eofb)
>  {
>  	if (eofb->eof_flags & XFS_EOF_FLAGS_UID &&
> -	    ip->i_d.di_uid != eofb->eof_uid)
> +	    !uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
>  		return 0;
>  
>  	if (eofb->eof_flags & XFS_EOF_FLAGS_GID &&
> -	    ip->i_d.di_gid != eofb->eof_gid)
> +	    !gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))

More of a question... since we're originally comparing against the
on-disk values, is the separate internal structure strictly necessary
for making eofblocks userns aware?

>  		return 0;
>  
>  	if (eofb->eof_flags & XFS_EOF_FLAGS_PRID &&
...
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 5e99968..d6e64d9 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
...
> @@ -1610,7 +1610,8 @@ xfs_file_ioctl(
>  		return -error;
>  
>  	case XFS_IOC_FREE_EOFBLOCKS: {
> -		struct xfs_eofblocks eofb;
> +		struct xfs_ueofblocks eofb;
> +		struct xfs_eofblocks keofb;
>  
>  		if (copy_from_user(&eofb, arg, sizeof(eofb)))
>  			return -XFS_ERROR(EFAULT);
> @@ -1625,7 +1626,37 @@ xfs_file_ioctl(
>  		    memchr_inv(eofb.pad64, 0, sizeof(eofb.pad64)))
>  			return -XFS_ERROR(EINVAL);
>  
> -		error = xfs_icache_free_eofblocks(mp, &eofb);
> +		keofb.eof_version = eofb.eof_version;
> +		keofb.eof_flags = eofb.eof_flags;
> +		keofb.eof_prid = eofb.eof_prid;
> +		keofb.eof_min_file_size = eofb.eof_min_file_size;
> +

A conversion helper would be nice here. I'd probably just convert all of
the fields and then reduce the following EINVAL bits to pure
permission/sanity checks.

> +		if (eofb.eof_flags & XFS_EOF_FLAGS_UID) {
> +			keofb.eof_uid = make_kuid(current_user_ns(), eofb.eof_uid);
> +			if (!uid_valid(keofb.eof_uid))
> +				return -XFS_ERROR(EINVAL);
> +		}
> +
> +		if (eofb.eof_flags & XFS_EOF_FLAGS_GID) {
> +			keofb.eof_gid = make_kgid(current_user_ns(), eofb.eof_gid);
> +			if (!gid_valid(keofb.eof_gid))
> +				return -XFS_ERROR(EINVAL);
> +		}
> +
> +		if (!capable(CAP_SYS_ADMIN)) {
> +			if (!(eofb.eof_flags & (XFS_EOF_FLAGS_UID | XFS_EOF_FLAGS_GID)))
> +				return -XFS_ERROR(EPERM);
> +
> +			if ((eofb.eof_flags & XFS_EOF_FLAGS_UID) &&
> +			    !uid_eq(current_fsuid(), keofb.eof_uid))
> +				return -XFS_ERROR(EPERM);
> +
> +			if ((eofb.eof_flags & XFS_EOF_FLAGS_GID) &&
> +			    !in_group_p(keofb.eof_gid))
> +				return -XFS_ERROR(EPERM);
> +		}

A comment above this hunk to describe what we decide to enforce here and
why will probably be helpful. ;) Otherwise, the checks seem reasonable
to me, notwithstanding the open question you called out in the commit
log description. FWIW, this particular EPERM check should probably stand
on its own as an independent patch.

> +
> +		error = xfs_icache_free_eofblocks(mp, &keofb);
>  		return -error;
>  	}
>  
...
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 800f896..80326da 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -159,6 +159,41 @@
>  #define MAX(a,b)	(max(a,b))
>  #define howmany(x, y)	(((x)+((y)-1))/(y))
>  
...
> +
> +struct xfs_eofblocks {
> +	__u32		eof_version;
> +	__u32		eof_flags;
> +	kuid_t		eof_uid;
> +	kgid_t		eof_gid;
> +	prid_t		eof_prid;
> +	__u64		eof_min_file_size;
> +};
> +

This should probably go into xfs_icache.h along with the aforementioned
conversion helper.

As I mentioned previously, I have some code around that creates an
internal version of the eofblocks structure. The main differences are
the name (xfs_eofblocks_internal) and I did the conversion down in
xfs_icache.c since I wasn't changing anything that affected the ioctl().

I can throw it up on the list for reference or if it's of any use as a
base for this work...

Brian

>  /*
>   * Various platform dependent calls that don't fit anywhere else
>   */
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index b75c9bb..57e2c18 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1651,8 +1651,8 @@ xfs_qm_write_sb_changes(
>  int
>  xfs_qm_vop_dqalloc(
>  	struct xfs_inode	*ip,
> -	uid_t			uid,
> -	gid_t			gid,
> +	xfs_dqid_t		uid,
> +	xfs_dqid_t		gid,
>  	prid_t			prid,
>  	uint			flags,
>  	struct xfs_dquot	**O_udqpp,
> @@ -1697,7 +1697,7 @@ xfs_qm_vop_dqalloc(
>  			 * holding ilock.
>  			 */
>  			xfs_iunlock(ip, lockflags);
> -			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t) uid,
> +			if ((error = xfs_qm_dqget(mp, NULL, uid,
>  						 XFS_DQ_USER,
>  						 XFS_QMOPT_DQALLOC |
>  						 XFS_QMOPT_DOWARN,
> @@ -1723,7 +1723,7 @@ xfs_qm_vop_dqalloc(
>  	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
>  		if (ip->i_d.di_gid != gid) {
>  			xfs_iunlock(ip, lockflags);
> -			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)gid,
> +			if ((error = xfs_qm_dqget(mp, NULL, gid,
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
> index c38068f..5f0bfe8 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -320,8 +320,8 @@ extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
>  		struct xfs_mount *, struct xfs_dquot *,
>  		struct xfs_dquot *, long, long, uint);
>  
> -extern int xfs_qm_vop_dqalloc(struct xfs_inode *, uid_t, gid_t, prid_t, uint,
> -		struct xfs_dquot **, struct xfs_dquot **);
> +extern int xfs_qm_vop_dqalloc(struct xfs_inode *, xfs_dqid_t, xfs_dqid_t,
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
> +xfs_qm_vop_dqalloc(struct xfs_inode *ip, xfs_dqid_t uid, xfs_dqid_t gid,
> +		prid_t prid, uint flags, struct xfs_dquot **udqp,
> +		struct xfs_dquot **gdqp)
>  {
>  	*udqp = NULL;
>  	*gdqp = NULL;
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 195a403..c50306e 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -384,7 +384,9 @@ xfs_symlink(
>  	/*
>  	 * Make sure that we have allocated dquot(s) on disk.
>  	 */
> -	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
> +	error = xfs_qm_vop_dqalloc(dp,
> +			xfs_kuid_to_disk(current_fsuid()),
> +			xfs_kgid_to_disk(current_fsgid()), prid,
>  			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
>  	if (error)
>  		goto std_return;
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index 0176bb2..94f4f9f6 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -515,7 +515,9 @@ xfs_create(
>  	/*
>  	 * Make sure that we have allocated dquot(s) on disk.
>  	 */
> -	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
> +	error = xfs_qm_vop_dqalloc(dp,
> +			xfs_kuid_to_disk(current_fsuid()),
> +			xfs_kgid_to_disk(current_fsgid()), prid,
>  			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT, &udqp, &gdqp);
>  	if (error)
>  		return error;
> diff --git a/init/Kconfig b/init/Kconfig
> index 9d3a788..8083ffd 100644
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
> @@ -1099,21 +1098,9 @@ config NET_NS
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
> -	default n
> +	default y
>  	help
>  	 While the nececessary conversions are being added to all subsystems this option allows
>  	 the code to continue to build for unconverted subsystems.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
