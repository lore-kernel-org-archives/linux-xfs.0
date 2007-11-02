Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 02 Nov 2007 14:27:03 -0700 (PDT)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.181])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA2LQukO027923
	for <xfs@oss.sgi.com>; Fri, 2 Nov 2007 14:26:58 -0700
Received: by py-out-1112.google.com with SMTP id u77so1825595pyb
        for <xfs@oss.sgi.com>; Fri, 02 Nov 2007 14:27:01 -0700 (PDT)
Message-ID: <64bb37e0711021402g4961e474u75e48fa5a893ab7a@mail.gmail.com>
Date: Fri, 2 Nov 2007 22:02:23 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Subject: Re: writeout stalls in current -git
In-Reply-To: <20071102204258.GR995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710221505.35397.maximlevitsky@gmail.com>
	 <393060478.03650@ustc.edu.cn>
	 <64bb37e0710310822r5ca6b793p8fd97db2f72a8655@mail.gmail.com>
	 <393903856.06449@ustc.edu.cn>
	 <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com>
	 <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com>
	 <E1InmAI-0003ME-2i@localhost> <1193998532.27652.343.camel@twins>
	 <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com>
	 <20071102204258.GR995458@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Fengguang Wu <wfg@mail.ustc.edu.cn>, Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 11/2/07, David Chinner <dgc@sgi.com> wrote:
> On Fri, Nov 02, 2007 at 08:22:10PM +0100, Torsten Kaiser wrote:
> > [  630.000000] SysRq : Emergency Sync
> > [  630.120000] Emergency Sync complete
> > [  632.850000] SysRq : Show Blocked State
> > [  632.850000]   task                        PC stack   pid father
> > [  632.850000] pdflush       D ffff81000f091788     0   285      2
> > [  632.850000]  ffff810005d4da80 0000000000000046 0000000000000800
> > 0000007000000001
> > [  632.850000]  ffff81000fd52400 ffffffff8022d61c ffffffff80819b00
> > ffffffff80819b00
> > [  632.850000]  ffffffff80815f40 ffffffff80819b00 ffff810100316f98
> > 0000000000000000
> > [  632.850000] Call Trace:
> > [  632.850000]  [<ffffffff8022d61c>] task_rq_lock+0x4c/0x90
> > [  632.850000]  [<ffffffff8022c8ea>] __wake_up_common+0x5a/0x90
> > [  632.850000]  [<ffffffff805b16e7>] __down+0xa7/0x11e
> > [  632.850000]  [<ffffffff8022da70>] default_wake_function+0x0/0x10
> > [  632.850000]  [<ffffffff805b1365>] __down_failed+0x35/0x3a
> > [  632.850000]  [<ffffffff803752ce>] xfs_buf_lock+0x3e/0x40
> > [  632.850000]  [<ffffffff8037740e>] _xfs_buf_find+0x13e/0x240
> > [  632.850000]  [<ffffffff8037757f>] xfs_buf_get_flags+0x6f/0x190
> > [  632.850000]  [<ffffffff803776b2>] xfs_buf_read_flags+0x12/0xa0
> > [  632.850000]  [<ffffffff80368824>] xfs_trans_read_buf+0x64/0x340
> > [  632.850000]  [<ffffffff80352361>] xfs_itobp+0x81/0x1e0
> > [  632.850000]  [<ffffffff8026b293>] write_cache_pages+0x123/0x330
> > [  632.850000]  [<ffffffff80354d0e>] xfs_iflush+0xfe/0x520
>
> That's stalled waiting on the inode cluster buffer lock. That implies
> that the inode lcuser is already being written out and the inode has
> been redirtied during writeout.
>
> Does the kernel you are testing have the "flush inodes in ascending
> inode number order" patches applied? If so, can you remove that
> patch and see if the problem goes away?

It's 2.6.23-mm1 with only some small fixes.

In it's broken-out directory I see:
git-xfs.patch

and

writeback-fix-periodic-superblock-dirty-inode-flushing.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch
writeback-introduce-writeback_controlmore_io-to-indicate-more-io.patch

I don't know if the patch you mentioned is part of that version of the
mm-patchset.

Torsten
