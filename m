Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DDB847F3F
	for <xfs@oss.sgi.com>; Tue, 16 Dec 2014 14:04:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5C6D8AC00A
	for <xfs@oss.sgi.com>; Tue, 16 Dec 2014 12:04:47 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	hmjT3DAmyB29f5Wk for <xfs@oss.sgi.com>;
	Tue, 16 Dec 2014 12:04:44 -0800 (PST)
Date: Wed, 17 Dec 2014 07:04:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: easily reproducible filesystem crash on rebuilding array [XFS
	bug in my book]
Message-ID: <20141216200410.GC15665@dastard>
References: <20141211123936.1f3d713d@harpe.intellique.com>
	<20141215130715.4dfaaa8e@harpe.intellique.com>
	<20141215132500.13210fdb@harpe.intellique.com>
	<20141216120821.587cf104@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141216120821.587cf104@harpe.intellique.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 16, 2014 at 12:08:21PM +0100, Emmanuel Florac wrote:
> Le Mon, 15 Dec 2014 13:25:00 +0100
> Emmanuel Florac <eflorac@intellique.com> =E9crivait:
> =

> > Reading the source I see that the error occured in xfs_buf_read_map, I
> > suppose it's when xfsbufd tries to scan dirty metadata? This is a read
> > error, so it could very well be a simple IO starvation at the
> > controller level (as the controller probably gives priority to
> > whatever writes are pending over reads).
> > =

> > Maybe setting xfsbufd_centisecs to the max could help here? Trying
> > right away... Any advice welcome.
> > =

> =

> Alas, same thing;
> =

> dmesg output:
> =

> =

> ffff8800df1f5020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ......=
..........
> ffff8800df1f5030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ......=
..........
> XFS (dm-0): Metadata corruption detected at xfs_inode_buf_verify+0x6c/0xb=
0, block 0xeffffff40
> XFS (dm-0): Unmount and run xfs_repair
> XFS (dm-0): First 64 bytes of corrupted metadata buffer:
> ffff8800df1f5000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ......=
..........
> ffff8800df1f5010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ......=
..........
> ffff8800df1f5020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ......=
..........
> ffff8800df1f5030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ......=
..........
> XFS (dm-0): Metadata corruption detected at xfs_inode_buf_verify+0x6c/0xb=
0, block 0xeffffff40
> XFS (dm-0): Unmount and run xfs_repair

So the underlying storage stack is returning zeros without any IO
errors here. It's probably a lookup operation, so it simply fails
and returns the error to userspace. Every one of these messages is a
separate read IO, but they are all returning zeros.

....

> XFS (dm-0): First 64 bytes of corrupted metadata buffer:
> ffff8800df1f5000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ......=
..........
> ffff8800df1f5010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ......=
..........
> ffff8800df1f5020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ......=
..........
> ffff8800df1f5030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ......=
..........
> XFS (dm-0): metadata I/O error: block 0xeffffff40 ("xfs_trans_read_buf_ma=
p") error 117 numblks 16
> XFS (dm-0): xfs_do_force_shutdown(0x1) called from line 383 of file fs/xf=
s/xfs_trans_buf.c.  Return address =3D 0xffffffff8125cc90
> XFS (dm-0): I/O Error Detected. Shutting down filesystem
> XFS (dm-0): Please umount the filesystem and rectify the problem(s)
> XFS (dm-0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 117.
> XFS (dm-0): xfs_log_force: error 5 returned.
> XFS (dm-0): xfs_log_force: error 5 returned.

And here the same read error has occurred in a dirty transaction,
and so the filesystem shut down.

> There is no IO error at the RAID controller level, at all. The buffer
> hasn't been overwritten with zeros, I'm pretty sure it actually timed
> out and just read nothing. This is not a case for an IO error IMO, a
> retry would almost certainly succeed; after all the problem occurred
> after more than 8 hours of continuous heavy read/write activity.

What you see above is a persistent corruption that has been
reported several times as XFS has errored out and then re-read
the data from disk multiple times. A retry would most certainly
return zeros again.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
