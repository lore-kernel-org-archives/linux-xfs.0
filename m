Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 171CD7F76
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2015 14:58:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D9F0A8F8040
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2015 12:58:52 -0800 (PST)
Received: from mail-pa0-f47.google.com (mail-pa0-f47.google.com
	[209.85.220.47]) by cuda.sgi.com with ESMTP id DSCHHbDgLz9o8xir
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Nov 2015 12:58:50 -0800 (PST)
Received: by pasz6 with SMTP id z6so137560979pas.2
	for <xfs@oss.sgi.com>; Fri, 06 Nov 2015 12:58:49 -0800 (PST)
Subject: Re: [PATCH v14 02/22] vfs: Add MAY_CREATE_FILE and MAY_CREATE_DIR
	permission flags
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1446723580-3747-3-git-send-email-agruenba@redhat.com>
Date: Fri, 6 Nov 2015 13:58:42 -0700
Message-Id: <ABAAFEBD-0C80-41A3-8D29-F2AB9BAF1823@dilger.ca>
References: <1446723580-3747-1-git-send-email-agruenba@redhat.com>
	<1446723580-3747-3-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0828838089537466610=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>


--===============0828838089537466610==
Content-Type: multipart/signed; boundary="Apple-Mail=_CF1F0347-94B9-4516-BCFE-FD637F708057"; protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_CF1F0347-94B9-4516-BCFE-FD637F708057
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 5, 2015, at 4:39 AM, Andreas Gruenbacher <agruenba@redhat.com> =
wrote:
>=20
> Richacls distinguish between creating non-directories and directories. =
To
> support that, add an isdir parameter to may_create(). When checking
> inode_permission() for create permission, pass in an additional
> MAY_CREATE_FILE or MAY_CREATE_DIR mask flag.
>=20
> To allow checking for delete *and* create access when replacing an =
existing
> file via vfs_rename(), add a replace parameter to may_delete().

I thought you proposed adding an enum for these parameters, and possibly
making them a single parameter flag, to make the code in the caller more
readable.  Flags like below for example, though I'm not stuck on =
"MAY_IS"
as a prefix, just my first thought:

enum may_flags {
	MAY_IS_FILE	=3D 0x0,	/* Essentially !MAY_IS_DIR */
	MAY_IS_DIR	=3D 0x1,	/* Operation only allowed on =
directory */
	MAY_IS_REPLACE	=3D 0x2,	/* Operation only
};

would make it immediately clear what is being passed to the function.
Some examples inline below.  If Al hates it, fine, but having functions
with multiple "true, false" or "false, true" arguments is ugly and error
prone, IMHO.

> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> Reviewed-by: J. Bruce Fields <bfields@redhat.com>
> ---
> fs/namei.c         | 43 +++++++++++++++++++++++++------------------
> include/linux/fs.h |  2 ++
> 2 files changed, 27 insertions(+), 18 deletions(-)
>=20
> diff --git a/fs/namei.c b/fs/namei.c
> index 224ecf1..0259392 100644
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
> @@ -2549,10 +2551,11 @@ EXPORT_SYMBOL(__check_sticky);
>  * 10. We don't allow removal of NFS sillyrenamed files; it's handled =
by
>  *     nfs_async_unlink().
>  */
> -static int may_delete(struct inode *dir, struct dentry *victim, bool =
isdir)
> +static int may_delete(struct inode *dir, struct dentry *victim,
> +		      bool isdir, bool replace)
> {
> 	struct inode *inode =3D d_backing_inode(victim);
> -	int error;
> +	int error, mask =3D MAY_WRITE | MAY_EXEC;
>=20
> 	if (d_is_negative(victim))
> 		return -ENOENT;
> @@ -2561,7 +2564,9 @@ static int may_delete(struct inode *dir, struct =
dentry *victim, bool isdir)
> 	BUG_ON(victim->d_parent->d_inode !=3D dir);
> 	audit_inode_child(dir, victim, AUDIT_TYPE_CHILD_DELETE);
>=20
> -	error =3D inode_permission(dir, MAY_WRITE | MAY_EXEC);
> +	if (replace)
> +		mask |=3D isdir ? MAY_CREATE_DIR : MAY_CREATE_FILE;
> +	error =3D inode_permission(dir, mask);
> 	if (error)
> 		return error;
> 	if (IS_APPEND(dir))
> @@ -2592,14 +2597,16 @@ static int may_delete(struct inode *dir, =
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
> @@ -2649,7 +2656,7 @@ EXPORT_SYMBOL(unlock_rename);
> int vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
> 		bool want_excl)
> {
> -	int error =3D may_create(dir, dentry);
> +	int error =3D may_create(dir, dentry, false);

	int error =3D may_create(dir, dentry, MAY_IS_FILE);

> 	if (error)
> 		return error;
>=20
> @@ -3494,7 +3501,7 @@ EXPORT_SYMBOL(user_path_create);
>=20
> int vfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, =
dev_t dev)
> {
> -	int error =3D may_create(dir, dentry);
> +	int error =3D may_create(dir, dentry, false);
>=20
> 	if (error)
> 		return error;
> @@ -3586,7 +3593,7 @@ SYSCALL_DEFINE3(mknod, const char __user *, =
filename, umode_t, mode, unsigned, d
>=20
> int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
> {
> -	int error =3D may_create(dir, dentry);
> +	int error =3D may_create(dir, dentry, true);

	int error =3D may_create(dir, dentry, MAY_IS_DIR);

> 	unsigned max_links =3D dir->i_sb->s_max_links;
>=20
> 	if (error)
> @@ -3667,7 +3674,7 @@ EXPORT_SYMBOL(dentry_unhash);
>=20
> int vfs_rmdir(struct inode *dir, struct dentry *dentry)
> {
> -	int error =3D may_delete(dir, dentry, 1);
> +	int error =3D may_delete(dir, dentry, true, false);


The cases where there are multiple parameters is where it makes the most
improvement, since the code is more readable:

	int error =3D may_delete(dir, dentry, MAY_IS_DIR);

> 	if (error)
> 		return error;
> @@ -3789,7 +3796,7 @@ SYSCALL_DEFINE1(rmdir, const char __user *, =
pathname)
> int vfs_unlink(struct inode *dir, struct dentry *dentry, struct inode =
**delegated_inode)
> {
> 	struct inode *target =3D dentry->d_inode;
> -	int error =3D may_delete(dir, dentry, 0);
> +	int error =3D may_delete(dir, dentry, false, false);

	int error =3D may_delete(dir, dentry, MAY_IS_FILE);

Cheers, Andreas

> 	if (error)
> 		return error;
> @@ -3923,7 +3930,7 @@ SYSCALL_DEFINE1(unlink, const char __user *, =
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
> @@ -4006,7 +4013,7 @@ int vfs_link(struct dentry *old_dentry, struct =
inode *dir, struct dentry *new_de
> 	if (!inode)
> 		return -ENOENT;
>=20
> -	error =3D may_create(dir, new_dentry);
> +	error =3D may_create(dir, new_dentry, false);
> 	if (error)
> 		return error;
>=20
> @@ -4194,19 +4201,19 @@ int vfs_rename(struct inode *old_dir, struct =
dentry *old_dentry,
> 	if (source =3D=3D target)
> 		return 0;
>=20
> -	error =3D may_delete(old_dir, old_dentry, is_dir);
> +	error =3D may_delete(old_dir, old_dentry, is_dir, false);
> 	if (error)
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
> +			error =3D may_delete(new_dir, new_dentry, =
is_dir, true);
> 		else
> -			error =3D may_delete(new_dir, new_dentry, =
new_is_dir);
> +			error =3D may_delete(new_dir, new_dentry, =
new_is_dir, true);

> 	}
> 	if (error)
> 		return error;
> @@ -4469,7 +4476,7 @@ SYSCALL_DEFINE2(rename, const char __user *, =
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






--Apple-Mail=_CF1F0347-94B9-4516-BCFE-FD637F708057
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVj0UgnKl2rkXzB/gAQj0pQ//S0x5zpIJIIlg0ZToZKnQtKv6YKa2Qsbu
60fY9fT901YO7DeSsO3F8e+qx8RYRDOTjtfedLalum7CxEd8BAmeY6EK17KVR0Fn
m1lgacRF7bbplLEtiCtSkn1a26TbZPuMF0Z3YApvGWyBxZ0+0zaYKKOiPyZ8Ybz8
2NrltLToKzMxDzoMvsPE2+L4g1sxRwtiPhHiMs9/2oLJ64ML7ppNrzJn2dnGksDS
XP1g4iv2sWf82jms2RFiZ0/2rECUkFZfWhcVbjSinHmM7H1+furXJ9H1pnMji0/j
WyypBGlC4z0ovaOYXsJfrSv0jnS5XnoWXK3nQR+rGA6NvyujCPs5NjjpI8mrU+Yt
Yv+ORJdhyOmVwtSZo4C4Nx1PDlki74WFoXiYkF5L5OorztgCxcdF4xtTxr7BY9J7
HwtIpXrxYUNHAfaSyPdj5zVSk1cED3Pgs0pdxkiSEgkX26ZZ/jZMzV1UYmvOsOvC
UY0rgVHcHKtX5tWZ8mXUtIhVV0kugt3loj6JYiEhYPsUMcpq5xk9KqTQTfjYA2q+
U9EUjHjtZIKFH7Bw8XpXHdSF8Tww7wY2T/Dx5equgoiHn71wxqrXdfsqhhM90WSM
2B3ghmZaNdfnwSdQf3nR5A1Pfqoupq39BT+Gdx+VouIWNbGXFLxmDjCKxEeaKy9x
Jgfoz+qXk6Y=
=TK5q
-----END PGP SIGNATURE-----

--Apple-Mail=_CF1F0347-94B9-4516-BCFE-FD637F708057--


--===============0828838089537466610==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0828838089537466610==--
