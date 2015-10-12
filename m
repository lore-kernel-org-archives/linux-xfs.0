Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9FBB07F59
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 20:51:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1E011AC001
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 18:51:20 -0700 (PDT)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
	[209.85.212.180]) by cuda.sgi.com with ESMTP id
	cBgc8OF6jcAcKYWy (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 11 Oct 2015 18:51:16 -0700 (PDT)
Received: by wicgb1 with SMTP id gb1so32857594wic.1
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 18:51:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151012001033.GA27164@dastard>
References: <1444604337-17651-1-git-send-email-andreas.gruenbacher@gmail.com>
	<1444604337-17651-25-git-send-email-andreas.gruenbacher@gmail.com>
	<20151012001033.GA27164@dastard>
Date: Mon, 12 Oct 2015 03:51:15 +0200
Message-ID: <CAHpGcMKeJHDegs2cYKaJdX4Tw43Jp30Nv_2WoSNZfBzGJKu=BQ@mail.gmail.com>
Subject: Re: [PATCH v10 24/46] xfs: Add richacl support
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
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
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, Linux API Mailing List <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

2015-10-12 2:10 GMT+02:00 Dave Chinner <david@fromorbit.com>:
> On Mon, Oct 12, 2015 at 12:58:35AM +0200, Andreas Gruenbacher wrote:
>> diff --git a/fs/ext4/richacl.h b/fs/ext4/richacl.h
>> index fc7826f..f26fbdd 100644
>> --- a/fs/ext4/richacl.h
>> +++ b/fs/ext4/richacl.h
>> @@ -24,7 +24,6 @@
>>
>>  extern struct richacl *ext4_get_richacl(struct inode *);
>>  extern int ext4_set_richacl(struct inode *, struct richacl *);
>> -
>>  extern int ext4_init_richacl(handle_t *, struct inode *, struct inode *);
>>
>>  #else  /* CONFIG_EXT4_FS_RICHACL */
>
> stray hunk.

Oops, thanks.

>> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
>> index 5d47b4d..05dd312 100644
>> --- a/fs/xfs/Kconfig
>> +++ b/fs/xfs/Kconfig
>> @@ -52,6 +52,17 @@ config XFS_POSIX_ACL
>>
>>         If you don't know what Access Control Lists are, say N.
>>
>> +config XFS_RICHACL
>> +        bool "XFS Rich Access Control Lists (EXPERIMENTAL)"
>> +        depends on XFS_FS
>> +        select FS_RICHACL
>> +        help
>> +          Richacls are an implementation of NFSv4 ACLs, extended by file masks
>> +          to cleanly integrate into the POSIX file permission model.  To learn
>> +       more about them, see http://www.bestbits.at/richacl/.
>> +
>> +          If you don't know what Richacls are, say N.
>> +
>
> So now we have multiple compile time ACL configs that we have to
> test. Personally, I see no reason for making either posix or rich
> acls compile time dependent. How about we just change CONFIG_FS_XFS
> to have "select FS_POSIX_ACL" and "select FS_RICHACL"
> unconditionally, and then we can get rid of all the conditional
> code?

I'm sure neither kind of ACLs makes sense on many tiny systems, it
should be possible to disable them. XFS may not make sense on those
kinds of systems either, that is not my call to make though.

>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index 9590a06..8c6da45 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -461,10 +461,18 @@ xfs_sb_has_ro_compat_feature(
>>  #define XFS_SB_FEAT_INCOMPAT_FTYPE   (1 << 0)        /* filetype in dirent */
>>  #define XFS_SB_FEAT_INCOMPAT_SPINODES        (1 << 1)        /* sparse inode chunks */
>>  #define XFS_SB_FEAT_INCOMPAT_META_UUID       (1 << 2)        /* metadata UUID */
>> +
>> +#ifdef CONFIG_XFS_RICHACL
>> +#define XFS_SB_FEAT_INCOMPAT_RICHACL (1 << 3)        /* richacls */
>> +#else
>> +#define XFS_SB_FEAT_INCOMPAT_RICHACL 0
>> +#endif
>> +
>
> Regardless of whether we build in richacl support, this is wrong.
> Feature bits are on-disk format definitions, so it will always have
> this value whether or not the kernel supports the feature.

This is so that xfs_mount_validate_sb() will complain when mounting a
richacl filesystem on a kernel which doesn't have richacl suport
compiled in. The same effect can be had with extra code there of
course.

>> @@ -722,7 +737,10 @@ xfs_setattr_nonsize(
>>        *           Posix ACL code seems to care about this issue either.
>>        */
>>       if ((mask & ATTR_MODE) && !(flags & XFS_ATTR_NOACL)) {
>> -             error = posix_acl_chmod(inode, inode->i_mode);
>> +             if (XFS_IS_RICHACL(inode))
>> +                     error = richacl_chmod(inode, inode->i_mode);
>> +             else
>> +                     error = posix_acl_chmod(inode, inode->i_mode);
>>               if (error)
>>                       return error;
>>       }
>
> This sort of thing could do with a helper like:
>
> static inline int
> xfs_acl_chmod(struct inode *inode, int mode)
> {
>         if (IS_RICHACL(inode))
>                 return richacl_chmod(inode, mode);
>         return posix_acl_chmod(inode, mode);
> }

Alright.

>> +#include "xfs.h"
>> +#include "xfs_format.h"
>> +#include "xfs_log_format.h"
>> +#include "xfs_inode.h"
>> +#include "xfs_attr.h"
>> +
>> +#include <linux/richacl_xattr.h>
>> +
>> +struct richacl *
>> +xfs_get_richacl(struct inode *inode)
>> +{
>
> ...
>
> If we always build in ACL support, this can all go in xfs_acl.c.
>
>> +     struct xfs_inode *ip = XFS_I(inode);
>> +     struct richacl *acl;
>> +     int size = XATTR_SIZE_MAX;
>> +     void *value;
>> +     int error;
>> +
>> +     value = kmem_zalloc_large(size, KM_SLEEP);
>> +     if (!value)
>> +             return ERR_PTR(-ENOMEM);
>> +
>> +     error = xfs_attr_get(ip, XATTR_NAME_RICHACL, value, &size, ATTR_ROOT);
>> +     if (error) {
>> +             /*
>> +              * If the attribute doesn't exist make sure we have a negative
>> +              * cache entry, for any other error assume it is transient and
>> +              * leave the cache entry as ACL_NOT_CACHED.
>> +              */
>> +             acl = (error == -ENOATTR) ? NULL : ERR_PTR(error);
>
> I rather dislike ternaries in code like this - it's hard to read the
> logic. Initalise acl to NULL, and then this simply becomes:
>
>                 if (error != -ENOATTR)
>                         acl = ERR_PTR(error);

As you prefer.

>> +     } else
>> +             acl = richacl_from_xattr(&init_user_ns, value, size);
>> +
>> +     if (!IS_ERR(acl))
>> +             set_cached_richacl(inode, acl);
>> +     kfree(value);
>> +
>> +     return acl;
>> +}
>> +
>> +int
>> +xfs_set_richacl(struct inode *inode, struct richacl *acl)
>> +{
>> +     struct xfs_inode *ip = XFS_I(inode);
>> +     umode_t mode = inode->i_mode;
>> +     int error;
>> +
>> +     if (acl) {
>> +             /* Don't allow acls with unmapped identifiers. */
>> +             if (richacl_has_unmapped_identifiers(acl))
>> +                     return -EINVAL;
>> +
>> +             if (richacl_equiv_mode(acl, &mode) == 0) {
>> +                     xfs_set_mode(inode, mode);
>> +                     acl = NULL;
>> +             }
>
> Comment needed here - why does this now seem to accidentally fall
> through to removing the ACL?

Setting an ACL that is equivalent to a file mode is the same as
removing any existing ACLs and doing a chmod to that equivalent file
mode. It's the sams as with POSIX ACLs, and the code is the same as
well. I'll add a comment though.

> Also, why is this in the XFS specific
> code when it's generic richacl functionality that is being checked?

This turns into two non-atomic operations if we move it into generic code.

> Also, I really dislike the API where passing a NULL acl means to
> "set this acl" actually means "remove the existing ACL". Why no
> ->remove_acl method called from the generic code?

It's not uncommon, it saves inode operations and wiring-up code.

>> +#ifndef __FS_XFS_RICHACL_H
>> +#define __FS_XFS_RICHACL_H
>> +
>> +#include <linux/richacl.h>
>> +
>> +#ifdef CONFIG_XFS_RICHACL
>> +
>> +#define XFS_IS_RICHACL(inode) IS_RICHACL(inode)
>
> No. Just use IS_RICHACL() everywhere, and whatever build
> conditional that uses.

Okay.

>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -1500,7 +1500,19 @@ xfs_fs_fill_super(
>>       sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
>>       sb->s_max_links = XFS_MAXLINK;
>>       sb->s_time_gran = 1;
>> -     set_posix_acl_flag(sb);
>> +
>> +     if (xfs_sb_version_hasrichacl(&mp->m_sb)) {
>> +#ifdef CONFIG_XFS_RICHACL
>> +             sb->s_flags |= MS_RICHACL;
>> +#else
>> +             error = -EOPNOTSUPP;
>> +             goto out_free_sb;
>> +#endif
>> +     } else {
>> +#ifdef CONFIG_XFS_POSIX_ACL
>> +             sb->s_flags |= MS_POSIXACL;
>> +#endif
>
> The whole point of having set_posix_acl_flag() is that it keeps
> the ifdef hackery out of the code. If we are going to keep build
> time config options for these, then please keep the wrappers to hide
> this mess...

That can indeed go away since xfs_mount_validate_sb() checks the mount
flags already.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
