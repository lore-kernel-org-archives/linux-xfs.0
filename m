Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4V0aBr4015584 for <xfs@oss.sgi.com>; Mon, 30 May 2011 19:36:12 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1D0E1BEE585
	for <xfs@oss.sgi.com>; Mon, 30 May 2011 17:36:10 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	8XB3sngE4dQeEpFU for <xfs@oss.sgi.com>;
	Mon, 30 May 2011 17:36:10 -0700 (PDT)
Date: Tue, 31 May 2011 10:36:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs revival
Message-ID: <20110531003607.GG561@dastard>
References: <BANLkTi=B1S2+V4VvLM5X5Ea+S4r82RbaTQ@mail.gmail.com>
	<BANLkTikxZgxyoAG-k2BJFvfKviHxnwHBgA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTikxZgxyoAG-k2BJFvfKviHxnwHBgA@mail.gmail.com>
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
To: James Grossmann <cctsurf@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, May 28, 2011 at 09:16:17AM -0500, James Grossmann wrote:
> On Sat, May 28, 2011 at 12:12 AM, James Grossmann <cctsurf@gmail.com> wro=
te:
> > I recently decided to build a raid10 on my server. =A0sadly shortly
> > after I built it, a pair of the drives (mirroring each other) dropped
> > errors at the same time, but upon a little revival are both actively
> > working. =A0I resynced the raid, but now I'm having difficulties
> > reviving my xfs file system.
> > I'm running ubuntu server 11.04, which includes xfsprogs 3.1.4.
> > I have been attempting to get the git version or even 3.1.5 working on
> > my system because I continue to get errors in attempting to xfs_repair
> > the volume, but they don't seem to want to build for me. =A0I kept
> > getting a hang on inode 2111, but with some searching found the
> > command: sudo xfs_repair -P -o bhash=3D1024 /dev/md0 to get me to inode
> > 538638356. =A0However, it fails at that point with the following
> > message:
> > corrupt dinode 538638356, extent total =3D 1, nblocks =3D 0. =A0This is=
 a bug.
> > Please capture the filesystem metadata with xfs_metadump and
> > report it to xfs@oss.sgi.com.
> > cache_node_purge: refcount was 1, not zero (node=3D0x3412410)
> >
> > fatal error -- 117 - couldn't iget disconnected inode

Ok, not much to go on there.

> >
> > When I attempt the referenced command, it fails on me with the
> > following error, I have attached the file it produces in dumping.
> > udo xfs_metadump /dev/md/OlIronsides\:0 Olironsides.xfs.metadump
> > cache_node_purge: refcount was 1, not zero (node=3D0x20b2420)
> > xfs_metadump: cannot read root inode (117)
> > cache_node_purge: refcount was 1, not zero (node=3D0x20b6020)
> > xfs_metadump: cannot read realtime bitmap inode (117)
> > *** glibc detected *** xfs_db: free(): invalid next size (normal):
> > 0x00000000020d6000 ***

That doesn't tell us much because the binaries are stripped.
Building and using an unstripped binary shoul dgive a much more
informative backtrace.

....

> I was able to install the ubuntu Oneiric Ocelot's version of xfsprogs
> (3.1.5), but I still get the same error at the same place.
> Following the user guide, I was able to read inode 538638356:
> =

> sudo xfs_db -c "inode 538638356" -c "print" /dev/md/OlIronsides\:0
> cache_node_purge: refcount was 1, not zero (node=3D0x2062420)
> xfs_db: cannot read root inode (117)
> cache_node_purge: refcount was 1, not zero (node=3D0x2066020)
> xfs_db: cannot read realtime bitmap inode (117)
> core.magic =3D 0x494e
> core.mode =3D 0100755
> core.version =3D 2
> core.format =3D 2 (extents)
> core.nlinkv2 =3D 1
> core.onlink =3D 0
> core.projid_lo =3D 0
> core.projid_hi =3D 0
> core.uid =3D 1000
> core.gid =3D 100
> core.flushiter =3D 3
> core.atime.sec =3D Wed May 25 22:44:12 2011
> core.atime.nsec =3D 569449438
> core.mtime.sec =3D Sat Dec 12 13:55:26 2009
> core.mtime.nsec =3D 000000000
> core.ctime.sec =3D Thu May 26 16:14:51 2011
> core.ctime.nsec =3D 201400000
> core.size =3D 5035163
> core.nblocks =3D 1230
  ^^^^^^^^^^^^^^^^^^^
> core.extsize =3D 0
> core.nextents =3D 1
> core.naextents =3D 0
> core.forkoff =3D 0
> core.aformat =3D 2 (extents)
> core.dmevmask =3D 0
> core.dmstate =3D 0
> core.newrtbm =3D 0
> core.prealloc =3D 0
> core.realtime =3D 0
> core.immutable =3D 0
> core.append =3D 0
> core.sync =3D 0
> core.noatime =3D 0
> core.nodump =3D 0
> core.rtinherit =3D 0
> core.projinherit =3D 0
> core.nosymlinks =3D 0
> core.extsz =3D 0
> core.extszinherit =3D 0
> core.nodefrag =3D 0
> core.filestream =3D 0
> core.gen =3D 2106989417
> next_unlinked =3D null
> u.bmx[0] =3D [startoff,startblock,blockcount,extentflag] 0:[0,386750464,1=
230,0]

so that looks like it has an extent and data blocks, so something
has happened during the repair to zero block count of the in-memory
version of the inode. That implies that the extent might be bad and
was cleared earlier in the repair process, but without the repair
output there i sno way to tell.

> I'm having problems building the git xfsprogs, I get the following
> error when I run make, I'm guessing I just don't have something
> installed for the build.

Have you pulled in all the automake, autoconf, etc packages? You
caould also try running 'make realclean' first, too.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
