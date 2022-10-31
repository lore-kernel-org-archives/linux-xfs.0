Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CDA0C38A02
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Oct 2022 01:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJaBVx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 21:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJaBVw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 21:21:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B181BE6
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 18:21:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C2B8B810D8
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 01:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E8D6C43141
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 01:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667179308;
        bh=nS+cln8CIohRP96Zy8qLMPnCE/0H0ioBgHbXv666DUg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fqC8yTBhinDX5UpVHdwys87XBo2urHj2JtJ/Fmf6hKuiqa8X3cyi2/4aFXHhXddmJ
         6hu4Saqf1JgMnMsYpbHEDbdPYnoZPavUOAcsFtyi5PJf+UI2hPzLYivBvKCJtdNSss
         fe8/5a8+4Nbl+9tMGGpM13LLgDHKXJ7Vn89aqx+4njbXAIvmPYA40qmOJPk9sga4AP
         erlVOB7qqee/lLfk61kOtJFEH9ftTd4+CwLNbyxMTla8FGg+gkUKygXSrW45SE7Jg/
         20bR3oLFIZ7KuW5ScbuOpblceC/M1sfx0GYPRTJvXqVSm754SBbmq0kqo9f4KSXmWw
         GQx3HFNscIO4Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7E6E1C433E9; Mon, 31 Oct 2022 01:21:48 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216639] [xfstests] WARNING: CPU: 1 PID: 429349 at
 mm/huge_memory.c:2465 __split_huge_page_tail+0xab0/0xce0
Date:   Mon, 31 Oct 2022 01:21:48 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: PATCH_ALREADY_AVAILABLE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216639-201763-E7Sgkj3yB8@https.bugzilla.kernel.org/>
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

Zorro Lang (zlang@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |PATCH_ALREADY_AVAILABLE

--- Comment #3 from Zorro Lang (zlang@redhat.com) ---
(In reply to Dave Chinner from comment #2)
> On Sun, Oct 30, 2022 at 02:38:17AM +0000, bugzilla-daemon@kernel.org wrot=
e:
> > Many xfstests cases fail [1] and hit below kernel
> > (HEAD=3D05c31d25cc9678cc173cf12e259d638e8a641f66) warning [2] (on x86_6=
4 and
> > s390x). No special mkfs or mount options, just simple default xfs testi=
ng,
> > without any MKFS_OPTIONS or MOUNT_OPTIONS specified.
> >=20
> > [1]
> > FSTYP         -- xfs (debug)
> > PLATFORM      -- Linux/x86_64 hp-xxxxxx-xx-xxxx 6.1.0-rc2+ #1 SMP
> > PREEMPT_DYNAMIC Fri Oct 28 19:52:51 EDT 2022
> > MKFS_OPTIONS  -- -f -m
> > crc=3D1,finobt=3D1,rmapbt=3D0,reflink=3D1,bigtime=3D1,inobtcount=3D1
> > /dev/vda2
> > MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /dev/vda2
> > /mnt/xfstests/scratch
> >=20
> > generic/061       _check_dmesg: something found in dmesg (see
> > /var/lib/xfstests/results//generic/061.dmesg)
> >=20
> > Ran: generic/061
> > Failures: generic/061
> > Failed 1 of 1 tests
> >=20
> > [2]
> > [14281.743118] run fstests generic/061 at 2022-10-29 01:00:39
> > [14295.930483] page:000000001065a86b refcount:0 mapcount:0
> > mapping:0000000064faa2f2 index:0x40 pfn:0x143040
> > [14295.947825] head:000000001065a86b order:5 compound_mapcount:0
> > compound_pincount:0
> > [14295.950100] memcg:ffff88817efe2000
> > [14295.951215] aops:xfs_address_space_operations [xfs] ino:8e dentry
> > name:"061.429109"
> > [14295.955474] flags:
> >
> 0x17ffffc0010035(locked|uptodate|lru|active|head|node=3D0|zone=3D2|lastcp=
upid=3D0x1fffff)
> > [14295.958302] raw: 0017ffffc0010035 ffffea0004756c08 ffffea00050c1788
> > ffff88811e804448
> > [14295.960624] raw: 0000000000000040 0000000000000000 00000000ffffffff
> > ffff88817efe2000
> > [14295.962927] page dumped because: VM_WARN_ON_ONCE_PAGE(page_tail->pri=
vate
> > !=3D 0)
> > [14295.965744] ------------[ cut here ]------------
> > [14295.967201] WARNING: CPU: 1 PID: 429349 at mm/huge_memory.c:2465
> > __split_huge_page_tail+0xab0/0xce0
> ....
> > [14296.015290] Call Trace:
> > [14296.016083]  <TASK>
> > [14296.018235]  __split_huge_page+0x2a5/0x11b0
> > [14296.019675]  split_huge_page_to_list+0xb13/0xf30
> > [14296.027369]  truncate_inode_partial_folio+0x1d9/0x370
> > [14296.028940]  truncate_inode_pages_range+0x350/0xbc0
> > [14296.059204]  truncate_pagecache+0x63/0x90
> > [14296.060471]  xfs_setattr_size+0x2a2/0xc50 [xfs]
>=20
> Yup, splitting a multi-page folio during truncate. Looks like this
> has already been fixed in the Linus kernel by commit 5aae9265ee1a
> ("mm: prep_compound_tail() clear page->private") here:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/
> ?id=3D5aae9265ee1a30cf716d6caf6b29fe99b9d55130
>=20
> It was merged after your currrent head commit...

Thanks Dave! Hahah, looks like I just missed that fix :) I submitted testing
jobs on Friday night, then checked results on Sunday morning, just missed t=
his
commit merging.

Thanks,
Zorro

>=20
> This won't reproduce on ext4 because it doesn't use multi-page
> folios in the page cache.
>=20
> Cheers,
>=20
> Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
