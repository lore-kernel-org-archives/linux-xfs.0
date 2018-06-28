Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56220 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751172AbeF1Bnl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jun 2018 21:43:41 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D06C3290DA
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 01:43:40 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200311] xfsprogs fails to install when user group has space
Date: Thu, 28 Jun 2018 01:43:40 +0000
Message-ID: <bug-200311-201763-TYAn7z6Toe@https.bugzilla.kernel.org/>
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

--- Comment #2 from Luiz Angelo Daros de Luca (luizluca@gmail.com) ---
It's, indeed, the only problem I face with xfsprogs and few others: use of
group name without quotes. Group names are rarely used as input.

I normally quote every shell var by default, no matter is usage.

The group came from M$ Active Directory, integrated using sssd. I can rename
the unix mapped name to something without spaces, but I normally prefer to
detect the problem and report upstream (for those that cannot change the group
name)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.