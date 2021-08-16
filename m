Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CE5C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Aug 2021 12:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC8DA63272
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Aug 2021 12:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhHPMqU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Aug 2021 08:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229643AbhHPMqT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Aug 2021 08:46:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 85B006327A
        for <linux-xfs@vger.kernel.org>; Mon, 16 Aug 2021 12:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629117948;
        bh=xwgJZr2JSn7dD3yuerkcS/cG+c/R9fol7sHHf4+a5XY=;
        h=From:To:Subject:Date:From;
        b=UZmTPYGrnfQ1Uw4iAR0HPh5D3QjpCIdEA36tX+czhLzwc7JWgEPieDTH5vv/Z3bcf
         C2HVK7i++vAfdkUFBbjQVUs5wxg7WiELzrNsOa6a0PFbZrpaWo3/d5pPVNFXS+FgM8
         q/Fc34TRpOe4jT3sP684ozqckfPCcDLDBJfYJtxEEgQHBqfqVCtWykm3YpWFMXbdUS
         gq9yR1OHVYnXF4C57m7HQAmDIu2lNhtOwwhcOr/niLtEaBfW5FLSv2TaTeOTIZctJ9
         l91LHuU9ldGrX8OUyFd3fHSSOPEvTEsrDri115ZXRnPk26AzdkcZ5KHW8LCbaTVDXW
         X0eHEJFKBqeLg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214079] New: [xfstests xfs/168] xfs_repair failed with
 shrinking 776672
Date:   Mon, 16 Aug 2021 12:45:48 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
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
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-214079-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214079

            Bug ID: 214079
           Summary: [xfstests xfs/168] xfs_repair failed with shrinking
                    776672
           Product: File System
           Version: 2.5
    Kernel Version: v5.14-rc4 + xfs-5.15-merge-1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

xfstests xfs/168 fails on ppc64le with xfs-linux kernel xfs-5.15-merge-1:

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/ppc64le ibm-p9z-06-lp1 5.14.0-rc4+ #1 SMP Mon Aug 16
05:26:46 EDT 2021
MKFS_OPTIONS  -- -f -m crc=3D1,finobt=3D1,reflink=3D1,rmapbt=3D1,bigtime=3D=
1,inobtcount=3D1
-b size=3D1024 /dev/sda3
MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /dev/sda3
/mnt/xfstests/scratch

xfs/168 [failed, exit status 1]- output mismatch (see
/var/lib/xfstests/results//xfs/168.out.bad)
    --- tests/xfs/168.out       2021-08-16 08:00:55.599141174 -0400
    +++ /var/lib/xfstests/results//xfs/168.out.bad      2021-08-16
08:03:59.237993851 -0400
    @@ -1,2 +1,3 @@
     QA output created by 168
    -Silence is golden
    +xfs_repair failed with shrinking 776672
    +(see /var/lib/xfstests/results//xfs/168.full for details)
    ...
    (Run 'diff -u /var/lib/xfstests/tests/xfs/168.out
/var/lib/xfstests/results//xfs/168.out.bad'  to see the entire diff)
Ran: xfs/168
Failures: xfs/168
Failed 1 of 1 tests


Part of .full output:
...
...
xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: No space left on device
meta-data=3D/dev/sda3              isize=3D512    agcount=3D2, agsize=3D517=
120 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D1
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D1
data     =3D                       bsize=3D1024   blocks=3D776673, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D1024   blocks=3D6011, version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
fsstress: check_cwd failure
fsstress: check_cwd failure
fsstress: check_cwd failure
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
xfs_growfs: /mnt/xfstests/scratch is not a mounted XFS filesystem
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ALERT: The filesystem has valuable metadata changes in a log which is being
ignored because the -n option was used.  Expect spurious inconsistencies
which may be resolved by first mounting the filesystem to replay the log.
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
        - agno =3D 1
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 1
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.
xfs_repair failed with shrinking 776672

Please check the attachment to get full .full output file

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
