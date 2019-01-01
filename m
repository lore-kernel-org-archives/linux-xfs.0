Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40740 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726149AbfAAWaf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jan 2019 17:30:35 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 795B028707
        for <linux-xfs@vger.kernel.org>; Tue,  1 Jan 2019 22:30:34 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202077] xfs transaction log reservation overruns on 4.14.67
Date: Tue, 01 Jan 2019 22:30:34 +0000
Message-ID: <bug-202077-201763-YRyzPgNLi5@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202077-201763@https.bugzilla.kernel.org/>
References: <bug-202077-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202077

--- Comment #2 from Dave Chinner (david@fromorbit.com) ---
On Wed, Dec 26, 2018 at 05:19:12PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> We've encountered two recent examples of xfs transaction overruns on
> production
> systems running 4.14.67 kernels.  Both systems in this case are running
> docker
> with dozens of overlay mounts, using this xfs fs as both upper and lower.  In
> both cases the filesystem was able to successfully recover when the
> filesystem
> was unmounted and remounted again.

Inboth cases, it looks like there were two free space manipulations
in a single transaction, likely first modifying the free list
(pattern is EFD, XAGF, ABTB, ABTC, then AGFL) followed by freeing
the actual extent (more ABTB, ABTC buffers).

> It looks like there has been a good bit of work in 4.16+

The first fixes went into 4.18 with the deferred AGFL free
operations. Those were the commits associated with the patchset
titled "[PATCH v2 0/6] xfs: defer agfl block frees".

There were more fixes in 4.19 to always defer the AGFL free for all
operations. This was a much larger and more significant change, and
can be found from the series titled "[PATCH 00/24] xfs: broad
enablement of deferred agfl frees".

> addressing similar issues but none of it has made it back into the
> 4.14 LTS.  Any chance that any of the attached debug output points
> to anything specific that might be a candidate for backport?

Backporting the first series might be sufficient to avoid your
problem (both are from the inode inactivation path) but it is no
guarantee. I also have no idea what dependencies that patchset has
on the rest of the code (e.g. is there enough deferred op
infrastructure in place in 4.14?), and seeing as it touches core
allocation algorithms it would require a substantial amount of QA
before release....

Cheers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
