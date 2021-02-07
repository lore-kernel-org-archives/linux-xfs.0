Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CFE5C433E0
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 05:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A5D864E31
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Feb 2021 05:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhBGFHS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Feb 2021 00:07:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhBGFHR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Feb 2021 00:07:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0B09564E34
        for <linux-xfs@vger.kernel.org>; Sun,  7 Feb 2021 05:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612674397;
        bh=I23KbEI6BE8Hp86bAsZ5D1wDKQPpftNAyaD0wSahb+4=;
        h=From:To:Subject:Date:From;
        b=pbPvSDSCPXuS7zhxqqibZFpgnwQDAO/dzFoprf1D20PB7UdATF0x6pXfhBLBambOl
         f38cVZeHxWRPWjzURyKbQTy6ZqwppX32o4Fe803dn75AsHHG4c29w6dkkE2ckRn0bc
         VcAJI/rCmLsnrx2UaHezqElifWK6UtzLQN0g1tVIlyBsKHDrr7zogG8d4SR52CS+Ig
         SfwfQkCwr0GFskWw+IeYrvRnAOKClvjBif4YGuKtFUEg9khPGmrmb5+c0nfu+KkltQ
         h8gwOB1Wnnnj9C6GBOSO6IZJG9i0rsquJJUgvdU10B10VCmDQWnDa+E2Y6RPUv7ai9
         RZMmixuUxcSWA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 211605] New: Re-mount XFS causes "noattr2 mount option is
 deprecated" warning
Date:   Sun, 07 Feb 2021 05:06:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: cuihao.leo@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-211605-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211605

            Bug ID: 211605
           Summary: Re-mount XFS causes "noattr2 mount option is
                    deprecated" warning
           Product: File System
           Version: 2.5
    Kernel Version: 5.10.13
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: cuihao.leo@gmail.com
        Regression: No

Created attachment 295103
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D295103&action=3Dedit
proposed fix

After recent kernel update, I notice "XFS: noattr2 mount option is deprecat=
ed."
kernel message every time I shutdown the system. It turns out that remounti=
ng a
XFS causes the warning.

Steps to Reproduce:
1) Mount a XFS and remount it with different options:
> $ mount some_xfs.img /mnt/test
> $ mount -o remount,ro /mnt/test
2) Check kernel message. Remounting causes a line of warning:
> XFS: noattr2 mount option is deprecated.

I had checked my fstab and kernel params and didn't found any use of "attr2"
option. It doesn't break things, but is a little confusing.

Build Information:
Arch Linux stock kernel.
Linux cvhc-tomato 5.10.13-arch1-1 #1 SMP PREEMPT Wed, 03 Feb 2021 23:44:07
+0000 x86_64 GNU/Linux

Additional Information:
The warning is introduced in commit c23c393e. I guess remounting triggers it
because XFS driver still writes attr2 option to /proc/mounts:
> $ grep attr2 /proc/mounts
> /dev/nvme0n1p3 / xfs rw,noatime,attr2,inode64,logbufs=3D8,logbsize=3D32k,=
noquota
> 0 0

"attr2" is default so it should be omitted in mount options. A potential fix
(attached, untested) is to hide it and make "noattr2" explicit in
xfs_fs_show_options.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
