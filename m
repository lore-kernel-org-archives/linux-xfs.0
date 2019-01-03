Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51358 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728379AbfACWS4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 17:18:56 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2D19B23794
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jan 2019 22:18:56 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Thu, 03 Jan 2019 22:18:56 +0000
Message-ID: <bug-202127-201763-gkEuA391xL@https.bugzilla.kernel.org/>
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

--- Comment #3 from daimh@umich.edu ---
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
