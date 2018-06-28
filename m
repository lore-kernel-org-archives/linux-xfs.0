Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53116 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932114AbeF1C47 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jun 2018 22:56:59 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8EEC529F35
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 02:56:58 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200311] xfsprogs fails to install when user group has space
Date: Thu, 28 Jun 2018 02:56:57 +0000
Message-ID: <bug-200311-201763-bZohWnRt00@https.bugzilla.kernel.org/>
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

Darrick J. Wong (djwong+kernel@djwong.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |djwong+kernel@djwong.org

--- Comment #4 from Darrick J. Wong (djwong+kernel@djwong.org) ---
If you're going to escape strings, why not escape PKG_USER too?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.