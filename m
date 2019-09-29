Return-Path: <SRS0=eCaL=XY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F7D2C4360C
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Sep 2019 11:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51CBD20863
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Sep 2019 11:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbfI2Lw7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 29 Sep 2019 07:52:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725924AbfI2Lw7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 29 Sep 2019 07:52:59 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 202349] Extreme desktop freezes during sustained write
 operations with XFS
Date:   Sun, 29 Sep 2019 11:52:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: hector@marcansoft.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-202349-201763-yVi42Mp68S@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202349-201763@https.bugzilla.kernel.org/>
References: <bug-202349-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202349

Hector Martin (hector@marcansoft.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |hector@marcansoft.com

--- Comment #13 from Hector Martin (hector@marcansoft.com) ---
I'm the author of the mentioned tweet.

What I was seeing was that on a system with loads of free RAM, XFS reclaiming
inodes would randomly block on IO.

This is completely unexpected. I do expect that a system under memory and IO
pressure ("used" memory, not just "available" memory used for clean caches)
will block on IO during allocations that trigger writeback. I do *not* expect
that on a system with tons of clean data to evict, but that is what I saw with
XFS.

I had a process writing real-time data to disk (on a moderately busy system
with gigabytes of free RAM), and even though disk bandwidth was plenty to keep
up with the data, I was seeing buffer underruns due to big random latency
spikes. After I introduced a process in the pipeline doing up to several
gigabytes of RAM buffering to even out the spikes, I was *still* getting the
buffer input stuttering for several seconds, breaking the real-time capture.
That's where I realized that a kernel pipe buffer allocation was somehow
blocking on XFS doing IO.

I would echo 3 > /proc/sys/vm/drop_caches, and latencies would become normal. I
would then watch RAM used for caches slowly creep up, and when it hit 95% or
so, latency would randomly shoot through the roof again. This is obviously
broken behavior. Allocating from RAM used for caches should **never** block on
IO. The system should never slow down because extra RAM is being used for
caches. That is just insane. The whole point of using RAM for caches is to
utilize otherwise wasted RAM. If this is causing allocations to block on IO
when freeing said RAM, randomly causing huge latency spikes for everything,
then that is broken.

I've since switched to ext4 on the same disks and haven't had a problem ever
since.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
