Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05EEAC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Nov 2023 20:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbjKBU7P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Nov 2023 16:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234446AbjKBU7O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2023 16:59:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3911019D
        for <linux-xfs@vger.kernel.org>; Thu,  2 Nov 2023 13:59:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BBA43C433CC
        for <linux-xfs@vger.kernel.org>; Thu,  2 Nov 2023 20:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698958750;
        bh=Aa3xHuGNKmMg/0iumSNj6Ixq93l3uqtydOg0mQjnXzg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=aq1BSkFdQXCUC586hgSCWkghaX7dlUJrDOUDV/7yTIrtqWIh5h0i71eVN0emt0wgY
         DPKrm+yQsG4qid3PU89UDoh1ObRTIkN3kXtjAafEEjyuubTs5yVwyijixuoUxifRLa
         9Jycgwyoa1l4xcJ9pSNP7x0vt5oJzXEgl6MnEbVgxbHwkCQuUwZ+CERWMG/1JL9qMN
         8mrPZnE6I95xbBdR9h17TjwsUq7fxQUZC5coAurcJdaqkQqntG9cfHHKjnRAMpybGV
         hADI+21WjRpxShxTpl4Qs1/jZLzGLBPwUDnYKfix29Ef5djPo/U1q0Mk4TanYsudG6
         rb15cYXHNwWmw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id AB5C6C53BD1; Thu,  2 Nov 2023 20:59:10 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Thu, 02 Nov 2023 20:59:09 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217572-201763-7aKPmPiF6l@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217572-201763@https.bugzilla.kernel.org/>
References: <bug-217572-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217572

--- Comment #21 from Dave Chinner (david@fromorbit.com) ---
On Thu, Nov 02, 2023 at 03:27:58PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217572
>=20
> --- Comment #18 from Christian Theune (ct@flyingcircus.io) ---
> We've updated a while ago and our fleet is not seeing improved results.
> They've
> actually seemed to have gotten worse according to the number of alerts we=
've
> seen.=20

This is still an unreproducable, unfixed bug in upstream kernels.
There is no known reproducer, so actually triggering it and hence
performing RCA is extremely difficult at this point in time. We don't
really even know what workload triggers it.

> We've had a multitude of crashes in the last weeks with the following
> statistics:
>=20
> 6.1.31 - 2 affected machines
> 6.1.35 - 1 affected machine
> 6.1.37 - 1 affected machine
> 6.1.51 - 5 affected machines
> 6.1.55 - 2 affected machines
> 6.1.57 - 2 affected machines

Do these machines have ECC memory?

> Here's the more detailed behaviour of one of the machines with 6.1.57.
>=20
> $ uptime
>  16:10:23  up 13 days 19:00,  1 user,  load average: 3.21, 1.24, 0.57

Yeah, that's the problem - such a rare, one off issue that we don't
really even know where to begin looking. :(

Given you seem to have a workload that occasionally triggers it,
could you try to craft a reproducer workload that does stuff similar
to your production workload and see if you can find out something
that makes this easier to trigger?

> $ uname -a
> Linux ts00 6.1.57 #1-NixOS SMP PREEMPT_DYNAMIC Tue Oct 10 20:00:46 UTC 20=
23
> x86_64 GNU/Linux
>=20
> And here' the stall:
....
> [654042.645101]  <TASK>
> [654042.645353]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
> [654042.645956]  ? xas_descend+0x22/0x90
> [654042.646366]  xas_load+0x30/0x40
> [654042.646738]  filemap_get_read_batch+0x16e/0x250
> [654042.647253]  filemap_get_pages+0xa9/0x630
> [654042.647714]  filemap_read+0xd2/0x340
> [654042.648124]  ? __mod_memcg_lruvec_state+0x6e/0xd0
> [654042.648670]  xfs_file_buffered_read+0x4f/0xd0 [xfs]

This implies you are using memcg to constrain memory footprint of
the applications? Are these workloads running in memcgs that
experience random memcg OOM conditions? Or maybe the failure
correlates with global OOM conditions triggering memcg reclaim?

Cheers,

Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
