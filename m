Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B1E077F3F
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2014 14:18:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3D177AC005
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2014 12:18:45 -0800 (PST)
Received: from mail-pa0-f51.google.com (mail-pa0-f51.google.com
	[209.85.220.51]) by cuda.sgi.com with ESMTP id CANzBSfk6Gijr9Xc
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 21 Nov 2014 12:18:44 -0800 (PST)
Received: by mail-pa0-f51.google.com with SMTP id ey11so5607713pad.10
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2014 12:18:43 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 3/4] vfs: don't let the dirty time inodes get more than a
	day stale
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1416599964-21892-4-git-send-email-tytso@mit.edu>
Date: Fri, 21 Nov 2014 14:19:07 -0600
Message-Id: <B1759DB3-7D86-499B-BE09-34D9927C75C8@dilger.ca>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-4-git-send-email-tytso@mit.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7816894130449936842=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com


--===============7816894130449936842==
Content-Type: multipart/signed; boundary="Apple-Mail=_06028ECC-11AE-4F7C-A8E7-651B3EF92124"; protocol="application/pgp-signature"; micalg=pgp-sha1


--Apple-Mail=_06028ECC-11AE-4F7C-A8E7-651B3EF92124
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 21, 2014, at 1:59 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> Guarantee that the on-disk timestamps will be no more than 24 hours
> stale.
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
> fs/fs-writeback.c  | 1 +
> fs/inode.c         | 7 ++++++-
> include/linux/fs.h | 1 +
> 3 files changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index ce7de22..eb04277 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1141,6 +1141,7 @@ void __mark_inode_dirty(struct inode *inode, int =
flags)
> 	if (flags & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
> 		trace_writeback_dirty_inode_start(inode, flags);
>=20
> +		inode->i_ts_dirty_day =3D 0;
> 		if (sb->s_op->dirty_inode)
> 			sb->s_op->dirty_inode(inode, flags);
>=20
> diff --git a/fs/inode.c b/fs/inode.c
> index 6e91aca..f0d6232 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1511,6 +1511,7 @@ static int relatime_need_update(struct vfsmount =
*mnt, struct inode *inode,
>  */
> static int update_time(struct inode *inode, struct timespec *time, int =
flags)
> {
> +	int days_since_boot =3D jiffies / (HZ * 86400);
> 	int ret;
>=20
> 	if (inode->i_op->update_time) {
> @@ -1527,12 +1528,16 @@ static int update_time(struct inode *inode, =
struct timespec *time, int flags)
> 		if (flags & S_MTIME)
> 			inode->i_mtime =3D *time;
> 	}
> -	if (inode->i_sb->s_flags & MS_LAZYTIME) {
> +	if ((inode->i_sb->s_flags & MS_LAZYTIME) &&
> +	    (!inode->i_ts_dirty_day ||
> +	     inode->i_ts_dirty_day =3D=3D days_since_boot)) {
> 		spin_lock(&inode->i_lock);
> 		inode->i_state |=3D I_DIRTY_TIME;
> 		spin_unlock(&inode->i_lock);
> +		inode->i_ts_dirty_day =3D days_since_boot;

It isn't clear if this is correct.  It looks like the condition will
only be entered if i_ts_dirty_day =3D=3D days_since_boot, but that is =
only
set inside the condition?  Shouldn't this be:

	inode->i_ts_dirty_day =3D ~0U;

	if ((inode->i_sb->s_flags & MS_LAZYTIME) &&
	    inode->i_ts_dirty_day !=3D days_since_boot)) {
		spin_lock(&inode->i_lock);
		inode->i_state |=3D I_DIRTY_TIME;
		spin_unlock(&inode->i_lock);
		inode->i_ts_dirty_day =3D days_since_boot;
	}

and "days_since_boot" should be declared unsigned short so it wraps
in the same way as i_ts_dirty_day, maybe using typeof(i_ts_dirty_day)
so that there isn't any need to update this in the future if the type
changes.  Conceivably this could be an unsigned char, if that packed
into struct inode better, at the risk of losing a timestamp update on
an inode in cache for 256+ days and only modifying it 256 days later.

Cheers, Andreas

> 		return 0;
> 	}
> +	inode->i_ts_dirty_day =3D 0;
> 	if (inode->i_op->write_time)
> 		return inode->i_op->write_time(inode);
> 	mark_inode_dirty_sync(inode);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 489b2f2..e3574cd 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -575,6 +575,7 @@ struct inode {
> 	struct timespec		i_ctime;
> 	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe =
i_size */
> 	unsigned short          i_bytes;
> +	unsigned short		i_ts_dirty_day;
> 	unsigned int		i_blkbits;
> 	blkcnt_t		i_blocks;
>=20
> --=20
> 2.1.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_06028ECC-11AE-4F7C-A8E7-651B3EF92124
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVG+ePHKl2rkXzB/gAQJXBw/8CHtl3zs0AtBCmVU6RpM2oVHlpYdo++a4
hBKVloH3VD/OIl2WBaDm5e5m8ZVQri5o12nTmJM8Tz4JWJzPd3Sqyd/gFJy94aZW
EnyWxPKr5yjKb6hsJmmyzRY9xthmRM3IY+5EFQBHs1TH9zf4ii54qPmnAyaZ+kfJ
tMWyBg+yeln2+Kf+YqQTk+LNj3jvj7dNd3+f14O6T3Omm/ubMJptuUnTj+bXEIPh
Kn5sBSBY1f4qOAXyJg1jYDIKkWYZyop4q51WBNV75dsKGq1vJ0NYlHseZ2A6UEC5
GdMhcZIijG6774AA9CzqPEvqRnUcuCeGO0khQu6Z9/p3jggqbTsKS9+RgVq/YjUH
uzCeJBEj2k+0koG18bK3idxqYZue6ctMFhls95PjzE6tX6jPaYLl8FPMx/LvxAKh
67lub9Yxjqo8/c+WFVZQJoQdKffZTnTpD0aHAa/o5k5yxe7lxTBgq5ccpm9K52Gf
u4lNShxGC/Ikq4MRF5mOWLo4415Jme86SbVuhsJLW5ccC33LNuZVb/aBFZL0Ha6N
U/nUz+RGs06aFkBNBwMXrRelgdXY/tdtOFjpubqpsgpvs50rzEtDSLh9xHcpot1U
QLGnWS/BPcJ/b51j0GMB9fSM2S0BeBOJyzNeDZqHokOVvB7UyF4nSFZuxi8kB6Uh
PPmK59Tsi6c=
=1NRD
-----END PGP SIGNATURE-----

--Apple-Mail=_06028ECC-11AE-4F7C-A8E7-651B3EF92124--


--===============7816894130449936842==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7816894130449936842==--
