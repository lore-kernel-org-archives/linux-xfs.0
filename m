Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4U4Jqek220210 for <xfs@oss.sgi.com>; Sun, 29 May 2011 23:19:52 -0500
Received: from cobra.newdream.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ADC64166D629
	for <xfs@oss.sgi.com>; Sun, 29 May 2011 21:19:26 -0700 (PDT)
Received: from cobra.newdream.net (cobra.newdream.net [66.33.216.30]) by
	cuda.sgi.com with ESMTP id Csdf5ZRdWN9y85rW for
	<xfs@oss.sgi.com>; Sun, 29 May 2011 21:19:26 -0700 (PDT)
Date: Sun, 29 May 2011 21:20:59 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
Subject: Re: [regression, 3.0-rc1] dentry cache growth during unlinks, XFS
	performance way down
In-Reply-To: <20110530034741.GD561@dastard>
Message-ID: <Pine.LNX.4.64.1105292057570.9134@cobra.newdream.net>
References: <20110530020604.GC561@dastard> <20110530034741.GD561@dastard>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="557981400-1242587162-1306728170=:9134"
Content-ID: <Pine.LNX.4.64.1105292103520.9342@cobra.newdream.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--557981400-1242587162-1306728170=:9134
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.1105292103521.9342@cobra.newdream.net>

Hey Dave,

On Mon, 30 May 2011, Dave Chinner wrote:
> On Mon, May 30, 2011 at 12:06:04PM +1000, Dave Chinner wrote:
> > Folks,
> >=20
> > I just booted up a 3.0-rc1 kernel, and mounted an XFS filesystem
> > with 50M files in it. Running:
> >=20
> > $ for i in /mnt/scratch/*; do sudo /usr/bin/time rm -rf $i 2>&1 & done
> >=20
> > runs an 8-way parallel unlink on the files. Normally this runs at
> > around 80k unlinks/s, and it runs with about 500k-1m dentries and
> > inodes cached in the steady state.
> >=20
> > The steady state behaviour with 3.0-rc1 is that there are around 10m
> > cached dentries - all negative dentries - consuming about 1.6GB of
> > RAM (of 4GB total). Previous steady state was, IIRC, around 200MB of
> > dentries. My initial suspicions are that the dentry unhashing
> > change=FF=FF may be the cause of this...
>=20
> So a bisect lands on:
>=20
> $ git bisect good
> 79bf7c732b5ff75b96022ed9d29181afd3d2509c is the first bad commit
> commit 79bf7c732b5ff75b96022ed9d29181afd3d2509c
> Author: Sage Weil <sage@newdream.net>
> Date:   Tue May 24 13:06:06 2011 -0700
>=20
>     vfs: push dentry_unhash on rmdir into file systems
>=20
>     Only a few file systems need this.  Start by pushing it down into eac=
h
>     fs rmdir method (except gfs2 and xfs) so it can be dealt with on a pe=
r-fs
>     basis.
>=20
>     This does not change behavior for any in-tree file systems.
>=20
>     Acked-by: Christoph Hellwig <hch@lst.de>
>     Signed-off-by: Sage Weil <sage@newdream.net>
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>=20
> :040000 040000 c45d58718d33f7ca1da87f99fa538f65eaa3fe2c ec71cbecc59e8b142=
a7bfcabd469fa67486bef30 M        fs
>=20
> Ok, so the question has to be asked - why wasn't dentry_unhash()
> pushed down into XFS?

Christoph asked me to leave it out to avoid the push-down + remove=20
noise.  I missed it in v1, added it in v2, then took it out again. =20
Ultimately that isn't the real problem, though:

> Further, now that dentry_unhash() has been removed from most
> filesystems, what is replacing the shrink_dcache_parent() call that
> was cleaning up the "we can never reference again" child dentries of
> the unlinked directories? It appears that they are now being left in
> memory on the dentry LRU. It also appears that they have
> D_REFERENCED bit set, so they do not get immediately reclaimed by
> the shrinker.

Ah, yeah, that makes sense.  I missed the shrink_dcache_parent side=20
effect.  I suspect we just need something like the below?  (Very lightly=20
tested!)

Thanks-
sage


From=20c1fac19b662b02ab4aea98ee2a8d0098bc985bc8 Mon Sep 17 00:00:00 2001
From: Sage Weil <sage@newdream.net>
Date: Sun, 29 May 2011 20:35:44 -0700
Subject: [PATCH 1/3] vfs: shrink_dcache_parent before rmdir, dir rename

The dentry_unhash push-down series missed that shink_dcache_parent needs to
be called prior to rmdir or dir rename to clear DCACHE_REFERENCED and
allow efficient dentry reclaim.

Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/namei.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 1ab641f..e2e4e8d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2579,6 +2579,7 @@ int vfs_rmdir(struct inode *dir, struct dentry *dentr=
y)
 =09if (error)
 =09=09goto out;
=20
+=09shrink_dcache_parent(dentry);
 =09error =3D dir->i_op->rmdir(dir, dentry);
 =09if (error)
 =09=09goto out;
@@ -2993,6 +2994,8 @@ static int vfs_rename_dir(struct inode *old_dir, stru=
ct dentry *old_dentry,
 =09if (d_mountpoint(old_dentry) || d_mountpoint(new_dentry))
 =09=09goto out;
=20
+=09if (target)
+=09=09shrink_dcache_parent(new_dentry);
 =09error =3D old_dir->i_op->rename(old_dir, old_dentry, new_dir, new_dentr=
y);
 =09if (error)
 =09=09goto out;
--=20
1.7.1

--557981400-1242587162-1306728170=:9134
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--557981400-1242587162-1306728170=:9134--
