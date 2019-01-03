Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56098 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725931AbfACXYx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 18:24:53 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 39CED26256
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jan 2019 23:24:52 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Thu, 03 Jan 2019 23:24:52 +0000
Message-ID: <bug-202127-201763-DQnlkOcmzC@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202127-201763@https.bugzilla.kernel.org/>
References: <bug-202127-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202127

--- Comment #12 from daimh@umich.edu ---
[root@watsons-s1 ~]# uname -a
Linux watsons-s1.mbni.org 4.17.5-1-ARCH #1 SMP PREEMPT Sun Jul 8 17:27:31 UTC
2018 x86_64 GNU/Linux
[root@watsons-s1 ~]# mkfs.xfs -V
mkfs.xfs version 4.17.0
[root@watsons-s1 ~]# mkfs -t xfs -f /dev/sda  
meta-data=/dev/sda               isize=512    agcount=557, agsize=268434944
blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=149409103872, imaxpct=1
         =                       sunit=256    swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

I will thinking about the firmware upgrade tomorrow. :)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
