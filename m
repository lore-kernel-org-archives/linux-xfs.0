Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD12EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jun 2023 14:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjF2Ozo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jun 2023 10:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbjF2Ozm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2023 10:55:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5091F2102
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 07:55:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D97B061573
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 14:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4CFB3C43395
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 14:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688050537;
        bh=NbSLh9eGkYI2YlVo5EGtezIaZRBImbcoDLo17E/NRX8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZZSxas5AP5PDMUOWK5vSmscO1gJXKF06zdsUtGv0NFrMJQ108ZI6oiOk0YXbMZkCq
         dpLO6EPbbj29TsHZACPWbdnBmnYbmOknPKZaXqfL8Tw/emgwVKMBDDDZiJgXZjHYHL
         Yq6Y/+EQ2eIV/d1iXObljOlptj2mcGkTA15/MO91zcfGVYdoRHyVTt4wO6fOOJQmCx
         58DxMe+RasiADnm+eUyF4Ylr6SbCPsetQ0UwsYoa33voejYVSG6sIWGGK29OpbI9Tt
         RUn4CFj3MK1/nLqO19ahHwhk0pY/KXFcquW8vtMDCQd71fzWbB9GWpEgNwt3LmEXck
         lJz7fhonz8FCA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 3ADBBC53BD2; Thu, 29 Jun 2023 14:55:37 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217604] Kernel metadata repair facility is not available, but
 kernel has XFS_ONLINE_REPAIR=y
Date:   Thu, 29 Jun 2023 14:55:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: djwong@kernel.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: DOCUMENTED
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217604-201763-NMlchTiuIF@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217604-201763@https.bugzilla.kernel.org/>
References: <bug-217604-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217604

--- Comment #3 from Darrick J. Wong (djwong@kernel.org) ---
On Thu, Jun 29, 2023 at 07:10:35AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217604
>=20
> j.fikar@gmail.com changed:
>=20
>            What    |Removed                     |Added
> -------------------------------------------------------------------------=
---
>              Status|NEW                         |RESOLVED
>          Resolution|---                         |DOCUMENTED
>=20
> --- Comment #2 from j.fikar@gmail.com ---
> OK Dave, I'll do that. Maybe the help for XFS_ONLINE_REPAIR can mention t=
hat
> it
> is not yet working, to avoid future confusion.

Both kernel and userspace yell EXPERIMENTAL when you invoke any part of
the online fsck system; I thought that was sufficient...

--D

> Actually, I was reporting another kernel bug (vmalloc error), which was
> probably seen before and currently it is in network drivers (no idea, why=
 it
> is
> there).
>=20
> I'm telling you, as it might be XFS related. I see the bug exactly once a=
 day
> and when I look at my cron.daily jobs, it happens during xfs_fsr run.
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217502
>=20
> --=20
> You may reply to this email to add a comment.
>=20
> You are receiving this mail because:
> You are watching the assignee of the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
