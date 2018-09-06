Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50464 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725880AbeIFKLd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Sep 2018 06:11:33 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C5F672A425
        for <linux-xfs@vger.kernel.org>; Thu,  6 Sep 2018 05:37:50 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200981] hypervisor fs hangs at heavy write activity on VM (kvm,
 qcow2 image) having a reflink disk copy
Date: Thu, 06 Sep 2018 05:37:51 +0000
Message-ID: <bug-200981-201763-gJrchpJW4A@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200981-201763@https.bugzilla.kernel.org/>
References: <bug-200981-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200981

--- Comment #6 from Alexander Y.  Fomichev (git.user@gmail.com) ---
Created attachment 278347
  --> https://bugzilla.kernel.org/attachment.cgi?id=278347&action=edit
missing sb_end_intwrite: proof of concept

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
