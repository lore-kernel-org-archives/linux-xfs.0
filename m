Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E1FC5ACD6
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 03:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E087B20724
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 03:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgCRDjQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 23:39:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbgCRDjQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Mar 2020 23:39:16 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 206869] [xfstests generic/587]: quota mismatch
Date:   Wed, 18 Mar 2020 03:39:15 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206869-201763-1uqbelUVto@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206869-201763@https.bugzilla.kernel.org/>
References: <bug-206869-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206869

--- Comment #3 from Zorro Lang (zlang@redhat.com) ---
(In reply to Darrick J. Wong from comment #2)
> Created attachment 287959 [details]
> test patch for xfstests
> 
> Does the attached patch to generic/587 fix the problem?

Yes, generic/587 test passed after merge this patch. And this patch looks
smarter than what I write, I'll ack it after you send it to fstests:)

# ./check generic/587
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 xxx-xxxx-xxx 5.6.0-rc5-xfs-whatamess+ #2 SMP Fri
Mar 13 12:21:33 CST 2020
MKFS_OPTIONS  -- -f -m crc=0 -b size=512 /dev/mapper/testvg-scratchdev
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0
/dev/mapper/testvg-scratchdev /mnt/scratch

generic/587 3s ...  3s
Ran: generic/587
Passed all 1 tests

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
