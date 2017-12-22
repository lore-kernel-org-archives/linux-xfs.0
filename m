Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38267 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756776AbdLVXOj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Dec 2017 18:14:39 -0500
From: NeilBrown <neil@brown.name>
Date: Sat, 23 Dec 2017 10:14:18 +1100
Subject: Re: [PATCH v4 01/19] fs: new API for handling inode->i_version
In-Reply-To: <20171222120556.7435-2-jlayton@kernel.org>
References: <20171222120556.7435-1-jlayton@kernel.org> <20171222120556.7435-2-jlayton@kernel.org>
Message-ID: <87zi6a73ud.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 22 2017, Jeff Layton wrote:

> From: Jeff Layton <jlayton@redhat.com>
>
> Add a documentation blob that explains what the i_version field is, how
> it is expected to work, and how it is currently implemented by various
> filesystems.
>
> We already have inode_inc_iversion. Add several other functions for
> manipulating and accessing the i_version counter. For now, the
> implementation is trivial and basically works the way that all of the
> open-coded i_version accesses work today.
>
> Future patches will convert existing users of i_version to use the new
> API, and then convert the backend implementation to do things more
> efficiently.
>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/btrfs/file.c          |   1 +
>  fs/btrfs/inode.c         |   1 +
>  fs/btrfs/ioctl.c         |   1 +
>  fs/btrfs/xattr.c         |   1 +
>  fs/ext4/inode.c          |   1 +
>  fs/ext4/namei.c          |   1 +
>  fs/inode.c               |   1 +
>  include/linux/fs.h       |  15 ----
>  include/linux/iversion.h | 205 +++++++++++++++++++++++++++++++++++++++++=
++++++
>  9 files changed, 212 insertions(+), 15 deletions(-)
>  create mode 100644 include/linux/iversion.h
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index eb1bac7c8553..c95d7b2efefb 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -31,6 +31,7 @@
>  #include <linux/slab.h>
>  #include <linux/btrfs.h>
>  #include <linux/uio.h>
> +#include <linux/iversion.h>
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "transaction.h"
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e1a7f3cb5be9..27f008b33fc1 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -43,6 +43,7 @@
>  #include <linux/posix_acl_xattr.h>
>  #include <linux/uio.h>
>  #include <linux/magic.h>
> +#include <linux/iversion.h>
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "transaction.h"
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 2ef8acaac688..aa452c9e2eff 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -43,6 +43,7 @@
>  #include <linux/uuid.h>
>  #include <linux/btrfs.h>
>  #include <linux/uaccess.h>
> +#include <linux/iversion.h>
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "transaction.h"
> diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
> index 2c7e53f9ff1b..5258c1714830 100644
> --- a/fs/btrfs/xattr.c
> +++ b/fs/btrfs/xattr.c
> @@ -23,6 +23,7 @@
>  #include <linux/xattr.h>
>  #include <linux/security.h>
>  #include <linux/posix_acl_xattr.h>
> +#include <linux/iversion.h>
>  #include "ctree.h"
>  #include "btrfs_inode.h"
>  #include "transaction.h"
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 7df2c5644e59..fa5d8bc52d2d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -39,6 +39,7 @@
>  #include <linux/slab.h>
>  #include <linux/bitops.h>
>  #include <linux/iomap.h>
> +#include <linux/iversion.h>
>=20=20
>  #include "ext4_jbd2.h"
>  #include "xattr.h"
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 798b3ac680db..bcf0dff517be 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -34,6 +34,7 @@
>  #include <linux/quotaops.h>
>  #include <linux/buffer_head.h>
>  #include <linux/bio.h>
> +#include <linux/iversion.h>
>  #include "ext4.h"
>  #include "ext4_jbd2.h"
>=20=20
> diff --git a/fs/inode.c b/fs/inode.c
> index 03102d6ef044..19e72f500f71 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -18,6 +18,7 @@
>  #include <linux/buffer_head.h> /* for inode_has_buffers */
>  #include <linux/ratelimit.h>
>  #include <linux/list_lru.h>
> +#include <linux/iversion.h>
>  #include <trace/events/writeback.h>
>  #include "internal.h"
>=20=20
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 511fbaabf624..76382c24e9d0 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2036,21 +2036,6 @@ static inline void inode_dec_link_count(struct ino=
de *inode)
>  	mark_inode_dirty(inode);
>  }
>=20=20
> -/**
> - * inode_inc_iversion - increments i_version
> - * @inode: inode that need to be updated
> - *
> - * Every time the inode is modified, the i_version field will be increme=
nted.
> - * The filesystem has to be mounted with i_version flag
> - */
> -
> -static inline void inode_inc_iversion(struct inode *inode)
> -{
> -       spin_lock(&inode->i_lock);
> -       inode->i_version++;
> -       spin_unlock(&inode->i_lock);
> -}
> -
>  enum file_time_flags {
>  	S_ATIME =3D 1,
>  	S_MTIME =3D 2,
> diff --git a/include/linux/iversion.h b/include/linux/iversion.h
> new file mode 100644
> index 000000000000..bb50d27c71f9
> --- /dev/null
> +++ b/include/linux/iversion.h
> @@ -0,0 +1,205 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_IVERSION_H
> +#define _LINUX_IVERSION_H
> +
> +#include <linux/fs.h>
> +
> +/*
> + * The change attribute (i_version) is mandated by NFSv4 and is mostly f=
or
> + * knfsd, but is also used for other purposes (e.g. IMA). The i_version =
must
> + * appear different to observers if there was a change to the inode's da=
ta or
> + * metadata since it was last queried.
> + *
> + * It should be considered an opaque value by observers. If it remains t=
he same
                                 ^^^^^^^^^^^^

You keep using that word ... I don't think it means what you think it
means.
Change that sentence to:

    Observers see i_version as a 64 number which never decreases.

and the rest still makes perfect sense.

Thanks,
NeilBrown


> + * since it was last checked, then nothing has changed in the inode. If =
it's
> + * different then something has changed. Observers cannot infer anything=
 about
> + * the nature or magnitude of the changes from the value, only that the =
inode
> + * has changed in some fashion.
> + *
> + * Not all filesystems properly implement the i_version counter. Subsyst=
ems that
> + * want to use i_version field on an inode should first check whether the
> + * filesystem sets the SB_I_VERSION flag (usually via the IS_I_VERSION m=
acro).
> + *
> + * Those that set SB_I_VERSION will automatically have their i_version c=
ounter
> + * incremented on writes to normal files. If the SB_I_VERSION is not set=
, then
> + * the VFS will not touch it on writes, and the filesystem can use it ho=
w it
> + * wishes. Note that the filesystem is always responsible for updating t=
he
> + * i_version on namespace changes in directories (mkdir, rmdir, unlink, =
etc.).
> + * We consider these sorts of filesystems to have a kernel-managed i_ver=
sion.
> + *
> + * Note that some filesystems (e.g. NFS and AFS) just use the field to s=
tore
> + * a server-provided value (for the most part). For that reason, those
> + * filesystems do not set SB_I_VERSION. These filesystems are considered=
 to
> + * have a self-managed i_version.
> + */
> +
> +/**
> + * inode_set_iversion_raw - set i_version to the specified raw value
> + * @inode: inode to set
> + * @new: new i_version value to set
> + *
> + * Set @inode's i_version field to @new. This function is for use by
> + * filesystems that self-manage the i_version.
> + *
> + * For example, the NFS client stores its NFSv4 change attribute in this=
 way,
> + * and the AFS client stores the data_version from the server here.
> + */
> +static inline void
> +inode_set_iversion_raw(struct inode *inode, const u64 new)
> +{
> +	inode->i_version =3D new;
> +}
> +
> +/**
> + * inode_set_iversion - set i_version to a particular value
> + * @inode: inode to set
> + * @new: new i_version value to set
> + *
> + * Set @inode's i_version field to @new. This function is for filesystem=
s with
> + * a kernel-managed i_version.
> + *
> + * For now, this just does the same thing as the _raw variant.
> + */
> +static inline void
> +inode_set_iversion(struct inode *inode, const u64 new)
> +{
> +	inode_set_iversion_raw(inode, new);
> +}
> +
> +/**
> + * inode_set_iversion_queried - set i_version to a particular value and =
set
> + *                              flag to indicate that it has been viewed
> + * @inode: inode to set
> + * @new: new i_version value to set
> + *
> + * When loading in an i_version value from a backing store, we typically=
 don't
> + * know whether it was previously viewed before being stored or not. Thu=
s, we
> + * must assume that it was, to ensure that any changes will result in the
> + * value changing.
> + *
> + * This function will set the inode's i_version, and possibly flag the v=
alue
> + * as if it has already been viewed at least once.
> + *
> + * For now, this just does what inode_set_iversion does.
> + */
> +static inline void
> +inode_set_iversion_queried(struct inode *inode, const u64 new)
> +{
> +	inode_set_iversion(inode, new);
> +}
> +
> +/**
> + * inode_maybe_inc_iversion - increments i_version
> + * @inode: inode with the i_version that should be updated
> + * @force: increment the counter even if it's not necessary
> + *
> + * Every time the inode is modified, the i_version field must be seen to=
 have
> + * changed by any observer.
> + *
> + * In this implementation, we always increment it after taking the i_loc=
k to
> + * ensure that we don't race with other incrementors.
> + *
> + * Returns true if counter was bumped, and false if it wasn't.
> + */
> +static inline bool
> +inode_maybe_inc_iversion(struct inode *inode, bool force)
> +{
> +	spin_lock(&inode->i_lock);
> +	inode->i_version++;
> +	spin_unlock(&inode->i_lock);
> +	return true;
> +}
> +
> +/**
> + * inode_inc_iversion - forcibly increment i_version
> + * @inode: inode that needs to be updated
> + *
> + * Forcbily increment the i_version field. This always results in a chan=
ge to
> + * the observable value.
> + */
> +static inline void
> +inode_inc_iversion(struct inode *inode)
> +{
> +	inode_maybe_inc_iversion(inode, true);
> +}
> +
> +/**
> + * inode_iversion_need_inc - is the i_version in need of being increment=
ed?
> + * @inode: inode to check
> + *
> + * Returns whether the inode->i_version counter needs incrementing on th=
e next
> + * change.
> + *
> + * For now, we assume that it always does.
> + */
> +static inline bool
> +inode_iversion_need_inc(struct inode *inode)
> +{
> +	return true;
> +}
> +
> +/**
> + * inode_peek_iversion_raw - grab a "raw" iversion value
> + * @inode: inode from which i_version should be read
> + *
> + * Grab a "raw" inode->i_version value and return it. The i_version is n=
ot
> + * flagged or converted in any way. This is mostly used to access a self=
-managed
> + * i_version.
> + *
> + * With those filesystems, we want to treat the i_version as an entirely
> + * opaque value.
> + */
> +static inline u64
> +inode_peek_iversion_raw(const struct inode *inode)
> +{
> +	return inode->i_version;
> +}
> +
> +/**
> + * inode_peek_iversion - read i_version without flagging it to be increm=
ented
> + * @inode: inode from which i_version should be read
> + *
> + * Read the inode i_version counter for an inode without registering it =
as a
> + * query.
> + *
> + * This is typically used by local filesystems that need to store an i_v=
ersion
> + * on disk. In that situation, it's not necessary to flag it as having b=
een
> + * viewed, as the result won't be used to gauge changes from that point.
> + */
> +static inline u64
> +inode_peek_iversion(const struct inode *inode)
> +{
> +	return inode_peek_iversion_raw(inode);
> +}
> +
> +/**
> + * inode_query_iversion - read i_version for later use
> + * @inode: inode from which i_version should be read
> + *
> + * Read the inode i_version counter. This should be used by callers that=
 wish
> + * to store the returned i_version for later comparison. This will guara=
ntee
> + * that a later query of the i_version will result in a different value =
if
> + * anything has changed.
> + *
> + * This implementation just does a peek.
> + */
> +static inline u64
> +inode_query_iversion(struct inode *inode)
> +{
> +	return inode_peek_iversion(inode);
> +}
> +
> +/**
> + * inode_cmp_iversion - check whether the i_version counter has changed
> + * @inode: inode to check
> + * @old: old value to check against its i_version
> + *
> + * Compare an i_version counter with a previous one. Returns 0 if they a=
re
> + * the same or non-zero if they are different.
> + */
> +static inline s64
> +inode_cmp_iversion(const struct inode *inode, const u64 old)
> +{
> +	return (s64)inode_peek_iversion(inode) - (s64)old;
> +}
> +#endif
> --=20
> 2.14.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlo9kcsACgkQOeye3VZi
gbkteQ/9HWUFYQFS7GfJm491MWt9JgBJ2ISsVIvCnw91XkEfJwkh7LalCUp006aa
6RjkNR/y1HKeDg76DK2l0BvcPgtG2mMPOeknM0bP0agQMduGNM7HR4KuT07w0Ykx
aoykya7T2WhROoD0dD0GSMG8ZHMzXyta6pfQVY+LEkdthS/6jckR/ZBglt4unUET
ffrFikuvKp1Kd6Iy3qDUcfL4bqV7UbqAUHMULA51XGmgLIz0CEOqX62rADkl7+Do
g8GdcIOjef6wIWAZjBGwzoH5lnp3urgolB/BKlt8pZYZ2AMZrhmFzhJPX2XY4rZQ
+Fi84TWpyj5+kB1Q4Q6rLKAAbAQRMZ56uecIhz7neFJp97ZlUXXBzy7FyN3y6hEC
wMTotmvnq6Fsh1EIMjIEvDJByALU6IIsvFCm2tG41Rm0nkZH+emhjDK4D7iTUuad
q2OfT6L92TUs1YYhnPN0cefMFSRyRfvzSRRPOtia/C3IZ12IWAykY8heEMigpuw8
Q1TC17H0Yl0U8u4IBb2hfS/FJi91pFfP5Pta00KWLr8XkQPqz2IS4eqYgC5/a+Sx
J4UVucyAAr0AgRLM+rzMq2j/qEUwvDzwXhUxIANMUd8W9hWTE+1DQbT8hU/A2h//
CNT7VtBfywPOFyb6HgXpQXRkjKw/CLTnvdj+4tRgI1tiXCSgnWQ=
=UWMg
-----END PGP SIGNATURE-----
--=-=-=--
