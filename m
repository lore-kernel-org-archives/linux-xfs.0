Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33224 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727354AbeJERNy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 13:13:54 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7F54A28EC2
        for <linux-xfs@vger.kernel.org>; Fri,  5 Oct 2018 10:15:47 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201331] deadlock (XFS?)
Date: Fri, 05 Oct 2018 10:15:47 +0000
Message-ID: <bug-201331-201763-YVmN87vFYw@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201331-201763@https.bugzilla.kernel.org/>
References: <bug-201331-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201331

--- Comment #9 from Carlos Maiolino (cmaiolino@redhat.com) ---
(In reply to edo from comment #8)
> > Basically, your RMW'd your RAID device to death because every write
> is a sub-stripe write.
> 
> Why is it bad?
> Even with default 512k stipe almost every write is sub-stripe write.

512k * 8 = 4MiB

A substripe write will require 4MiB + parity (which IIRC will be another
1024MiB) so a total of 5MiB needs to be Read, modified and written for each
undersized write.

For a 16MiB stripe:

16MiB * 8 data disks = 128MiB + 32MiB for the parity chunks, so, for every
undersized write, you need to have 160MiB of data read modified and written
back to the array.

Multiply it for several files, and you will RMW your array to death really
fast, mainly if your workload is mostly undersized IO.



> Anyway system lock till reset is an error, isn't it?

Your system is not locked up, it's just really slow due the amount of time
being spent waiting for IO completion.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
