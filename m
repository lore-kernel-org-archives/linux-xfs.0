Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40184 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727090AbeJRJkY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Oct 2018 05:40:24 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 24DB6286A2
        for <linux-xfs@vger.kernel.org>; Thu, 18 Oct 2018 01:41:55 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201453] Bug 1640090 - [xfstests xfs/490]: xfs_db print a bad
 (negative number) as agi freecount
Date: Thu, 18 Oct 2018 01:41:55 +0000
Message-ID: <bug-201453-201763-LL35Q14HnV@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201453-201763@https.bugzilla.kernel.org/>
References: <bug-201453-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201453

--- Comment #2 from Dave Chinner (david@fromorbit.com) ---
On Wed, Oct 17, 2018 at 11:20:42AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> # _scratch_xfs_get_metadata_field "recs[1].freecount" "agi 0" "addr root"     
> -197
> ]# xfs_db -c "agi 0" -c "addr root" -c "print recs[1]" /dev/loop1             
> recs[1] = [startino,holemask,count,freecount,free]
> 1:[128,0,64,-197,0xffffffffffffffe0]
.....
> And it's not reproducible on x86_64:
> # xfs_db -c "agi 0" -c "addr root" -c "print recs[1]" /dev/loop1
> recs[1] = [startino,holemask,count,freecount,free] 
> 1:[128,0,64,59,0xffffffffffffffe0]

-197 = -(256 - 59)

This looks like a sign extension problem in the xfs_db code. s390 is
a big endian system, right?

Cheers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
