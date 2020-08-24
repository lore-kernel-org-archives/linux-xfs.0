Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9036C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 22:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C129C20578
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 22:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgHXW1X convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 18:27:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgHXW1T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Aug 2020 18:27:19 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209005] xfs_repair 5.7.0: missing newline in message: entry at
 block N offset NN in directory inode NNNNNN has illegal name "/foo":
Date:   Mon, 24 Aug 2020 22:27:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: cs@cskk.id.au
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209005-201763-v25JDTo37q@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209005-201763@https.bugzilla.kernel.org/>
References: <bug-209005-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209005

--- Comment #6 from Cameron Simpson (cs@cskk.id.au) ---
Sorry for the delay, been asleep.

Alas, the filesystem has been repaired and I didn't keep a log, or alas, a
transcript.

The xfs_repair is from xfsprogs 5.7.0.

By contrast, the filesystem is made by quite an old kernel:

Linux octopus 3.16.0-7-amd64 #1 SMP Debian 3.16.59-1 (2018-10-03) x86_64
GNU/Linux

and I have seen this filenames-with-a-leading-slash in a previous repair of an
XFS filesystem from this machine.

This bug report is really about the messaging, not the bogus filenames; I
accept that the kernel is old and the XFS implementation therefore many
bugfixes behind.

For added fun the FS is on an iscsi device from a QNAP NAS (because QNAPs don't
do XFS); I started the repair after getting link errors on the FS, after a
building wide power out took out the machine and the NAS; and we had to reseat
a drive in the raidset. It's just backups, but it has 5TB of highly linked
files in it.

Just FYI, BTW, a second run of xfs_repair after the big repair corrected a few
hardlink counts (but a mere handful, maybe 4, after the previous repair did
thousands of fixes).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
