Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56DADC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Oct 2022 23:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbiJIXnF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Oct 2022 19:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbiJIXm2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Oct 2022 19:42:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E927057E34
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 16:14:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E47B0B80DD0
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 22:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9558EC43142
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 22:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665355666;
        bh=TA8WZxaIMD9zOwIi6zlIBUe8wFI/Y9QFrjIaDLiH23k=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZwHKSlLcBhww4L8fGKd60uJ6yzh4g5LSia+yyIsK/vjdU4gEx/0ZQl5h1XeS91xKY
         RaYHvWTpXc0uNvOu0csQYdZIwutimtrw1qxgl6nTcy4E/2m0biEkqP7g5Q5zg2jFMQ
         fNxOfzIACZZDhJtTirgNf/ZoU9Uw8Z9JshPdZvcEYqXhJeyOqrUYp0xcb+Zu+MNsEA
         raVf1Xa1rKkcseFrBf9tglxfWkthWCzg2zdo0w2Xhyk/85dQdbXIqPmRXpiSPmuc+j
         I0ip6A0S9ERZuaWHU/k1FRuRLPcC3TcztqwEaHe4fZ8m6Hr2C4sIIHg0abZQ/XeO7E
         oqluWFdIV4EcQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 857CBC433E9; Sun,  9 Oct 2022 22:47:46 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216566] [xfstests generic/648] BUG: unable to handle page
 fault, RIP: 0010:__xfs_dir3_data_check+0x171/0x700 [xfs]
Date:   Sun, 09 Oct 2022 22:47:46 +0000
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
Message-ID: <bug-216566-201763-OhX1hI8sZ7@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216566-201763@https.bugzilla.kernel.org/>
References: <bug-216566-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216566

--- Comment #1 from Dave Chinner (david@fromorbit.com) ---
On Sun, Oct 09, 2022 at 05:47:49PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216566
>=20
>             Bug ID: 216566
>            Summary: [xfstests generic/648] BUG: unable to handle page
>                     fault, RIP: 0010:__xfs_dir3_data_check+0x171/0x700
>                     [xfs]
>            Product: File System
>            Version: 2.5
>     Kernel Version: v6.1-rc0
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: zlang@redhat.com
>         Regression: No
>=20
> xfstests generic/648 hit kernel panic[1] on xfs with 64k directory block =
size
> (-n size=3D65536), before panic, there's a kernel assertion (not sure if =
it's
> related).
>=20
> It's reproducable, but not easy. Generally I reproduced it by loop running
> generic/648 on xfs (-n size=3D65536) hundreds of time.
>=20
> The last time I hit this panic on linux with HEAD=3D

Given that there have been no changes to XFS committed in v6.1-rc0
at this point in time, this won't be an XFS regression unless you
can reproduce it on 6.0 or 5.19 kernels, too. Regardless, I'd suggest
bisection is in order to find where the problem was introduced.

-Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
