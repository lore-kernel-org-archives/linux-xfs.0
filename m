Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B25C77B7A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 16:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238307AbjFFQ5K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 12:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238424AbjFFQ5C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 12:57:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802A2172B
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 09:56:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F215562B51
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 16:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309ECC433EF;
        Tue,  6 Jun 2023 16:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686070616;
        bh=jNvCO2fknvgrEmsh55HT6eMfNR+qqDMHx03mNtV/Xtg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GQC8LO2sdGnUz2XeRamZo1tMZ5RXhIJmNatZyB8+Swew0RY8pLlx2InxotHb/0Nzh
         2/xwD3N1XUUS0Vpy2mAcHTzCbZtixaDdnyJKbJUmHs5w1+XNy60R2loCt5G/XtP1Jx
         CzUOPl8KKsER691PpKJQ3aDT2DvCglccPT6mFUPQH48dipbolUFzQq1AKoVzEewkSd
         AYyjpG9AXsHXI7bFijyd9Obhrv+UepOXW+gAALG7BxvQdxaVRwlnOV7Ew+mefjwNir
         fidZ61RlOk7IGrkdZ5r1C5HwG9FY1bWl6hyolsIdAC8XBwTUlOyaCGneMJ0ZdYBw7S
         4/2YTgPIvoFPA==
Date:   Tue, 6 Jun 2023 17:56:51 +0100
From:   Lee Jones <lee@kernel.org>
To:     Leah Rumancik <lrumancik@google.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: verify buffer contents when we skip log replay
Message-ID: <20230606165651.GB1930705@google.com>
References: <20230411233159.GH360895@frogsfrogsfrogs>
 <20230601130351.GA1787684@google.com>
 <20230601151146.GH16865@frogsfrogsfrogs>
 <CAOQ4uxh5m9VHnq0JG9BeAjAXyRdYy0fi9NwJVgWvH2tD7f9mLA@mail.gmail.com>
 <CAMxqPXVrsy0MMzt0e6cKZmBmLox3xJcjXu8yd-THzEUdDD=HGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMxqPXVrsy0MMzt0e6cKZmBmLox3xJcjXu8yd-THzEUdDD=HGw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 02 Jun 2023, Leah Rumancik wrote:

> Hello!
> 
> Sorry for the lull in backports lately, I've been OOO a lot lately.
> However, I did spend some time yesterday identifying the next set of
> 5.15.y patches and I am planning to include the CVE fix in it. Amir,
> that'd be great if you could test this patch on 6.1! I'll prioritize
> working on this so we can get the CVE fix out soon.
> 
> I have about 30 or so patches until 5.15.y is caught up to 6.1.y.
> Planning on splitting these into two sets. Once 5.15.y is caught up,
> I'll transition to 6.1.y.

Sounds great, thanks Leah.

It looks as though this fix patches an issue added to v3.17.  Are there
any plans to backport fixes further than v5.15?

> On Fri, Jun 2, 2023 at 3:16 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Thu, Jun 1, 2023 at 6:18 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > On Thu, Jun 01, 2023 at 02:03:51PM +0100, Lee Jones wrote:
> > > > Hi Darrick,
> > > >
> > > > On Tue, 11 Apr 2023, Darrick J. Wong wrote:
> > > >
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > >
> > > > > syzbot detected a crash during log recovery:
> > > > >
> > > > > XFS (loop0): Mounting V5 Filesystem bfdc47fc-10d8-4eed-a562-11a831b3f791
> > > > > XFS (loop0): Torn write (CRC failure) detected at log block 0x180. Truncating head block from 0x200.
> > > > > XFS (loop0): Starting recovery (logdev: internal)
> > > > > ==================================================================
> > > > > BUG: KASAN: slab-out-of-bounds in xfs_btree_lookup_get_block+0x15c/0x6d0 fs/xfs/libxfs/xfs_btree.c:1813
> > > > > Read of size 8 at addr ffff88807e89f258 by task syz-executor132/5074
> > > > >
> > > > > CPU: 0 PID: 5074 Comm: syz-executor132 Not tainted 6.2.0-rc1-syzkaller #0
> > > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> > > > > Call Trace:
> > > > >  <TASK>
> > > > >  __dump_stack lib/dump_stack.c:88 [inline]
> > > > >  dump_stack_lvl+0x1b1/0x290 lib/dump_stack.c:106
> > > > >  print_address_description+0x74/0x340 mm/kasan/report.c:306
> > > > >  print_report+0x107/0x1f0 mm/kasan/report.c:417
> > > > >  kasan_report+0xcd/0x100 mm/kasan/report.c:517
> > > > >  xfs_btree_lookup_get_block+0x15c/0x6d0 fs/xfs/libxfs/xfs_btree.c:1813
> > > > >  xfs_btree_lookup+0x346/0x12c0 fs/xfs/libxfs/xfs_btree.c:1913
> > > > >  xfs_btree_simple_query_range+0xde/0x6a0 fs/xfs/libxfs/xfs_btree.c:4713
> > > > >  xfs_btree_query_range+0x2db/0x380 fs/xfs/libxfs/xfs_btree.c:4953
> > > > >  xfs_refcount_recover_cow_leftovers+0x2d1/0xa60 fs/xfs/libxfs/xfs_refcount.c:1946
> > > > >  xfs_reflink_recover_cow+0xab/0x1b0 fs/xfs/xfs_reflink.c:930
> > > > >  xlog_recover_finish+0x824/0x920 fs/xfs/xfs_log_recover.c:3493
> > > > >  xfs_log_mount_finish+0x1ec/0x3d0 fs/xfs/xfs_log.c:829
> > > > >  xfs_mountfs+0x146a/0x1ef0 fs/xfs/xfs_mount.c:933
> > > > >  xfs_fs_fill_super+0xf95/0x11f0 fs/xfs/xfs_super.c:1666
> > > > >  get_tree_bdev+0x400/0x620 fs/super.c:1282
> > > > >  vfs_get_tree+0x88/0x270 fs/super.c:1489
> > > > >  do_new_mount+0x289/0xad0 fs/namespace.c:3145
> > > > >  do_mount fs/namespace.c:3488 [inline]
> > > > >  __do_sys_mount fs/namespace.c:3697 [inline]
> > > > >  __se_sys_mount+0x2d3/0x3c0 fs/namespace.c:3674
> > > > >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > > > >  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
> > > > >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > > > RIP: 0033:0x7f89fa3f4aca
> > > > > Code: 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> > > > > RSP: 002b:00007fffd5fb5ef8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
> > > > > RAX: ffffffffffffffda RBX: 00646975756f6e2c RCX: 00007f89fa3f4aca
> > > > > RDX: 0000000020000100 RSI: 0000000020009640 RDI: 00007fffd5fb5f10
> > > > > RBP: 00007fffd5fb5f10 R08: 00007fffd5fb5f50 R09: 000000000000970d
> > > > > R10: 0000000000200800 R11: 0000000000000206 R12: 0000000000000004
> > > > > R13: 0000555556c6b2c0 R14: 0000000000200800 R15: 00007fffd5fb5f50
> > > > >  </TASK>
> > > > >
> > > > > The fuzzed image contains an AGF with an obviously garbage
> > > > > agf_refcount_level value of 32, and a dirty log with a buffer log item
> > > > > for that AGF.  The ondisk AGF has a higher LSN than the recovered log
> > > > > item.  xlog_recover_buf_commit_pass2 reads the buffer, compares the
> > > > > LSNs, and decides to skip replay because the ondisk buffer appears to be
> > > > > newer.
> > > > >
> > > > > Unfortunately, the ondisk buffer is corrupt, but recovery just read the
> > > > > buffer with no buffer ops specified:
> > > > >
> > > > >     error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno,
> > > > >                     buf_f->blf_len, buf_flags, &bp, NULL);
> > > > >
> > > > > Skipping the buffer leaves its contents in memory unverified.  This sets
> > > > > us up for a kernel crash because xfs_refcount_recover_cow_leftovers
> > > > > reads the buffer (which is still around in XBF_DONE state, so no read
> > > > > verification) and creates a refcountbt cursor of height 32.  This is
> > > > > impossible so we run off the end of the cursor object and crash.
> > > > >
> > > > > Fix this by invoking the verifier on all skipped buffers and aborting
> > > > > log recovery if the ondisk buffer is corrupt.  It might be smarter to
> > > > > force replay the log item atop the buffer and then see if it'll pass the
> > > > > write verifier (like ext4 does) but for now let's go with the
> > > > > conservative option where we stop immediately.
> > > > >
> > > > > Link: https://syzkaller.appspot.com/bug?extid=7e9494b8b399902e994e
> > > > > Fixes: 67dc288c2106 ("xfs: ensure verifiers are attached to recovered buffers")
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > >  fs/xfs/xfs_buf_item_recover.c |   10 ++++++++++
> > > > >  1 file changed, 10 insertions(+)
> > > >
> > > > Rightly or wrongly, CVE-2023-212 has been raised against this issue.
> > > >
> > > > It looks as though the Fixes: tag above was stripped when applied.
> > > >
> > > > Should this still be submitted to Stable?
> > >
> > > Yes, but we have not been successful in persuading any company to pick
> > > up stable backporting and QA for any kernel newer than 5.15.
> > >
> >
> > I already have a kdevops baseline that I established for xfs-6.1.y when
> > I backported the SGID vfs fixes, so it is not a problem for me to test
> > this patch (or any other if you have hints).
> >
> > I have not yet invested in selecting patches for backport, partly
> > because Leah wrote that she intends to take this up.
> >
> > Leah, if your priorities have changed, I can try to start collecting
> > candidates for backport in my spare time, whenever that will be.
> >
> > In any case, testing the occasional patch for 6.1.y is something that
> > I can do until a company/distro becomes the owner of xfs-6.1.y.
> >
> > Darrick et al.,
> >
> > If you want me to test any other patches for 6.1.y, please let me know.
> >
> > Thanks,
> > Amir.

-- 
Lee Jones [李琼斯]
