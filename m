Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33CFC433E0
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 22:57:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A2AB61606
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 22:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhBGW5Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Feb 2021 17:57:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhBGW5Q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Feb 2021 17:57:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 049A964E2A
        for <linux-xfs@vger.kernel.org>; Sun,  7 Feb 2021 22:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612738596;
        bh=dLjCDTREESqTlFCiMxOTE+cLwuXZXppZN3uR70KpH+E=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=F3dTLYg6g/JfheYQn5PID4LeA34t0Adu+Nyx2YG4MWOOOKAQYZ7gq/fGcQJcWLnLU
         9nVj82IM/yELlWbFrWhEvVpC9XnRYRyA7FSxszxJ4H/QavHNWYLh0s2ZaL3T8Gb37I
         X8zFF0g2mUwaOoBA/vKrd8GZdvxxFUXbSGZlBWu2OrDLcFrNl4kN44qYkbxLwrhaQY
         ALwQH0zF6Xkrf3tTKKDMwP2adV00yCIFWISr+Gqq/weevRPgel6nCKBPXUGZjVlOGF
         eArUEs8wehceY1Q9QFffGmPCuklJ9m0s+dWUPZGr6yMhlFrFNFqL+LX6o98Srb/Juk
         X4lCpxiP+v9Nw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211605] Re-mount XFS causes "noattr2 mount option is
 deprecated" warning
Date:   Sun, 07 Feb 2021 22:56:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: sandeen@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-211605-201763-chWJnzyMWI@https.bugzilla.kernel.org/>
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

--- Comment #3 from Eric Sandeen (sandeen@redhat.com) ---
I think we do have a buglet here, but I can't explain how you are getting
"noattr2"

Can you rerun the test with more info, i.e.:

$ mount -V
$ mount some_xfs.img /mnt/test
$ grep /mnt/test /proc/mounts
$ strace -emount -v mount -o remount,ro /mnt/test

so we can see the mount version, the contents of /proc/mounts, and what gets
sent to the mount syscall?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
