Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAGKh04F117779 for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 14:43:00 -0600
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8833D1C4A069
	for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 12:44:29 -0800 (PST)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id E9kocCgF3xhOc2Fh for
	<xfs@oss.sgi.com>; Tue, 16 Nov 2010 12:44:29 -0800 (PST)
Date: Tue, 16 Nov 2010 21:44:15 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS: I/O Error Detected / 2.6.27.39
Message-ID: <20101116214415.61ecb7cd@galadriel.home>
In-Reply-To: <4CE282DB.8060200@open-e.com>
References: <4CE282DB.8060200@open-e.com>
Mime-Version: 1.0
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
To: Piotr Kandziora <piotr.kandziora@open-e.com>
Cc: Janusz@oss.sgi.com, Artur Piechocki <artur.piechocki@open-e.com>, lukasz.wittig@open-e.com, Bak <jb@open-e.com>, xfs@oss.sgi.com

Le Tue, 16 Nov 2010 14:10:51 +0100 vous =E9criviez:

> Hi,
> =

> Our environment is following:
> - we have 24GB RAM,
> - we are using 3ware controller (and it does not report any errors),

What model? 9550SX? 9650SE? 9690SA? 9750 ? =


> - we have one big logical volume (20TB) exported via NFS with large =

> amount of small files (about 150k),
> - we are doing periodically backup of this logical volume using rsync
> to another server.
> - we have kernel 2.6.27.39,

What distribution, architecture? What is the version of xfs tools
(try xfs_info -V for instance)? What are the xfs mount options?

> Unfortunately our system is freezing unexpectedly without reason.

What are the symptoms ? does the whole system freeze up? Or does it
crash with kernel panic, or otherwise "Oops" messages?

Older 3Ware cards (9550, early 9650) are prone to overheating and may
fail.

> We =

> started investigating this problem and noticed that cache memory is =

> slowly increasing.

This is completely normal and expected. Linux uses up all available
memory as a disk cache.

> We tried to dump this cache memory using:
> /bin/echo "3" > /proc/sys/vm/drop_caches
> =

> In a result, cache was dumped, but in logs we noticed a lot of errors =

> with XFS:
> =

> [kern.warning] kernel: xfs_iunlink_remove: xfs_inotobp()  returned an =

> error 22 on dm-16.  Returning error.
> [kern.notice] kernel: xfs_inactive:\011xfs_ifree() returned an error
> =3D 22 on dm-16
> [kern.notice] kernel: xfs_force_shutdown(dm-16,0x1) called from line =

> 1406 of file fs/xfs/xfs_vnodeops.c.  Return address =3D 0x
> [kern.alert] kernel: Filesystem \"dm-16\": I/O Error Detected.
> Shutting down filesystem: dm-16
> [kern.alert] kernel: Please umount the filesystem, and rectify the =

> problem(s)
> [kern.warning] kernel: xfs_imap_to_bp: xfs_trans_read_buf()returned
> an error 5 on dm-16.  Returning error.
> [kern.warning] kernel: xfs_imap_to_bp: xfs_trans_read_buf()returned
> an error 5 on dm-16.  Returning error.
> [kern.warning] kernel: xfs_imap_to_bp: xfs_trans_read_buf()returned
> an error 5 on dm-16.  Returning error.
> =

> We are wondering if this is problem connected to hardware or rather
> this is XFS problem (if yes, was it fixed?).

This may be an xfs bug but more details would be necessary.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
