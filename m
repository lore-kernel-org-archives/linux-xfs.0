Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot1-f50.google.com ([209.85.210.50]:44526 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbfEMBph (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 May 2019 21:45:37 -0400
Received: by mail-ot1-f50.google.com with SMTP id g18so10058316otj.11
        for <linux-xfs@vger.kernel.org>; Sun, 12 May 2019 18:45:37 -0700 (PDT)
MIME-Version: 1.0
From: Tim Smith <tim.smith@vaultcloud.com.au>
Date: Mon, 13 May 2019 11:45:26 +1000
Message-ID: <CAHgs-5XkA5xFgxgSaX9m70gduuO1beq6fiY7UEGv1ad6bd19Hw@mail.gmail.com>
Subject: xfs filesystem reports negative usage - reoccurring problem
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hey guys,

We've got a bunch of hosts with multiple spinning disks providing file
server duties with xfs.

Some of the filesystems will go into a state where they report
negative used space -  e.g. available is greater than total.

This appears to be purely cosmetic, as we can still write data to (and
read from) the filesystem, but it throws out our reporting data.

We can (temporarily) fix the issue by unmounting and running
`xfs_repair` on the filesystem, but it soon reoccurs.

Does anybody have any ideas as to why this might be happening and how
to prevent it? Can userspace processes affect change to the xfs
superblock?

Example of a 'good' filesystem on the host:

$ sudo df -k /dev/sdac
Filesystem      1K-blocks       Used  Available Use% Mounted on
/dev/sdac      9764349952 7926794452 1837555500  82% /srv/node/sdac

$ sudo strace df -k /dev/sdac |& grep statfs

statfs("/srv/node/sdac", {f_type=0x58465342, f_bsize=4096,
f_blocks=2441087488, f_bfree=459388875, f_bavail=459388875,
f_files=976643648, f_ffree=922112135, f_fsid={16832, 0},
f_namelen=255, f_frsize=4096, f_flags=3104}) = 0

$ sudo xfs_db -r /dev/sdac
[ snip ]
icount = 54621696
free = 90183
fdblocks = 459388955

Example of a 'bad' filesystem on the host:

$ sudo df -k /dev/sdad
Filesystem      1K-blocks        Used   Available Use% Mounted on
/dev/sdad      9764349952 -9168705440 18933055392    - /srv/node/sdad

$ sudo strace df -k /dev/sdad |& grep statfs
statfs("/srv/node/sdad", {f_type=0x58465342, f_bsize=4096,
f_blocks=2441087488, f_bfree=4733263848, f_bavail=4733263848,
f_files=976643648, f_ffree=922172221, f_fsid={16848, 0},
f_namelen=255, f_frsize=4096, f_flags=3104}) = 0

$ sudo xfs_db -r /dev/sdad
[ snip ]
icount = 54657600
ifree = 186173
fdblocks = 4733263928

Host environment:
$ uname -a
Linux hostname 4.15.0-47-generic #50~16.04.1-Ubuntu SMP Fri Mar 15
16:06:21 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux

$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description: Ubuntu 16.04.5 LTS
Release: 16.04
Codename: xenial

Thank you!
Tim
