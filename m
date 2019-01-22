Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43508 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728317AbfAVOfi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jan 2019 09:35:38 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D795D2A988
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jan 2019 14:35:37 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Tue, 22 Jan 2019 14:35:37 +0000
Message-ID: <bug-202127-201763-3hw9z0dcNb@https.bugzilla.kernel.org/>
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

--- Comment #24 from daimh@umich.edu ---
Thanks a lot for reminding me su&sw, I just did this and mkfs.xfs worked

# /opt/MegaRAID/storcli/storcli /c0 /v0 show all | grep  "Strip\|Drives\|RAID"
0/0   RAID60 Optl  RW     Yes     RAWBD -   ON  556.591 TB      
Strip Size = 1.0 MB
Number of Drives Per Span = 19
# mkfs.xfs -d su=1m,sw=17 /dev/sda 
# mount /dev/sda /treehouse/watsons_lab/s1/

But I still need help from you guys. What about my other storage servers that
have a huge XFS system created under older Kernel 4.17.* and xfsprogs 4.17 ? I
cannot mount it under the latest ArchLinux, and those filesystem are quite
full..

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
