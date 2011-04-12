Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3C7trX4139899 for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 02:55:53 -0500
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3476E14BCD86
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 00:59:13 -0700 (PDT)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	KWYUDCoJeW7dhMrp for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2011 00:59:13 -0700 (PDT)
Received: by iyb26 with SMTP id 26so7273804iyb.26
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 00:59:13 -0700 (PDT)
MIME-Version: 1.0
From: Raz <raziebe@gmail.com>
Date: Tue, 12 Apr 2011 10:58:53 +0300
Message-ID: <BANLkTinyBD7Zm3DvoYCVfYJkF36yXz6hOA@mail.gmail.com>
Subject: HUGE XFS regression in 2.6.32 upto 2.6.38
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
To: xfs-oss <xfs@oss.sgi.com>

Christoph Hello
I am testing 2.6.38 with AIM benchmark.
I compared 2.6.38 to 2.6.27 and I noticed that 2.6.27 is much better
than 2.6.38 when
doing sync random writes test over an xfs regular file over native
Linux partition on top common sata disk.
I git bisected the problem and I reached this SHA1:
commit 13e6d5cdde0e785aa943810f08b801cadd0935df
Author: Christoph Hellwig <hch@lst.de>
Date: =A0 Mon Aug 31 21:00:31 2009 -0300

=A0 =A0xfs: merge fsync and O_SYNC handling

=A0 =A0The guarantees for O_SYNC are exactly the same as the ones we need to
=A0 =A0make for an fsync call (and given that Linux O_SYNC is O_DSYNC the
=A0 =A0equivalent is fdadatasync, but we treat both the same in XFS), except
=A0 =A0with a range data writeout. =A0Jan Kara has started unifying these t=
wo
=A0 =A0path for filesystems using the generic helpers, and I've started to
=A0 =A0look at XFS.
...


The bellow two tests presents the how different performance is before and p=
atch:
#test 16) bisect 11
---------------------------------------------------------------------------=
---------------------------------
=A0Test =A0 =A0 =A0 =A0Test =A0 =A0 =A0 =A0Elapsed =A0Iteration =A0 =A0Iter=
ation =A0 =A0 =A0 =A0 =A0Operation
Number =A0 =A0 =A0 Name =A0 =A0 =A0Time (sec) =A0 Count =A0 Rate (loops/sec=
) =A0 =A0Rate (ops/sec)
---------------------------------------------------------------------------=
---------------------------------
=A0 =A0 1 sync_disk_rw =A0 =A0 =A0 =A030.71 =A0 =A0 =A0 =A0 19 =A0 =A00.618=
69 =A0 =A0 =A0 =A0 1583.85
Sync Random Disk Writes (K)/second
---------------------------------------------------------------------------=
---------------------------------

#test 17 ) bisect 12
---------------------------------------------------------------------------=
---------------------------------
=A0 =A0 1 sync_disk_rw =A0 =A0 =A0 =A069.05 =A0 =A0 =A0 =A0 =A01 =A0 =A00.0=
1448 =A0 =A0 =A0 =A0 =A0 37.07
Sync Random Disk Writes (K)/second
---------------------------------------------------------------------------=
---------------------------------


Regards
Raz Ben-Yehuda


=A0Reply
=A0Reply to all
=A0Forward

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
