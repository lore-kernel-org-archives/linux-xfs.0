Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39480 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727958AbeJEXjZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 19:39:25 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5D9B229A3E
        for <linux-xfs@vger.kernel.org>; Fri,  5 Oct 2018 16:39:55 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201331] deadlock (XFS?)
Date: Fri, 05 Oct 2018 16:39:55 +0000
Message-ID: <bug-201331-201763-hP0TZ4Prac@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201331-201763@https.bugzilla.kernel.org/>
References: <bug-201331-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201331

--- Comment #10 from edo (edo.rus@gmail.com) ---
> A substripe write will require 4MiB + parity (which IIRC will be another 1024MiB) so a total of 5MiB needs to be Read, modified and written for each undersized write.

I'm pretty sure, md raid can do partial update for chunks.

I just ran 4Kib random write test (fio) on freshly created array with chunk
size 4Kib, after that with chunk size 16Mib - no difference in terms iops on
raid device (observed in fio), iops and transfer speed on raid members
(observed in iostat).


> Your system is not locked up, it's just really slow due the amount of time being spent waiting for IO completion.

No.
Array was filling with good speed (80-250Mib/s, limited by network) several
hours after system startup.
Unexpectedly write stopped (zeros in iostat) and messages "blocked for more
than 120 seconds" arrive. I managed to continue disk filling with hardware
reset only.
Such behavior repeated many times, I tried several kernel versions and kernel
options.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
