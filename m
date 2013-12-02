Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 685C429DF9
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 16:05:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 43898304087
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 14:05:17 -0800 (PST)
Received: from mail-pd0-f179.google.com (mail-pd0-f179.google.com
	[209.85.192.179]) by cuda.sgi.com with ESMTP id
	IM5vTa6FDCEZimMu (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 14:05:13 -0800 (PST)
Received: by mail-pd0-f179.google.com with SMTP id r10so18929461pdi.24
	for <xfs@oss.sgi.com>; Mon, 02 Dec 2013 14:05:12 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Subject: Re: [PATCH] fs: fix iversion handling
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20131202173636.GA17724@infradead.org>
Date: Mon, 2 Dec 2013 15:05:07 -0700
Message-Id: <8E57B1B6-E650-4A1A-AF78-0A9C9593A3E3@dilger.ca>
References: <20131119151707.GA13412@infradead.org>
	<20131202173636.GA17724@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5136026106792554506=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com


--===============5136026106792554506==
Content-Type: multipart/signed; boundary="Apple-Mail=_7D8628FB-B316-4644-8F5D-7B988D7E3343"; protocol="application/pgp-signature"; micalg=pgp-sha1


--Apple-Mail=_7D8628FB-B316-4644-8F5D-7B988D7E3343
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 2, 2013, at 10:36 AM, Christoph Hellwig <hch@infradead.org> =
wrote:
> ping?

Added linux-ext4 to the CC list.

I'm happy to see this cleanup.  You can add my

  Reviewed-by: Andreas Dilger <adilger@dilger.ca>

for the ext4 part, one question inline for the btrfs change (someone =
with more
btrfs knowledge needs to comment if that is important or not.

Cheers, Andreas

> On Tue, Nov 19, 2013 at 07:17:07AM -0800, Christoph Hellwig wrote:
>> Currently notify_change directly updates i_version for size updates,
>> which not only is counter to how all other fields are updated through
>> struct iattr, but also breaks XFS, which need inode updates to happen
>> under its own lock, and synchronized to the structure that gets =
written
>> to the log.
>>=20
>> Remove the update in the common code, and it to btrfs and ext4,
>> XFS already does a proper updaste internally and currently gets a
>> double update with the existing code.
>>=20
>> IMHO this is 3.13 and -stable material and should go in through the =
XFS
>> tree.
>>=20
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>=20
>> Index: xfs/fs/attr.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- xfs.orig/fs/attr.c	2013-11-19 16:08:42.275415189 +0100
>> +++ xfs/fs/attr.c	2013-11-19 16:08:51.803414994 +0100
>> @@ -182,11 +182,6 @@ int notify_change(struct dentry * dentry
>> 			return -EPERM;
>> 	}
>>=20
>> -	if ((ia_valid & ATTR_SIZE) && IS_I_VERSION(inode)) {
>> -		if (attr->ia_size !=3D inode->i_size)
>> -			inode_inc_iversion(inode);
>> -	}
>> -
>> 	if ((ia_valid & ATTR_MODE)) {
>> 		umode_t amode =3D attr->ia_mode;
>> 		/* Flag setting protected by i_mutex */
>> Index: xfs/fs/btrfs/inode.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- xfs.orig/fs/btrfs/inode.c	2013-11-19 16:08:42.275415189 =
+0100
>> +++ xfs/fs/btrfs/inode.c	2013-11-19 16:08:51.803414994 +0100
>> @@ -4345,8 +4345,12 @@ static int btrfs_setsize(struct inode *i
>> 	 * these flags set.  For all other operations the VFS set these =
flags
>> 	 * explicitly if it wants a timestamp update.
>> 	 */
>> -	if (newsize !=3D oldsize && (!(mask & (ATTR_CTIME | =
ATTR_MTIME))))
>> -		inode->i_ctime =3D inode->i_mtime =3D =
current_fs_time(inode->i_sb);
>> +	if (newsize !=3D oldsize) {
>> +		inode_inc_iversion(inode);

Should this be conditional on IS_I_VERSION(inode)?

>> +		if (!(mask & (ATTR_CTIME | ATTR_MTIME)))
>> +			inode->i_ctime =3D inode->i_mtime =3D
>> +				current_fs_time(inode->i_sb);
>> +	}
>>=20
>> 	if (newsize > oldsize) {
>> 		truncate_pagecache(inode, newsize);
>> Index: xfs/fs/ext4/inode.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- xfs.orig/fs/ext4/inode.c	2013-11-19 16:08:42.275415189 +0100
>> +++ xfs/fs/ext4/inode.c	2013-11-19 16:08:51.803414994 +0100
>> @@ -4594,6 +4594,10 @@ int ext4_setattr(struct dentry *dentry,
>> 			if (attr->ia_size > sbi->s_bitmap_maxbytes)
>> 				return -EFBIG;
>> 		}
>> +
>> +		if (IS_I_VERSION(inode) && attr->ia_size !=3D =
inode->i_size)
>> +			inode_inc_iversion(inode);
>> +
>> 		if (S_ISREG(inode->i_mode) &&
>> 		    (attr->ia_size < inode->i_size)) {
>> 			if (ext4_should_order_data(inode)) {
>>=20
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> ---end quoted text---
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_7D8628FB-B316-4644-8F5D-7B988D7E3343
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUp0EE3Kl2rkXzB/gAQIzLRAAq6brTcMpky/57cXpzlHi98YjCuAd2PYU
wkW/nIY9jjGuvIZtaARixtxhpjhpoMMqk3ioID16PzXLyuzqHb02RquLqWD9BILA
Tv+6FfiD2s7IwkQdxR1VH/Fpxzrqg7s4VKI7FuJN7MGCG23AseJY+99M/KModnWh
ClEUdvuaNzMoQQonvq/Q+bxooBnkpTgQa470WjFlwXQlmaRMw4pfFQZKxqqD7iAi
q9X5KDsnR5fswvsJ3yus89k0BaFSSkgFhGm7FG7wqjecxTWZ9KWCXySvPvsjuG4x
vqd/PAXGCMrE7DQaETCE4pU7Ay6KOdfrKmve6TsGaDeaN7TynChNLT9/E2ETXqSc
X9hUxLCwE/U80dxEOekIDnCa/W/V4seUpJrbYCSRv5Qz2zH3kVXBZYCxcrwbGPmb
NLF9zzAuJoAVmGWP3OBWQGcVU88gBFQV4QbfKo6C9FCw6Su83O9/PsMXgJFK0+zw
Ybv2iKZZIPreLvVN09HGcwrUcKeQW4MY9zAzx4OIkDiwn7Ri6le6yjtKqy9TOFBi
JDSAIFrd0BsHbzajU3IM1nGo+lHFcqd4Hl+JbZmqNg/VVk4VnlD5mMuAbkVLJjJM
uyjQXZOhmfSMn4aVOVNTejlGHZ+RU/Eo3zprKjVd8Wo2G7SDs7zC8s96R1/zbqTd
bypDBX0MeaU=
=JE2+
-----END PGP SIGNATURE-----

--Apple-Mail=_7D8628FB-B316-4644-8F5D-7B988D7E3343--


--===============5136026106792554506==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5136026106792554506==--
