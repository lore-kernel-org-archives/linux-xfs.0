Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49198 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725919AbfADEmq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 23:42:46 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 90E6F26D08
        for <linux-xfs@vger.kernel.org>; Fri,  4 Jan 2019 04:42:45 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Fri, 04 Jan 2019 04:42:45 +0000
Message-ID: <bug-202127-201763-2Gj5HpdcAt@https.bugzilla.kernel.org/>
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

--- Comment #14 from daimh@umich.edu ---
I just upgraded the firmware from 24.19.0-0047 to the latest 24.22.0-0034, also
upgrade the kernel to 4.20.0-arch1-1-ARCH with xfsprogs version to 4.19.0, the
problem persists. 

[root@watsons-s1 ~]# /opt/MegaRAID/storcli/storcli /c0 show all | grep -i
firmware
Firmware Package Build = 24.22.0-0034
Firmware Version = 4.740.00-8394
Support PD Firmware Download = No

[root@watsons-s1 ~]# uname -a
Linux watsons-s1.mbni.org 4.20.0-arch1-1-ARCH #1 SMP PREEMPT Mon Dec 24
03:00:40 UTC 2018 x86_64 GNU/Linux

[root@watsons-s1 ~]# mkfs.xfs -V
mkfs.xfs version 4.19.0

[root@watsons-s1 ~]# blockdev --getsz  --getsize64 --getss --getpbsz 
--getiomin   --getioopt /dev/sda
1195272830976
611979689459712
512
4096
1048576
262144

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
