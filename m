Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9CCSvuL161245 for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 07:28:57 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id 54BvbvH03foHejUj
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Oct 2012 05:30:29 -0700 (PDT)
Received: by mail-pb0-f53.google.com with SMTP id wz12so3409084pbc.26
	for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 05:30:29 -0700 (PDT)
Date: Fri, 12 Oct 2012 18:00:14 +0530
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Subject: Re: [RFC PATCH] xfs: enables file data inlining in inodes
Message-ID: <20121012123014.GB3632@Archie>
References: <1349985158-9952-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
In-Reply-To: <1349985158-9952-1-git-send-email-cmaiolino@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3882373173832051367=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com


--===============3882373173832051367==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,


* On Thu, Oct 11, 2012 at 04:52:38PM -0300, Carlos Maiolino <cmaiolino@redh=
at.com> wrote:
>Hi,
>
>this is a first RFC patch of my work on data inlining, i.e. use the xfs in=
ode's
>literal area to store user's data.
>
>This first patch just cares about write and read new files into inode's li=
teral
>area, it does not make any conversion from inline to extent or vice-versa.
>
>The idea to send this patch to list is just to get comments about this fir=
st
>work and see if anybody has some ideas/suggestions about it, mainly related
>with page cache and journal handling, since it's the first time I deal with
>journal and page cache handling, I'm not pretty sure if I did things right
>or not.
>
>Every comment is very appreciated.
>
>Thanks
>---
> fs/xfs/xfs_aops.c  | 134 ++++++++++++++++++++++++++++++++++++++++++++++++=
++---
>+	if (ip->i_d.di_format =3D=3D XFS_DINODE_FMT_LOCAL) {
>+		struct page	*page =3D list_first_entry(pages, struct page, lru);
>+
>+		ASSERT(i_size_read(VFS_I(ip) <=3D PAGE_CACHE_SIZE));

Looks good.

But, I guess should be --- ASSERT(i_size_read(VFS_I(ip)) <=3D PAGE_CACHE_SI=
ZE);  here?

>+
>+		list_del(&page->lru);
>+		if(!(add_to_page_cache_lru(page, mapping,
>+					    page->index, GFP_KERNEL)))
>+			return xfs_inline_read(ip, page, page->mapping);
>+
>+		page_cache_release(page);
>+		return 0;
>+	} else {
>+		return mpage_readpages(mapping, pages, nr_pages, xfs_get_blocks);
>+	}
> }
>
> const struct address_space_operations xfs_address_space_operations =3D {
>diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>index 2778258..5e56e5c 100644
>--- a/fs/xfs/xfs_inode.c
>+++ b/fs/xfs/xfs_inode.c
>@@ -287,18 +287,6 @@ xfs_iformat(
> 	case S_IFDIR:
>--=20
>1.7.11.7
>
>_______________________________________________
>xfs mailing list
>xfs@oss.sgi.com
>http://oss.sgi.com/mailman/listinfo/xfs




Regards,
--=20
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJQeA1WAAoJEKYW3KHXK+l38YEIAISbKMJy2hSNlhq4mqHFd1YN
LHEwZRqXig5q1X+FQJoI8GKwr4ZnTlt95HIvSKpxVUc2Zbc/ZQPXjf4oMbURwK11
BAEDN2XVWOOczVweJ1cu+pL1OzmtczllDAtDsIj2zNnpscT1JQBNDvnNgbx7aqHm
l2g9rC22cY0kxm8LaOq9+CMR/JAKEuReW4CLNAVinC/LotLGWFTbIIoJb5I6EI9h
jgEyLhxh8DIAMU/KtqlX9+yWERqGFuaZs19CFb9VRhLEhwkbDAL1Eo2QnY9yd3LE
m6KGnr9S1ChE2cllZqp9/1vbA3yiENbT/jALEKI9SQu0JaS+ymh3dVGqF+7nhbg=
=yNX5
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--


--===============3882373173832051367==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3882373173832051367==--
