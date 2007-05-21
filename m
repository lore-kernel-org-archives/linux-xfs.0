Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 May 2007 00:22:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4L7MBfB023720
	for <xfs@oss.sgi.com>; Mon, 21 May 2007 00:22:12 -0700
Date: Mon, 21 May 2007 17:26:19 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: Mount Failure: Totally Zeroed Log
Message-ID: <055E345AE1C3F913656DFC26@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20070518060825.GD3340@fs3.ph>
References: <20070518060825.GD3340@fs3.ph>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Federico Sevilla III <jijo@fs3.ph>, XFS Mailing List <xfs@oss.sgi.com>

Hi,

I haven't seen that one before :)
When it says "totally zeroed log" it is actually more likely that
the h_cycle of the first log record header is zeroed.
   typedef struct xlog_rec_header {
        uint      h_magicno;    /* log record (LR) identifier           :  4 */
  --->  uint      h_cycle;      /* write cycle of log                   :  4 */
i.e. the 2nd 4byte word in the ondisk log is zero.
This should never happen on Linux (on IRIX a new log is zeroed with no records in it).
Each 512 byte sector is stamped with a cycle# which is started at 1 and never
set to zero. The cycle# is at the start of each sector or at the 2nd int
for sectors which contain log record headers.
On Linux, we always start a fresh log with an unmount record (to store the
uuid) which means a freshly mkfs'ed filesystem will always have 1 entry in it
and thus with a cycle# of 1.

The upshot is that something has corrupted at least the first sector
of your ondisk log.
If it was only the 1st sector corrupted and it wasn't in the active part
(tail to head) then with some hacking one would be able to run recovery
theoretically :).
Try a:
$ xfs_logprint -d device
to have a look at all the cycle#'s on the log to get an idea of the corruption
for interest's sake.

Hmmm...it's interesting that we don't bail out if we find this corrupted log,
after the call to xlog_find_head(). We don't return an error but return 0
and a warning. Okay, so when we try to validate the record header later,
the h_magicno is wrong too and this time we do EFSCORRUPTED.
Probably, could have done that in xlog_find_head() really.

No, I don't know what is corrupting your log.
Even with the write-cache on I would have thought it would cause
metadata inconsistencies on replay but I would not have thought it would cause
junk in the log - as the log write should still be valid (we just
have ordering issues to deal with).

--Tim


--On 18 May 2007 2:08:25 PM +0800 Federico Sevilla III <jijo@fs3.ph> wrote:

> Hi,
>
> I encountered the following error after an unclean shutdown:
>
>     Filesystem "md1": Disabling barriers, not supported by the underlying device
>     XFS mounting filesystem md1
>     XFS: totally zeroed log
>     Starting XFS recovery on filesystem: md1 (logdev: internal)
>     Filesystem "md1": XFS internal error xlog_valid_rec_header(1) at line 3503 of file
> fs/xfs/xfs_log_recover.c.  Caller 0xf8992fbd      [<f8992a5d>] xlog_valid_rec_header+0xc5/0xd5
> [xfs]
>      [<f8992fbd>] xlog_do_recovery_pass+0x550/0x90f [xfs]
>      [<f8992fbd>] xlog_do_recovery_pass+0x550/0x90f [xfs]
>      [<f89933c1>] xlog_do_log_recovery+0x45/0xa6 [xfs]
>      [<f899343f>] xlog_do_recover+0x1d/0x102 [xfs]
>      [<f89935ab>] xlog_recover+0x87/0x98 [xfs]
>      [<f898c4bd>] xfs_log_mount+0x8d/0xce [xfs]
>      [<f8994c17>] xfs_mountfs+0x982/0xc63 [xfs]
>      [<f89888ee>] xfs_ioinit+0x21/0x26 [xfs]
>      [<f899b3c6>] xfs_mount+0x30b/0x37e [xfs]
>      [<f89abf24>] vfs_mount+0x28/0x2c [xfs]
>      [<f89abdb5>] xfs_fs_fill_super+0x6e/0x193 [xfs]
>      [<c019dbd2>] snprintf+0x16/0x1a
>      [<c017a1cd>] disk_name+0x25/0x66
>      [<c0151c10>] get_sb_bdev+0xca/0x117
>      [<c0158146>] __link_path_walk+0xadd/0xbd2
>      [<f89abef8>] xfs_fs_get_sb+0x1e/0x22 [xfs]
>      [<f89abd47>] xfs_fs_fill_super+0x0/0x193 [xfs]
>      [<c0151de6>] vfs_kern_mount+0x35/0x66
>      [<c0151e40>] do_kern_mount+0x29/0x39
>      [<c0163ffd>] do_new_mount+0x67/0xa4
>      [<c01645f9>] do_mount+0x153/0x16b
>      [<c0164459>] copy_mount_options+0x4c/0x99
>      [<c016489d>] sys_mount+0x79/0xba
>      [<c010278b>] syscall_call+0x7/0xb
>     XFS: log mount/recovery failed: error 117
>     XFS: log mount failed
>
> The machine runs Debian GNU/Linux 4.0 (Etch), with a custom-built 2.6.18
> kernel using the Debian 2.6.18 source and the OpenVZ patch. xfs_repair
> is able to repair the filesystem, but most of the files just end up in
> lost+found. I have verified that write cache on both drives has been
> disabled, and hdparm is set to disable them everytime during startup.
>
> Any clues as to what could be causing this?
>
> Thank you very much.
>
> Cheers!
>
> --
> Federico Sevilla III
> F S 3 Consulting Inc.
> http://www.fs3.ph
>
