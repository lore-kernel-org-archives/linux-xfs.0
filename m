Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37062 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728779AbfACXcg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 18:32:36 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4462526E3E
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jan 2019 23:32:36 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Thu, 03 Jan 2019 23:32:36 +0000
Message-ID: <bug-202127-201763-YsYMv3ugqW@https.bugzilla.kernel.org/>
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

--- Comment #13 from Eric Sandeen (sandeen@sandeen.net) ---
(In reply to daimh from comment #12)

> [root@watsons-s1 ~]# mkfs.xfs -V
> mkfs.xfs version 4.17.0
> [root@watsons-s1 ~]# mkfs -t xfs -f /dev/sda  

Thanks.  That's what I suspected, i.e. older xfsprogs just didn't validate or
notice this problem, but I was too lazy to check the history. ;) Thanks for the
test and the info.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
