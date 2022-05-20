Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA858C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 11:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbiETL4R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 07:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236577AbiETL4M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 07:56:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AA910FE2
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 04:56:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B76CB82B3D
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 11:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C16CAC3411A
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 11:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653047766;
        bh=HaHVlJUf0VZSA82160Bum5CTe9Zl6XfClOBC8xAIcK0=;
        h=From:To:Subject:Date:From;
        b=fomJ/eGErGyb01jNiJGDiZDoDP3o1elCOayCHEkyRaghRGdX9dkEddb4ppKyaMCRY
         Dw3TPb/yp8UQi/CEKrAZJRAi7u6+0iYLlcsvzt1oHU6hvNWVB4kWuEHvwDIs813Zdn
         UX9SsPH7BALtGCDElj2osX0uiqFRPXohqPQk2csT/WTOlxdQTmfMHY20nc57D5z7EG
         L8IfGkHNtmIRWB3Z7AWfCfjUgBqMABPV+8M/x0rQDannKP+TirY6RsxdOKCQH6sog8
         eDRmIby2V8IKNmDtJ/vnimDPZlLIil1W+e3uoUBtucww727/IH4eJmN7znpXrNJcBO
         YLGjwkspWc0Yg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B0EE1CC13B0; Fri, 20 May 2022 11:56:06 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] New: XFS hangs in iowait when extracting large number
 of files
Date:   Fri, 20 May 2022 11:56:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bugzkernelorg8392@araxon.sk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-216007-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216007

            Bug ID: 216007
           Summary: XFS hangs in iowait when extracting large number of
                    files
           Product: File System
           Version: 2.5
    Kernel Version: 5.15.32
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: bugzkernelorg8392@araxon.sk
        Regression: No

Created attachment 301008
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301008&action=3Dedit
output from dmesg after echo w > /proc/sysrq-trigger

Overview:

When I try to extract an uncompressed tar archive (2.6 milion files, 760.3 =
GiB
in size) on newly created (empty) XFS file system, after first low tens of
gigabytes extracted the process hangs in iowait indefinitely. One CPU core =
is
100% occupied with iowait, the other CPU core is idle (on 2-core Intel Cele=
ron
G1610T).

I have kernel compiled with my .config file. When I try this with a more
"standard" kernel, the problem is not reproducible.

Steps to Reproduce:

1) compile the kernel with the attached .config

2) reboot with this kernel

3) create a new XFS filesystem on a spare drive (just mkfs.xfs -f <dev>)

4) mount this new file system

5) try to extract large amount of data there

Actual results:

After 20-40 GiB written, the process hangs in iowait indefinitely, never
finishing the archive extraction.

Expected Results:

Archive extraction continues smoothly until done.

Build Date & Hardware:

2022-05-01 on HP ProLiant MicroServer Gen8, 4GB ECC RAM

Additional Information:

No other filesystem tested with the same archive on the same hardware befor=
e or
after this (ext2, ext3, ext4, reiserfs3, jfs, nilfs2, f2fs, btrfs, zfs) has
shown this behavior. When I downgraded the kernel to 5.10.109, the XFS star=
ted
working again. Kernel versions higher than 5.15 seem to be affected, I tried
5.17.1, 5.17.6 and 5.18.0-rc7, they all hang up after a few minutes.

No error is reported to the system log or to dmesg when the process hangs. =
No
error shows on stdout or stderr of the tar process either.

This is not a SMR problem. None of the disks present in the test setup are =
SMR.
All are CMR, and while they certainly are not brand new, they are all in go=
od
working condition.

Attached is the dmesg output after issuing this command:

echo w > /proc/sysrq-trigger

More could be found here: https://forums.gentoo.org/viewtopic-p-8709116.html

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
