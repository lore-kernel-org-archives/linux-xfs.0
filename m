Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:35988 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729046AbeLEKCo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Dec 2018 05:02:44 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8E87F2CD5C
        for <linux-xfs@vger.kernel.org>; Wed,  5 Dec 2018 10:02:43 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201897] [xfstests generic/482]: filesystem corruption after log
 replay
Date: Wed, 05 Dec 2018 10:02:43 +0000
Message-ID: <bug-201897-201763-7IkRplFf0g@https.bugzilla.kernel.org/>
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

--- Comment #4 from Zorro Lang (zlang@redhat.com) ---
V5 XFS without reflink feature test pass:
# ./check generic/482
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 ibm-x3650m4-10 4.20.0-rc1
MKFS_OPTIONS  -- -f -m reflink=0,rmapbt=0,finobt=0,crc=1 -i sparse=0
/dev/mapper/rhel_ibm--x3650m4--10-xfscratch
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0
/dev/mapper/rhel_ibm--x3650m4--10-xfscratch /mnt/scratch

generic/482 1567s ...  774s
Ran: generic/482
Passed all 1 tests

# ./check generic/482
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 ibm-x3650m4-10 4.20.0-rc1
MKFS_OPTIONS  -- -f -m reflink=0,rmapbt=0,finobt=1,crc=1 -i sparse=1
/dev/mapper/rhel_ibm--x3650m4--10-xfscratch                                     
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0
/dev/mapper/rhel_ibm--x3650m4--10-xfscratch /mnt/scratch                        

generic/482 774s ...  841s
Ran: generic/482
Passed all 1 tests

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
