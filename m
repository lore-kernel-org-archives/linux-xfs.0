Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Oct 2006 20:47:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9I3lmaG027987
	for <xfs@oss.sgi.com>; Tue, 17 Oct 2006 20:47:51 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71F59D19843E
	for <xfs@oss.sgi.com>; Tue, 17 Oct 2006 20:47:06 -0700 (PDT)
Message-ID: <4535A3BE.9000006@sandeen.net>
Date: Tue, 17 Oct 2006 22:47:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: corrupted log causes infinite loop at mount
References: <452FECFE.5050902@sandeen.net> <4531CC5D.5010705@melbourne.sgi.com> <45323F7F.80807@sandeen.net>
In-Reply-To: <45323F7F.80807@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: chatz@melbourne.sgi.com, xfs@oss.sgi.com

Eric Sandeen wrote:
> David Chatterton wrote:
>> I assume the loop is further up the chain since kmem_alloc should 
>> return NULL
>> when asked to alloc 0. So then the problem also lies further up the 
>> chain in
>> checking for a 0 length before calling down, and/or not assuming we 
>> are out of
>> memory when xfs_buf_get_noaddr fails.
> 
> Well, I set kdb breakpoints, and we only entered xfs_buf_get_noaddr 
> once, so I assume it's looping inside.  But I was looking for bugs on, 
> um, another filesystem at the time, so didn't investigate much.
> 
> I can put it on my list of spare-time bugs to look at, or just thought 
> you guys may be interested as well.

<spare-time>

well, as a quick fix, this seems to do the trick:

--- linux-2.6.18.orig/fs/xfs/xfs_log_recover.c
+++ linux-2.6.18/fs/xfs/xfs_log_recover.c
@@ -75,6 +75,9 @@ xlog_get_bp(
         int             num_bblks)
  {
         ASSERT(num_bblks > 0);
+       if (num_bblks <= 0) {
+               return NULL;
+       }

         if (log->l_sectbb_log) {
                 if (num_bblks > 1)

but it's not the most helpful output:

XFS: Log inconsistent (didn't find previous header)
XFS: empty log check failed
XFS: log mount/recovery failed: error 5
XFS: log mount failed

... but not that bad I guess.

it's getting the 0 allocation because last & start are equal here:

num_blks 0 last 2756 start 2756

  [<dec87bd5>] xlog_find_verify_log_record+0x45/0x2f2 [xfs]
  [<dec88254>] xlog_find_tail+0x20e/0xb8d [xfs]
  [<dec88be9>] xlog_recover+0x16/0x22d [xfs]
  [<dec84338>] xfs_log_mount+0x4e4/0x530 [xfs]
  [<dec8b2af>] xfs_mountfs+0xa58/0xf61 [xfs]
  [<dec7dd7b>] xfs_ioinit+0x1e/0x23 [xfs]
  [<dec91db8>] xfs_mount+0x7a8/0x875 [xfs]
  [<deca2713>] vfs_mount+0x17/0x1a [xfs]
  [<deca25b5>] xfs_fs_fill_super+0x6c/0x1b3 [xfs]
  [<c047bd7b>] get_sb_bdev+0xd1/0x11f
  [<deca1ac9>] xfs_fs_get_sb+0x20/0x25 [xfs]
  [<c047b933>] vfs_kern_mount+0x83/0xf6
  [<c047b9e8>] do_kern_mount+0x2d/0x3e
  [<c048ee67>] do_mount+0x5fe/0x671
  [<c048ef51>] sys_mount+0x77/0xae
  [<c0403fb3>] syscall_call+0x7/0xb

and they're equal because in xlog_find_zeroed():

         start_blk = last_blk - num_scan_bblks;

/* here, start 2756 last 3268 num_scan_bblks 512 */

         /*
          * We search for any instances of cycle number 0 that occur before
          * our current estimate of the head.  What we're trying to detect is
          *        1 ... | 0 | 1 | 0...
          *                       ^ binary search ends here
          */
         if ((error = xlog_find_verify_cycle(log, start_blk,
                                          (int)num_scan_bblks, 0, &new_blk)))
                 goto bp_err;
         if (new_blk != -1)
                 last_blk = new_blk;

/* now new last_blk == new_blk == 2756, same as start */

         /*
          * Potentially backup over partial log record write.  We don't need
          * to search the end of the log because we know it is zero.
          */
         if ((error = xlog_find_verify_log_record(log, start_blk,
                                 &last_blk, 0)) == -1) {

Maybe that's enough for Tim to come up with a better check :)

-Eric
