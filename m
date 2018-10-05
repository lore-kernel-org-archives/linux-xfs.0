Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41020 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728433AbeJEQFt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 12:05:49 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id CABA6290AA
        for <linux-xfs@vger.kernel.org>; Fri,  5 Oct 2018 09:07:59 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201331] deadlock (XFS?)
Date: Fri, 05 Oct 2018 09:08:00 +0000
Message-ID: <bug-201331-201763-HAk6tqVTQO@https.bugzilla.kernel.org/>
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

Carlos Maiolino (cmaiolino@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |cmaiolino@redhat.com

--- Comment #6 from Carlos Maiolino (cmaiolino@redhat.com) ---
Edo, I'm closing this bug.

There is no evidence of bug on what you described, but a poorly configured
storage.

As Dave mentioned, you are RMWing your storage array to death. Please, fix your
storage array configuration, and feel free to reopen the bug if you still hit
it with a proper storage configuration, but by now, what you have is a big
number of huge RMW cycles.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
