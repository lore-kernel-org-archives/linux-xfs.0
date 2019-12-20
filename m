Return-Path: <SRS0=kies=2K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89900C43603
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Dec 2019 13:04:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 515362067C
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Dec 2019 13:04:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QnIh9yQr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfLTNEz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Dec 2019 08:04:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39237 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727359AbfLTNEz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Dec 2019 08:04:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576847093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mVySOG+KQbTfStUG6rCGdNjLNmZw207w3OGOv2aprho=;
        b=QnIh9yQrJzSGqi0yt4Fn7rPXmfdMOdYEoDrsOJXlYKcC69addwaEBBvEtdDwMg6F8uJym8
        qa/v6TJGAHO8CMiQg4OZm42A3zpHVplfNAtAjCwikTwjpdhVXz/d+hGijLKNjuIYVZZxBO
        wDUSZDAMqYO5ePOZNyRs0OxFJsMUC4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-ZxxgX2FRMHitA0GAGrtLsA-1; Fri, 20 Dec 2019 08:04:49 -0500
X-MC-Unique: ZxxgX2FRMHitA0GAGrtLsA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85D3B184BEC7;
        Fri, 20 Dec 2019 13:04:47 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B1B969A86;
        Fri, 20 Dec 2019 13:04:43 +0000 (UTC)
Date:   Fri, 20 Dec 2019 08:04:41 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Daniel Axtens <dja@axtens.net>
Cc:     syzbot <syzbot+4722bf4c6393b73a792b@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, allison.henderson@oracle.com,
        aryabinin@virtuozzo.com, darrick.wong@oracle.com,
        dchinner@redhat.com, dvyukov@google.com,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        sandeen@redhat.com, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org
Subject: Re: BUG: unable to handle kernel paging request in
 xfs_sb_quiet_read_verify
Message-ID: <20191220130441.GA11941@bfoster>
References: <000000000000d99340059a100686@google.com>
 <874kxvttx0.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kxvttx0.fsf@dja-thinkpad.axtens.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 20, 2019 at 05:03:55PM +1100, Daniel Axtens wrote:
> syzbot <syzbot+4722bf4c6393b73a792b@syzkaller.appspotmail.com> writes:
> 
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    2187f215 Merge tag 'for-5.5-rc2-tag' of git://git.kernel.o..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11059951e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=ab2ae0615387ef78
> > dashboard link: https://syzkaller.appspot.com/bug?extid=4722bf4c6393b73a792b
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12727c71e00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12ff5151e00000
> >
> > The bug was bisected to:
> >
> > commit 0609ae011deb41c9629b7f5fd626dfa1ac9d16b0
> > Author: Daniel Axtens <dja@axtens.net>
> > Date:   Sun Dec 1 01:55:00 2019 +0000
> >
> >      x86/kasan: support KASAN_VMALLOC
> 
> Looking at the log, it's an access of fffff52000680000 that goes wrong.
> 
> Reversing the shadow calculation, it looks like an attempted access of
> FFFFC90003400000, which is in vmalloc space. I'm not sure what that
> memory represents.
> 
> Looking at the instruction pointer, it seems like we're here:
> 
> static void
> xfs_sb_quiet_read_verify(
> 	struct xfs_buf	*bp)
> {
> 	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(bp);
> 
> 	if (dsb->sb_magicnum == cpu_to_be32(XFS_SB_MAGIC)) {     <<<< fault here
> 		/* XFS filesystem, verify noisily! */
> 		xfs_sb_read_verify(bp);
> 
> 
> Is it possible that dsb is junk?
> 

Hmm.. so the context here is a read I/O completion verifier. That means
the I/O returned success and we're running a verifier function to detect
content corruption, etc., before the buffer read returns to the caller.
This particular call is quiet superblock verification, which is used
when the filesystem may legitimately be something other than XFS (so we
don't want to spit out corruption messages if the verification fails).
From that perspective, it's certainly possible dsb is junk.

The buffer itself is a sector sized uncached buffer. That means the page
count for the buffer shouldn't be more than 1, which in turn means that
->b_addr should be initialized as such:

_xfs_buf_map_pages()
{
	...
        if (bp->b_page_count == 1) {
                /* A single page buffer is always mappable */
                bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
	...
}

... which isn't a vmap. However, we do have a multi-read dance in
xfs_readsb() where we first read the superblock without a verifier, read
the sector size specified in the super (which could be garbage) and then
re-read the superblock with a buffer based on that. So when I run the
attached reproducer, I see something like this:

<...>-885   [002] ...1    68.897501: xfs_buf_init: dev 7:0 bno 0xffffffffffffffff nblks 0x1 hold 1 pincount 0 lock 0 flags NO_IOACCT caller xfs_buf_get_uncached+0x91/0x3c0 [xfs]
repro-885   [002] ...1    68.897576: xfs_buf_get_uncached: dev 7:0 bno 0xffffffffffffffff nblks 0x1 hold 1 pincount 0 lock 0 flags NO_IOACCT|PAGES caller xfs_buf_read_uncached+0x3f/0x140 [xfs]
...
repro-885   [002] ...1    68.899077: xfs_buf_init: dev 7:0 bno 0xffffffffffffffff nblks 0x41 hold 1 pincount 0 lock 0 flags NO_IOACCT caller xfs_buf_get_uncached+0x91/0x3c0 [xfs]
repro-885   [002] ...1    68.899613: xfs_buf_get_uncached: dev 7:0 bno 0xffffffffffffffff nblks 0x41 hold 1 pincount 0 lock 0 flags NO_IOACCT|PAGES caller xfs_buf_read_uncached+0x3f/0x140 [xfs]
...

... where the sector size (65 * 512 == 33280) looks bogus. That said, it
looks like we have error checks throughout the page allocation/mapping
sequence so it isn't obvious what the problem is here. As far as we can
tell, we successfully allocated and mapped the 9 pages required for this
I/O. Thus I'd think we'd be able to get far enough to examine the
content to establish this is not a valid XFS sb and fail the mount.

Since this mapping functionality is fairly fundamental code in XFS, I
ran a quick test to use a multi-page directory block size (i.e. mkfs.xfs
-f <dev> -nsize=8k), started populating a directory and very quickly hit
a similar crash. I'm going to double check that this works as expected
without KASAN vmalloc support enabled, but is it possible something is
wrong with KASAN here?

Brian

> Regards,
> Daniel
> 
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=161240aee00000
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=151240aee00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=111240aee00000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+4722bf4c6393b73a792b@syzkaller.appspotmail.com
> > Fixes: 0609ae011deb ("x86/kasan: support KASAN_VMALLOC")
> >
> > BUG: unable to handle page fault for address: fffff52000680000
> > #PF: supervisor read access in kernel mode
> > #PF: error_code(0x0000) - not-present page
> > PGD 21ffee067 P4D 21ffee067 PUD aa51c067 PMD a85e1067 PTE 0
> > Oops: 0000 [#1] PREEMPT SMP KASAN
> > CPU: 1 PID: 3088 Comm: kworker/1:2 Not tainted 5.5.0-rc2-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
> > Google 01/01/2011
> > Workqueue: xfs-buf/loop0 xfs_buf_ioend_work
> > RIP: 0010:xfs_sb_quiet_read_verify+0x47/0xc0 fs/xfs/libxfs/xfs_sb.c:735
> > Code: 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 7f 49 8b 9c 24 30 01  
> > 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <0f> b6 04 02 84  
> > c0 74 04 3c 03 7e 50 8b 1b bf 58 46 53 42 89 de e8
> > RSP: 0018:ffffc90008187cc0 EFLAGS: 00010a06
> > RAX: dffffc0000000000 RBX: ffffc90003400000 RCX: ffffffff82ad3c26
> > RDX: 1ffff92000680000 RSI: ffffffff82aa0a0f RDI: ffff8880a2cdba70
> > RBP: ffffc90008187cd0 R08: ffff88809eb6c500 R09: ffffed1015d2703d
> > R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: ffff8880a2cdb940
> > R13: ffff8880a2cdb95c R14: ffff8880a2cdbb74 R15: 0000000000000000
> > FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: fffff52000680000 CR3: 000000009f5ab000 CR4: 00000000001406e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >   xfs_buf_ioend+0x3f9/0xde0 fs/xfs/xfs_buf.c:1162
> >   xfs_buf_ioend_work+0x19/0x20 fs/xfs/xfs_buf.c:1183
> >   process_one_work+0x9af/0x1740 kernel/workqueue.c:2264
> >   worker_thread+0x98/0xe40 kernel/workqueue.c:2410
> >   kthread+0x361/0x430 kernel/kthread.c:255
> >   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> > Modules linked in:
> > CR2: fffff52000680000
> > ---[ end trace 744ceb50d377bf94 ]---
> > RIP: 0010:xfs_sb_quiet_read_verify+0x47/0xc0 fs/xfs/libxfs/xfs_sb.c:735
> > Code: 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 7f 49 8b 9c 24 30 01  
> > 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <0f> b6 04 02 84  
> > c0 74 04 3c 03 7e 50 8b 1b bf 58 46 53 42 89 de e8
> > RSP: 0018:ffffc90008187cc0 EFLAGS: 00010a06
> > RAX: dffffc0000000000 RBX: ffffc90003400000 RCX: ffffffff82ad3c26
> > RDX: 1ffff92000680000 RSI: ffffffff82aa0a0f RDI: ffff8880a2cdba70
> > RBP: ffffc90008187cd0 R08: ffff88809eb6c500 R09: ffffed1015d2703d
> > R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: ffff8880a2cdb940
> > R13: ffff8880a2cdb95c R14: ffff8880a2cdbb74 R15: 0000000000000000
> > FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: fffff52000680000 CR3: 000000009f5ab000 CR4: 00000000001406e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >
> >
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this bug report. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> > syzbot can test patches for this bug, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
> 

