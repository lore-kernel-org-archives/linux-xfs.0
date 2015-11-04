Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 29CEB7FB7
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 20:18:36 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 93A60AC002
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 18:18:32 -0800 (PST)
Received: from mail-pa0-f52.google.com (mail-pa0-f52.google.com
	[209.85.220.52]) by cuda.sgi.com with ESMTP id yskIJSBz8UMDLdr3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Nov 2015 18:18:28 -0800 (PST)
Received: by pasz6 with SMTP id z6so37103649pas.2
	for <xfs@oss.sgi.com>; Tue, 03 Nov 2015 18:18:27 -0800 (PST)
Subject: Re: [PATCH v13 21/51] ext4: Add richacl feature flag
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1446563847-14005-22-git-send-email-agruenba@redhat.com>
Date: Tue, 3 Nov 2015 19:18:19 -0700
Message-Id: <06282344-726E-49AD-936B-7BFF8F43B967@dilger.ca>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-22-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0989651016798414165=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>


--===============0989651016798414165==
Content-Type: multipart/signed; boundary="Apple-Mail=_CCEA3C87-F09E-4ABD-A2B3-E40C5E9468A2"; protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_CCEA3C87-F09E-4ABD-A2B3-E40C5E9468A2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Nov 3, 2015, at 8:16 AM, Andreas Gruenbacher <agruenba@redhat.com> =
wrote:
>=20
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>=20
> This feature flag selects richacl instead of posix acl support on the
> file system. In addition, the "acl" mount option is needed for =
enabling
> either of the two kinds of acls.

This patch confuses me.  I thought the whole point of INCOMPAT_RICHACL
was that the filesystem should never, ever be mounted without ACL =
support
because the ACLs will get confused without it.  In that case, it doesn't
make sense to have a mount option that _has_ to be specified to mount =
the
filesystem, and returns an error when trying to disable it.

It makes more sense to just enable "acl" by default if INCOMPAT_RICHACL
is set in the superblock and not need the mount option at all.

Having a mount option made more sense when enabling this support was =
optional
for the filesystem, and it could be mounted without it enabled, but you
wanted INCOMPAT_RICHACL to prevent that so it needs to be fixed.

Cheers, Andreas

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
> fs/ext4/ext4.h  |  6 ++++--
> fs/ext4/super.c | 49 ++++++++++++++++++++++++++++++++++++++++---------
> 2 files changed, 44 insertions(+), 11 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index fd1f28b..b97a3b1 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -991,7 +991,7 @@ struct ext4_inode_info {
> #define EXT4_MOUNT_UPDATE_JOURNAL	0x01000	/* Update the journal =
format */
> #define EXT4_MOUNT_NO_UID32		0x02000  /* Disable 32-bit UIDs =
*/
> #define EXT4_MOUNT_XATTR_USER		0x04000	/* Extended user =
attributes */
> -#define EXT4_MOUNT_POSIX_ACL		0x08000	/* POSIX Access Control =
Lists */
> +#define EXT4_MOUNT_ACL			0x08000	/* Access =
Control Lists */
> #define EXT4_MOUNT_NO_AUTO_DA_ALLOC	0x10000	/* No auto delalloc =
mapping */
> #define EXT4_MOUNT_BARRIER		0x20000 /* Use block barriers */
> #define EXT4_MOUNT_QUOTA		0x80000 /* Some quota option set =
*/
> @@ -1582,6 +1582,7 @@ static inline int ext4_encrypted_inode(struct =
inode *inode)
> #define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB =
or 3-lvl htree */
> #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode =
*/
> #define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
> +#define EXT4_FEATURE_INCOMPAT_RICHACL		0x20000
>=20
> #define EXT2_FEATURE_COMPAT_SUPP	EXT4_FEATURE_COMPAT_EXT_ATTR
> #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| =
\
> @@ -1607,7 +1608,8 @@ static inline int ext4_encrypted_inode(struct =
inode *inode)
> 					 EXT4_FEATURE_INCOMPAT_FLEX_BG| =
\
> 					 EXT4_FEATURE_INCOMPAT_MMP | \
> 					 =
EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
> -					 EXT4_FEATURE_INCOMPAT_ENCRYPT)
> +					 EXT4_FEATURE_INCOMPAT_ENCRYPT | =
\
> +					 EXT4_FEATURE_INCOMPAT_RICHACL)
> #define EXT4_FEATURE_RO_COMPAT_SUPP	=
(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
> 					 =
EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
> 					 =
EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index a63c7b0..7457ea8 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1270,6 +1270,28 @@ static ext4_fsblk_t get_sb_block(void **data)
> 	return sb_block;
> }
>=20
> +static int enable_acl(struct super_block *sb)
> +{
> +	sb->s_flags &=3D ~(MS_POSIXACL | MS_RICHACL);
> +	if (test_opt(sb, ACL)) {
> +		if (EXT4_HAS_INCOMPAT_FEATURE(sb,
> +					      =
EXT4_FEATURE_INCOMPAT_RICHACL)) {
> +#ifdef CONFIG_EXT4_FS_RICHACL
> +			sb->s_flags |=3D MS_RICHACL;
> +#else
> +			return -EOPNOTSUPP;
> +#endif
> +		} else {
> +#ifdef CONFIG_EXT4_FS_POSIX_ACL
> +			sb->s_flags |=3D MS_POSIXACL;
> +#else
> +			return -EOPNOTSUPP;
> +#endif
> +		}
> +	}
> +	return 0;
> +}
> +
> #define DEFAULT_JOURNAL_IOPRIO (IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 3))
> static char deprecated_msg[] =3D "Mount option \"%s\" will be removed =
by %s\n"
> 	"Contact linux-ext4@vger.kernel.org if you think we should keep =
it.\n";
> @@ -1416,9 +1438,9 @@ static const struct mount_opts {
> 	 MOPT_NO_EXT2 | MOPT_DATAJ},
> 	{Opt_user_xattr, EXT4_MOUNT_XATTR_USER, MOPT_SET},
> 	{Opt_nouser_xattr, EXT4_MOUNT_XATTR_USER, MOPT_CLEAR},
> -#ifdef CONFIG_EXT4_FS_POSIX_ACL
> -	{Opt_acl, EXT4_MOUNT_POSIX_ACL, MOPT_SET},
> -	{Opt_noacl, EXT4_MOUNT_POSIX_ACL, MOPT_CLEAR},
> +#if defined(CONFIG_EXT4_FS_POSIX_ACL) || =
defined(CONFIG_EXT4_FS_RICHACL)
> +	{Opt_acl, EXT4_MOUNT_ACL, MOPT_SET},
> +	{Opt_noacl, EXT4_MOUNT_ACL, MOPT_CLEAR},
> #else
> 	{Opt_acl, 0, MOPT_NOSUPPORT},
> 	{Opt_noacl, 0, MOPT_NOSUPPORT},
> @@ -1466,6 +1488,13 @@ static int handle_mount_opt(struct super_block =
*sb, char *opt, int token,
> #endif
> 	switch (token) {
> 	case Opt_noacl:
> +#ifdef CONFIG_EXT4_FS_RICHACL
> +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, =
EXT4_FEATURE_INCOMPAT_RICHACL)) {
> +		ext4_msg(sb, KERN_ERR, "Mount option \"%s\" incompatible =
"
> +			 "with richacl feature", opt);
> +		return -1;
> +	}
> +#endif
> 	case Opt_nouser_xattr:
> 		ext4_msg(sb, KERN_WARNING, deprecated_msg, opt, "3.5");
> 		break;
> @@ -3576,8 +3605,8 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 		set_opt(sb, NO_UID32);
> 	/* xattr user namespace & acls are now defaulted on */
> 	set_opt(sb, XATTR_USER);
> -#ifdef CONFIG_EXT4_FS_POSIX_ACL
> -	set_opt(sb, POSIX_ACL);
> +#if defined(CONFIG_EXT4_FS_POSIX_ACL) || =
defined(CONFIG_EXT4_FS_RICHACL)
> +	set_opt(sb, ACL);
> #endif
> 	/* don't forget to enable journal_csum when metadata_csum is =
enabled. */
> 	if (ext4_has_metadata_csum(sb))
> @@ -3660,8 +3689,9 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> 		sb->s_iflags |=3D SB_I_CGROUPWB;
> 	}
>=20
> -	sb->s_flags =3D (sb->s_flags & ~MS_POSIXACL) |
> -		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
> +	err =3D enable_acl(sb);
> +	if (err)
> +		goto failed_mount;
>=20
> 	if (le32_to_cpu(es->s_rev_level) =3D=3D EXT4_GOOD_OLD_REV &&
> 	    (EXT4_HAS_COMPAT_FEATURE(sb, ~0U) ||
> @@ -4981,8 +5011,9 @@ static int ext4_remount(struct super_block *sb, =
int *flags, char *data)
> 	if (sbi->s_mount_flags & EXT4_MF_FS_ABORTED)
> 		ext4_abort(sb, "Abort forced by user");
>=20
> -	sb->s_flags =3D (sb->s_flags & ~MS_POSIXACL) |
> -		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
> +	err =3D enable_acl(sb);
> +	if (err)
> +		goto restore_opts;
>=20
> 	es =3D sbi->s_es;
>=20
> --
> 2.5.0
>=20


Cheers, Andreas






--Apple-Mail=_CCEA3C87-F09E-4ABD-A2B3-E40C5E9468A2
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVjlq63Kl2rkXzB/gAQj04Q/+Lfxvp1SYlSbQtf89x2V4Ya5sstQ7wSzN
3V/z/36Se9CdpCUmuGaKElq+MI7thPE7mn0vnDCNgd89QhL1i+eoieJ0FCiSHXel
G3axLsRMGW9RdUQz+bdMRdSMnU3Grm9MRH33uspPqWKelTpMAIyonXGQmofQSOA1
KrNDIaPFg2U4c8y58SZ8l1EwcNnFxCpnbx4VG6a+WeNmdpTyqFfjgDA2t9qNPDnO
9i0wfIYxpi85OJZtybba/t1aIXPALfxPKY03Rbvc2MnK5OKWFjxAXHo8LNMAzt3y
6+leREMQj0trSHBLxC0UoKfLqXcrxczLdXoG4XgygMqJqSEflEOiiedd71EJoxwg
dbVDuKjqxH4g1Ios91FNLubhC+GhS/6R+mssTtIwpSDtevV1Ev52hIpXsWw5VpY/
oZ+/tNcjYwsmO7nSiVxvGx2wkMo50EfTCKfpyYLI19WAAnhXUDG0F5GU0jYzoDao
JQV43yT/Zswl3PzgrY31sI21tnxtW8ke69pxdC64C1xr2zZ4HZRiWw6biPWvpPlk
JzP0/Kw/NsLuNL5gmSiDupv72uZ5UynvLZiaGtNnWSKZadS5j8OX7d3XmC8qRPsX
GoQJiZBAQxPrIq6ESzcKuGvvbngDeaUzOmmaSDgic1HxCDK4fUoNXQKd5GPIBJsX
RekIQDAukCc=
=KMZQ
-----END PGP SIGNATURE-----

--Apple-Mail=_CCEA3C87-F09E-4ABD-A2B3-E40C5E9468A2--


--===============0989651016798414165==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0989651016798414165==--
