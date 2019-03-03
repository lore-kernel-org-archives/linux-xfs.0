Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:24320 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726639AbfCCVxk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Mar 2019 16:53:40 -0500
Date: Mon, 4 Mar 2019 08:53:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/8] fs: add support to change project ID
Message-ID: <20190303215335.GQ23020@dastard>
References: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
 <1551449141-7884-2-git-send-email-wshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551449141-7884-2-git-send-email-wshilong1991@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>

On Fri, Mar 01, 2019 at 11:05:34PM +0900, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> From: Wang Shilong <wshilong@ddn.com>
> 
> Currently, Filesystem use FS_IOC_FS_SETXATTR ioctl
> to change project ID of file. However we don't
> support ioctl on symlink files, and it is desirable
> to change symlink files' project ID just like uid/gid.
> 
> This patch try to reuse existed interface fchownat(),
> use group id to set project ID if flag AT_FCHOWN_PROJID
> passed in.
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
>  fs/attr.c                        | 26 ++++++++++++++++++++++++--
>  fs/open.c                        | 29 +++++++++++++++++++++++------
>  fs/quota/dquot.c                 | 23 +++++++++++++++++++++++
>  include/linux/fs.h               |  3 +++
>  include/linux/quotaops.h         |  9 +++++++++
>  include/uapi/linux/fcntl.h       |  1 +
>  tools/include/uapi/linux/fcntl.h |  1 +
>  7 files changed, 84 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/attr.c b/fs/attr.c
> index d22e8187477f..c6b1c1132c8f 100644
> --- a/fs/attr.c
> +++ b/fs/attr.c
> @@ -85,6 +85,28 @@ int setattr_prepare(struct dentry *dentry, struct iattr *attr)
>  	if ((ia_valid & ATTR_GID) && !chgrp_ok(inode, attr->ia_gid))
>  		return -EPERM;
>  
> +	/*
> +	 * Project Quota ID state is only allowed to change from within the init
> +	 * namespace. Enforce that restriction only if we are trying to change
> +	 * the quota ID state. Everything else is allowed in user namespaces.
> +	 */
> +	if ((ia_valid & ATTR_PROJID) && current_user_ns() != &init_user_ns) {
> +		kprojid_t projid;
> +		int rc;
> +
> +		/*
> +		 * Filesystem like xfs does't have ->get_projid hook
> +		 * should check permission by themselves.
> +		 */
> +		if (inode->i_sb->dq_op->get_projid) {
> +			rc = inode->i_sb->dq_op->get_projid(inode, &projid);
> +			if (rc)
> +				return rc;
> +			if (!projid_eq(projid, attr->ia_projid))
> +				return -EPERM;
> +		}
> +	}

That's a nasty landmine, and we shouldn't be making exceptions like
this in generic code.  And, really, it makes no sense to me to be
checking if the projid is changing, either. If ATTR_PROJID is set,
and we aren't in the init_user_ns then reject it.

i.e. Callers should not set ATTR_PROJID if they aren't changing it,
not expect the infrastructure to silently ignore attempts to change
attributes they do not have permission to change when no change will
eventually occur.


>  	/* Make sure a caller can chmod. */
>  	if (ia_valid & ATTR_MODE) {
>  		if (!inode_owner_or_capable(inode))
> @@ -232,8 +254,8 @@ int notify_change(struct dentry * dentry, struct iattr * attr, struct inode **de
>  	unsigned int ia_valid = attr->ia_valid;
>  
>  	WARN_ON_ONCE(!inode_is_locked(inode));
> -
> -	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_TIMES_SET)) {
> +	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_PROJID |
> +			ATTR_TIMES_SET)) {
>  		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>  			return -EPERM;
>  	}
> diff --git a/fs/open.c b/fs/open.c
> index 0285ce7dbd51..4e58c6ee23b3 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -597,7 +597,8 @@ SYSCALL_DEFINE2(chmod, const char __user *, filename, umode_t, mode)
>  	return do_fchmodat(AT_FDCWD, filename, mode);
>  }
>  
> -static int chown_common(const struct path *path, uid_t user, gid_t group)
> +static int chown_common(const struct path *path, uid_t user, gid_t group,
> +			bool set_project)

Why not just pass the projid? This bleeds API definition into the
implementation. chown_common() shoul dbe able toset all three IDs in
one call as it is not restricted by the chownat() userspace API.
i.e.:

static int chown_common(const struct path *path, uid_t user, gid_t group, projid_t project)

and the IDs that aren't getting set should be passed with the value
of -1.

>  {
>  	struct inode *inode = path->dentry->d_inode;
>  	struct inode *delegated_inode = NULL;
> @@ -605,9 +606,11 @@ static int chown_common(const struct path *path, uid_t user, gid_t group)
>  	struct iattr newattrs;
>  	kuid_t uid;
>  	kgid_t gid;
> +	kprojid_t projid;
>  
>  	uid = make_kuid(current_user_ns(), user);
>  	gid = make_kgid(current_user_ns(), group);
> +	projid = make_kprojid(current_user_ns(), (projid_t)group);

This doesn't look right. project IDs are not to be mapped to the
current_user_ns - they should only be visible to the init_user_ns.

>  retry_deleg:
>  	newattrs.ia_valid =  ATTR_CTIME;
> @@ -620,13 +623,22 @@ static int chown_common(const struct path *path, uid_t user, gid_t group)
>  	if (group != (gid_t) -1) {
>  		if (!gid_valid(gid))
>  			return -EINVAL;
> -		newattrs.ia_valid |= ATTR_GID;
> -		newattrs.ia_gid = gid;
> +		if (!set_project) {
> +			newattrs.ia_valid |= ATTR_GID;
> +			newattrs.ia_gid = gid;
> +		} else {
> +			newattrs.ia_valid |= ATTR_PROJID;
> +			newattrs.ia_projid = projid;
> +		}
> +	} else if (set_project) {
> +		return -EINVAL;
>  	}
>  	if (!S_ISDIR(inode->i_mode))
>  		newattrs.ia_valid |=
>  			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
>  	inode_lock(inode);
> +	if (set_project)
> +		gid = make_kgid(current_user_ns(), (gid_t) -1);

This is cumbersome because you didn't pass the project ID as it's
own type. it also removes the gid_valid() check. Leave the group
code alone, then add:

	if (projid != (projid_t)-1) {
		if (current_user_ns() != &init_user_ns)
			return -EPERM;
		newattrs.ia_projid = make_kprojid(&init_user_ns, projid);
		if (!projid_valid(newattrs.ia_projid))
			return -EINVAL;
		newattrs.ia_valid |= ATTR_PROJID;
	}

This way callers of chown_common() can set all three types in one
call if need be.

>  	error = security_path_chown(path, uid, gid);
>  	if (!error)
>  		error = notify_change(path->dentry, &newattrs, &delegated_inode);
> @@ -645,10 +657,15 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
>  	struct path path;
>  	int error = -EINVAL;
>  	int lookup_flags;
> +	bool set_project = false;
>  
> -	if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
> +	if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH |
> +		      AT_FCHOWN_PROJID)) != 0)
>  		goto out;
>  
> +	if (flag & AT_FCHOWN_PROJID)
> +		set_project = true;
> +
>  	lookup_flags = (flag & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
>  	if (flag & AT_EMPTY_PATH)
>  		lookup_flags |= LOOKUP_EMPTY;
> @@ -659,7 +676,7 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
>  	error = mnt_want_write(path.mnt);
>  	if (error)
>  		goto out_release;
> -	error = chown_common(&path, user, group);
> +	error = chown_common(&path, user, group, set_project);
>  	mnt_drop_write(path.mnt);

	/*
	 * If the project ID flag is set, the group field contains the
	 * Project ID, not a Group ID.
	 */
	if (flag & AT_FCHOWN_PROJID)
		error = chown_common(&path, user, -1, group);
	else
		error = chown_common(&path, user, group, -1);

>  out_release:
>  	path_put(&path);
> @@ -700,7 +717,7 @@ int ksys_fchown(unsigned int fd, uid_t user, gid_t group)
>  	if (error)
>  		goto out_fput;
>  	audit_file(f.file);
> -	error = chown_common(&f.file->f_path, user, group);
> +	error = chown_common(&f.file->f_path, user, group, false);

	error = chown_common(&f.file->f_path, user, group, -1);

>  	mnt_drop_write_file(f.file);
>  out_fput:
>  	fdput(f);
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index fc20e06c56ba..46f39ee87312 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -2095,6 +2095,29 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
>  		}
>  		transfer_to[GRPQUOTA] = dquot;
>  	}
> +
> +	if (iattr->ia_valid & ATTR_PROJID) {
> +		kprojid_t projid;
> +
> +		if (!inode->i_sb->dq_op->get_projid)
> +			return -ENOTSUPP;
> +
> +		ret = inode->i_sb->dq_op->get_projid(inode, &projid);
> +		if (ret)
> +			return ret;
> +		if (!projid_eq(iattr->ia_projid, projid)) {
> +			dquot = dqget(sb, make_kqid_projid(iattr->ia_projid));
> +			if (IS_ERR(dquot)) {
> +				if (PTR_ERR(dquot) != -ESRCH) {
> +					ret = PTR_ERR(dquot);
> +					goto out_put;
> +				}
> +				dquot = NULL;
> +			}
> +			transfer_to[PRJQUOTA] = dquot;
> +		}
> +	}
> +
>  	ret = __dquot_transfer(inode, transfer_to);

OK, no I see why this is such a mess. There's no project ID field
in the struct inode, which would get rid of the need to call
get_projid() to extract it from the inode quota interface.

Ok, I think this patch needs to be split up into system call
functionality and quota infrastructure, rather than dumping them
into the same patch. That way we can discuss them separately, and
have the conversion of whether we shoul dbemaking the project ID a
member of struct inode or not to simplify this code.

> diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
> index dc905a4ff8d7..84d3aeb43e2c 100644
> --- a/include/linux/quotaops.h
> +++ b/include/linux/quotaops.h
> @@ -22,6 +22,15 @@ static inline struct quota_info *sb_dqopt(struct super_block *sb)
>  /* i_mutex must being held */
>  static inline bool is_quota_modification(struct inode *inode, struct iattr *ia)
>  {
> +	if (ia->ia_valid & ATTR_PROJID && inode->i_sb->dq_op->get_projid) {
> +		kprojid_t projid;
> +		int rc;
> +
> +		rc = inode->i_sb->dq_op->get_projid(inode, &projid);
> +		if (!rc && !projid_eq(projid, ia->ia_projid))
> +			return true;
> +	}
> +
>  	return (ia->ia_valid & ATTR_SIZE && ia->ia_size != inode->i_size) ||
>  		(ia->ia_valid & ATTR_UID && !uid_eq(ia->ia_uid, inode->i_uid)) ||
>  		(ia->ia_valid & ATTR_GID && !gid_eq(ia->ia_gid, inode->i_gid));

Because the same issues keep coming up....

> diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
> index 6448cdd9a350..712c60d7f727 100644
> --- a/include/uapi/linux/fcntl.h
> +++ b/include/uapi/linux/fcntl.h
> @@ -90,5 +90,6 @@
>  #define AT_STATX_FORCE_SYNC	0x2000	/* - Force the attributes to be sync'd with the server */
>  #define AT_STATX_DONT_SYNC	0x4000	/* - Don't sync attributes with the server */
>  
> +#define AT_FCHOWN_PROJID	0x40000000 /* Change project ID instead of group id */
>  
>  #endif /* _UAPI_LINUX_FCNTL_H */
> diff --git a/tools/include/uapi/linux/fcntl.h b/tools/include/uapi/linux/fcntl.h
> index 6448cdd9a350..712c60d7f727 100644
> --- a/tools/include/uapi/linux/fcntl.h
> +++ b/tools/include/uapi/linux/fcntl.h
> @@ -90,5 +90,6 @@
>  #define AT_STATX_FORCE_SYNC	0x2000	/* - Force the attributes to be sync'd with the server */
>  #define AT_STATX_DONT_SYNC	0x4000	/* - Don't sync attributes with the server */
>  
> +#define AT_FCHOWN_PROJID	0x40000000 /* Change project ID instead of group id */

What is the significance of this number? Why not just the next
highest flag bit in the sequence (i.e. 0x8000)?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
