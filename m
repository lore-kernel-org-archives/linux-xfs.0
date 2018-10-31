Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45538 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbeKAHnA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Nov 2018 03:43:00 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C2DA82BB6E
        for <linux-xfs@vger.kernel.org>; Wed, 31 Oct 2018 22:42:54 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201577] [xfstests generic/070]: XFS corruption and Oops when
 setxattr on 64k blocksize XFS
Date: Wed, 31 Oct 2018 22:42:54 +0000
Message-ID: <bug-201577-201763-k2wEXF0DfO@https.bugzilla.kernel.org/>
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

--- Comment #1 from Dave Chinner (david@fromorbit.com) ---
On Wed, Oct 31, 2018 at 07:34:49AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=201577
> 
>             Bug ID: 201577
>            Summary: [xfstests generic/070]: XFS corruption and Oops when
>                     setxattr on 64k blocksize XFS
......
> How reproducible:
> nearly 100% on 64k blocksize XFS on ppc64le
> 
> Additional info:
> Can't reproduce this bug on 4k blocksize XFS

I saw both these (the corruption and the assert on shutdown) a few
days ago on a 4k block size filesystem. Not reproducable, though,
but it doesn't have anything specifically to do with 64k block size.

What kernel are you running, exactly? A plain 4.19 release kernel?

Cheers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
