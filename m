Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56321C4320A
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 03:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CCCC61222
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 03:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhHWDSZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Aug 2021 23:18:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232362AbhHWDSY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 22 Aug 2021 23:18:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5917961360
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 03:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629688659;
        bh=dS7pRu2gqa/FrDXlIii1EUc6+il9hZ6ppLAEjnsMrW8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=cUZaPTCKVbyh0/UUa92lT9b24Y6uAfexyeegZAOiO94i8VPur+ATzLZTmXU5sQLII
         mUKffe8bakqn43QdpzAlBRgPz6fSuOEFqliSophf9ZYZKf3GBHL3vmqAiOlhuzzhht
         WZ86mIpqyVFNS56bJQnbYe/e+huz0osorn6BBdQ/sAzSLNHbGJn3QbyzexsYe38eEY
         cA5+eM5tcXisSo4/wSTwqhH5xikP+ztSuJRDvGFFNa2bkzRF31CJZaS+WajdntAWfA
         WNp/AQxs3t2YbhFgoRPkq3RuQJS935tvMYusYFKYL+mMATOG9rdAsFlXrNCRzks5Sw
         i8NlL4L6BmCTA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214077] [xfstests xfs/168] xfs_repair failed with shrinking
 776672
Date:   Mon, 23 Aug 2021 03:17:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214077-201763-RkL3dJcFW6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214077-201763@https.bugzilla.kernel.org/>
References: <bug-214077-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214077

--- Comment #3 from Zorro Lang (zlang@redhat.com) ---
dmesg output, when xfs/168 run into fail:

[10782.980699] run fstests xfs/168 at 2021-08-16 09:29:52=20
[10785.856212] XFS (sda4): Mounting V5 Filesystem=20
[10785.960044] XFS (sda4): Ending clean mount=20
[10785.999747] XFS (sda4): EXPERIMENTAL online shrink feature in use. Use at
your own risk!=20
[10786.124668] XFS (sda4): Unmounting Filesystem=20
[10788.000206] XFS (sda4): Mounting V5 Filesystem=20
[10788.089115] XFS (sda4): Ending clean mount=20
[-- MARK -- Mon Aug 16 13:30:00 2021]=20
[10792.642459] XFS (sda4): Unmounting Filesystem=20
[10793.229287] XFS (sda4): Mounting V5 Filesystem=20
[10793.289566] XFS (sda4): Ending clean mount=20
[10797.115638] fsstress (111266) used greatest stack depth: 20600 bytes lef=
t=20
[10797.859428] XFS (sda4): Unmounting Filesystem=20
[10798.558178] XFS (sda4): Mounting V5 Filesystem=20
[10807.354979] XFS (sda4): Ending clean mount=20
[10810.791370] fsstress (111532) used greatest stack depth: 20312 bytes lef=
t=20
[10811.886076] XFS (sda4): xlog_verify_grant_tail: space > BBTOB(tail_block=
s)=20
[10812.241353] XFS (sda4): Unmounting Filesystem=20
[10813.075136] XFS (sda4): Mounting V5 Filesystem=20
[10813.176424] XFS (sda4): Ending clean mount=20
[10817.343832] fsstress (111792) used greatest stack depth: 20008 bytes lef=
t=20
[10817.807386] XFS (sda4): Unmounting Filesystem=20
[10819.260537] XFS (sda4): Mounting V5 Filesystem=20
[10819.923391] XFS (sda4): Ending clean mount=20
[10824.793331] XFS (sda4): Unmounting Filesystem=20
[10825.701244] XFS (sda4): Mounting V5 Filesystem=20
[10843.028604] XFS (sda4): Ending clean mount=20
[10847.696262] XFS (sda4): Unmounting Filesystem=20
[10849.031471] XFS (sda4): Mounting V5 Filesystem=20
[10849.389481] XFS (sda4): Ending clean mount=20
[10854.117904] XFS (sda4): xlog_verify_grant_tail: space > BBTOB(tail_block=
s)=20
[10854.117904] XFS (sda4): xlog_verify_grant_tail: space > BBTOB(tail_block=
s)=20
[10854.626542] XFS (sda4): Unmounting Filesystem=20
[10855.791704] XFS (sda4): Mounting V5 Filesystem=20
[10860.128289] XFS (sda4): Ending clean mount=20
[10861.518327] XFS (sda4): Error -28 reserving per-AG metadata reserve pool=
.=20
[10861.534515] XFS (sda4): Corruption of in-memory data (0x8) detected at
xfs_ag_shrink_space+0x739/0xae0 [xfs] (fs/xfs/libxfs/xfs_ag.c:877).  Shutti=
ng
down filesystem=20
[10861.543426] sda4: writeback error on inode 532936, offset 475136, sector
68696454=20
[10861.551487] XFS (sda4): Please unmount the filesystem and rectify the
problem(s)=20
[10862.297180] XFS (sda4): Unmounting Filesystem=20
[10863.893759] XFS (sda5): Unmounting Filesystem=20
[10864.373197] XFS (sda5): Mounting V5 Filesystem=20
[10864.483245] XFS (sda5): Ending clean mount=20
[10883.073207] XFS (sda4): Mounting V5 Filesystem=20
[10883.160863] XFS (sda4): Ending clean mount=20
[10883.190838] XFS (sda4): Unmounting Filesystem=20
[10883.610827] XFS (sda5): Unmounting Filesystem=20
[10884.278500] XFS (sda5): Mounting V5 Filesystem=20
[10884.322675] XFS (sda5): Ending clean mount

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
