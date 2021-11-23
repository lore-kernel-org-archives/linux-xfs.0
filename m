Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3474DC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 15:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbhKWPrI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Nov 2021 10:47:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230044AbhKWPrI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Nov 2021 10:47:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D586A60FC1
        for <linux-xfs@vger.kernel.org>; Tue, 23 Nov 2021 15:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637682239;
        bh=ktZ9Xr9lojZZhi7OIrYVB82WOCzYcMnEsCHBtrGQKDQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=iSNiQ6JXK/125XJajoVsaEjKHCK53ONFch+bWelG8+9ObhwOqkoG669xiWPQGIihc
         0b7FPLnMd6N2mzeqjIUAKOytBjEblhwFkSfAxghuzECRf9mJZVFBTF6x0zR7cW/1Es
         5XIaCBS+F/rmx3/bGaMhDL5gTze61H+4pfuoGd+K/8zHbfBfQqEs+3povPMj/H9Pzh
         PYAwThA6QQzse2s6toK8WV36KG9fbb/R2fLMdyXFxI+3iqLzNPlcQSdI3CwM7jYgfL
         jor9NeySVZjwgdzhXAFIvRuexIXUMgBLtfcZ0Nm4YLv//Yai9oteq2XKPpKkNjC4PS
         nhHlqmOmlWXDw==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id D267060F4D; Tue, 23 Nov 2021 15:43:59 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 202441] Possibly vfs cache related replicable xfs regression
 since 4.19.0  on sata hdd:s
Date:   Tue, 23 Nov 2021 15:43:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: hvtaifwkbgefbaei@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-202441-201763-2GZTXzAYPG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202441-201763@https.bugzilla.kernel.org/>
References: <bug-202441-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D202441

Sami Farin (hvtaifwkbgefbaei@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |hvtaifwkbgefbaei@gmail.com

--- Comment #28 from Sami Farin (hvtaifwkbgefbaei@gmail.com) ---
[....] When vfs_cache_pressure=3D0, the kernel will never
        reclaim dentries and inodes due to memory pressure and this
        can easily lead to out-of-memory conditions. [....]

I wish that was true. I have it set to 0, and I have 32 GiB RAM of which 23=
 GiB
free when doing the test using XFS filesystem:

$ du -sh
$ sleep 60
# (dentries forgotten, the next du takes a minute to run (SATA rust platter
disk))
$ du -sh

kernel 5.10.80. No swap.

MemTotal:       32759756 kB
MemFree:        23807992 kB
MemAvailable:   23774316 kB
Buffers:              24 kB
Cached:           765240 kB
SwapCached:            0 kB
Active:           290420 kB
Inactive:        3859348 kB
Active(anon):     168968 kB
Inactive(anon):  3720380 kB
Active(file):     121452 kB
Inactive(file):   138968 kB
Unevictable:       18304 kB
Mlocked:           18304 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                56 kB
Writeback:             0 kB
AnonPages:       3391352 kB
Mapped:           310564 kB
Shmem:            496832 kB
KReclaimable:     196444 kB
Slab:            2197440 kB
SReclaimable:     196444 kB
SUnreclaim:      2000996 kB
KernelStack:       25728 kB
PageTables:        67676 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    15855588 kB
Committed_AS:   17433636 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      392660 kB
VmallocChunk:          0 kB
Percpu:            43264 kB
HardwareCorrupted:     0 kB
AnonHugePages:   1015808 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
FileHugePages:         0 kB
FilePmdMapped:         0 kB
HugePages_Total:     512
HugePages_Free:      512
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:         1048576 kB
DirectMap4k:    27877496 kB
DirectMap2M:     5607424 kB
DirectMap1G:     1048576 kB

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
