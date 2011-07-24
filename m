Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6O1Z3f4184630 for <xfs@oss.sgi.com>; Sat, 23 Jul 2011 20:35:04 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A69581683FF2
	for <xfs@oss.sgi.com>; Sat, 23 Jul 2011 18:35:00 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Ct8v6FktdKHfVPLW for <xfs@oss.sgi.com>;
	Sat, 23 Jul 2011 18:35:00 -0700 (PDT)
Date: Sun, 24 Jul 2011 11:34:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20110724013457.GB31951@dastard>
References: <CADDb1s3X5PANPrrz=GRZZyKmSK1=xiBQ8+zz3WNTW6xN=c80PQ@mail.gmail.com>
	<CADDb1s04zm48uQ0mZAUsNZ_rDX-KnSHNeFsYb06Hg10k59ijOQ@mail.gmail.com>
	<CADDb1s2rcEvik3Tb4zooq93A6BSP+W9K87VdJEWLN9iHY1StMQ@mail.gmail.com>
	<20110722083457.GC13963@dastard>
	<CADDb1s1MpajXEHhMVf-h2K1JKQqaDLZ0QQY41seURUpde8D7Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADDb1s1MpajXEHhMVf-h2K1JKQqaDLZ0QQY41seURUpde8D7Sg@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 22, 2011 at 04:03:53PM +0530, Amit Sahrawat wrote:
> On Fri, Jul 22, 2011 at 2:04 PM, Dave Chinner <david@fromorbit.com> wrote:
> > [<c0023000>] (dump_backtrace+0x0/0x110)
> > [<c02dd668>] (dump_stack+0x0/0x1c)
> > [<c0176b84>] (xfs_error_report+0x0/0x5c)
> > [<c0150cd4>] (xfs_free_ag_extent+0x0/0x600)
> > [<c0152b78>] (xfs_free_extent+0x0/0xa4)
> > [<c015fea0>] (xfs_bmap_finish+0x0/0x194)
> > [<c017e664>] (xfs_itruncate_finish+0x0/0x30c)
> > [<c0197bbc>] (xfs_inactive+0x0/0x40c)
> > [<c01a3d50>] (xfs_fs_clear_inode+0x0/0x60)
> > [<c00bdcf8>] (clear_inode+0x0/0xe8)
> > [<c00be4a8>] (generic_delete_inode+0x0/0x178)
> > [<c00be620>] (generic_drop_inode+0x0/0x68)
> > [<c00bd2fc>] (iput+0x0/0x7c)
> > [<c00b4b44>] (do_unlinkat+0x0/0x154)
> > [<c00b4c98>] (sys_unlink+0x0/0x1c)
> >
> > So, you powered off an active machine while writing to it, and after
> > it started back up it hit a free space between corruption. And then
> > you couldn't mount it because log replay was trying to replay the
> > last committed transaction to the log. That transaction shows inode
> > 132 being unlinked, added to the AGI unliked list, and then being
> > inactivated. There is an EFI committed for 1 extent. There is no EFD
> > committed, so the shutdown occurred during that operation. Log
> > replay then hits the corruption repeatedly by trying to replay the
> > EFI to complete the extent free operation.
> >
> Yes, it happened exactly as you mentioned above. But the problem
> happened much earlier.

Obviously.

> While writing the 'reset' happened. At the next reboot - the
> filesystem mounted even though there
> was corruption - the file and journal did not match.

You found this how?

> And it did not
> show any error either.

Well, no. If the journal format is intact, then it's contents are
trusted.

> The moment the issue happened and then if checked through xfs_logprint
> - the blocks free in the allocation group does not match up properly.
> I checked by taking the print from xfs_free_ag_extent - it showed the
> wrong blocks contigous to that file.

Yes, which is why I suspect that the journal contained something it
shouldn't have.

> Original file which was to be deleted is of '255' blocks and started
> from physical block number - 12.

Yes, I saw that in the EFI record in the logprint output I quoted.

> While the free space tree has free
> blocks larger than what it should be. it returns the length starting
> from block number and the length which is last committed to the log.
> 
> As I mentioned in the last mail - the details about the observation.
> Please check.

Going back to the transaction you quoted first: it doesn't match the
entries in the log print you attached in your second email. I can't
comment on it at all.

> > So, the log and the repair output are useless for determining what
> > caused the problem - you need the log from the mount *before* the
> > first shutdown occurred, and to have run repair *before* you
> > tried to unlink anything.
> 
> It is only after 'first shutdown' I came to know about the corruption.
> Since, there was no error shown at the mount time, it did not seemed
> reasonable enough to run "repair" on the disk.

It's standard practice for power failure integrity testing.

> But at the same time I checked with the case(reset while direct-IO),
> when there was no issue - I tried to check the logs the same way as
> you mentioned
> - reset - log_print - check using xfs_repair and then mount - the
> behaviour was as per the logs -  The number of commit transactions and
> the files created was ok.
> Logs are attached for xfs_logprint output.
> 
> mount after taking the log prints.
> 
> #mount /dev/sdb1 /media/b
> XFS mounting filesystem sda1
> Starting XFS recovery on filesystem: sda1 (logdev: internal)
> Ending XFS recovery on filesystem: sda1 (logdev: internal)
> 
> #> ls -li /media/b
>     131 -rwxr-xr-x    1 root     0          2887184 Jan  1 00:00 test_code
>     132 -rw-r--r--    1 root     0          1044480 Jan  1 00:00
> direct_io_file_0
>     133 -rw-r--r--    1 root     0           819200 Jan  1 00:00
> direct_io_file_1

Last entry in the log for inode 133 is this:

Oper (480): tid: 738ef289  len: 56  clientid: TRANS  flags: none
INODE: #regs: 3   ino: 0x85  flags: 0x5   dsize: 16
        blkno: 64  len: 16  boff: 1280
Oper (481): tid: 738ef289  len: 96  clientid: TRANS  flags: none
INODE CORE
magic 0x494e mode 0100644 version 2 format 2
nlink 1 uid 0 gid 0
atime 0xc mtime 0xd ctime 0xd
size 0xc9400 nblocks 0xcb extsize 0x0 nextents 0x1
naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
flags 0x0 gen 0x0
Oper (482): tid: 738ef289  len: 16  clientid: TRANS  flags: none
EXTENTS inode data

The inode size is 0xc9400 = 824,320 bytes, and blocks = 0xcb = 203 =
831,488 bytes. So there's nothing wrong here. Indeed, it appears
this transaction was not replayed because:

----------------------------------------------------------------------------
Oper (477): tid: 44eff979  len: 0  clientid: TRANS  flags: COMMIT
Oper (478): tid: 738ef289  len: 0  clientid: TRANS  flags: START
Oper (479): tid: 738ef289  len: 16  clientid: TRANS  flags: none
Oper (480): tid: 738ef289  len: 56  clientid: TRANS  flags: none
Oper (481): tid: 738ef289  len: 96  clientid: TRANS  flags: none
Oper (482): tid: 738ef289  len: 16  clientid: TRANS  flags: none
Oper (483): tid: 738ef289  len: 24  clientid: TRANS  flags: none
Oper (484): tid: 738ef289  len: 128  clientid: TRANS  flags: none
Oper (485): tid: 738ef289  len: 28  clientid: TRANS  flags: none
Oper (486): tid: 738ef289  len: 128  clientid: TRANS  flags: none
Oper (487): tid: 738ef289  len: 20  clientid: TRANS  flags: CONTINUE
BUF:  #regs: 2   Not printing rest of data

============================================================================
xfs_logprint: skipped 3510 cleared blocks in range: 592 - 4101
xfs_logprint: skipped 61434 zeroed blocks in range: 4102 - 65535
xfs_logprint: physical end of log
============================================================================
xfs_logprint: logical end of log
============================================================================


The transaction was never committed completely in the journal. The
last complete transaction in the journal matches up with the inode
size in your ls -l output about.

Your test code is obviously doing single block allocation (probably
4k DIO append writes). I can't see any inconsistencies with what is
in the journal, with what you see from ls -l, nor any
inconsistencies with the AGF spce accounting. Hence I suspect that
it's either a barrier problem, or perhaps yet another manifestation
of vmap cache aliasing causing random corruption during journal
replay. Can you verify that the transactions being replayed match
the contents of the logprint output (i.e. the entire transactions
including buffer data matches, and not just the transaction IDs).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
