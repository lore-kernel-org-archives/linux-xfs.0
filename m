Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:35259 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBXVc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 19:21:32 -0400
Received: by mail-ua0-f179.google.com with SMTP id y4so52701295uay.2
        for <linux-xfs@vger.kernel.org>; Fri, 02 Jun 2017 16:21:32 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?UMOpdGVyIEFuZHLDoXMgRmVsdsOpZ2k=?= <petschy@gmail.com>
Date: Sat, 3 Jun 2017 01:21:31 +0200
Message-ID: <CAG3eYYQMTdmCK9EdJA4hfYSSPStLSC=YBK+tvk67r6Vn4-UcxQ@mail.gmail.com>
Subject: My XFS volume died, please help!
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello,

after a power outage, the mount replayed the journal and no errors
were reported, but the mounted XFS volume had suspiciously little free
space. So I unmounted, and ran xfs_repair which crashed in phase 5
with a floating point exception. After that I was unable to mount
again, due to metadata corruption, so the repair made things worse.
Please help!

Linux 4.4.66 x86_64, Debian Jessie, xfsprogs 3.2.1

xps_repair output:
Phase 5 - rebuild AG headers and trees...
        - agno = 0
traps: xfs_repair[4786] trap divide error ip:417fef sp:7ffe43770d60
error:0 in xfs_repair[400000+7a000]
Floating point exception

mount output:
XFS (dm-2): Mounting V5 Filesystem
XFS (dm-2): Corruption warning: Metadata has LSN (11:170112) ahead of
current LSN (1:64). Please unmount and run xfs_repair (>= v4.3) to
resolve.
XFS (dm-2): log mount/recovery failed: error -22
XFS (dm-2): log mount failed
mount: wrong fs type, bad option, bad superblock on /dev/mapper/storage-crypt,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

I dumped the whole volume with dd so that I can revert to the current
(hopefully not hopelessly screwed) state. Downloaded xfsprogs 4.11.0
and checked the changelog. There are fixes for xfs_repair phase 5,
though the FP exception is not mentioned. Is this bug already fixed?
Should I try xfs_repair from 4.11?

Thanks & kind regards, Peter
