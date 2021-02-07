Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9181C433E0
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 22:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7087A64E02
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 22:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhBGWnL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Feb 2021 17:43:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:55700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBGWnG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Feb 2021 17:43:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 93D3C64E06
        for <linux-xfs@vger.kernel.org>; Sun,  7 Feb 2021 22:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612737745;
        bh=4dClYSe7+s5jvGdBqOuJUAGw9WOE4YyQpZiWVNGka8M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZyvXlsdoUopmobxrwJeDPVh4UIiTUGrBMkv2WdZe0tuDYMA1ZguA661DDJahHm49C
         Pxfy97UD1qf+Jiw3belnOth3hVJAoNpbaBraUFxZ6LkNv622jR6PEbMtEC9Dg08FpH
         /qKq9eJh/Lv6KNyXZvpGXxTLjT9yObio0yMUY008kcBNkCIiUasBITbxYO4P8/Ofp/
         ZW+MMIRttC4d4cp0p3lm2hxA0b3EwrB+tR16dbwpMRxfYGIVuMh3fx6oqDkwVfrANj
         im6X7b9ZEPtj6eAgoHDy7xX1iEhWO0KN5boPm6+hIIKmRQ/Pw+ER7LjLrRChtk69rp
         pDeqq2u2DVNGA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211605] Re-mount XFS causes "noattr2 mount option is
 deprecated" warning
Date:   Sun, 07 Feb 2021 22:42:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-211605-201763-D0Z6yTNppB@https.bugzilla.kernel.org/>
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

--- Comment #2 from Dave Chinner (david@fromorbit.com) ---
On Sun, Feb 07, 2021 at 05:06:36AM +0000, bugzilla-daemon@bugzilla.kernel.o=
rg
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D211605
>=20
>             Bug ID: 211605
>            Summary: Re-mount XFS causes "noattr2 mount option is
>                     deprecated" warning
>            Product: File System
>            Version: 2.5
>     Kernel Version: 5.10.13
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: low
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: cuihao.leo@gmail.com
>         Regression: No
>=20
> Created attachment 295103
>   --> https://bugzilla.kernel.org/attachment.cgi?id=3D295103&action=3Dedit
> proposed fix
>=20
> After recent kernel update, I notice "XFS: noattr2 mount option is
> deprecated."
> kernel message every time I shutdown the system. It turns out that remoun=
ting
> a
> XFS causes the warning.
>=20
> Steps to Reproduce:
> 1) Mount a XFS and remount it with different options:
> > $ mount some_xfs.img /mnt/test
> > $ mount -o remount,ro /mnt/test
> 2) Check kernel message. Remounting causes a line of warning:
> > XFS: noattr2 mount option is deprecated.

That sounds like a mount(1) bug, not a kernel bug. Something is
adding the "noattr2" option to the remount line. Running you test
on my system doesn't show that warning. I'm running a 5.11-rc5 kernel
and:

$ mount -V
mount from util-linux 2.36 (libmount 2.36.0: selinux, smack, btrfs, namespa=
ces,
assert, debug)
$

And there is no such "noattr2 is deprecated" output. What version of
mount are you running?

What we really need from your system is debug that tells us exactly
what the mount option string that the mount command is handing the
mount syscall.

> I had checked my fstab and kernel params and didn't found any use of "att=
r2"
> option. It doesn't break things, but is a little confusing.

"attr2" !=3D "noattr2"

The kernel is warning about a mount option being specified that
isn't even in the set emitted in /proc/mounts. Nor is it on your
command line. Yet the kernel is warning about it, and that implies
that mount has passed it to the kernel incorrectly.

Cheers,

Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
