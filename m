Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,TVD_SUBJ_ACC_NUM,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB6FC4363D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 18:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83C902311B
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 18:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbgIXST1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 14:19:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727753AbgIXST0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Sep 2020 14:19:26 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date:   Thu, 24 Sep 2020 18:19:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: daimh@umich.edu
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: PATCH_ALREADY_AVAILABLE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-202127-201763-VBabxAHYN6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202127-201763@https.bugzilla.kernel.org/>
References: <bug-202127-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202127

daimh@umich.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |PATCH_ALREADY_AVAILABLE

--- Comment #37 from daimh@umich.edu ---
Today another new machine had the same problem. I fixed it by upgrading the
firmware.


####Here is the info before the update
# /opt/MegaRAID/storcli/storcli  /c0 show all |grep ^Firmware
Firmware Package Build = 24.19.0-0049
Firmware Version = 4.720.00-8220
# blockdev --getiomin   --getioopt /dev/sdc
1048576
262144
# mkfs -t xfs /dev/sdc 
meta-data=/dev/sdc               isize=512    agcount=262, agsize=268434944
blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=70314098688, imaxpct=1
         =                       sunit=256    swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
SB stripe unit sanity check failed
Metadata corruption detected at 0x56324656db89, xfs_sb block 0x0/0x1000
libxfs_bwrite: write verifier failed on xfs_sb bno 0x0/0x1000
mkfs.xfs: Releasing dirty buffer to free list!
found dirty buffer (bulk) on free list!
SB stripe unit sanity check failed
Metadata corruption detected at 0x56324656db89, xfs_sb block 0x0/0x1000
libxfs_bwrite: write verifier failed on xfs_sb bno 0x0/0x1000
mkfs.xfs: writing AG headers failed, err=117


#####Then I upgraded with the command below and rebooted it
# /opt/MegaRAID/storcli/storcli  /c0 download file=mr3316fw.rom 

#####Here the info after the update
# /opt/MegaRAID/storcli/storcli  /c0 show all |grep -i firmware
Firmware Package Build = 24.22.0-0071
Firmware Version = 4.740.00-8452
# blockdev --getiomin   --getioopt /dev/sdc
262144
262144
#

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
