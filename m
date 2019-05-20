Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44144 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733161AbfETQMF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 12:12:05 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2E9D828917
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 16:12:05 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 203655] XFS: Assertion failed: 0, xfs_log_recover.c, line: 551
Date: Mon, 20 May 2019 16:12:04 +0000
Message-ID: <bug-203655-201763-21ISRoNsQn@https.bugzilla.kernel.org/>
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

--- Comment #3 from bfoster@redhat.com ---
On Mon, May 20, 2019 at 04:02:06PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=203655
> 
> Eric Sandeen (sandeen@sandeen.net) changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |sandeen@sandeen.net
> 
> --- Comment #2 from Eric Sandeen (sandeen@sandeen.net) ---
> I think the question here is whether the ASSERT() is valid - we don't ever
> want
> to assert on disk corruption, it should only be for "this should never happen
> in the code" scenarios.
> 

Makes sense. It's not clear to me whether that's the intent of the bug,
but regardless I think it would be reasonable to kill off that
particular assert. We already warn and return an error.

Brian

> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
