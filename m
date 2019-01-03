Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43550 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726100AbfACT4R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 14:56:17 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 07273289EE
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jan 2019 19:56:17 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Thu, 03 Jan 2019 19:56:17 +0000
Message-ID: <bug-202127-201763-TJFoB6PLY3@https.bugzilla.kernel.org/>
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

--- Comment #1 from daimh@umich.edu ---
[root@watsons-s1 ~]# grep sda /proc/partitions 
   8        0 597636415488 sda


By the way, the xfs filesystem works without any issue under the environment
below
[root@watsons-s1 ~]# mkfs.xfs -V
mkfs.xfs version 4.17.0
[root@watsons-s1 ~]# uname -a
Linux watsons-s1.mbni.org 4.17.5-1-ARCH #1 SMP PREEMPT Sun Jul 8 17:27:31 UTC
2018 x86_64 GNU/Linux

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
