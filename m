Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:36547 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932577AbdGKUZG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2017 16:25:06 -0400
Received: by mail-wr0-f173.google.com with SMTP id c11so4580709wrc.3
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2017 13:25:05 -0700 (PDT)
MIME-Version: 1.0
From: Sergey F <sf.softevol@gmail.com>
Date: Tue, 11 Jul 2017 23:25:04 +0300
Message-ID: <CACw1Djo4TUtmE5jJj_2zhtL+W5SK=daA5aNyChY4Qyjv40_ckw@mail.gmail.com>
Subject: [BUG] internal error XFS_WANT_CORRUPTED_GOTO
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello.

on one from our server we got error

XFS (dm-0): Internal error XFS_WANT_CORRUPTED_GOTO at line 3156 of
file fs/xfs/libxfs/xfs_btree.c. Caller xfs_free_ag_extent+0x402/0x780
[xfs]
XFS (dm-0): Internal error xfs_trans_cancel at line 990 of file
fs/xfs/xfs_trans.c. Caller xfs_inactive_truncate+0xe5/0x120 [xfs]

As this error appear on our / partition - we needed to reboot our
server through IPMI interface.
After reboot server enter in emergency mode, where with xfs_repair -L
option filesystem was successfully repaired and server now seems to
works correct.

Last action on server was remove huge number of files (as said  person
who execute action - 75,000+ )

Do you have any ideas what exactly could be the reason for this issue?
how could we investigate this issue?

We could find similar information here:
https://www.centos.org/forums/viewtopic.php?t=15898
On this link topicstarter said that he could get information from xfs
maillists, so i think that we could try to work with somebody from
your specialists.

Server information:
CentOS7
LSIMegaRAIDSAS9240-4i
2xSeagate ST1000NM0055-1V410C
Linux kernel version:
uname  -a
Linux 3.10.0-514.21.2.el7.x86_64 #1 SMP Tue Jun 20 12:24:47 UTC 2017
x86_64 x86_64 x86_64 GNU/Linux
XFS packages version:
yum list installed | grep xfs
xfsprogs.x86_64 4.5.0-10.el7_3          @updates
