Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:36790 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726131AbeLIMzm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Dec 2018 07:55:42 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id ACCA12A6C4
        for <linux-xfs@vger.kernel.org>; Sun,  9 Dec 2018 12:55:41 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201939] There is no 'no space' message when using xfs with nfs.
Date: Sun, 09 Dec 2018 12:55:40 +0000
Message-ID: <bug-201939-201763-iNaoOHXk22@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201939-201763@https.bugzilla.kernel.org/>
References: <bug-201939-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201939

--- Comment #1 from gbkwon@gmail.com ---

Please see the log below.


top - 21:54:10 up 58 min,  0 users,  load average: 8.50, 8.37, 8.83
Tasks: 347 total,   2 running, 345 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us,  4.2%sy,  0.0%ni, 95.8%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
12368 root      20   0     0    0    0 S   12  0.0   4:32.44 kworker/2:2
11092 root      20   0     0    0    0 S   10  0.0   4:42.57 kworker/3:1
11166 root      20   0     0    0    0 R    9  0.0   2:09.47 kworker/5:1
12473 root      20   0     0    0    0 S    8  0.0   2:09.36 kworker/4:2
 2944 root      20   0     0    0    0 D    6  0.0   2:09.10 nfsd
 2953 root      20   0     0    0    0 D    6  0.0   2:24.65 nfsd
 3024 root      20   0     0    0    0 D    6  0.0   2:23.12 nfsd

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
