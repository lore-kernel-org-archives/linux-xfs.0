Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56928 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728511AbfAVOSu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jan 2019 09:18:50 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2283028BBE
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jan 2019 14:18:50 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] cannot mount or create xfs on a  597T device
Date: Tue, 22 Jan 2019 14:18:49 +0000
Message-ID: <bug-202127-201763-8gmz4oGaAv@https.bugzilla.kernel.org/>
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

--- Comment #23 from Eric Sandeen (sandeen@sandeen.net) ---
"An update is that Broadcom engineer cannot reproduce the issue with Arch Linux
kernel 4.20.3-arch1-1-ARCH and mkfs.xfs version 4.19.0."

Which issue is that?  Failed mkfs, or nonsensical geometry?

BTW, I hope we made it clear that you can (probably?) move forward by manually
specifying sunit & swidth to override the junk values from the hardware.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
