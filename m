Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6P5Q3hd243299 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 00:26:03 -0500
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DDA3F00989
	for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 22:26:01 -0700 (PDT)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	xUp5EqyMUqlMLE0R for <xfs@oss.sgi.com>;
	Sun, 24 Jul 2011 22:26:01 -0700 (PDT)
Received: by iyf40 with SMTP id 40so4593321iyf.26
	for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 22:26:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110724013457.GB31951@dastard>
References: <CADDb1s3X5PANPrrz=GRZZyKmSK1=xiBQ8+zz3WNTW6xN=c80PQ@mail.gmail.com>
	<CADDb1s04zm48uQ0mZAUsNZ_rDX-KnSHNeFsYb06Hg10k59ijOQ@mail.gmail.com>
	<CADDb1s2rcEvik3Tb4zooq93A6BSP+W9K87VdJEWLN9iHY1StMQ@mail.gmail.com>
	<20110722083457.GC13963@dastard>
	<CADDb1s1MpajXEHhMVf-h2K1JKQqaDLZ0QQY41seURUpde8D7Sg@mail.gmail.com>
	<20110724013457.GB31951@dastard>
Date: Mon, 25 Jul 2011 10:56:01 +0530
Message-ID: <CADDb1s3JnFQiKqjD6ANDkUUyCtVwg=LDeKe4piK3ZwzQ6FK83w@mail.gmail.com>
Subject: Re: XFS internal error XFS_WANT_CORRUPTED_GOTO
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
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

On Sun, Jul 24, 2011 at 7:04 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Jul 22, 2011 at 04:03:53PM +0530, Amit Sahrawat wrote:
>> On Fri, Jul 22, 2011 at 2:04 PM, Dave Chinner <david@fromorbit.com> wrot=
e:
>> > [<c0023000>] (dump_backtrace+0x0/0x110)
>> > [<c02dd668>] (dump_stack+0x0/0x1c)
>> > [<c0176b84>] (xfs_error_report+0x0/0x5c)
>> > [<c0150cd4>] (xfs_free_ag_extent+0x0/0x600)
>> > [<c0152b78>] (xfs_free_extent+0x0/0xa4)
>> > [<c015fea0>] (xfs_bmap_finish+0x0/0x194)
>> > [<c017e664>] (xfs_itruncate_finish+0x0/0x30c)
>> > [<c0197bbc>] (xfs_inactive+0x0/0x40c)
>> > [<c01a3d50>] (xfs_fs_clear_inode+0x0/0x60)
>> > [<c00bdcf8>] (clear_inode+0x0/0xe8)
>> > [<c00be4a8>] (generic_delete_inode+0x0/0x178)
>> > [<c00be620>] (generic_drop_inode+0x0/0x68)
>> > [<c00bd2fc>] (iput+0x0/0x7c)
>> > [<c00b4b44>] (do_unlinkat+0x0/0x154)
>> > [<c00b4c98>] (sys_unlink+0x0/0x1c)
>> >
>> > So, you powered off an active machine while writing to it, and after
>> > it started back up it hit a free space between corruption. And then
>> > you couldn't mount it because log replay was trying to replay the
>> > last committed transaction to the log. That transaction shows inode
>> > 132 being unlinked, added to the AGI unliked list, and then being
>> > inactivated. There is an EFI committed for 1 extent. There is no EFD
>> > committed, so the shutdown occurred during that operation. Log
>> > replay then hits the corruption repeatedly by trying to replay the
>> > EFI to complete the extent free operation.
>> >
>> Yes, it happened exactly as you mentioned above. But the problem
>> happened much earlier.
>
> Obviously.
>
>> While writing the 'reset' happened. At the next reboot - the
>> filesystem mounted even though there
>> was corruption - the file and journal did not match.
>
> You found this how?
Just before removing the file on next 'reboot' - I checked the values
for file extents and the 'by-block' tree free length.
File extents - no. of blocks was correct but the neighbouring blocks
do not match with the occupied blocks in the allocation group.
If a file of 'N' blocks is present in an allocation group, then the
allocation group should now have (X-N) free blocks, where 'X' is the
size of allocation group in blocks.
But in this case - free size of allocation group is (X - M), where M
is greater than 'N'.
which means when there is a free request for that file and then
corresponsing blocks are checked in the allocation group - it will
show the blocks as already free and point to corruption.
Is the above observation  correct?
>
>> And it did not
>> show any error either.
>
> Well, no. If the journal format is intact, then it's contents are
> trusted.
>
>> The moment the issue happened and then if checked through xfs_logprint
>> - the blocks free in the allocation group does not match up properly.
>> I checked by taking the print from xfs_free_ag_extent - it showed the
>> wrong blocks contigous to that file.
>
> Yes, which is why I suspect that the journal contained something it
> shouldn't have.
>
>> Original file which was to be deleted is of '255' blocks and started
>> from physical block number - 12.
>
> Yes, I saw that in the EFI record in the logprint output I quoted.
>
>> While the free space tree has free
>> blocks larger than what it should be. it returns the length starting
>> from block number and the length which is last committed to the log.
>>
>> As I mentioned in the last mail - the details about the observation.
>> Please check.
>
> Going back to the transaction you quoted first: it doesn't match the
> entries in the log print you attached in your second email. I can't
> comment on it at all.
In the last mail - I attached the log where-in 'reset' happened but
there was no corruption. Just to check that what all is recorded in
journal, and this time journal matched with the data on the disk.
>
>> > So, the log and the repair output are useless for determining what
>> > caused the problem - you need the log from the mount *before* the
>> > first shutdown occurred, and to have run repair *before* you
>> > tried to unlink anything.
>>
>> It is only after 'first shutdown' I came to know about the corruption.
>> Since, there was no error shown at the mount time, it did not seemed
>> reasonable enough to run "repair" on the disk.
>
> It's standard practice for power failure integrity testing.
Yes, Even I agree to this. But why was there a mount at first hand? I
guess if it returned some error - xfs_repair could be run.

>
>> But at the same time I checked with the case(reset while direct-IO),
>> when there was no issue - I tried to check the logs the same way as
>> you mentioned
>> - reset - log_print - check using xfs_repair and then mount - the
>> behaviour was as per the logs - =A0The number of commit transactions and
>> the files created was ok.
>> Logs are attached for xfs_logprint output.
>>
>> mount after taking the log prints.
>>
>> #mount /dev/sdb1 /media/b
>> XFS mounting filesystem sda1
>> Starting XFS recovery on filesystem: sda1 (logdev: internal)
>> Ending XFS recovery on filesystem: sda1 (logdev: internal)
>>
>> #> ls -li /media/b
>> =A0 =A0 131 -rwxr-xr-x =A0 =A01 root =A0 =A0 0 =A0 =A0 =A0 =A0 =A0288718=
4 Jan =A01 00:00 test_code
>> =A0 =A0 132 -rw-r--r-- =A0 =A01 root =A0 =A0 0 =A0 =A0 =A0 =A0 =A0104448=
0 Jan =A01 00:00
>> direct_io_file_0
>> =A0 =A0 133 -rw-r--r-- =A0 =A01 root =A0 =A0 0 =A0 =A0 =A0 =A0 =A0 81920=
0 Jan =A01 00:00
>> direct_io_file_1
>
> Last entry in the log for inode 133 is this:
>
> Oper (480): tid: 738ef289 =A0len: 56 =A0clientid: TRANS =A0flags: none
> INODE: #regs: 3 =A0 ino: 0x85 =A0flags: 0x5 =A0 dsize: 16
> =A0 =A0 =A0 =A0blkno: 64 =A0len: 16 =A0boff: 1280
> Oper (481): tid: 738ef289 =A0len: 96 =A0clientid: TRANS =A0flags: none
> INODE CORE
> magic 0x494e mode 0100644 version 2 format 2
> nlink 1 uid 0 gid 0
> atime 0xc mtime 0xd ctime 0xd
> size 0xc9400 nblocks 0xcb extsize 0x0 nextents 0x1
> naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
> flags 0x0 gen 0x0
> Oper (482): tid: 738ef289 =A0len: 16 =A0clientid: TRANS =A0flags: none
> EXTENTS inode data
>
> The inode size is 0xc9400 =3D 824,320 bytes, and blocks =3D 0xcb =3D 203 =
=3D
> 831,488 bytes. So there's nothing wrong here. Indeed, it appears
> this transaction was not replayed because:
>
> -------------------------------------------------------------------------=
---
> Oper (477): tid: 44eff979 =A0len: 0 =A0clientid: TRANS =A0flags: COMMIT
> Oper (478): tid: 738ef289 =A0len: 0 =A0clientid: TRANS =A0flags: START
> Oper (479): tid: 738ef289 =A0len: 16 =A0clientid: TRANS =A0flags: none
> Oper (480): tid: 738ef289 =A0len: 56 =A0clientid: TRANS =A0flags: none
> Oper (481): tid: 738ef289 =A0len: 96 =A0clientid: TRANS =A0flags: none
> Oper (482): tid: 738ef289 =A0len: 16 =A0clientid: TRANS =A0flags: none
> Oper (483): tid: 738ef289 =A0len: 24 =A0clientid: TRANS =A0flags: none
> Oper (484): tid: 738ef289 =A0len: 128 =A0clientid: TRANS =A0flags: none
> Oper (485): tid: 738ef289 =A0len: 28 =A0clientid: TRANS =A0flags: none
> Oper (486): tid: 738ef289 =A0len: 128 =A0clientid: TRANS =A0flags: none
> Oper (487): tid: 738ef289 =A0len: 20 =A0clientid: TRANS =A0flags: CONTINUE
> BUF: =A0#regs: 2 =A0 Not printing rest of data
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> xfs_logprint: skipped 3510 cleared blocks in range: 592 - 4101
> xfs_logprint: skipped 61434 zeroed blocks in range: 4102 - 65535
> xfs_logprint: physical end of log
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> xfs_logprint: logical end of log
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>
>
> The transaction was never committed completely in the journal. The
> last complete transaction in the journal matches up with the inode
> size in your ls -l output about.
Yes, this is what I wanted to show using the latest log prints. But
this is not case when there is an issue.
>
> Your test code is obviously doing single block allocation (probably
> 4k DIO append writes). I can't see any inconsistencies with what is
The test case is just writing to a file using DIO. Write buffer
request is '5K' - issue write request in a loop - 204 times. Final
File size - 1020K.

> in the journal, with what you see from ls -l, nor any
> inconsistencies with the AGF spce accounting. Hence I suspect that
> it's either a barrier problem, or perhaps yet another manifestation
> of vmap cache aliasing causing random corruption during journal
> replay. Can you verify that the transactions being replayed match
> the contents of the logprint output (i.e. the entire transactions
> including buffer data matches, and not just the transaction IDs).

Barrier is enabled on my target and it does not have cache aliasing
problem either.
I have ARM cortex a9 - single core.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
