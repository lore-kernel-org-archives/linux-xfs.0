Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D012C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Oct 2021 02:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01A4B61166
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Oct 2021 02:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhJ2CZP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Oct 2021 22:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhJ2CZO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Oct 2021 22:25:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DC9ED61177
        for <linux-xfs@vger.kernel.org>; Fri, 29 Oct 2021 02:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635474166;
        bh=MRf0f4Kja1CxCzDCWUhP21BL2VCI8GKeSB6FNBhAfqE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ebwrpSdXGyQGnafnbK/1ak/cDIxsHeiPi1gIQkyHTzytEtV3bBWhzS5HldFLvhLvz
         zKv76ysPOyAzcNllqL3FSTvj3wBu4qQimxrUpHj+dSBbNWb44aW3yQ+IMJ0N74IwG3
         T2DD2mfztPfdLlvzIMug5XC8nrMyouOMCc0M2V2sM1/HMdtHKFt97Ke9peINTIB8s2
         +yHUmaU0VPWEkVzJ/vWEc6JIYqFaFsusRHfJXnDH/QNg853FLcS5S8/BH+wyvpU8fL
         HAQ0WiyyoN4ggXy64se50WoMmTV6NK5Q2LtUoY0BCR2kZ93u/1hl/wd9jzs4HE3QRC
         +sztse7G6IFsA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 214767] xfs seems to hang due to race condition? maybe related
 to (gratuitous) thaw.
Date:   Fri, 29 Oct 2021 02:22:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: pedram.fard@appian.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214767-201763-xcOGV26Txc@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214767-201763@https.bugzilla.kernel.org/>
References: <bug-214767-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214767

--- Comment #14 from Pedram Fard (pedram.fard@appian.com) ---
Here is the result of echo t > /proc/sysrq-trigger:

1 I root       578     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfsalloc]
1 I root       579     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs_mru_cache]
1 I root      1251     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-buf/nvme0n1]
1 I root      1252     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-conv/nvme0n]
1 I root      1253     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-cil/nvme0n1]
1 I root      1254     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-reclaim/nvm]
1 I root      1255     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-eofblocks/n]
1 I root      1256     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-log/nvme0n1]
1 S root      1257     2  0  80   0 -     0 -      Oct20 ?        00:02:06
[xfsaild/nvme0n1]
1 I root      1990     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-buf/dm-0]
1 I root      1991     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-conv/dm-0]
1 I root      1992     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-cil/dm-0]
1 I root      1993     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-reclaim/dm-]
1 I root      1994     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-eofblocks/d]
1 I root      1995     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-log/dm-0]
1 S root      1996     2  0  80   0 -     0 -      Oct20 ?        00:00:00
[xfsaild/dm-0]
1 I root      1999     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-buf/dm-1]
1 I root      2000     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-conv/dm-1]
1 I root      2001     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-cil/dm-1]
1 I root      2002     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-reclaim/dm-]
1 I root      2003     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-eofblocks/d]
1 I root      2004     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-log/dm-1]
1 S root      2005     2  0  80   0 -     0 -      Oct20 ?        00:01:53
[xfsaild/dm-1]
1 I root      2008     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-buf/dm-2]
1 I root      2009     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-conv/dm-2]
1 I root      2010     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-cil/dm-2]
1 I root      2011     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-reclaim/dm-]
1 I root      2012     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-eofblocks/d]
1 I root      2013     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-log/dm-2]
1 S root      2014     2  0  80   0 -     0 -      Oct20 ?        00:00:00
[xfsaild/dm-2]
0 S root      2226  1942  0  80   0 - 30496 -      17:41 ?        00:00:00
/bin/sh -f /usr/sbin/xfs_freeze -u /usr/local/appian
4 D root      2230  2226  0  80   0 - 29825 -      17:41 ?        00:00:00
/usr/sbin/xfs_io -F -r -p xfs_freeze -x -c thaw /usr/local/appian
1 I root      4068     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-buf/dm-3]
1 I root      4069     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-conv/dm-3]
1 I root      4070     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-cil/dm-3]
1 I root      4071     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-reclaim/dm-]
1 I root      4072     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-eofblocks/d]
1 I root      4073     2  0  60 -20 -     0 -      Oct20 ?        00:00:00
[xfs-log/dm-3]
1 S root      4074     2  0  80   0 -     0 -      Oct20 ?        00:02:01
[xfsaild/dm-3]
0 S root     10903 13809  0  80   0 - 29855 -      17:57 pts/0    00:00:00 =
grep
--color=3Dauto xfs
1 I root     11221     2  0  80   0 -     0 -      17:44 ?        00:00:00
[kworker/1:4-xfs]
4 D root     22209     1  0  80   0 - 29825 -      16:08 ?        00:00:00
/usr/sbin/xfs_io -F -r -p xfs_freeze -x -c thaw /usr/local/appian
1 I root     23187     2  0  80   0 -     0 -      17:37 ?        00:00:00
[kworker/1:3-xfs]
1 I root     30083     2  0  80   0 -     0 -      17:29 ?        00:00:00
[kworker/1:1-xfs]

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
