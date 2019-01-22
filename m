Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46714 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728205AbfAVMtd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jan 2019 07:49:33 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 596DE2A18D
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jan 2019 12:49:32 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Tue, 22 Jan 2019 12:49:31 +0000
Message-ID: <bug-202127-201763-jc6cMFk2so@https.bugzilla.kernel.org/>
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

--- Comment #22 from daimh@umich.edu ---
An update is that Broadcom engineer cannot reproduce the issue with Arch Linux
kernel 4.20.3-arch1-1-ARCH and mkfs.xfs version 4.19.0. The difference is his
raid-60 is 7T and 2T, while mine is 556T. 

I upgraded both kernel and mkfs to the same version as above, the problem
persists.

I downgraded them to linux-4.17.14.arch1-1 and xfsprogs-4.17.0-1 again, then
xfs can be created and mounted without any glitch.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
