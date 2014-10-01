Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C1DCC7F72
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 16:05:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9EF1E8F8035
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 14:05:48 -0700 (PDT)
Received: from mail-pa0-f46.google.com (mail-pa0-f46.google.com
	[209.85.220.46]) by cuda.sgi.com with ESMTP id W5Jzy6yRFdlAVyUc
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Oct 2014 14:05:46 -0700 (PDT)
Received: by mail-pa0-f46.google.com with SMTP id fa1so934484pad.5
	for <xfs@oss.sgi.com>; Wed, 01 Oct 2014 14:05:46 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 04/12] fs: Generic infrastructure for optional inode fields
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1412191894-9113-5-git-send-email-jack@suse.cz>
Date: Wed, 1 Oct 2014 15:05:46 -0600
Message-Id: <3BFF1023-E198-4797-A96A-EA158137157E@dilger.ca>
References: <1412191894-9113-1-git-send-email-jack@suse.cz>
	<1412191894-9113-5-git-send-email-jack@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4029599559373013697=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com


--===============4029599559373013697==
Content-Type: multipart/signed; boundary="Apple-Mail=_4CB239A5-51E1-4A1D-8055-1AAFD25DB4DA"; protocol="application/pgp-signature"; micalg=pgp-sha1


--Apple-Mail=_4CB239A5-51E1-4A1D-8055-1AAFD25DB4DA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 1, 2014, at 1:31 PM, Jan Kara <jack@suse.cz> wrote:
> There are parts of struct inode which are used only by a few =
filesystems
> (e.g. i_dquot pointers, i_mapping->private_list, ...). Thus all the
> other filesystems are just wasting memory with these fields. On the
> other hand it isn't simple to just move these fields to filesystem
> specific part of inode because there is generic code which needs to =
peek
> into the fields and it is cumbersome to provide helpers into which fs
> has to stuff the field it is storing elsewhere.
>=20
> We create a simple infrastructure which allows for optional inode =
fields
> stored in the fs-specific part of the inode. Accessing these fields =
has
> a slightly worse performance as we have to lookup their offset in the
> offset table stored in the superblock but in most cases this is
> acceptable. Notably, this offset-table mechanism is faster than having
> fs-specific hook functions which would need to be called to provide
> pointers to desired fields.
>=20
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
> include/linux/fs.h | 24 ++++++++++++++++++++++++
> 1 file changed, 24 insertions(+)
>=20
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 94187721ad41..977f8fb6ca88 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -615,6 +615,11 @@ struct inode {
> 	void			*i_private; /* fs or device private =
pointer */
> };
>=20
> +/* Optional inode fields (stored in filesystems inode if the fs needs =
them) */
> +enum {

This should be a named enum, like "enum inode_field" or similar, so it
can be referenced below.

> +	IF_FIELD_NR	/* Number of optional inode fields */
> +};
> +
> static inline int inode_unhashed(struct inode *inode)
> {
> 	return hlist_unhashed(&inode->i_hash);
> @@ -1236,6 +1241,11 @@ struct super_block {
> 	void 			*s_fs_info;	/* Filesystem private =
info */
> 	unsigned int		s_max_links;
> 	fmode_t			s_mode;
> +	/*
> +	 * We could have here just a pointer to the offsets array but =
this
> +	 * way we save one dereference when looking up field offsets
> +	 */
> +	int			s_inode_fields[IF_FIELD_NR];
>=20
> 	/* Granularity of c/m/atime in ns.
> 	   Cannot be worse than a second */
> @@ -1286,6 +1296,20 @@ struct super_block {
> 	struct rcu_head		rcu;
> };
>=20
> +static inline void *inode_field(const struct inode *inode, int field)

This should use "enum inode_field" instead of int, so the compiler could
warn about invalid parameter values.  It might make sense to add a =
check:

        if (field < IF_FIELD_NR)

but I'm not sure if the overhead is worthwhile, unless it can always be
resolved at compile time.  That might be possible since this is a static
inline function.

Cheers, Andreas

> +{
> +	int offset =3D inode->i_sb->s_inode_fields[field];
> +
> +	if (!offset)	/* Field not present? */
> +		return NULL;

> +	return ((char *)inode) + offset;
> +}
> +
> +static inline void sb_init_inode_fields(struct super_block *sb, int =
*fields)
> +{
> +	memcpy(sb->s_inode_fields, fields, sizeof(int) * IF_FIELD_NR);
> +}
> +
> extern struct timespec current_fs_time(struct super_block *sb);
>=20
> /*
> --=20
> 1.8.1.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_4CB239A5-51E1-4A1D-8055-1AAFD25DB4DA
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVCxsq3Kl2rkXzB/gAQK7DhAAg3ag4acKmQyynoKDAwfPBBgZ5l/zZ1PP
rpSmjKWN2iqW0CuA8fZqLBzJqSH7p1SKznutS+ivQfrMicLjy0fnwY30YddBmoeZ
2p29hh1F1g1cWTdw8JeQB+VrJcvXKGIAIskysYUuF5bix6Btltp/TjAHOTV8xS0O
sK7ZCRt6foheGufOQdfiuTWRJyloy8RyL4FOVn/UFGeuU7t9Ynh78wM+Qx/LrSQT
5ZnpFcE3GIFNKcn7SKhAkfve4KqFji1EzMutWmhkJRt14AGYE+kwrBlvZM+F+Xex
Pt+z0p/K5xMDiTFPsqFOITpHbx1QUoLVhXFsgb1+3HoYMTiJX+yYj3QDI9Ac0+kq
PcuYJ3RAfW/FHAiZ2GAeCDLwDFA44+/n77hsrWWi/3ne3G1de8o/fDhM5W5gWsBP
u6pFEv5Fu8912YbmBvJecMYpMr6VQbsm+BMm6HwZx4IYcqgNde87ZlYGfs4svSzY
QBNas2XXwWUR9pdnWyqdraQODQbAoPTqH9KIMveUh01HNffh6dU40/6Q/lZXg/wE
hvIV45qBTdF88aEaBDDAUT5Jgr8I+9YrFHgVAwhwGAXZvaPpVGC1MqIU4Pcypl3o
79a1zmZK0msglR0NA0PN+kr6nsCvpjNg23UwzSLJBP0HZEOiHDShDZrydsaXRxG8
iSQpGDVjxhg=
=ONs2
-----END PGP SIGNATURE-----

--Apple-Mail=_4CB239A5-51E1-4A1D-8055-1AAFD25DB4DA--


--===============4029599559373013697==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4029599559373013697==--
