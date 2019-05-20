Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33504 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726357AbfETXPA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:15:00 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 11F5A2893D
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 23:15:00 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 203655] XFS: Assertion failed: 0, xfs_log_recover.c, line: 551
Date: Mon, 20 May 2019 23:14:58 +0000
Message-ID: <bug-203655-201763-WTVoEZfV5k@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203655-201763@https.bugzilla.kernel.org/>
References: <bug-203655-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203655

--- Comment #4 from Dave Chinner (david@fromorbit.com) ---
On Mon, May 20, 2019 at 12:12:00PM -0400, Brian Foster wrote:
> On Mon, May 20, 2019 at 04:02:06PM +0000, bugzilla-daemon@bugzilla.kernel.org
> wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=203655
> > 
> > Eric Sandeen (sandeen@sandeen.net) changed:
> > 
> >            What    |Removed                     |Added
> >
> ----------------------------------------------------------------------------
> >                  CC|                            |sandeen@sandeen.net
> > 
> > --- Comment #2 from Eric Sandeen (sandeen@sandeen.net) ---
> > I think the question here is whether the ASSERT() is valid - we don't ever
> want
> > to assert on disk corruption, it should only be for "this should never
> happen
> > in the code" scenarios.
> > 
> 
> Makes sense. It's not clear to me whether that's the intent of the bug,
> but regardless I think it would be reasonable to kill off that
> particular assert. We already warn and return an error.

IMO, the assert is most definitely valid for a debug build.  If I'm
writing new code and I corrupt the log, I want it to stop
immediately so I can look at what I did wrong the moment it is
detected and (hopefully) preserving the underlying filesystem state
that is associated with the corrupt journal.

Production systems will not have the assert built in and so will
return -EIO and fail log recovery gracefully. i.e. The ASSERT is
there for the benefit of the XFS developers and has no impact on
user systems, so I'd close this NOTABUG.

Cheers,

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
