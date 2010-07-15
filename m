Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6FLUloN225346 for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 16:30:47 -0500
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 419D0BC8F85
	for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 14:40:00 -0700 (PDT)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	Amkt1BbsLQ7UjD58 for <xfs@oss.sgi.com>;
	Thu, 15 Jul 2010 14:40:00 -0700 (PDT)
Received: by qyk35 with SMTP id 35so3188846qyk.5
	for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 14:33:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100714234857.GD30737@dastard>
References: <1279134201-6890-1-git-send-email-treestem@gmail.com>
	<20100714234857.GD30737@dastard>
Date: Thu, 15 Jul 2010 17:33:41 -0400
Message-ID: <AANLkTilOS8WwFGhdLq8qAO-ihrpZxe2YvZNnimYpEcQ9@mail.gmail.com>
Subject: Re: [PATCH] XFS: _xfs_buf_find ignores XBF_DONT_BLOCK flag
From: Peter Watkins <treestem@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 14, 2010 at 7:48 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Jul 14, 2010 at 03:03:21PM -0400, Peter Watkins wrote:

[ snip ]

>
> I think you misunderstand what XBF_DONT_BLOCK is for - that's not
> hard because it's not particularly well commented. FYI, it's to
> prevent memory reclaim recursion back into the filesystem during
> memory allocation in the buffer layer while we hold locked items.
> The buffer cache implementation of the flag has changed over time
> (originally an Irix flag, IIRC) so it doesn't quite describe what it
> does on linux anymore. =A0See xb_to_gfp() and xb_to_km() to find out
> what it triggers.
>
> FWIW, if we wanted to avoid blocking on buffer locks, then we'd be
> passing XBF_TRYLOCK....

Thanks for taking the time to clue me in.


>
> Ok, so the problem here is that we are trying a memory allocation
> with a locked inode buffer, and memory reclaim can trip over that
> locked inode buffer and deadlock. That means we should not allow
> allocation recursion from within xfs_iformat() even though we are
> not in a tranaction context.
>

Which is just what KM_NOFS is for. I see.

> The following patch converts the allocations during inode
> initialisation to use KM_NOFS. It applies to a 2.6.35-rc3 kernel,
> but might apply to a 2.6.27 kernel. Can you test it?

Sure, I'll test it on some of these systems. The bug is not easy to
reproduce, but
I'll try to recreate the load.

Thanks for the help!

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> xfs: fix memory reclaim recursion deadlock on locked inode buffer
>
> From: Dave Chinner <dchinner@redhat.com>
>
> Calling into memory reclaim with a locked inode buffer can deadlock
> if memory reclaim tries to lock the inode buffer during inode
> teardown. Convert the relevant memory allocations to use KM_NOFS to
> avoid this deadlock condition.
>
> Reported-by: Peter Watkins <treestem@gmail.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
> =A0fs/xfs/xfs_inode.c | =A0 20 +++++++++++---------
> =A01 files changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 5715a9d..3c206b3 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -422,7 +422,7 @@ xfs_iformat(
> =A0 =A0 =A0 =A0if (!XFS_DFORK_Q(dip))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0ASSERT(ip->i_afp =3D=3D NULL);
> - =A0 =A0 =A0 ip->i_afp =3D kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
> + =A0 =A0 =A0 ip->i_afp =3D kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP|KM_=
NOFS);
> =A0 =A0 =A0 =A0ip->i_afp->if_ext_max =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0XFS_IFORK_ASIZE(ip) / (uint)sizeof(xfs_bmb=
t_rec_t);
> =A0 =A0 =A0 =A0switch (dip->di_aformat) {
> @@ -505,7 +505,7 @@ xfs_iformat_local(
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ifp->if_u1.if_data =3D ifp->if_u2.if_inlin=
e_data;
> =A0 =A0 =A0 =A0else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0real_size =3D roundup(size, 4);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ifp->if_u1.if_data =3D kmem_alloc(real_size=
, KM_SLEEP);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ifp->if_u1.if_data =3D kmem_alloc(real_size=
, KM_SLEEP|KM_NOFS);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0ifp->if_bytes =3D size;
> =A0 =A0 =A0 =A0ifp->if_real_bytes =3D real_size;
> @@ -632,7 +632,7 @@ xfs_iformat_btree(
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0ifp->if_broot_bytes =3D size;
> - =A0 =A0 =A0 ifp->if_broot =3D kmem_alloc(size, KM_SLEEP);
> + =A0 =A0 =A0 ifp->if_broot =3D kmem_alloc(size, KM_SLEEP|KM_NOFS);
> =A0 =A0 =A0 =A0ASSERT(ifp->if_broot !=3D NULL);
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Copy and convert from the on-disk structure
> @@ -2191,7 +2191,7 @@ xfs_iroot_realloc(
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ifp->if_broot_bytes =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0new_size =3D (size_t)XFS_B=
MAP_BROOT_SPACE_CALC(rec_diff);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ifp->if_broot =3D kmem_allo=
c(new_size, KM_SLEEP);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ifp->if_broot =3D kmem_allo=
c(new_size, KM_SLEEP|KM_NOFS);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ifp->if_broot_bytes =3D (i=
nt)new_size;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -2207,7 +2207,7 @@ xfs_iroot_realloc(
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0new_size =3D (size_t)XFS_BMAP_BROOT_SPACE_=
CALC(new_max);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ifp->if_broot =3D kmem_realloc(ifp->if_bro=
ot, new_size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(size_t)XF=
S_BMAP_BROOT_SPACE_CALC(cur_max), /* old size */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 KM_SLEEP);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 KM_SLEEP|KM=
_NOFS);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0op =3D (char *)XFS_BMAP_BROOT_PTR_ADDR(mp,=
 ifp->if_broot, 1,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ifp->if_broot_bytes);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0np =3D (char *)XFS_BMAP_BROOT_PTR_ADDR(mp,=
 ifp->if_broot, 1,
> @@ -2233,7 +2233,7 @@ xfs_iroot_realloc(
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0new_size =3D 0;
> =A0 =A0 =A0 =A0if (new_size > 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_broot =3D kmem_alloc(new_size, KM_SLEEP=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_broot =3D kmem_alloc(new_size, KM_SLEEP=
|KM_NOFS);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * First copy over the btree block header.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> @@ -2337,7 +2337,8 @@ xfs_idata_realloc(
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0real_size =3D roundup(new_size, 4);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ifp->if_u1.if_data =3D=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ASSERT(ifp->if_real_bytes =
=3D=3D 0);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ifp->if_u1.if_data =3D kmem=
_alloc(real_size, KM_SLEEP);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ifp->if_u1.if_data =3D kmem=
_alloc(real_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 KM_SLEEP|KM_NOFS);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (ifp->if_u1.if_data !=3D ifp->if=
_u2.if_inline_data) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * Only do the realloc if =
the underlying size
> @@ -2348,11 +2349,12 @@ xfs_idata_realloc(
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0kmem_realloc(ifp->if_u1.if_data,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0real_size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ifp->if_real_bytes,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 KM_SLEEP);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 KM_SLEEP|KM_NOFS);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ASSERT(ifp->if_real_bytes =
=3D=3D 0);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ifp->if_u1.if_data =3D kmem=
_alloc(real_size, KM_SLEEP);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ifp->if_u1.if_data =3D kmem=
_alloc(real_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 KM_SLEEP|KM_NOFS);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy(ifp->if_u1.if_data,=
 ifp->if_u2.if_inline_data,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ifp->if_by=
tes);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
