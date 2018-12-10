Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44068 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726841AbeLJXTr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Dec 2018 18:19:47 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C5B5F2A67E
        for <linux-xfs@vger.kernel.org>; Mon, 10 Dec 2018 23:19:46 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201939] There is no 'no space' message when using xfs with nfs.
Date: Mon, 10 Dec 2018 23:19:46 +0000
Message-ID: <bug-201939-201763-NwEnCJ5mDC@https.bugzilla.kernel.org/>
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

Christian Kujau (lists@nerdbynature.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lists@nerdbynature.de

--- Comment #2 from Christian Kujau (lists@nerdbynature.de) ---
> kernel : nfs server 3.4.113 vanilla, nfs client 2.6.32-573.el6.x86_64

Both kernel versions have been EOL for a long time (or is the server maybe on
4.4.113 instead?), please either try to reproduce with recent kernel version or
contact the vendor about this issue.

That being said, there have been some problems with NFS & ENOSPC in the (very
distant) past:

> NFS behaviour when filesystem is 100% full
> https://technicalprose.blogspot.com/2013/11/nfs-behaviour-when-filesystem-is-100.html

> NFS corruption on ENOSPC
> https://www.redhat.com/archives/linux-lvm/2010-December/msg00030.html

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
