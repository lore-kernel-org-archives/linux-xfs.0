Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE562C43217
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Oct 2022 23:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbiJIXwk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Oct 2022 19:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbiJIXwE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Oct 2022 19:52:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45592B03CC
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 16:23:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D31D60C2B
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 22:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88006C43142
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 22:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665356328;
        bh=hJGu0WR8kpa66pDttEw55U0WYkaAMMUPmcLa2V2Xqo8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=lztn+zg1fnkrAzvJiOvB7KlnaaakbVSrX7rz7PfLp78cpmEGN+IafE9fjPaYH10wn
         DcrM5r76BttFNULiTBQBznCmBHqbNUbW3jCS3FqRGhh4JyfyEGihtxW4GCK7XZfsnS
         c9wFpwj1Et8ORh9JAwz6lF/DdNPVVNEXJxZQeR5uaBoROrZ6ippR0QVFFReKlysL4W
         CMET7sFHjigb2fqxzRBzwVjsSOTJs5D+Z20OnU6qxNWnq9ZMcTLhKtEPfZpyJMgMjd
         g5zwA9/R4XCWoK3qlBn91Ns/7IegRuTUutGgRfJqFZ0hlEZ2vHno8eI9b/Iy/F6NH3
         Ptcl5O7gno0iw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7490CC32747; Sun,  9 Oct 2022 22:58:48 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216567] [xfstests generic/451] kernel BUG at mm/truncate.c:669!
Date:   Sun, 09 Oct 2022 22:58:48 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216567-201763-cwWMUnbnuU@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216567-201763@https.bugzilla.kernel.org/>
References: <bug-216567-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216567

--- Comment #2 from Dave Chinner (david@fromorbit.com) ---
On Sun, Oct 09, 2022 at 05:58:33PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216567
>=20
> --- Comment #1 from Zorro Lang (zlang@redhat.com) ---
> Hmm... besides this panic, g/451 just hit another panic when I tried to
> reproduce this bug:
>=20
> [ 1084.111233] run fstests generic/451 at 2022-10-09 11:12:39=20
> [ 1099.015616] restraintd[2581]: *** Current Time: Sun Oct 09 11:12:56 20=
22=20
> Localwatchdog at: Tue Oct 11 10:57:56 2022=20
> [ 1101.932132] ------------[ cut here ]------------=20
> [ 1101.932220] ------------[ cut here ]------------=20
> [ 1101.936972] kernel BUG at include/linux/pagemap.h:1247!=20
> [ 1101.936985] invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI=20
> [ 1101.941681] kernel BUG at include/linux/pagemap.h:1247!=20
> [ 1101.946825] CPU: 19 PID: 557513 Comm: xfs_io Kdump: loaded Not tainted
> 6.0.0+ #1=20
> [ 1101.946831] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.5.4
> 12/17/2021=20
> [ 1101.946833] RIP: 0010:read_pages+0xa29/0xda0=20
> [ 1101.976950] Code: ff ff be 01 00 00 00 e9 87 fe ff ff 0f b6 d0 be ff f=
f ff
> ff 4c 89 ff 88 44 24 18 e8 11 74 25 00 0f b6 44 24 18 e9 f1 fe ff ff <0f>=
 0b
> 4c
> 89 ff e8 1d 86 00 00 e9 ea fe ff ff 48 c7 c6 c0 85 55 99=20
> [ 1101.995693] RSP: 0018:ffa00000396ef7f0 EFLAGS: 00010202=20
> [ 1102.000921] RAX: 0000000000000002 RBX: dffffc0000000000 RCX:
> 0000000000000001=20
> [ 1102.008054] RDX: 1fe220003427d324 RSI: 0000000000000004 RDI:
> ffd40000095e8500=20
> [ 1102.015186] RBP: ffffffffc13f66c0 R08: 0000000000000000 R09:
> ffffffff9aa44067=20
> [ 1102.022321] R10: fffffbfff354880c R11: 0000000000000001 R12:
> fff3fc00072ddf4a=20
> [ 1102.029451] R13: ffa00000396efa54 R14: ffa00000396efa30 R15:
> 0000000000000003=20
> [ 1102.036584] FS:  00007f1de484b740(0000) GS:ff11002033400000(0000)
> knlGS:0000000000000000=20
> [ 1102.044671] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=20
> [ 1102.050418] CR2: 0000000001c81ff8 CR3: 000000016171e004 CR4:
> 0000000000771ee0=20
> [ 1102.057549] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000=20
> [ 1102.064681] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400=20
> [ 1102.071815] PKRU: 55555554=20
> [ 1102.074527] Call Trace:=20
> [ 1102.076982]  <TASK>=20
> [ 1102.079092]  ? file_ra_state_init+0xe0/0xe0=20
> [ 1102.083283]  ? __xa_clear_mark+0x100/0x100=20
> [ 1102.087385]  page_cache_ra_unbounded+0x269/0x510=20
> [ 1102.092013]  filemap_get_pages+0x26d/0x980=20
> [ 1102.096121]  ? filemap_add_folio+0x150/0x150=20
> [ 1102.100403]  filemap_read+0x2a9/0xae0=20
> [ 1102.104074]  ? lock_acquire+0x1d8/0x620=20
> [ 1102.107921]  ? find_held_lock+0x33/0x120=20
> [ 1102.111850]  ? filemap_get_pages+0x980/0x980=20
> [ 1102.116121]  ? validate_chain+0x154/0xdf0=20
> [ 1102.120133]  ? __lock_contended+0x980/0x980=20
> [ 1102.124320]  ? xfs_ilock+0x1d0/0x4d0 [xfs]=20
> [ 1102.128582]  ? xfs_ilock+0x1d0/0x4d0 [xfs]=20
> [ 1102.132816]  xfs_file_buffered_read+0x16f/0x390 [xfs]=20
> [ 1102.137995]  xfs_file_read_iter+0x274/0x560 [xfs]=20
> [ 1102.142831]  vfs_read+0x585/0x810=20

This is also a problem with the page cache, and doesn't seem related
to XFS or directory block size configuration:

        BUG_ON(ractl->_batch_count > ractl->_nr_pages);

Also, there haven't been any changes to XFS code so far in 6.1-rc0,
so this isn't a recent XFS regression, either. Perhaps a bisect
would be in order?

-Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
