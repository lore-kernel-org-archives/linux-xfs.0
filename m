Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46976 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726116AbfBAWAB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Feb 2019 17:00:01 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8B28632F5A
        for <linux-xfs@vger.kernel.org>; Fri,  1 Feb 2019 22:00:00 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202441] Possibly vfs cache related replicable xfs regression
 since 4.19.0  on sata hdd:s
Date: Fri, 01 Feb 2019 21:59:59 +0000
Message-ID: <bug-202441-201763-QN7VyTFJrO@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202441-201763@https.bugzilla.kernel.org/>
References: <bug-202441-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202441

--- Comment #26 from Roger (rogan6710@gmail.com) ---
I have tried both your suggested reverts on a customized non-modular server
oriented 5.0.0-rc3, and subjected the poor machine to a brutal test: 8
"simultaneous" defonfig compiles, a sort of load balancing test I do to
evaluate io and cpu, on a xfs formatted hdd, while copying GB sized files to a
btrfs formatted hdd ditto and my, by now, significant collection of kernel
source trees to yet another ext4 formatted hdd. All this while watching a (very
boring) youtube HD video and writing this. All working perfectly with a very
responsive ui, while buff/cache is kept at 20-23 Gb, and almost no cpu idle.

I have also done the earlier tests with very good results :)
5.5.0-rc3 locked up completely, and I had do do a "Norwegian reboot", when I
tried loading it like that, earlier, without the reverts.

>From my point of view, they entirely solve this particular problem.
I'll continue testing the reverts on other versions as well.

All kernel compile processes finished with a delta t < 5o seconds, good :)
(now try that on jfs ;))

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
