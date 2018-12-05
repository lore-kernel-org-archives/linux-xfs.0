Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40210 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbeLEJHX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Dec 2018 04:07:23 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DA37D2CCA2
        for <linux-xfs@vger.kernel.org>; Wed,  5 Dec 2018 09:07:22 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201897] [xfstests generic/482]: filesystem corruption after log
 replay
Date: Wed, 05 Dec 2018 09:07:23 +0000
Message-ID: <bug-201897-201763-kFGbWj8oOb@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201897-201763@https.bugzilla.kernel.org/>
References: <bug-201897-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201897

--- Comment #3 from Zorro Lang (zlang@redhat.com) ---
Ext4 test passed (below 4.20.0-rc1 contains xfs-v4.20-fixes-3):

# ./check generic/482
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 ibm-x3650m4-10 4.20.0-rc1
MKFS_OPTIONS  -- /dev/mapper/rhel_ibm--x3650m4--10-xfscratch
MOUNT_OPTIONS -- -o acl,user_xattr -o context=system_u:object_r:root_t:s0
/dev/mapper/rhel_ibm--x3650m4--10-xfscratch /mnt/scratch                        

generic/482      1567s
Ran: generic/482
Passed all 1 tests

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
