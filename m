Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFF7C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 21 May 2022 22:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345078AbiEUWcD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 May 2022 18:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234785AbiEUWcC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 May 2022 18:32:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF2B1CB14
        for <linux-xfs@vger.kernel.org>; Sat, 21 May 2022 15:32:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B37860C6F
        for <linux-xfs@vger.kernel.org>; Sat, 21 May 2022 22:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4D99C34119
        for <linux-xfs@vger.kernel.org>; Sat, 21 May 2022 22:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653172319;
        bh=Tpfh81ZIiZ+Tu9qtU9IPjH339IzkUd1MufBkryOlmHc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=N4gGlHS+d+pbhR51V38Zoo16K3RJA5n8HRBxNw8K9FuD3BxQqffsGa477xg/8nehM
         6cwSnyoDH9MKET99ltJwyPFS+stYpTTr6TXkCsUiF0M4KnHHWRl5AuPgrmPI/XsixZ
         BRT0MSGFgvOMmcbwdCx2YkslB3x+tbsKf/WgelI3Qjg8k8NO9NxS8PlNR6Nzra7X6x
         wgKQPM6tG1gnLIUSwMktyM7NX6QePmORbJMwAxEUkRqzsbF9uowt5I5Nt9cucSn6Et
         BJ+668NsJVWi8s2HmfwWR8xwOBaz2u2wxKHFKBSPpJYpHAQ4mbBT6G5xOKnyqeGdjh
         ZsanMyuhTX3NQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B6480CC13B0; Sat, 21 May 2022 22:31:59 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Sat, 21 May 2022 22:31:59 +0000
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
Message-ID: <bug-216007-201763-4bIsuoCV4o@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216007-201763@https.bugzilla.kernel.org/>
References: <bug-216007-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216007

--- Comment #5 from Dave Chinner (david@fromorbit.com) ---
On Sat, May 21, 2022 at 05:14:36AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216007
>=20
> --- Comment #4 from Peter Pavlisko (bugzkernelorg8392@araxon.sk) ---
> > What sort of storage subsystem does this machine have? If it's a spinni=
ng
> > disk then you've probably just filled memory
>=20
> Yes, all the disks are classic spinning CMR disks. But, out of all file
> systems
> tried, only XFS is doing this on the test machine. I can trigger this
> behavior
> every time. And kernels from 5.10 and bellow still work, even with my
> non-standard .config.
>=20
> Here is the memory situation when it is stuck:
>=20
> ftp-back ~ # free
>                total        used        free      shared  buff/cache=20=20
>                available
> Mem:         3995528      175872       69240         416     3750416=20=
=20=20=20
> 3763584

Doesn't tell us a whole lot except for "no free memory to allocate
without reclaim". /proc/meminfo, /proc/vmstat and /proc/slabinfo
would tell us a lot more.

Also, knowing if you've tweaked things like dirty ratios, etc would
also be helpful...

> This may not be a XFS bug, but so far only XFS seems to suffer from it.

Not that uncommon, really. XFS puts a different load on the memory
allocation/reclaim and cache subsystems compared to other
filesystems, so XFS tends to trip over bugs that others don't.

Cheers,

Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
