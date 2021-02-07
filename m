Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05CDBC433DB
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 23:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C51D1614A5
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 23:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhBGXCL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Feb 2021 18:02:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:32854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBGXCK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Feb 2021 18:02:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 241E764E31
        for <linux-xfs@vger.kernel.org>; Sun,  7 Feb 2021 23:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612738890;
        bh=xlgbuQ8UyJJLwmhdZ1F6FxUhv0g8B5QpSFdejlX8WTs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Uf2Cl7f2M6vYsYV8D0vbWm2zlV+BUVFttWO1jT6xx2R6zwDJk41c3c21Jj3+ISUGW
         0UoxdLqrQHCtpi4HP45MkrTjRjMneQX6B6izHAWQdTdJRN6xrzwMZxhqTKizFjbWWp
         bbsSXZYDiic4uWN76nwZwtmBtx7gnx2sjlzW1VxrtWZXm6zS5l1kLKWiDQUEr7erx0
         WHg2vAtALKMhma9GpCuXKwPsenOoFiZljUXjQqSjP2F7hfME44qNssL+ZlvPumMIYM
         oyASOACySeiKf7pK2xXg7LvYd5n7S09gmx+qEI4vTNJ6DMg8SsYv+crjckqUCCzQ1T
         QDBx8JBjeFADw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211605] Re-mount XFS causes "noattr2 mount option is
 deprecated" warning
Date:   Sun, 07 Feb 2021 23:01:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: sandeen@sandeen.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-211605-201763-7XvPElabdR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211605-201763@https.bugzilla.kernel.org/>
References: <bug-211605-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211605

--- Comment #4 from Eric Sandeen (sandeen@sandeen.net) ---
On 2/7/21 4:15 PM, Dave Chinner wrote:
> On Sun, Feb 07, 2021 at 05:06:36AM +0000, bugzilla-daemon@bugzilla.kernel=
.org
> wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D211605
>>
>>             Bug ID: 211605
>>            Summary: Re-mount XFS causes "noattr2 mount option is
>>                     deprecated" warning
>>            Product: File System
>>            Version: 2.5
>>     Kernel Version: 5.10.13
>>           Hardware: All
>>                 OS: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: low
>>           Priority: P1
>>          Component: XFS
>>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>>           Reporter: cuihao.leo@gmail.com
>>         Regression: No
>>
...

> The kernel is warning about a mount option being specified that
> isn't even in the set emitted in /proc/mounts. Nor is it on your
> command line. Yet the kernel is warning about it, and that implies
> that mount has passed it to the kernel incorrectly.

I am confused about how "noattr2" showed up.

But we do still emit "attr2" in /proc/mounts, and a remount will complain
about /that/, so we do need to stop emitting deprecated options in
/proc/mounts.

# mount /dev/pmem0p1 /mnt/test
# grep pmem /proc/mounts=20
/dev/pmem0p1 /mnt/test xfs
rw,seclabel,relatime,attr2,inode64,logbufs=3D8,logbsize=3D32k,noquota 0 0
# mount -o remount,ro /mnt/test
# dmesg | tail -n 1
[346311.064017] XFS: attr2 mount option is deprecated.

Pavel, can you fix this up, since your patch did the deprecations? I guess =
we
missed this on review.

Ideally the xfs(5) man page in xfsprogs should be updated as well to reflect
the
deprecated items.


-Eric

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
