Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B894FC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 21:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9548B2072C
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 21:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387986AbgEWVWz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 17:22:55 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:34040 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387586AbgEWVWy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 17:22:54 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 1F750D79217;
        Sun, 24 May 2020 07:22:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jcbbS-0000LF-9x; Sun, 24 May 2020 07:22:46 +1000
Date:   Sun, 24 May 2020 07:22:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/24] xfs: rework inode flushing to make inode reclaim
 fully asynchronous
Message-ID: <20200523212246.GF2040@dread.disaster.area>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522040401.GE2040@dread.disaster.area>
 <20200523161833.GF8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523161833.GF8230@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=jMzBtkicp1Uh4BhHB8oA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 23, 2020 at 09:18:33AM -0700, Darrick J. Wong wrote:
> On Fri, May 22, 2020 at 02:04:01PM +1000, Dave Chinner wrote:
> > 
> > FWIW, I forgot to put it in the original description - the series
> > can be pulled from my git tree here:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-async-inode-reclaim
> 
> Hmm, so I tried this out with quotas enabled and hit this in xfs/438:

Yeah, I found another bug about 2 hours after I send this - the
iodone error ->li_error callouts are not handled correctly, but I
haven't seen this one.

> 
> MKFS_OPTIONS="-m reflink=1,rmapbt=1 -i sparse=1 /dev/sdf
> MOUNT_OPTIONS="-o usrquota,grpquota,prjquota"
> 
>  BUG: kernel NULL pointer dereference, address: 0000000000000020
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 0 P4D 0 
>  Oops: 0000 [#1] PREEMPT SMP
>  CPU: 3 PID: 824887 Comm: xfsaild/dm-0 Tainted: G        W         5.7.0-rc4-djw #rc4
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1 04/01/2014
>  RIP: 0010:do_raw_spin_trylock+0x5/0x40
>  Code: 64 de 81 48 89 ef e8 ba fe ff ff eb 8b 89 c6 48 89 ef e8 de dc ff ff 66 90 eb 8b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 <8b> 07 85 c0 75 28 ba 01 00 00 00 f0 0f b1 17 75 1d 65 8b 05 83 d8
>  RSP: 0018:ffffc90000afbdc0 EFLAGS: 00010086
>  RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
>  RDX: ffff888070ee0000 RSI: 0000000000000000 RDI: 0000000000000020
>  RBP: 0000000000000020 R08: 0000000000000001 R09: 0000000000000001
>  R10: 0000000000000000 R11: ffffc90000afbc3d R12: 0000000000000038
>  R13: 0000000000000202 R14: 0000000000000003 R15: ffff88800688a600
>  FS:  0000000000000000(0000) GS:ffff88807e000000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000020 CR3: 000000003bba2001 CR4: 00000000001606a0
>  Call Trace:
>   _raw_spin_lock_irqsave+0x47/0x80
>   ? down_trylock+0xf/0x30
>   down_trylock+0xf/0x30
>   xfs_buf_trylock+0x1a/0x1f0 [xfs]
>   xfsaild+0xb69/0x1320 [xfs]
>   kthread+0x130/0x170

Where is xfsaild calling xfs_buf_trylock directly?

Oh, resubmission of failed inode and dquot items, which may well be
the same problem as I mentioned above. I'll try to reproduce on
Monday...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
