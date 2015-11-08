Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D1B927F6D
	for <xfs@oss.sgi.com>; Sun,  8 Nov 2015 02:17:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BF412304039
	for <xfs@oss.sgi.com>; Sun,  8 Nov 2015 00:17:37 -0800 (PST)
Received: from mail-pa0-f52.google.com (mail-pa0-f52.google.com
	[209.85.220.52]) by cuda.sgi.com with ESMTP id 7O5ZixC1qv49svhA
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 08 Nov 2015 00:17:35 -0800 (PST)
Received: by pasz6 with SMTP id z6so170931539pas.2
	for <xfs@oss.sgi.com>; Sun, 08 Nov 2015 00:17:35 -0800 (PST)
Subject: Re: [PATCH v14 02/22] vfs: Add MAY_CREATE_FILE and MAY_CREATE_DIR
	permission flags
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1446918268-858-1-git-send-email-agruenba@redhat.com>
Date: Sun, 8 Nov 2015 01:18:55 -0700
Message-Id: <0B5A4519-9506-41AA-9AA9-A67EA070E6F8@dilger.ca>
References: <1446723580-3747-1-git-send-email-agruenba@redhat.com>
	<1446723580-3747-3-git-send-email-agruenba@redhat.com>
	<ABAAFEBD-0C80-41A3-8D29-F2AB9BAF1823@dilger.ca>
	<1446918268-858-1-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4606300233868234044=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>


--===============4606300233868234044==
Content-Type: multipart/signed; boundary="Apple-Mail=_28C5425C-AF5E-40F9-B6EB-6C6221836E29"; protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_28C5425C-AF5E-40F9-B6EB-6C6221836E29
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 7, 2015, at 10:44 AM, Andreas Gruenbacher <agruenba@redhat.com> =
wrote:
>=20
> On Fri, Nov 6, 2015 at 9:58 PM, Andreas Dilger <adilger@dilger.ca> =
wrote:
>> I thought you proposed adding an enum for these parameters, and =
possibly
>> making them a single parameter flag, to make the code in the caller =
more
>> readable.
>=20
> No, the result would just be different but not any better; vfs_rename =
would
> become messy.  I've played with this patch some more, and I find the =
approach
> below which splits may_delete into may_delete and may_replace much =
better.
> What do you think?

This is definitely better than the previous patch.  You can add:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Cheers, Andreas

> ---------- 8< ----------
>=20
> Richacls distinguish between creating non-directories and directories. =
To
> support that, add an isdir parameter to may_create(). When checking
> inode_permission() for create permission, pass in an additional
> MAY_CREATE_FILE or MAY_CREATE_DIR mask flag.
>=20
> Add may_replace() to allow checking for delete and create access when
> replacing an existing file in vfs_rename().
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> Reviewed-by: J. Bruce Fields <bfields@redhat.com>
> ---
> fs/namei.c         | 49 =
+++++++++++++++++++++++++++++++++----------------
> include/linux/fs.h |  2 ++
> 2 files changed, 35 insertions(+), 16 deletions(-)
>=20
> diff --git a/fs/namei.c b/fs/namei.c
> index 224ecf1..4e5dc2f 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -453,7 +453,9 @@ static int sb_permission(struct super_block *sb, =
struct inode *inode, int mask)
>  * this, letting us set arbitrary permissions for filesystem access =
without
>  * changing the "normal" UIDs which are used for other things.
>  *
> - * When checking for MAY_APPEND, MAY_WRITE must also be set in @mask.
> + * MAY_WRITE must be set in @mask whenever MAY_APPEND, =
MAY_CREATE_FILE, or
> + * MAY_CREATE_DIR are set.  That way, file systems that don't support =
these
> + * permissions will check for MAY_WRITE instead.
>  */
> int inode_permission(struct inode *inode, int mask)
> {
> @@ -2549,7 +2551,8 @@ EXPORT_SYMBOL(__check_sticky);
>  * 10. We don't allow removal of NFS sillyrenamed files; it's handled =
by
>  *     nfs_async_unlink().
>  */
> -static int may_delete(struct inode *dir, struct dentry *victim, bool =
isdir)
> +static int may_delete_replace(struct inode *dir, struct dentry =
*victim,
> +			      bool isdir, int mask)
> {
> 	struct inode *inode =3D d_backing_inode(victim);
> 	int error;
> @@ -2561,7 +2564,7 @@ static int may_delete(struct inode *dir, struct =
dentry *victim, bool isdir)
> 	BUG_ON(victim->d_parent->d_inode !=3D dir);
> 	audit_inode_child(dir, victim, AUDIT_TYPE_CHILD_DELETE);
>=20
> -	error =3D inode_permission(dir, MAY_WRITE | MAY_EXEC);
> +	error =3D inode_permission(dir, mask | MAY_WRITE | MAY_EXEC);
> 	if (error)
> 		return error;
> 	if (IS_APPEND(dir))
> @@ -2584,6 +2587,18 @@ static int may_delete(struct inode *dir, struct =
dentry *victim, bool isdir)
> 	return 0;
> }
>=20
> +static int may_delete(struct inode *dir, struct dentry *victim, bool =
isdir)
> +{
> +	return may_delete_replace(dir, victim, isdir, 0);
> +}
> +
> +static int may_replace(struct inode *dir, struct dentry *victim, bool =
isdir)
> +{
> +	int mask =3D isdir ? MAY_CREATE_DIR : MAY_CREATE_FILE;
> +
> +	return may_delete_replace(dir, victim, isdir, mask);
> +}
> +
> /*	Check whether we can create an object with dentry child in =
directory
>  *  dir.
>  *  1. We can't do it if child already exists (open has special =
treatment for
> @@ -2592,14 +2607,16 @@ static int may_delete(struct inode *dir, =
struct dentry *victim, bool isdir)
>  *  3. We should have write and exec permissions on dir
>  *  4. We can't do it if dir is immutable (done in permission())
>  */
> -static inline int may_create(struct inode *dir, struct dentry *child)
> +static inline int may_create(struct inode *dir, struct dentry *child, =
bool isdir)
> {
> +	int mask =3D isdir ? MAY_CREATE_DIR : MAY_CREATE_FILE;
> +
> 	audit_inode_child(dir, child, AUDIT_TYPE_CHILD_CREATE);
> 	if (child->d_inode)
> 		return -EEXIST;
> 	if (IS_DEADDIR(dir))
> 		return -ENOENT;
> -	return inode_permission(dir, MAY_WRITE | MAY_EXEC);
> +	return inode_permission(dir, MAY_WRITE | MAY_EXEC | mask);
> }
>=20
> /*
> @@ -2649,7 +2666,7 @@ EXPORT_SYMBOL(unlock_rename);
> int vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
> 		bool want_excl)
> {
> -	int error =3D may_create(dir, dentry);
> +	int error =3D may_create(dir, dentry, false);
> 	if (error)
> 		return error;
>=20
> @@ -3494,7 +3511,7 @@ EXPORT_SYMBOL(user_path_create);
>=20
> int vfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, =
dev_t dev)
> {
> -	int error =3D may_create(dir, dentry);
> +	int error =3D may_create(dir, dentry, false);
>=20
> 	if (error)
> 		return error;
> @@ -3586,7 +3603,7 @@ SYSCALL_DEFINE3(mknod, const char __user *, =
filename, umode_t, mode, unsigned, d
>=20
> int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
> {
> -	int error =3D may_create(dir, dentry);
> +	int error =3D may_create(dir, dentry, true);
> 	unsigned max_links =3D dir->i_sb->s_max_links;
>=20
> 	if (error)
> @@ -3667,7 +3684,7 @@ EXPORT_SYMBOL(dentry_unhash);
>=20
> int vfs_rmdir(struct inode *dir, struct dentry *dentry)
> {
> -	int error =3D may_delete(dir, dentry, 1);
> +	int error =3D may_delete(dir, dentry, true);
>=20
> 	if (error)
> 		return error;
> @@ -3789,7 +3806,7 @@ SYSCALL_DEFINE1(rmdir, const char __user *, =
pathname)
> int vfs_unlink(struct inode *dir, struct dentry *dentry, struct inode =
**delegated_inode)
> {
> 	struct inode *target =3D dentry->d_inode;
> -	int error =3D may_delete(dir, dentry, 0);
> +	int error =3D may_delete(dir, dentry, false);
>=20
> 	if (error)
> 		return error;
> @@ -3923,7 +3940,7 @@ SYSCALL_DEFINE1(unlink, const char __user *, =
pathname)
>=20
> int vfs_symlink(struct inode *dir, struct dentry *dentry, const char =
*oldname)
> {
> -	int error =3D may_create(dir, dentry);
> +	int error =3D may_create(dir, dentry, false);
>=20
> 	if (error)
> 		return error;
> @@ -4006,7 +4023,7 @@ int vfs_link(struct dentry *old_dentry, struct =
inode *dir, struct dentry *new_de
> 	if (!inode)
> 		return -ENOENT;
>=20
> -	error =3D may_create(dir, new_dentry);
> +	error =3D may_create(dir, new_dentry, false);
> 	if (error)
> 		return error;
>=20
> @@ -4199,14 +4216,14 @@ int vfs_rename(struct inode *old_dir, struct =
dentry *old_dentry,
> 		return error;
>=20
> 	if (!target) {
> -		error =3D may_create(new_dir, new_dentry);
> +		error =3D may_create(new_dir, new_dentry, is_dir);
> 	} else {
> 		new_is_dir =3D d_is_dir(new_dentry);
>=20
> 		if (!(flags & RENAME_EXCHANGE))
> -			error =3D may_delete(new_dir, new_dentry, =
is_dir);
> +			error =3D may_replace(new_dir, new_dentry, =
is_dir);
> 		else
> -			error =3D may_delete(new_dir, new_dentry, =
new_is_dir);
> +			error =3D may_replace(new_dir, new_dentry, =
new_is_dir);
> 	}
> 	if (error)
> 		return error;
> @@ -4469,7 +4486,7 @@ SYSCALL_DEFINE2(rename, const char __user *, =
oldname, const char __user *, newna
>=20
> int vfs_whiteout(struct inode *dir, struct dentry *dentry)
> {
> -	int error =3D may_create(dir, dentry);
> +	int error =3D may_create(dir, dentry, false);
> 	if (error)
> 		return error;
>=20
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 4efa435..d6e2330 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -82,6 +82,8 @@ typedef void (dax_iodone_t)(struct buffer_head =
*bh_map, int uptodate);
> #define MAY_CHDIR		0x00000040
> /* called from RCU mode, don't block */
> #define MAY_NOT_BLOCK		0x00000080
> +#define MAY_CREATE_FILE		0x00000100
> +#define MAY_CREATE_DIR		0x00000200
>=20
> /*
>  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must =
correspond
> --
> 2.5.0
>=20


Cheers, Andreas






--Apple-Mail=_28C5425C-AF5E-40F9-B6EB-6C6221836E29
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVj8Fb3Kl2rkXzB/gAQjlFw//aWzy9SPFugHLc3t+sSL41Y1t+7aX4X8N
dd6d5FXGYH1PL+H1Z0iic/7Cmartf5YyNuILYboa89rUAEU7drzG4AkzLQ0TZ8OO
xac09BSBQ1XXO9SUB/ph4WvXwwSZRYGISqFi6+GZ4W5MIn/cKkB1zyFgwAwmWn6Z
v8QoR9t/Tipy0LjCdyMPfQx6hBYVaix3oUP5BNQvKcjkjzaPYig6QFcnXjUL6CTD
DhnQV8adxJLaWQfbt5IFg3pLABtGqnrKfqEDPPyD8waiu6Qt8amRXz01bKHuOgBv
VFOjgG8NBFJsFWFVsmmkSijeQNn8AzxQ8MNQAjdZgbzVIkFYVPGf/ZJxOhgt5dKb
ocNJsfF2Lrwksa729XLD6GAIIjRtk+HHGE+L5K/HQz0uv1WxUb9/AVSrusmsgyYB
tDbaiQENZm0V9pvxb0SM+jqI0lo93P9gl0ie8XcxRGQrMGxx9V4tm6aqhD8cQhsO
zDAaN90AWoTQme/ZkeqH3H2xePtNvXaCatMA9dlKvJkpL02vuxEC97BP5oVkLxHF
5n1mb6s9Pt6a6g091sZET5Mn7sqNDuRsCub5iOIlJyK69jXPPah9x5HnfUbNurP6
EhbUhSqw/zFBj9JbLxyMSa30bBFIpLApzukXgSbxlpd1Lcs6h1a7zqJ+qS/6JEuc
fDrfsrLN9zM=
=YAtC
-----END PGP SIGNATURE-----

--Apple-Mail=_28C5425C-AF5E-40F9-B6EB-6C6221836E29--


--===============4606300233868234044==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4606300233868234044==--
