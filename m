Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47998 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727528AbfGSVpl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jul 2019 17:45:41 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 981B9289BF
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jul 2019 21:45:40 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 204049] [xfstests generic/388]: XFS: Assertion failed:
 ip->i_d.di_format != XFS_DINODE_FMT_BTREE || ip->i_d.di_nextents >
 XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK), file: fs/xfs/xfs_inode.c, line: 3646
Date: Fri, 19 Jul 2019 21:45:39 +0000
Message-ID: <bug-204049-201763-TJ6zasqvKj@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204049-201763@https.bugzilla.kernel.org/>
References: <bug-204049-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204049

--- Comment #6 from billodo@redhat.com ---
On Fri, Jul 19, 2019 at 09:29:04PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=204049
> 
> --- Comment #5 from Luis Chamberlain (mcgrof@kernel.org) ---
> (In reply to Luis Chamberlain from comment #4)
> > The crash observed on stable kernels can be fixed with commit 6958d11f77
> > ("xfs: don't trip over uninitialized buffer on extent read of corrupted
> > inode") merged on v5.1.
> > 
> > I can't reproduce the immediate panic on v5.1 with the
> > "xfs_reflink_normapbt" anymore, as such I believe this seems like a
> > regression, and you should be able to bisect to v5.1 as the good kernel.
> 
> Correction, it just took longer to crash. Same crash as in kz#204223 [0] on
> v5.1. That issue is still not fixed.

In my experience,
many iterations of g/388 will definitely ferret out elusive failures.
It's sometimes tough to distinguish between real problems and abheritions.

-Bill


> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=204223
> 
> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
