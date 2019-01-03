Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54008 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726792AbfACXOn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 18:14:43 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1CD48252D5
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jan 2019 23:14:43 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Thu, 03 Jan 2019 23:14:43 +0000
Message-ID: <bug-202127-201763-WYrRk0jSF6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202127-201763@https.bugzilla.kernel.org/>
References: <bug-202127-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202127

--- Comment #8 from Chris Murphy (bugzilla@colorremedies.com) ---
Ok looks like firmware package 24.22.0-0034 translates to firmware
4.740.00-8394. I can't parse this file by only giving it 2 minutes read, so I
have no idea what firmware has this change but I found this:

SCGCQ01150173 - (Port_Complete) - Request for NVdata change on 9361-8i to make
the minimum stripe size 16K (instead of 64K)

But you have a 16i, not 8i. OK whatever. I would just flash it with the latest
if it doesn't already have it. And if it's still a problem file a bug with
Broadcom and reference this bug, specifically comment 4.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
