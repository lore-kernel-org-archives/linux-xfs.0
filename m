Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59094 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725998AbeJEGOB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 02:14:01 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5DC66293C8
        for <linux-xfs@vger.kernel.org>; Thu,  4 Oct 2018 23:18:16 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201331] deadlock (XFS?)
Date: Thu, 04 Oct 2018 23:18:17 +0000
Message-ID: <bug-201331-201763-UmBpWOiePj@https.bugzilla.kernel.org/>
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

--- Comment #3 from edo (edo.rus@gmail.com) ---
I have made some RAID tuning:
echo 32768 >  /sys/block/md3/md/stripe_cache_size

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
