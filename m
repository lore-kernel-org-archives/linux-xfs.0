Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CEF5C7EE29
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 02:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjFECgA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Jun 2023 22:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjFECf7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Jun 2023 22:35:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6792FBD
        for <linux-xfs@vger.kernel.org>; Sun,  4 Jun 2023 19:35:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F37B06148E
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 02:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 56049C433A7
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 02:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685932557;
        bh=zcSeDv+nyne4A32RYy3fWtHRqxZlghlL5cKx+CmB13E=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=HLyKMyB4X5nal/oo9uy7V6LBex9kbiyxJsiK43IRW0yD/yYTHl8ivcjjvr89pqv7f
         oTbdCUskVdvJkQRqvUNDxB2Fk/0qPkGUOA8lwp1PDk0aMnxUqjlhTpmOuYtufXS7fe
         oJWARvgu4IajQhtaa2EQY4yJAg81iAZ4YYDMAl03LQBEGvCEeg0/7jfevVGLW3c5bX
         0bhxbO+qXi2kHeYkii79Bp+lrzzA0A9W6xLg1L4wP9KwjbvdB0EukseOkLFd41/rfy
         sme2zMJeNiFPSRSMrWAvVtPbM+B/Vi702pbV+GHdaqXMFxt/AG9TDwACMzzEl8DHHx
         ZcqLh793UsP2Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 430C2C43145; Mon,  5 Jun 2023 02:35:57 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217522] xfs_attr3_leaf_add_work produces a warning
Date:   Mon, 05 Jun 2023 02:35:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lomov.vl@bkoty.ru
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217522-201763-C8jHF6liFM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217522-201763@https.bugzilla.kernel.org/>
References: <bug-217522-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217522

--- Comment #4 from Vladimir Lomov (lomov.vl@bkoty.ru) ---
Hello.
** bugzilla-daemon@kernel.org <bugzilla-daemon@kernel.org> [2023-06-04 18:3=
2:00
+0000]:

> https://bugzilla.kernel.org/show_bug.cgi?id=3D217522

>>> Yes, this bug is a collision between the bad old ways of doing flex
>>> arrays:
>>>
>>> typedef struct xfs_attr_leaf_name_local {
>>>         __be16  valuelen;               /* number of bytes in value */
>>>         __u8    namelen;                /* length of name bytes */
>>>         __u8    nameval[1];             /* name/value bytes */
>>> } xfs_attr_leaf_name_local_t;

>>> And the static checking that gcc/llvm purport to be able to do properly.

>> Something similar has caused problems with kernel compilation before:
>> https://lkml.org/lkml/2023/5/24/576 (I'm not 100% sure if the origin is =
the
>> same though).

> Yup.

Ok, I see. The "proper" way to get rid of the warning requires too much
effort, so there are doubts as to whether it is worth it.

>>> This is encoded into the ondisk structures, which means that someone
>>> needs to do perform a deep audit to change each array[1] into an
>>> array[] and then ensure that every sizeof() performed on those structure
>>> definitions has been adjusted.  Then they would need to run the full QA
>>> test suite to ensure that no regressions have been introduced.  Then
>>> someone will need to track down any code using
>>> /usr/include/xfs/xfs_da_format.h to let them know about the silent
>>> compiler bomb heading their way.

>>> I prefer we leave it as-is since this code has been running for years
>>> with no problems.

>> Should I assume that this problem is not significant and won't have any
>> effect
>> to the FS and won't cause the FS to misbehave or become corrupted? If so,
>> why
>> does the problem only show up on one host but not on the other? Or is th=
is a
>> runtime check, and it somehow happens on the first system (even rebooted
>> twice), but not on the second one.

> AFAICT, there's no real memory corruption problem here; it's just that
> the compiler treats array[1] as a single-element array instead of
> turning on whatever magic enables it to handle flexarrays (aka array[]
> or array[0]).  I don't know why you'd ever want a real single-element
> array, but legacy C is fun like that. :/

Ok, I get it, but what bothers me is why I only see this message on one
system and not the other.

At first I thought it had to do with the fact that I explicitly set
"read-only" attribute (chattr +i) to one file (/etc/resolv.conf), but I
checked that both systems had the same settings on that file. Then I thought
it might be a problem with XFS, but I configured to run fsck on every boot,=
 so
that the problem would be revealed at boot time, and I wouldn't see it again
after the next reboot. But the message remains even after reboot. So I must
conclude that the warning has nothing to do with the FS and the problem lies
somewhere else.

I'm puzzled why I don't see this message on the second system, especially
since I didn't see it with kernel 5.15 and the previous linux-next (I have a
different problem with these systems, so I don't run kernels 6.0+, but I'm
running linux-next to see if the problem persists). Let me stress what worr=
ies
me: why am I seeing this message on one system and not on the other? Why I
didn't see this message on the previous linux-next (compiled with the same
compiler)?

It might be related to the disks used (HDD, SSD SATA and NVME), because on =
the
system in question systemd gives a warning like 'invalid GPT table' (or
something like that, not the exact wording), even when I have repartitioned
the disk.

[...]

---
Vladimir Lomov

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
