Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33940 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750909AbeF0Wju (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jun 2018 18:39:50 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4EBAA2A0C2
        for <linux-xfs@vger.kernel.org>; Wed, 27 Jun 2018 22:39:50 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200311] xfsprogs fails to install when user group has space
Date: Wed, 27 Jun 2018 22:39:49 +0000
Message-ID: <bug-200311-201763-ieHtZZM5lH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200311-201763@https.bugzilla.kernel.org/>
References: <bug-200311-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200311

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@sandeen.net

--- Comment #1 from Eric Sandeen (sandeen@sandeen.net) ---
How did you get a group with a space in it in the first place?  That's not
supported by groupadd:

# groupadd "space force"
groupadd: 'space force' is not a valid group name

And according to adduser.conf(5) (thanks dchinner), IEEE Std 1003.1-2001
disallows spaces in names.

I'd be shocked if this is the only problem non-standard group names cause ...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.