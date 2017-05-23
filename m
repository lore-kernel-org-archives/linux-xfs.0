Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29592 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934276AbdEWQRK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2017 12:17:10 -0400
Date: Tue, 23 May 2017 09:17:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/3] xfs: improve transaction log res. overrun reporting
Message-ID: <20170523161703.GS4519@birch.djwong.org>
References: <1494276307-36887-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1494276307-36887-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, May 08, 2017 at 04:45:04PM -0400, Brian Foster wrote:
> Hi all,
> 
> This is a first pass at improved transaction log reservation overrun
> reporting based on Dave's suggestion[1]. This essentially creates a new
> helper to dump transaction info (i.e., logged items) along with ticket
> data in the event of an overrun and refactors things a bit to be able to
> call it from a context where an accurate calculation of the reservation
> requirement is available but the log items have not been removed from
> the transaction.
> 
> Note that this increases the amount of output on a tx overrun quite a
> bit, particularly if the transaction includes multiple log
> items/vectors, but I opted for verbosity and to retain the current
> format for the first iteration. I'm curious if anybody has thoughts on
> formatting, what data to include or not, whether to tie certain things
> (i.e., raw buffer data?) to the current log level, general level of
> detail, etc. Sample output from a fabricated overrun is shown below[2].
> 
> Lightly tested so far. Thoughts, reviews, flames appreciated.

Offhand this looks ok; will add it to my dev tree and go run something
that exhausts a transaction reservation to see it in action.  For now,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Brian
> 
> [1] http://www.spinics.net/lists/linux-xfs/msg06446.html
> [2] Output from an fallocate request after the write transaction
> reservation is erroneously reduced to 32 bytes:
> 
>  ------------[ cut here ]------------
>  WARNING: CPU: 1 PID: 1621 at fs/xfs//xfs_log_cil.c:466 xfs_log_commit_cil+0x6d5/0x790 [xfs]
>  ...
>  Call Trace:
>   dump_stack+0x86/0xc3
>   __warn+0xcb/0xf0
>   warn_slowpath_null+0x1d/0x20
>   xfs_log_commit_cil+0x6d5/0x790 [xfs]
>   __xfs_trans_commit+0x82/0x280 [xfs]
>   xfs_trans_commit+0x10/0x20 [xfs]
>   xfs_alloc_file_space+0x22a/0x4c0 [xfs]
>   xfs_file_fallocate+0x230/0x3b0 [xfs]
>   ? rcu_read_lock_sched_held+0x4a/0x80
>   ? rcu_sync_lockdep_assert+0x2f/0x60
>   ? __sb_start_write+0xe9/0x210
>   ? vfs_fallocate+0x214/0x280
>   vfs_fallocate+0x159/0x280
>   SyS_fallocate+0x48/0x80
>   entry_SYSCALL_64_fastpath+0x1f/0xc2
>  ...
>  ---[ end trace e928d52baa488ea3 ]---
>  XFS (dm-3): Transaction log reservation overrun:
>  XFS (dm-3):   log items: 876 bytes (iov hdrs: 120 bytes)
>  XFS (dm-3):   split region headers: 0 bytes
>  XFS (dm-3):   ctx ticket: 2100 bytes
>  XFS (dm-3): transaction summary:
>  XFS (dm-3):   flags	= 0x5
>  XFS (dm-3): ticket reservation summary:
>  XFS (dm-3):   unit res    = 2132 bytes
>  XFS (dm-3):   current res = -844 bytes
>  XFS (dm-3):   total reg   = 0 bytes (o/flow = 0 bytes)
>  XFS (dm-3):   ophdrs      = 0 (ophdr space = 0 bytes)
>  XFS (dm-3):   ophdr + reg = 0 bytes
>  XFS (dm-3):   num regions = 0
>  XFS (dm-3): log item: 
>  XFS (dm-3):   type	= 0x123b
>  XFS (dm-3):   flags	= 0x1
>  XFS (dm-3):   niovecs	= 4
>  XFS (dm-3):   size	= 720
>  XFS (dm-3):   bytes	= 300
>  XFS (dm-3):   buf len	= 304
>  XFS (dm-3):   iovec[0]
>  XFS (dm-3):     type	= 0x5
>  XFS (dm-3):     len	= 56
>  XFS (dm-3):     first 32 bytes of iovec[0]:
>  ffff984954ea2c78: 3b 12 04 00 45 00 00 00 34 00 10 00 49 98 ff ff  ;...E...4...I...
>  ffff984954ea2c88: 63 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  c...............
>  XFS (dm-3):   iovec[1]
>  XFS (dm-3):     type	= 0x6
>  XFS (dm-3):     len	= 176
>  XFS (dm-3):     first 32 bytes of iovec[1]:
>  ffff984954ea2cb0: 4e 49 a4 81 03 02 00 00 00 00 00 00 00 00 00 00  NI..............
>  ffff984954ea2cc0: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  XFS (dm-3):   iovec[2]
>  XFS (dm-3):     type	= 0x7
>  XFS (dm-3):     len	= 16
>  XFS (dm-3):     first 16 bytes of iovec[2]:
>  ffff984954ea2d60: 80 00 00 00 00 00 00 00 00 00 00 00 02 80 01 00  ................
>  XFS (dm-3):   iovec[3]
>  XFS (dm-3):     type	= 0xc
>  XFS (dm-3):     len	= 52
>  XFS (dm-3):     first 32 bytes of iovec[3]:
>  ffff984954ea2d70: 00 33 01 00 07 25 04 73 65 6c 69 6e 75 78 75 6e  .3...%.selinuxun
>  ffff984954ea2d80: 63 6f 6e 66 69 6e 65 64 5f 75 3a 6f 62 6a 65 63  confined_u:objec
>  XFS (dm-3): log item: 
>  XFS (dm-3):   type	= 0x123c
>  XFS (dm-3):   flags	= 0x0
>  XFS (dm-3):   niovecs	= 2
>  XFS (dm-3):   size	= 256
>  XFS (dm-3):   bytes	= 152
>  XFS (dm-3):   buf len	= 152
>  XFS (dm-3):   iovec[0]
>  XFS (dm-3):     type	= 0x1
>  XFS (dm-3):     len	= 24
>  XFS (dm-3):     first 24 bytes of iovec[0]:
>  ffff9849532d1258: 3c 12 02 00 00 28 01 00 01 00 00 00 00 00 00 00  <....(..........
>  ffff9849532d1268: 01 00 00 00 01 00 00 00                          ........
>  XFS (dm-3):   iovec[1]
>  XFS (dm-3):     type	= 0x2
>  XFS (dm-3):     len	= 128
>  XFS (dm-3):     first 32 bytes of iovec[1]:
>  ffff9849532d1270: 58 41 47 46 00 00 00 01 00 00 00 00 00 0f 00 00  XAGF............
>  ffff9849532d1280: 00 00 00 01 00 00 00 02 00 00 00 00 00 00 00 01  ................
>  XFS (dm-3): log item: 
>  XFS (dm-3):   type	= 0x123c
>  XFS (dm-3):   flags	= 0x0
>  XFS (dm-3):   niovecs	= 2
>  XFS (dm-3):   size	= 256
>  XFS (dm-3):   bytes	= 152
>  XFS (dm-3):   buf len	= 152
>  XFS (dm-3):   iovec[0]
>  XFS (dm-3):     type	= 0x1
>  XFS (dm-3):     len	= 24
>  XFS (dm-3):     first 24 bytes of iovec[0]:
>  ffff9849532d1358: 3c 12 02 00 00 20 08 00 10 00 00 00 00 00 00 00  <.... ..........
>  ffff9849532d1368: 01 00 00 00 01 00 00 00                          ........
>  XFS (dm-3):   iovec[1]
>  XFS (dm-3):     type	= 0x2
>  XFS (dm-3):     len	= 128
>  XFS (dm-3):     first 32 bytes of iovec[1]:
>  ffff9849532d1370: 41 42 33 43 00 00 00 02 ff ff ff ff ff ff ff ff  AB3C............
>  ffff9849532d1380: 00 00 00 00 00 00 00 10 00 00 00 01 00 00 00 54  ...............T
>  XFS (dm-3): log item: 
>  XFS (dm-3):   type	= 0x123c
>  XFS (dm-3):   flags	= 0x0
>  XFS (dm-3):   niovecs	= 2
>  XFS (dm-3):   size	= 256
>  XFS (dm-3):   bytes	= 152
>  XFS (dm-3):   buf len	= 152
>  XFS (dm-3):   iovec[0]
>  XFS (dm-3):     type	= 0x1
>  XFS (dm-3):     len	= 24
>  XFS (dm-3):     first 24 bytes of iovec[0]:
>  ffff9849532d1558: 3c 12 02 00 00 20 08 00 08 00 00 00 00 00 00 00  <.... ..........
>  ffff9849532d1568: 01 00 00 00 01 00 00 00                          ........
>  XFS (dm-3):   iovec[1]
>  XFS (dm-3):     type	= 0x2
>  XFS (dm-3):     len	= 128
>  XFS (dm-3):     first 32 bytes of iovec[1]:
>  ffff9849532d1570: 41 42 33 42 00 00 00 02 ff ff ff ff ff ff ff ff  AB3B............
>  ffff9849532d1580: 00 00 00 00 00 00 00 08 00 00 00 01 00 00 00 54  ...............T
>  XFS (dm-3): xfs_do_force_shutdown(0x2) called from line 501 of file fs/xfs//xfs_log_cil.c.  Return address = 0xffffffffc041e56b
>  XFS (dm-3): Log I/O Error Detected.  Shutting down filesystem
>  XFS (dm-3): Please umount the filesystem and rectify the problem(s)
> 
> Brian Foster (3):
>   xfs: separate shutdown from ticket reservation print helper
>   xfs: refactor xlog_cil_insert_items() to facilitate transaction dump
>   xfs: dump transaction usage details on log reservation overrun
> 
>  fs/xfs/xfs_log.c      | 59 +++++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_log_cil.c  | 84 ++++++++++++++++++++++++++++++---------------------
>  fs/xfs/xfs_log_priv.h |  1 +
>  3 files changed, 105 insertions(+), 39 deletions(-)
> 
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
