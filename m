Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 282F27F3F
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 16:22:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DD2258F8052
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 14:22:27 -0800 (PST)
Received: from mail-pb0-f44.google.com (mail-pb0-f44.google.com
	[209.85.160.44]) by cuda.sgi.com with ESMTP id HNm3Cp8uoITMlk5m
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 Dec 2013 14:22:26 -0800 (PST)
Received: by mail-pb0-f44.google.com with SMTP id rq2so1310554pbb.31
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 14:22:26 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Subject: Re: [PATCH 0/4 v3] fiemap: introduce EXTENT_DATA_COMPRESSED flag
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <cover.1386778302.git.dsterba@suse.cz>
Date: Thu, 12 Dec 2013 15:22:20 -0700
Message-Id: <6CAFB777-F514-4DD9-BD8B-95E7525FD534@dilger.ca>
References: <cover.1386778302.git.dsterba@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4312633308741788932=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: David Sterba <dsterba@suse.cz>
Cc: linux-nilfs@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, "linux-btrfs@vger.kernel.org Btrfs" <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, ocfs2-devel@oss.oracle.com


--===============4312633308741788932==
Content-Type: multipart/signed; boundary="Apple-Mail=_37EDDF86-D75C-4C7B-BD07-C6E3524E7CCC"; protocol="application/pgp-signature"; micalg=pgp-sha1


--Apple-Mail=_37EDDF86-D75C-4C7B-BD07-C6E3524E7CCC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 12, 2013, at 8:25 AM, David Sterba <dsterba@suse.cz> wrote:
> The original FIEMAP patch did not define this bit, btrfs will make use =
of
> it.  The defined constant maintains the same value as originally =
proposed.
>=20
> Currently, the 'filefrag' utility has no way to recognize and denote a
> compressed extent. As implemented in btrfs right now, the compression =
step
> splits a big extent into smaller chunks and this is reported as a =
heavily
> fragmented file. Adding the flag to filefrag will at least give some
> explanation why, this has been confusing users for some time already.

The whole series looks good to me (one minor nit if it needs to be =
resubmitted
for some reason).  You can add my:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> V3:
> Based on feedback from Andreas, implement #1 from V2, current users of
> fiemap_fill_next_extent (fs/, ext4, gfs2, ocfs2, nilfs2, xfs) updated
> accordingly, no functional change.
>=20
> V2:
> Based on feedback from Andreas, the fiemap_extent is now able to hold =
the
> physical extent length, to be filled by the filesystem callback.
>=20
> The filesystems do not have access to the structure that is passed =
back to
> userspace and are supposed to call fiemap_fill_next_extent, there's no =
direct
> way to fill fe_phys_length. There are two ways to pass it:
>=20
> 1) extend fiemap_fill_next_extent to take phys_length and update all
>   users (ext4, gfs2, ocfs2, nilfs2, xfs)
>=20
> 2) add new function that takes arguments for all the fiemap_extent =
items,
>   newly added phys_length compared to fiemap_fill_next_extent
>=20
> David Sterba (4):
>  fiemap: fix comment at EXTENT_DATA_ENCRYPTED
>  fiemap: add EXTENT_DATA_COMPRESSED flag
>  btrfs: set FIEMAP_EXTENT_DATA_COMPRESSED for compressed extents
>  Documentation/fiemap: Document the DATA_COMPRESSED flag
>=20
> Documentation/filesystems/fiemap.txt |   17 +++++++++++++----
> fs/btrfs/extent_io.c                 |    9 +++++++--
> fs/ext4/extents.c                    |    3 ++-
> fs/ext4/inline.c                     |    2 +-
> fs/gfs2/inode.c                      |    2 +-
> fs/ioctl.c                           |   18 ++++++++++++------
> fs/nilfs2/inode.c                    |    8 +++++---
> fs/ocfs2/extent_map.c                |    4 ++--
> fs/xfs/xfs_iops.c                    |    2 +-
> include/linux/fs.h                   |    2 +-
> include/uapi/linux/fiemap.h          |    8 ++++++--
> 11 files changed, 51 insertions(+), 24 deletions(-)
>=20
> --=20
> 1.7.9
>=20


Cheers, Andreas






--Apple-Mail=_37EDDF86-D75C-4C7B-BD07-C6E3524E7CCC
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUqo3HHKl2rkXzB/gAQKWWRAAkzM1fzS2F2wXEcHndEmzBZJf9PVrBgsH
T47p/DxSVlMzFAu6hVxvJcbl4iDIfzJOXd7e60ptbIKce/IBRQU6Lg0XHISfN/8x
EpdiDd8xySqcLuG8JZ66L+/7PSyO2aQYVNJnsNZjxEG7sJylC3NWPhnKZAi775lN
gnInYAHsgl2Dvc8NDUylvIcvQHOVkZ/o3cr/m8WPuxNTYGqwpw1HvMwEfqD5pfod
8QQyyqA0AGleubSpE0cB8KvzInBeE0ujw2gt/88mtV4Qd2xjrh3XEKbTI1QLbO1M
9NAXYkjXhHtU7xQNbSaMpVZ77Sv97v3NueDAVnZnvDGob4sjDFwIPokoqUbskLuw
CYQKuToqbRWpS/cdX159luWr8cCH5wFTfmkfQJRlsFFKrYU67OFwBO4AZSL+4l9+
NUXlQuMY3Gb+BVV0qq4faw+gWHbhinOYA0TzNxb5uX/nhr8EkbxwBaY1o9Ml+bYO
26g+IERx8WO1+/rvKM5cguPaWHOyppr8ggkkpCSmcGVro9HfagMeqZ+FHpZY7MsW
OXmcG7/h85862m0JrJRuZuvwH40PMEkk8Mo74Elr3nBJypcsX/OTZA8yb1d30XTR
EbdFbXZTnoqrbOz8hoEcpYzHa7xF2OBti7SNKU01T5D/vJja0jV4ZZCbWbfiaZGX
PDICGt1rRxQ=
=eiV9
-----END PGP SIGNATURE-----

--Apple-Mail=_37EDDF86-D75C-4C7B-BD07-C6E3524E7CCC--


--===============4312633308741788932==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4312633308741788932==--
