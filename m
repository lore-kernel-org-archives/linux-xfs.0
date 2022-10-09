Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0862CC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Oct 2022 23:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiJIX7d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Oct 2022 19:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbiJIX7N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Oct 2022 19:59:13 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C71F1AF32
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 16:31:34 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 374708AD52E;
        Mon, 10 Oct 2022 09:58:44 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ohfFq-00055n-Tz; Mon, 10 Oct 2022 09:58:42 +1100
Date:   Mon, 10 Oct 2022 09:58:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 216567] [xfstests generic/451] kernel BUG at
 mm/truncate.c:669!
Message-ID: <20221009225842.GT3600936@dread.disaster.area>
References: <bug-216567-201763@https.bugzilla.kernel.org/>
 <bug-216567-201763-9phRYnyMqv@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-216567-201763-9phRYnyMqv@https.bugzilla.kernel.org/>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=63435224
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=zyoQlP4wT9Kj4MpBQ7UA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 09, 2022 at 05:58:33PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=216567
> 
> --- Comment #1 from Zorro Lang (zlang@redhat.com) ---
> Hmm... besides this panic, g/451 just hit another panic when I tried to
> reproduce this bug:
> 
> [ 1084.111233] run fstests generic/451 at 2022-10-09 11:12:39 
> [ 1099.015616] restraintd[2581]: *** Current Time: Sun Oct 09 11:12:56 2022 
> Localwatchdog at: Tue Oct 11 10:57:56 2022 
> [ 1101.932132] ------------[ cut here ]------------ 
> [ 1101.932220] ------------[ cut here ]------------ 
> [ 1101.936972] kernel BUG at include/linux/pagemap.h:1247! 
> [ 1101.936985] invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI 
> [ 1101.941681] kernel BUG at include/linux/pagemap.h:1247! 
> [ 1101.946825] CPU: 19 PID: 557513 Comm: xfs_io Kdump: loaded Not tainted
> 6.0.0+ #1 
> [ 1101.946831] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4
> 12/17/2021 
> [ 1101.946833] RIP: 0010:read_pages+0xa29/0xda0 
> [ 1101.976950] Code: ff ff be 01 00 00 00 e9 87 fe ff ff 0f b6 d0 be ff ff ff
> ff 4c 89 ff 88 44 24 18 e8 11 74 25 00 0f b6 44 24 18 e9 f1 fe ff ff <0f> 0b 4c
> 89 ff e8 1d 86 00 00 e9 ea fe ff ff 48 c7 c6 c0 85 55 99 
> [ 1101.995693] RSP: 0018:ffa00000396ef7f0 EFLAGS: 00010202 
> [ 1102.000921] RAX: 0000000000000002 RBX: dffffc0000000000 RCX:
> 0000000000000001 
> [ 1102.008054] RDX: 1fe220003427d324 RSI: 0000000000000004 RDI:
> ffd40000095e8500 
> [ 1102.015186] RBP: ffffffffc13f66c0 R08: 0000000000000000 R09:
> ffffffff9aa44067 
> [ 1102.022321] R10: fffffbfff354880c R11: 0000000000000001 R12:
> fff3fc00072ddf4a 
> [ 1102.029451] R13: ffa00000396efa54 R14: ffa00000396efa30 R15:
> 0000000000000003 
> [ 1102.036584] FS:  00007f1de484b740(0000) GS:ff11002033400000(0000)
> knlGS:0000000000000000 
> [ 1102.044671] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
> [ 1102.050418] CR2: 0000000001c81ff8 CR3: 000000016171e004 CR4:
> 0000000000771ee0 
> [ 1102.057549] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000 
> [ 1102.064681] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400 
> [ 1102.071815] PKRU: 55555554 
> [ 1102.074527] Call Trace: 
> [ 1102.076982]  <TASK> 
> [ 1102.079092]  ? file_ra_state_init+0xe0/0xe0 
> [ 1102.083283]  ? __xa_clear_mark+0x100/0x100 
> [ 1102.087385]  page_cache_ra_unbounded+0x269/0x510 
> [ 1102.092013]  filemap_get_pages+0x26d/0x980 
> [ 1102.096121]  ? filemap_add_folio+0x150/0x150 
> [ 1102.100403]  filemap_read+0x2a9/0xae0 
> [ 1102.104074]  ? lock_acquire+0x1d8/0x620 
> [ 1102.107921]  ? find_held_lock+0x33/0x120 
> [ 1102.111850]  ? filemap_get_pages+0x980/0x980 
> [ 1102.116121]  ? validate_chain+0x154/0xdf0 
> [ 1102.120133]  ? __lock_contended+0x980/0x980 
> [ 1102.124320]  ? xfs_ilock+0x1d0/0x4d0 [xfs] 
> [ 1102.128582]  ? xfs_ilock+0x1d0/0x4d0 [xfs] 
> [ 1102.132816]  xfs_file_buffered_read+0x16f/0x390 [xfs] 
> [ 1102.137995]  xfs_file_read_iter+0x274/0x560 [xfs] 
> [ 1102.142831]  vfs_read+0x585/0x810 

This is also a problem with the page cache, and doesn't seem related
to XFS or directory block size configuration:

	BUG_ON(ractl->_batch_count > ractl->_nr_pages);

Also, there haven't been any changes to XFS code so far in 6.1-rc0,
so this isn't a recent XFS regression, either. Perhaps a bisect
would be in order?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
