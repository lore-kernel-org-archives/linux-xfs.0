Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47708 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726883AbeHXRKa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Aug 2018 13:10:30 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 37D182C704
        for <linux-xfs@vger.kernel.org>; Fri, 24 Aug 2018 13:35:48 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200925] New: null pointer dereference in xfs_dir_isempty()
Date: Fri, 24 Aug 2018 13:35:47 +0000
Message-ID: <bug-200925-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200925

            Bug ID: 200925
           Summary: null pointer dereference in xfs_dir_isempty()
           Product: File System
           Version: 2.5
    Kernel Version: 4.18
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: wen.xu@gatech.edu
        Regression: No

Created attachment 278069
  --> https://bugzilla.kernel.org/attachment.cgi?id=278069&action=edit
poc.c

- Reproduce
# mkdir mnt
# mount -t xfs 79.img mnt
# gcc 79.c
# ./a.out ./mnt

- Kernel message
Check attachment: 79.log

- Reason
https://elixir.bootlin.com/linux/latest/source/fs/xfs/libxfs/xfs_dir2.c#L185
        sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
        return !sfp->count;
Missing checks on sfp.

Reported by Wen Xu (wen.xu@gatech.edu) from SSLab.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
