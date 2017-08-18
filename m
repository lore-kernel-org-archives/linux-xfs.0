Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:33438 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbdHRL4d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Aug 2017 07:56:33 -0400
Received: by mail-qt0-f180.google.com with SMTP id a18so52437066qta.0
        for <linux-xfs@vger.kernel.org>; Fri, 18 Aug 2017 04:56:32 -0700 (PDT)
MIME-Version: 1.0
From: Ingard - <ingard1@gmail.com>
Date: Fri, 18 Aug 2017 13:56:31 +0200
Message-ID: <CAHeWggOTqbQUQB7xz1wUjejHU5W14w3wcN-oV-+KJxxyEEQ3TQ@mail.gmail.com>
Subject: corrupt xfs log
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

After a server crash we've encountered a corrupt xfs filesystem. When
trying to mount said filesystem normally the system hangs.
This was initially on a ubuntu trusty server with 3.13 kernel with
xfsprogs 3.1.9

We've installed a newer kernel (4.4.0-92) and compiled xfsprogs v
4.12.0 from source. We're still not able to mount the filesystem (and
replay the log) normally.
We are able to mount it -o ro,norecovery, but we're reluctant to do
xfs_repair -L without trying everything we can first. The filesystem
is browsable albeit a few paths which gives an error : "Structure
needs cleaning"

Does anyone have any advice as to how we might recover/repair the
corrupt log so we can replay it? Or is xfs_repair -L the only way
forward?


Excerpt from kern.log:
2017-08-17T13:40:41.122121+02:00 dn-238 kernel: [  294.300347] XFS
(sdd1): Mounting V4 filesystem in no-recovery mode. Filesystem will be
inconsistent.

2017-08-17T17:04:54.794194+02:00 dn-238 kernel: [12548.400260] XFS
(sdd1): Metadata corruption detected at xfs_inode_buf_verify+0x6f/0xd0
[xfs], xfs_inode block 0x81c9c210
2017-08-17T17:04:54.794216+02:00 dn-238 kernel: [12548.400342] XFS
(sdd1): Unmount and run xfs_repair
2017-08-17T17:04:54.794218+02:00 dn-238 kernel: [12548.400374] XFS
(sdd1): First 64 bytes of corrupted metadata buffer:
2017-08-17T17:04:54.794220+02:00 dn-238 kernel: [12548.400418]
ffff880171fff000: 3f 1a 33 54 5b 55 85 0b 7c f5 c6 d5 cf 51 47 41
?.3T[U..|....QGA
2017-08-17T17:04:54.794222+02:00 dn-238 kernel: [12548.400473]
ffff880171fff010: 97 ba ba 03 5c e4 02 7a e6 bc fb 5d f1 72 db c1
....\..z...].r..
2017-08-17T17:04:54.794223+02:00 dn-238 kernel: [12548.400527]
ffff880171fff020: c8 ad 3a 76 c7 e4 20 92 88 a2 35 0c 1f 36 cf b5
..:v.. ...5..6..
2017-08-17T17:04:54.794226+02:00 dn-238 kernel: [12548.400581]
ffff880171fff030: 8a bc 42 75 86 50 a0 a2 be 2c 2d 99 96 2d e1 ee
..Bu.P...,-..-..

kind regards
ingard
