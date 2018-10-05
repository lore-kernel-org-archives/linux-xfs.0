Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49280 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727809AbeJEQPw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 12:15:52 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7D21229251
        for <linux-xfs@vger.kernel.org>; Fri,  5 Oct 2018 09:18:00 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201331] deadlock (XFS?)
Date: Fri, 05 Oct 2018 09:18:01 +0000
Message-ID: <bug-201331-201763-xCdAN1uKdl@https.bugzilla.kernel.org/>
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

--- Comment #8 from edo (edo.rus@gmail.com) ---
> Basically, your RMW'd your RAID device to death because every write
is a sub-stripe write.

Why is it bad?
Even with default 512k stipe almost every write is sub-stripe write.
Anyway system lock till reset is an error, isn't it?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
