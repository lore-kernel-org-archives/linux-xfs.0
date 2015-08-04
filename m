Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A6AB67FAE
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 17:43:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2BF60AC001
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 15:42:58 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	xOSR6QG9bDL8Mv9h for <xfs@oss.sgi.com>;
	Tue, 04 Aug 2015 15:42:55 -0700 (PDT)
Date: Wed, 5 Aug 2015 08:42:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS File system in trouble
Message-ID: <20150804224240.GU16638@dastard>
References: <03864DDC681E664EBF5D47682BE7D7CF0D358740@USADCWVEMBX07.corp.global.level3.com>
	<CAN3tLtJuk3LKHtxvbXATBR7bjr2e=GTX-fgs-jQniuxqRXjeoA@mail.gmail.com>
	<55AAF73A.4040903@mygrande.net>
	<20150720111747.GA53450@bfoster.bfoster>
	<55B73365.1050908@mygrande.net>
	<20150728123307.GC38784@bfoster.bfoster>
	<55B79BFD.6020509@mygrande.net>
	<20150728221150.GA26604@bfoster.bfoster>
	<55BE7C75.4060604@mygrande.net> <55C06F41.4030502@mygrande.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55C06F41.4030502@mygrande.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Leslie Rhorer <lrhorer@mygrande.net>
Cc: "Rhorer, Leslie" <Leslie.Rhorer@level3.com>, Brian Foster <bfoster@redhat.com>, Kris Rusocki <kszysiu@braxis.org>, Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Aug 04, 2015 at 02:52:33AM -0500, Leslie Rhorer wrote:
> 	It's failing, again.  The rsync job failed and when I attempt to
> untar the file in the image mount, it fails there, as well.  See
> below.  I formatted a 1.5T drive as xfs and mounted it under /media.
> I then dumped the failing FS to a file on /media using xfs_metadump
> and used xfs_mdrestore to create an image of the FS.  I then mounted
> the image, copied over the tarball to its location, and ran tar to
> extract the files:
>
> [131874.545344] loop: module loaded
> [131874.549914] XFS (loop0): Mounting V4 Filesystem
                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> [131874.555540] XFS (loop0): Ending clean mount
> [132020.964431] XFS (loop0): xfs_iread: validation failed for inode 124656869424 failed
> [132020.964435] ffff88028b078000: 49 4e 00 00 03 02 00 00 00 30 00 70 00 00 03 e8  IN.......0.p....
> [132020.964437] ffff88028b078010: 00 00 00 00 06 20 b0 6f 01 2e 00 00 00 00 00 16  ..... .o........
> [132020.964438] ffff88028b078020: 01 57 37 fd 2b 5d 22 9e 1e 0a 61 8c 00 00 00 20  .W7.+]"...a....
> [132020.964440] ffff88028b078030: ff ff 00 d2 1b f6 27 90 00 00 00 00 00 00 00 00  ......'.........
> [132020.964454] XFS (loop0): Internal error xfs_iread at line 392 of
> file /build/linux-QZaPpC/linux-3.16.7-ckt11/fs/xfs/xfs_inode_buf.c.
> Caller xfs_iget+0x24b/0x690 [xfs]

That's a different error to all the ones you've previously posted.
This is an inode allocation that has found a bad inode on disk.

Decoding the 64 bytes above:

	di_magic = 0x494e
	di_mode = 0
	di_version = 3			<<< That's *wrong*
	di_format = 2
	di_onlink = 0
	di_uid = 0x300070		<<< Looks unlikely
	di_gid = 0x3e8
----
	di_nlink = 0
	di_projlo = 0x620		<<< should be zero
	di_projhi = 0xb06f		<<< should be zero
	di_pad[6] = 0x1 0x2e 0 0 0 0	<<< should be zero
	di_flushiter = 0x16		<<< should be zero for v3 inode
---
	di_atime	<random>
	di_mtime	<random, should be similar to atime>
	di_ctime	<random, should be similar/same as mtime>
	di_size = 0x20ffff00d2		<<< should be zero
----
	di_nblocks = 0x1bf6279000000000 <<< should be zero
	di_extsize = 0
----

You've just created and mounted a v4 filesystem, which means it is
using v2 inodes. This inode read back as a v3 inode, with lots of
crap in places where there should be zeros for either v2 or v3 inodes.

This does not look like a filesystem problem - it's clear that what
has come from disk (or a cached memory buffer) is full of garbage
and contains invalid configuration, and the filesystem has quite
correctly detected the corruption and shut down. The filesystem
would give the same errors if it tried to *write* such a corrupt
block, so we know what was just been detected has not come from the
filesytem code...

FWIW, I've occasionally seen this sort of thing happen when a power
supply had gone bad - it wasn't bad enough to make things fail, it
ust caused transient issues under load that manifest as corruptions
and crashes. Given that you've already found one set of hardware
problems and the corruption patterns are unlike any
filesystem/storage problem I've ever seen, I'd suggest that you
still have some kind of hardware issue...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
