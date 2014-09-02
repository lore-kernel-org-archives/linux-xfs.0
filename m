Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 696D57F6F
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 07:36:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 44A1B8F8050
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 05:36:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fi9qAcBfjARZCd3m (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Sep 2014 05:36:46 -0700 (PDT)
Date: Tue, 2 Sep 2014 08:36:42 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix double free of trans in log recovery on I/O error
Message-ID: <20140902123641.GA24452@bfoster.bfoster>
References: <1408648692-15957-1-git-send-email-bfoster@redhat.com>
	<CAOcd+r32+6gafv5+MCNyNTH1Ncas9CJHHrku+Y=sZefDzzS1Zw@mail.gmail.com>
	<20140825142025.GA10135@bfoster.bfoster>
	<AFED541EB7FA490C8E16DCB81F400B1C@alyakaslap>
	<20140831210507.GA11913@bfoster.bfoster>
	<3476A2CBDE694DC6BD06DBDD15165151@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3476A2CBDE694DC6BD06DBDD15165151@alyakaslap>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 02, 2014 at 12:51:35PM +0300, Alex Lyakas wrote:
> Hi Brian, Dave,
> I tested this patch on 3.8.13 kernel with the scenario I described in
> http://oss.sgi.com/pipermail/xfs/2014-August/037637.html, but I still see
> the issue.
> I placed the metadump at
> https://drive.google.com/file/d/0ByBy89zr3kJNV2UxMERNTkE4aHM/edit?usp=sharing
> 
> During log recovery, 3 IO errors are encountered:
> [  340.381199] XFS (dm-0): Mounting Filesystem
> [  340.439897] XFS (dm-0): Sleep 10s before xlog_do_recover
> [  350.440143] XFS (dm-0): Starting recovery (logdev: internal)
> [  351.584647] XFS (dm-0): metadata I/O error: block 0x1
> ("xlog_recover_iodone") error 28 numblks 1
> [  351.584660] XFS (dm-0): metadata I/O error: block 0x40
> ("xlog_recover_iodone") error 28 numblks 16
> [  351.584665] XFS (dm-0): xfs_do_force_shutdown(0x1) called from line 377
> of file /mnt/work/alex/zadara-btrfs/fs/xfs/xfs_log_recover.c.  Return
> address = 0xffffffffa0372728
> [  351.584969] XFS (dm-0): I/O Error Detected. Shutting down filesystem
> [  351.584970] XFS (dm-0): Please umount the filesystem and rectify the
> problem(s)
> [  351.585047] XFS (dm-0): metadata I/O error: block 0x1e00040
> ("xlog_recover_iodone") error 28 numblks 16
> [  351.585050] XFS (dm-0): xfs_do_force_shutdown(0x1) called from line 377
> of file /mnt/work/alex/zadara-btrfs/fs/xfs/xfs_log_recover.c.  Return
> address = 0xffffffffa0372728
> [  351.585068] XFS (dm-0): log mount/recovery failed: error 28
> [  351.585332] XFS (dm-0): log mount failed
> 
> Two IO error callbacks are handled before XFS is unmounted, but the last one
> crashes with stack[1].
> 

I don't reproduce this with the metadump posted above. I suppose
hardware/timing could make a difference, however.

> Do I need some or all of the 9 patches that Dave posted? (They do not apply
> to my kernel, so I need to apply them by hand).
> 

Only the first patch is required for the stable tree. Did you have to
manually apply that one? I had to, so it might be a good idea to post it
as applied to your tree just to verify.

That aside, I suppose the problem could be that we still don't wait for
the I/O completion mechanism fully on the mount/log recovery side. E.g.,
we have a buffer reference, but the caller can still proceed to free the
mp from which the error message derives the fs name.

Brian

> Thanks,
> Alex.
> 
> 
> [1]
> [  351.592349] general protection fault: 0000 [#1] SMP
> [  351.593440] Modules linked in: xfs(O) libcrc32c dm_linear_custom(O) nfsv3
> deflate zlib_deflate ctr twofish_generic twofish_x86_64_3way glue_helper lrw
> xts gf128mul twofish_x86_64 twofish_common camellia_generic serpent_generic
> blowfish_generic blowfish_x86_64 blowfish_common cast5_generic cast_common
> des_generic xcbc rmd160 sha512_generic crypto_null af_key xfrm_algo kvm
> ppdev vfat fat dm_round_robin microcode nfsd nfs_acl parport_pc dm_iostat(O)
> dm_multipath(O) psmouse serio_raw mac_hid i2c_piix4 lp parport nfsv4
> auth_rpcgss nfs fscache lockd sunrpc floppy
> [  351.596118] CPU 3
> [  351.596118] Pid: 133, comm: kworker/3:1H Tainted: G        W  O
> 3.8.13-557-generic #1382000791 Bochs Bochs
> [  351.596118] RIP: 0010:[<ffffffff8133c2cb>]  [<ffffffff8133c2cb>]
> strnlen+0xb/0x30
> [  351.596118] RSP: 0018:ffff880035405b08  EFLAGS: 00010086
> [  351.596118] RAX: 0000000000000000 RBX: ffffffff81e6a4e7 RCX:
> 0000000000000000
> [  351.596118] RDX: e4e8390a265c0000 RSI: ffffffffffffffff RDI:
> e4e8390a265c0000
> [  351.596118] RBP: ffff880035405b08 R08: 000000000000ffff R09:
> 000000000000ffff
> [  351.596118] R10: 0000000000000000 R11: 0000000000000331 R12:
> e4e8390a265c0000
> [  351.596118] R13: ffffffff81e6a8c0 R14: 0000000000000000 R15:
> 000000000000ffff
> [  351.596118] FS:  0000000000000000(0000) GS:ffff88007fd80000(0000)
> knlGS:0000000000000000
> [  351.596118] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  351.596118] CR2: 00007fff7bfe1c38 CR3: 0000000035a59000 CR4:
> 00000000000006e0
> [  351.596118] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [  351.596118] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [  351.596118] Process kworker/3:1H (pid: 133, threadinfo ffff880035404000,
> task ffff880035ae5c00)
> [  351.596118] Stack:
> [  351.596118]  ffff880035405b48 ffffffff8133dd5e ffff880035405b28
> ffffffff81e6a4e7
> [  351.596118]  ffffffffa03b2bc4 ffff880035405c80 ffffffffa03b2bc4
> ffffffff81e6a8c0
> [  351.596118]  ffff880035405bc8 ffffffff8133ef59 ffff880035405bc8
> ffffffff81059aa7
> [  351.596118] Call Trace:
> [  351.596118]  [<ffffffff8133dd5e>] string.isra.4+0x3e/0xd0
> [  351.596118]  [<ffffffff8133ef59>] vsnprintf+0x219/0x640
> [  351.596118]  [<ffffffff81059aa7>] ? msg_print_text+0xb7/0x1b0
> [  351.596118]  [<ffffffff8133f441>] vscnprintf+0x11/0x30
> [  351.596118]  [<ffffffff8105a971>] vprintk_emit+0xc1/0x490
> [  351.596118]  [<ffffffff8105aa20>] ? vprintk_emit+0x170/0x490
> [  351.596118]  [<ffffffff8168b992>] printk+0x61/0x63
> [  351.596118]  [<ffffffffa0335ba1>] __xfs_printk+0x31/0x50 [xfs]
> [  351.596118]  [<ffffffffa0335df3>] xfs_notice+0x53/0x60 [xfs]
> [  351.596118]  [<ffffffffa032cbc5>] xfs_do_force_shutdown+0xf5/0x180 [xfs]
> [  351.596118]  [<ffffffffa0372728>] ? xlog_recover_iodone+0x48/0x70 [xfs]
> [  351.596118]  [<ffffffffa0372728>] xlog_recover_iodone+0x48/0x70 [xfs]
> [  351.596118]  [<ffffffffa032245d>] xfs_buf_iodone_work+0x4d/0xb0 [xfs]
> [  351.596118]  [<ffffffff81077a11>] process_one_work+0x141/0x4a0
> [  351.596118]  [<ffffffff810789e8>] worker_thread+0x168/0x410
> [  351.596118]  [<ffffffff81078880>] ? manage_workers+0x120/0x120
> [  351.596118]  [<ffffffff8107df10>] kthread+0xc0/0xd0
> [  351.596118]  [<ffffffff8107de50>] ? flush_kthread_worker+0xb0/0xb0
> [  351.596118]  [<ffffffff816ab86c>] ret_from_fork+0x7c/0xb0
> [  351.596118]  [<ffffffff8107de50>] ? flush_kthread_worker+0xb0/0xb0
> [  351.596118] Code: 31 c0 80 3f 00 55 48 89 e5 74 11 48 89 f8 66 90 48 83
> c0 01 80 38 00 75 f7 48 29 f8 5d c3 66 90 55 31 c0 48 85 f6 48 89 e5 74 23
> <80> 3f 00 74 1e 48 89 f8 eb 0c 0f 1f 00 48 83 ee 01 80 38 00 74
> [  351.596118] RIP  [<ffffffff8133c2cb>] strnlen+0xb/0x30
> [  351.596118]  RSP <ffff880035405b08>
> [  351.596118] ---[ end trace cb6b9820566f6848 ]---
> 
> 
> 
> -----Original Message----- From: Brian Foster
> Sent: 01 September, 2014 12:05 AM
> To: Alex Lyakas
> Cc: xfs@oss.sgi.com ; Dave Chinner
> Subject: Re: [PATCH] xfs: fix double free of trans in log recovery on I/O
> error
> 
> On Sun, Aug 31, 2014 at 11:50:52AM +0300, Alex Lyakas wrote:
> >Hi Brian, Dave,
> >I tested this patch on kernel 3.16, top commit:
> >
> >commit 19583ca584d6f574384e17fe7613dfaeadcdc4a6
> >Author: Linus Torvalds <torvalds@linux-foundation.org>
> >Date:   Sun Aug 3 15:25:02 2014 -0700
> >
> >   Linux 3.16
> >
> >and, yes, it appears to fix the issue.
> >
> 
> Thanks. That settles that then, I think. We're reproducing different
> problems on the 3.8 stable kernel vs. a recent kernel using the same
> test case.
> 
> >Trouble is that our production kernel is 3.8.13, and we cannot upgrade to
> >mainline kernel easily. Question is whether we can expect some patch
> >suitable for our kernel, or, since our kernel is EOL and not a long-term
> >one, we cannot?
> >
> 
> Dave wrote a patch specifically to resolve this problem on older
> kernels:
> 
> http://oss.sgi.com/archives/xfs/2014-08/msg00204.html
> 
> Brian
> 
> >Thanks for your help,
> >Alex.
> >
> >
> >-----Original Message----- From: Brian Foster
> >Sent: 25 August, 2014 5:20 PM
> >To: Alex Lyakas
> >Cc: xfs@oss.sgi.com ; Dave Chinner
> >Subject: Re: [PATCH] xfs: fix double free of trans in log recovery on I/O
> >error
> >
> >On Sun, Aug 24, 2014 at 12:20:20PM +0300, Alex Lyakas wrote:
> >>Hi Brian,
> >>
> >>On Thu, Aug 21, 2014 at 10:18 PM, Brian Foster <bfoster@redhat.com>
> >>wrote:
> >>> XFS log recovery builds up an xlog_recover object as it passes through
> >>> the log operations on the physical log. These structures are managed >>
> >via
> >>> a hash table and are allocated when a new transaction is encountered >>
> >and
> >>> freed once a commit operation for the transaction is encountered.
> >>>
> >>> This state machine for active transactions is implemented by a
> >>> combination of xlog_do_recovery_pass(), which walks through the log
> >>> buffers and xlog_recover_process_data() which processes log operations
> >>> within each buffer. The latter function decides whether to allocate a
> >>> new xlog_recover, add to it or commit and ultimately free it.  If an
> >>> error occurs at any point during the lifecycle of a particular
> >>> xlog_recover, xlog_recover_process_data() frees the object and returns
> >>> an error.
> >>>
> >>> xlog_recover_commit_trans() handles the final processing of the
> >>> transaction. It submits whatever I/O is required for the transaction >>
> >and
> >>> frees xlog_recover object along with the transaction items it tracks.
> >>> If
> >>> an error occurs at the final stages of the commit operation, such as >>
> >I/O
> >>> failure, both xlog_recover_commit_trans() and
> >>> xlog_recover_process_data() attempt to free the trans object.
> >>>
> >>> Modify xlog_recover_commit_trans() to only free the trans object on
> >>> successful completion of the trans, including any I/O errors that might
> >>> occur when recovering the log.
> >>>
> >>> Signed-off-by: Brian Foster <bfoster@redhat.com>
> >>> ---
> >>>
> >>> Hi all,
> >>>
> >>> I found that the recent buffer I/O rework fixes didn't address the >>
> >crash
> >>> reproduced by the dm-flakey/log recovery test case I posted recently. I
> >>> tracked the crash down to this, which allows the test to pass. This
> >>> addresses the crash I saw when running the reproducer manually with the
> >>> metadump that Alex posted as well.
> >>>
> >>> FWIW, I also went back and tested the xfs_buf_iowait() experiment in
> >>> both scenarios (Alex's metadump and xfstests test) and they all
> >>> reproduce the same crash for me. I think that either I'm still not
> >>> reproducing the original problem, something else might have >>
> >contaminated
> >>> the original xfs_buf_iowait() test to give a false positive, or
> >>> something else entirely is going on.
> >>>
> >>> Alex,
> >>>
> >>> If you have a chance, I think it might be interesting to see whether >>
> >you
> >>> reproduce any problems with this patch. It looks like this is a
> >>> regression introduced by:
> >>>
> >>>         2a84108f xfs: free the list of recovery items on error
> >>>
> >>> ... but I have no idea if that's in whatever kernel you're running.
> >>I am running kernel 3.8.13 with some changes (published at
> >>https://github.com/zadarastorage/zadara-xfs-pushback), but this
> >>problem also happens on pristine 3.8.13 from
> >>git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git,
> >>branch linux-stable-3.8.y.
> >>
> >>I do not have commit 2a84108f in this kernel. It was introduced in 3.14.
> >>I applied your patch to 3.8.13, but it doesn't fix the issue. Same
> >>problem happens when testing scenario that I described in
> >>http://oss.sgi.com/pipermail/xfs/2014-August/037637.html.
> >>
> >
> >Ok, thanks. Yeah, I don't see the double free regression in the 3.8.13
> >stable branch. I went back to that kernel to try and confirm some
> >things. I do reproduce the problem with your metadump as well as the
> >test case I put together. I tested Dave's buf hold across sync I/O patch
> >and that does indeed prevent the problem.
> >
> >For whatever reason, neither the test case nor your metadump reproduce
> >the same problem on latest kernels. Instead, they reproduce this double
> >free regression. I suspect this is what you ran into when you reproduced
> >on a more recent kernel. If you'd like, feel free to try and verify that
> >by running your reproducer again on a recent kernel with this patch and
> >see if you can still reproduce a crash as with the 3.8.13 kernel.
> >
> >Brian
> >
> >>Thanks,
> >>Alex.
> >>
> >>>
> >>> Brian
> >>>
> >>>  fs/xfs/xfs_log_recover.c | 11 ++++++++---
> >>>  1 file changed, 8 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> >>> index 176c4b3..daca9a6 100644
> >>> --- a/fs/xfs/xfs_log_recover.c
> >>> +++ b/fs/xfs/xfs_log_recover.c
> >>> @@ -3528,10 +3528,15 @@ out:
> >>>         if (!list_empty(&done_list))
> >>>                 list_splice_init(&done_list, &trans->r_itemq);
> >>>
> >>> -       xlog_recover_free_trans(trans);
> >>> -
> >>>         error2 = xfs_buf_delwri_submit(&buffer_list);
> >>> -       return error ? error : error2;
> >>> +
> >>> +       if (!error)
> >>> +               error = error2;
> >>> +       /* caller frees trans on error */
> >>> +       if (!error)
> >>> +               xlog_recover_free_trans(trans);
> >>> +
> >>> +       return error;
> >>>  }
> >>>
> >>>  STATIC int
> >>> --
> >>> 1.8.3.1
> >>>
> >
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
