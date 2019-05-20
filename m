Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot1-f54.google.com ([209.85.210.54]:39189 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727216AbfETXjO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:39:14 -0400
Received: by mail-ot1-f54.google.com with SMTP id r7so14652736otn.6
        for <linux-xfs@vger.kernel.org>; Mon, 20 May 2019 16:39:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAHgs-5XkA5xFgxgSaX9m70gduuO1beq6fiY7UEGv1ad6bd19Hw@mail.gmail.com>
 <20190513140943.GC61135@bfoster> <683a9b7b-ad5c-5e91-893e-daaa68a853c9@sandeen.net>
In-Reply-To: <683a9b7b-ad5c-5e91-893e-daaa68a853c9@sandeen.net>
From: Tim Smith <tim.smith@vaultcloud.com.au>
Date: Tue, 21 May 2019 09:39:02 +1000
Message-ID: <CAHgs-5Vybp+diCoecfEWbHLRScNnsHKW7-4rwhXH3H+hfcfoLg@mail.gmail.com>
Subject: Re: xfs filesystem reports negative usage - reoccurring problem
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Tue, May 14, 2019 at 1:06 AM Eric Sandeen <sandeen@sandeen.net> wrote:
> I'm kind of interested in what xfs_repair finds in this case.

$ sudo xfs_repair -m 4096 -v /dev/sdad
Phase 1 - find and verify superblock...
        - block cache size set to 342176 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 159752 tail block 159752
        - scan filesystem freespace and inode maps...
sb_fdblocks 4725279343, counted 430312047
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
Phase 5 - rebuild AG headers and trees...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...

        XFS_REPAIR Summary    Mon May 20 18:53:30 2019

Phase           Start           End             Duration
Phase 1:        05/20 10:49:27  05/20 10:49:27
Phase 2:        05/20 10:49:27  05/20 10:50:05  38 seconds
Phase 3:        05/20 10:50:05  05/20 15:24:34  4 hours, 34 minutes, 29 seconds
Phase 4:        05/20 15:24:34  05/20 17:08:23  1 hour, 43 minutes, 49 seconds
Phase 5:        05/20 17:08:23  05/20 17:08:25  2 seconds
Phase 6:        05/20 17:08:25  05/20 18:53:30  1 hour, 45 minutes, 5 seconds
Phase 7:        05/20 18:53:30  05/20 18:53:30

Total run time: 8 hours, 4 minutes, 3 seconds

done

> However, 4.15 is about a year an a half old, so this list may not be
> the best place for support.
> ...
> LTS is "Long Term Support" right?  So I'd suggest reaching out to your
> distribution for assistance unless you can demonstrate the problem
> on a current upstream kernel.

Good point. I appreciate your assistance nonetheless :)
