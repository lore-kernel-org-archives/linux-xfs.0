Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A09C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 13:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377130AbiFPNjh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 09:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377149AbiFPNjg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 09:39:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADF62CC90
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 06:39:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2F9D61D19
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 13:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3E2EEC341C6
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 13:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655386774;
        bh=27g6AcSrNtewU0GskuHOqmr8+n9InznVkWYjA4tCXO8=;
        h=From:To:Subject:Date:From;
        b=kmEIKJvZIU4xZB6HoOyatIPYb8hj9QCha5MKp9qRVwt6dos7ndFHL4s8Y7K19B4nW
         8I2vfATHV8IqeWf4FHwzkuKmqnbLWs+SvHmqmBHMAQ/wJuouFrAkv2gWTVtg2hyFoR
         dkk8f8qip/Wj53EK0HumiAmpjb7kjqdvyH3leaFv5N4SYryzYOPgW6q8ffP85zeCct
         heKwylsQmDHZyT6RwE2r8rBa0mkHFpBm9aTqjqbv/hTvJveHCeVXXJ4TTHVOOEQss8
         0My5cCststkIZSmUUpwk0A2L5HdXzH7/Nbgc5UTGX/IOZDEdmks10WgDwbhXWI2XfX
         cCjB8+8tsQMNQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2A621C05FD2; Thu, 16 Jun 2022 13:39:34 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216141] New: xfs corrupted directly after sized mkfs
Date:   Thu, 16 Jun 2022 13:39:33 +0000
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
Message-ID: <bug-216141-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216141

            Bug ID: 216141
           Summary: xfs corrupted directly after sized mkfs
           Product: File System
           Version: 2.5
    Kernel Version: v5.19-rc2
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

I suddently hit xfstests generic/096 fails on a striped XFS. It's easy to
reproduce on my system manually by below steps:

# git lo | head -1
8c642e6f xfsprogs: Release v5.18.0
# ./mkfs/mkfs.xfs -f -d size=3D$((512*1024*1024)) /dev/sda5
meta-data=3D/dev/sda5              isize=3D512    agcount=3D8, agsize=3D163=
84 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D0
         =3D                       reflink=3D1    bigtime=3D1 inobtcount=3D1
data     =3D                       bsize=3D4096   blocks=3D131072, imaxpct=
=3D25
         =3D                       sunit=3D64     swidth=3D64 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D4096   blocks=3D16320, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D64 blks, lazy-cou=
nt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
# echo $?
0
# ./repair/xfs_repair -n /dev/sda5
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - zero log...
        - 21:35:03: zeroing log - 16320 of 16320 blocks done
        - scan filesystem freespace and inode maps...
agf_freeblks 58, counted 0 in ag 4
sb_fdblocks 114696, counted 114638
        - 21:35:03: scanning filesystem freespace - 8 of 8 allocation groups
done
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - 21:35:03: scanning agi unlinked lists - 8 of 8 allocation groups =
done
        - process known inodes and perform inode discovery...
        - agno =3D 0
        - agno =3D 7
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - 21:35:03: process known inodes and inode discovery - 64 of 64 ino=
des
done
        - process newly discovered inodes...
        - 21:35:03: process newly discovered inodes - 8 of 8 allocation gro=
ups
done
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - 21:35:03: setting up duplicate extent list - 8 of 8 allocation gr=
oups
done
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 4
        - agno =3D 2
        - agno =3D 3
        - agno =3D 5
        - agno =3D 7
        - agno =3D 6
        - agno =3D 1
        - 21:35:03: check for inodes claiming duplicate blocks - 64 of 64
inodes done
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
        - 21:35:04: verify and correct link counts - 8 of 8 allocation grou=
ps
done
No modify flag set, skipping filesystem flush and exiting.
# echo $?
1

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
