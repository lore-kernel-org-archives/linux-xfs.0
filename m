Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79561C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 07:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbiEXHyQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 03:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233042AbiEXHyO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 03:54:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062F87B9E4
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 00:54:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0D6D61587
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 07:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 095E0C3411C
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 07:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653378853;
        bh=+mDB/czA+lE0Iu++HPK+bJ9dNBCWed1wGgJdCxv5Eq4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=qEaxN1Uw9XI2qCGIi3VYH0qMbC2DmRMNLN/kg+fAXO70bL2eRe/0qtA0vkC+zfWhx
         jtyq13LXMimLjn0aj1iXNDfQ3oVzr9VHQArWOjVW/xi3hNmdiSUaOF7/z4if7uyDv7
         qiBDURbMLJCrFAMc3IxyZiRZ8ApKFxmkcJUj4knaW83WhI6ieJWCws82XvqZthlJFI
         2NH8nvXHQyyVW66WmMGmbMNOjO+bmcJPISZbUoRKSSnSIP5kmN9OgrM3dSbaQlulKt
         HvFg8cRRAY2mEqC+eWfDk2nHlMvxultHQ2MUDDSFyNrQYts3C2m465L2dELoLCjKbm
         YL2xtjh+rNP+g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E9CB1CC13B7; Tue, 24 May 2022 07:54:12 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Tue, 24 May 2022 07:54:12 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jack@suse.cz
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216007-201763-yqCmjiClvN@https.bugzilla.kernel.org/>
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

Jan Kara (jack@suse.cz) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz

--- Comment #10 from Jan Kara (jack@suse.cz) ---
(In reply to Peter Pavlisko from comment #6)
> (In reply to Chris Murphy from comment #2)
> > number of CPUs
>=20
> 1 CPU, 2 cores (Intel Celeron G1610T @ 2.30GHz)

OK, not much CPU power :)

> > contents of /proc/meminfo
>=20
> (at the time of iowait hangup)
>=20
> MemTotal:        3995528 kB
> MemFree:           29096 kB
> MemAvailable:    3749216 kB
> Buffers:           19984 kB
> Cached:          3556248 kB
> SwapCached:            0 kB
> Active:            62888 kB
> Inactive:        3560968 kB
> Active(anon):        272 kB
> Inactive(anon):    47772 kB
> Active(file):      62616 kB
> Inactive(file):  3513196 kB
> Unevictable:           0 kB
> Mlocked:               0 kB
> SwapTotal:       2097084 kB
> SwapFree:        2097084 kB
> Dirty:                28 kB
> Writeback:             0 kB

Interestingly basically no dirty memory or memory under writeback. Basically
everything is in Inactive(file) list which should be very easy to reclaim. =
But
given you say we make no progress in reclaiming memory and from the traces =
we
see process is hung waiting for memory allocation, it may be that the page
cache pages are pinned in memory by extra references or something like that.
The question is what could be XFS doing that clean page cache cannot be
reclaimed? I have no good answer to that...

...

>    8        0 1953514584 sda
>    8        1     131072 sda1
>    8        2    2097152 sda2
>    8        3 1951285336 sda3
>    8       16 1953514584 sdb
>    8       17     131072 sdb1
>    8       18    2097152 sdb2
>    8       19 1951285336 sdb3
>    8       32  976762584 sdc
>    8       33  976761560 sdc1
>   11        0    1048575 sr0
>    9        3 1951285248 md3
>    9        2    2097088 md2
>    9        1     131008 md1

Actually not that much overall memory compared to the disk sizes or the siz=
e of
unpacked archive.

You've mentioned another kernel config does not exhibit the problem. Can you
perhaps post it here for comparison?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
