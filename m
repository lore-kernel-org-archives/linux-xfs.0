Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399CFECAAA1
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 21:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiJ3VrN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 17:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiJ3VrM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 17:47:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D061A190
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 14:47:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D931C60F66
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 21:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 42E95C43140
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 21:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667166431;
        bh=5hF8fvdF+ckyIKnk6TVXDukp09ASbXLId9HG/UUPQMk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FEMIyXSYV7YHSqToGnERwESei/8/SCEMYgIEizql2Ma2fM0VGW02BPwAU5/F4ylxK
         AV5MUJjsjMWtv9DtJ4mOzqv+28aC/YJiMWcMXnyhmtE6R8iTU5E3teXasi8SwHwuY6
         1BlRgNN/uyczuPsSmRlkvLOap2LbUAvTiKAqeyW32IfxavN7oLvsA9+0N35FG81CU3
         APAOn8GB1j+RS6BN5l732Zsb8hxiyFfy506jysgrg1DaDQuCYgfQQZ9m4dM4peT4WI
         TEKQ2Po8Ie/E3VQkv1pGDXhxhi+GmAXw46m91H919HnrUkdeEct90jim4o2OmAQ5od
         TuNvEyzT2dsgQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2E68BC433E9; Sun, 30 Oct 2022 21:47:11 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216639] [xfstests] WARNING: CPU: 1 PID: 429349 at
 mm/huge_memory.c:2465 __split_huge_page_tail+0xab0/0xce0
Date:   Sun, 30 Oct 2022 21:47:10 +0000
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
Message-ID: <bug-216639-201763-m7sTjutx8D@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216639-201763@https.bugzilla.kernel.org/>
References: <bug-216639-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216639

--- Comment #2 from Dave Chinner (david@fromorbit.com) ---
On Sun, Oct 30, 2022 at 02:38:17AM +0000, bugzilla-daemon@kernel.org wrote:
> Many xfstests cases fail [1] and hit below kernel
> (HEAD=3D05c31d25cc9678cc173cf12e259d638e8a641f66) warning [2] (on x86_64 =
and
> s390x). No special mkfs or mount options, just simple default xfs testing,
> without any MKFS_OPTIONS or MOUNT_OPTIONS specified.
>=20
> [1]
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 hp-xxxxxx-xx-xxxx 6.1.0-rc2+ #1 SMP
> PREEMPT_DYNAMIC Fri Oct 28 19:52:51 EDT 2022
> MKFS_OPTIONS  -- -f -m
> crc=3D1,finobt=3D1,rmapbt=3D0,reflink=3D1,bigtime=3D1,inobtcount=3D1
> /dev/vda2
> MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /dev/vda2
> /mnt/xfstests/scratch
>=20
> generic/061       _check_dmesg: something found in dmesg (see
> /var/lib/xfstests/results//generic/061.dmesg)
>=20
> Ran: generic/061
> Failures: generic/061
> Failed 1 of 1 tests
>=20
> [2]
> [14281.743118] run fstests generic/061 at 2022-10-29 01:00:39
> [14295.930483] page:000000001065a86b refcount:0 mapcount:0
> mapping:0000000064faa2f2 index:0x40 pfn:0x143040
> [14295.947825] head:000000001065a86b order:5 compound_mapcount:0
> compound_pincount:0
> [14295.950100] memcg:ffff88817efe2000
> [14295.951215] aops:xfs_address_space_operations [xfs] ino:8e dentry
> name:"061.429109"
> [14295.955474] flags:
> 0x17ffffc0010035(locked|uptodate|lru|active|head|node=3D0|zone=3D2|lastcp=
upid=3D0x1fffff)
> [14295.958302] raw: 0017ffffc0010035 ffffea0004756c08 ffffea00050c1788
> ffff88811e804448
> [14295.960624] raw: 0000000000000040 0000000000000000 00000000ffffffff
> ffff88817efe2000
> [14295.962927] page dumped because: VM_WARN_ON_ONCE_PAGE(page_tail->priva=
te
> !=3D 0)
> [14295.965744] ------------[ cut here ]------------
> [14295.967201] WARNING: CPU: 1 PID: 429349 at mm/huge_memory.c:2465
> __split_huge_page_tail+0xab0/0xce0
....
> [14296.015290] Call Trace:
> [14296.016083]  <TASK>
> [14296.018235]  __split_huge_page+0x2a5/0x11b0
> [14296.019675]  split_huge_page_to_list+0xb13/0xf30
> [14296.027369]  truncate_inode_partial_folio+0x1d9/0x370
> [14296.028940]  truncate_inode_pages_range+0x350/0xbc0
> [14296.059204]  truncate_pagecache+0x63/0x90
> [14296.060471]  xfs_setattr_size+0x2a2/0xc50 [xfs]

Yup, splitting a multi-page folio during truncate. Looks like this
has already been fixed in the Linus kernel by commit 5aae9265ee1a
("mm: prep_compound_tail() clear page->private") here:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D5aae9265ee1a30cf716d6caf6b29fe99b9d55130

It was merged after your currrent head commit...

This won't reproduce on ext4 because it doesn't use multi-page
folios in the page cache.

Cheers,

Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
