Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59596 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725823AbeKAKlR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Nov 2018 06:41:17 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7374E2B739
        for <linux-xfs@vger.kernel.org>; Thu,  1 Nov 2018 01:40:30 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201577] [xfstests generic/070]: XFS corruption and Oops when
 setxattr on 64k blocksize XFS
Date: Thu, 01 Nov 2018 01:40:30 +0000
Message-ID: <bug-201577-201763-uWXPNMJZv6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201577-201763@https.bugzilla.kernel.org/>
References: <bug-201577-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201577

--- Comment #2 from Zorro Lang (zlang@redhat.com) ---
(In reply to Dave Chinner from comment #1)
> On Wed, Oct 31, 2018 at 07:34:49AM +0000,
> bugzilla-daemon@bugzilla.kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=201577
> > 
> >             Bug ID: 201577
> >            Summary: [xfstests generic/070]: XFS corruption and Oops when
> >                     setxattr on 64k blocksize XFS
> ......
> > How reproducible:
> > nearly 100% on 64k blocksize XFS on ppc64le
> > 
> > Additional info:
> > Can't reproduce this bug on 4k blocksize XFS
> 
> I saw both these (the corruption and the assert on shutdown) a few
> days ago on a 4k block size filesystem. Not reproducable, though,
> but it doesn't have anything specifically to do with 64k block size.
> 
> What kernel are you running, exactly? A plain 4.19 release kernel?

I git clone from
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git, master
branch, and its current HEAD is 310c7585e8300ddc46211df0757c11e4299ec482

ppc64le and aarch64 all can reproduce this issue easily if test with 64k bs
XFS.

Thanks,
Zorro

> 
> Cheers,
> 
> Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
