Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p36BcZi6032903 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 06:38:35 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7FD5B1BD7934
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 04:41:49 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	7hRasb13nHWtrC3C for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2011 04:41:49 -0700 (PDT)
Date: Wed, 6 Apr 2011 21:41:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: SL's kickstart corrupting XFS by "repairing" GPT labels?
Message-ID: <20110406114146.GF31057@dastard>
References: <4D9C3E14.6030009@fzu.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D9C3E14.6030009@fzu.cz>
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
To: Jan =?iso-8859-1?Q?Kundr=E1t?= <kundratj@fzu.cz>
Cc: lcg-admin@fzu.cz, xfs@oss.sgi.com

On Wed, Apr 06, 2011 at 12:19:00PM +0200, Jan Kundr=E1t wrote:
> Dear XFS developers,
> I'd like to ask for some help with troubleshooting the following issue
> which occurred almost simultaneously on three systems connected to one
> physically isolated island of our FC infrastructure. The machines in
> question are all running SL5.4 (a RHEL-5.4 clone), two of them are IBM
> x3650 M2, one is a HP DL360 G6. All hosts have a "Fibre Channel: QLogic
> Corp. ISP2432-based 4Gb Fibre Channel to PCI Express HBA" FC HBA and are
> located in the same physical rack, along with FC switches and the disk
> arrays. The machines are connected over a pair of FC switches (IBM
> System Storage SAN24B-4, by Brocade) to three disk arrays (Nexsan
> SATABeast2). All boxes have run without any issues for more than a year.
> =

> The disk arrays are configured to export 16TB block devices to the
> hosts. It looks like we set up GPT labeling on the raw block devices
> back when we installed the machines, but since that, we've created XFS
> filesystems on raw devices, without any partitioning below. There's
> still the secondary GPT header at the end of the block device, though,
> and a record [1] in RHEL4's Bugzilla mentions that certain tools invoked
> by the init scripts could try to "fix" the GPT entry at the beginning of
> the partition. Please note that we're running SL 5.4, not 4.x, so this
> issue should not affect us.
> =

> Anyway, this is how our trouble started on one of the IBM machines,
> named dpmpool5:
> =

> Mar 30 12:19:33 dpmpool5 kernel: Filesystem "dm-6": XFS internal error
> xfs_btree_check_sblock at line 307 of file fs/xfs/xfs_btree.c.  Caller
> 0xffffffff885281d9
> Mar 30 12:19:33 dpmpool5 kernel:
> Mar 30 12:19:33 dpmpool5 kernel: Call Trace:
> Mar 30 12:19:33 dpmpool5 kernel:  [<ffffffff88518bfa>]
> :xfs:xfs_btree_check_sblock+0xaf/0xbe
> Mar 30 12:19:33 dpmpool5 kernel:  [<ffffffff885281d9>]
> :xfs:xfs_inobt_lookup+0x10c/0x2ac

A corrupted inode allocation btree block.

.....
> The same issue re-occurs at 12:25:52, 12:56:27 and 13:29:58. After that,
> it happened on dm-1 at 14:04:43, and the log then reads:
> =

> Mar 30 14:04:44 dpmpool5 kernel: xfs_force_shutdown(dm-1,0x8) called
> from line 4269 of file fs/xfs/xfs_bmap.c.  Return address =3D
> 0xffffffff8850d796
> Mar 30 14:04:44 dpmpool5 kernel: Filesystem "dm-1": Corruption of
> in-memory data detected.  Shutting down filesystem: dm-1
> Mar 30 14:04:44 dpmpool5 kernel: Please umount the filesystem, and
> rectify the problem(s)

Did you do this?

> Then the dm-6 oopsed again:

It's not a kernel oops - it's a corruption report!

> Mar 30 14:04:46 dpmpool5 kernel: Filesystem "dm-6": XFS internal error
> xfs_btree_check_sblock at line 307 of file fs/xfs/xfs_btree.c.  Caller
> 0xffffffff885281d9
> Mar 30 14:04:46 dpmpool5 kernel:
> Mar 30 14:04:46 dpmpool5 kernel: Call Trace:
> Mar 30 14:04:46 dpmpool5 kernel:  [<ffffffff88518bfa>]
> :xfs:xfs_btree_check_sblock+0xaf/0xbe
> Mar 30 14:04:46 dpmpool5 kernel:  [<ffffffff885281d9>]
> :xfs:xfs_inobt_lookup+0x10c/0x2ac
> Mar 30 14:04:46 dpmpool5 kernel:  [<ffffffff88518727>]
> :xfs:xfs_btree_init_cursor+0x31/0x1a3
> Mar 30 14:04:46 dpmpool5 kernel:  [<ffffffff88526f9c>]
> :xfs:xfs_difree+0x17c/0x452

It's tripped over the same corruption.

....

> The error also showed up on other filesystems, I'm not including them
> here, as they're the same as what I've already shown.
> =

> Then, at 15:59:30, someone (very likely a colleague) tried to mount
> filesystem dm-0 (it was umounted as a result of an internal XFS error at
> 14:08:07). This is what showed up in the kernel's log:
> =

> Mar 30 15:59:30 dpmpool5 kernel: Filesystem "dm-0": Disabling barriers,
> trial barrier write failed
> Mar 30 15:59:30 dpmpool5 kernel: XFS mounting filesystem dm-0
> Mar 30 15:59:30 dpmpool5 kernel: Starting XFS recovery on filesystem:
> dm-0 (logdev: internal)
> Mar 30 15:59:30 dpmpool5 kernel: 00000000: 45 46 49 20 50 41 52 54 00 00
> 01 00 5c 00 00 00  EFI PART....\...
> Mar 30 15:59:30 dpmpool5 kernel: Filesystem "dm-0": XFS internal error
> xfs_alloc_read_agf at line 2194 of file fs/xfs/xfs_alloc.c.  Caller
> 0xffffffff885044ed
> Mar 30 15:59:30 dpmpool5 kernel:
> Mar 30 15:59:30 dpmpool5 kernel: Call Trace:
> Mar 30 15:59:30 dpmpool5 kernel:  [<ffffffff885028b7>]
> :xfs:xfs_alloc_read_agf+0x10f/0x192

and you've also got a corrupted AGF header.

.....

> Mar 30 15:59:31 dpmpool5 kernel: Failed to recover EFIs on filesystem: dm=
-0
> Mar 30 15:59:31 dpmpool5 kernel: XFS: log mount finish failed
> Mar 30 15:59:31 dpmpool5 multipathd: dm-0: umount map (uevent)
> =

> It looks like the "Failed to recover EFIs on filesystem" is not related
> to the EFI GPTs, right?

EFI =3D Extent Free Intent. It's a transaction item for the two-phase
extent deletion transaction (completed by a EFD - Extent Free Done -
transaction item). So it's not related to GPT at all.

> What puzzles me, though, is the hex dump of the
> disk contents (is that the XFS superblock?) which clearly shows trace of
> the EFI GPT partitioning.

It's from an AGF, which is not at the start of the disk, either. So
it appears like something has written crap to random locations in
your filesystem.

.....

> Sorry for a long introduction, but this is where this starts to get
> interesting, and it only occurred to me after I wrote this message.
> There's one more machine connected to that FC network, which was not
> supposed to be using its FC card at the time our trouble started. A
> colleague of mine was re-kickstarting the machine for a different
> purpose. The installation was a pretty traditional PXE setup of SL 5.5
> with the following KS setup for partitioning:
> =

> zerombr yes
> clearpart --all --initlabel
> part swap --size=3D1024 --asprimary
> part / --fstype ext3 --size=3D0 --grow --asprimary

There your problem - hello random crap....

Given the nature of the problem, I have to assume you aren't using
FC zoning to prevent hosts from seeing disks that don't belong to
them?

> The only source of information for timing of the installation are the
> logs from our DHCP server and Apache and timestamps at the reinstalled
> box, which suggest that the installation started at 11:43:06 and
> finished at 11:49:04.
> =

> So, to conclude, what we have here is that XFS filesystems on three
> boxes were hosed at roughly the same time when another box connected to
> the same FC SAN were undergoing reinstallation which was not supposed to
> touch the FC disks at all. What I'd like to ask here is what kind of
> corruption must have happened in order to trigger the XFS errors I
> showed in this e-mail.

Write stuff to metadata blocks that is not XFS metadata. Next time
XFS reads the corrupted block, it will throw a corruption error and
shutdown, just like you've seen.

> Would a "restore" of GPT partition table at the
> beginning of a disk from the copy at the end qualify as a possible
> candidate?

No. The log messages have already told you what your next step is.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
