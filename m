Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:35909 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751011AbdB0GHR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Feb 2017 01:07:17 -0500
MIME-Version: 1.0
From: Xiong Zhou <jencce.kernel@gmail.com>
Date: Mon, 27 Feb 2017 13:03:31 +0800
Message-ID: <CADJHv_vNVQPK91Jnwo9Vim4t6rvAOTXNuMyLSDNBJ8CtSn7H_Q@mail.gmail.com>
Subject: LTP write03 writev07 xfs failures
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>

Hi,

These 2 tests PASS on Linus tree commit:
  37c8596 Merge tag 'tty-4.11-rc1' of git://git.kernel.org/pub/scm/linux...
FAIL on commit:
  60e8d3e Merge tag 'pci-v4.11-changes' of git://git.kernel.org/pub/scm/...

LTP latest commit: c60d3ca move_pages12: include lapi/mmap.h

Steps:

sh-4.2# pwd
/root/ltp
sh-4.2# git log --oneline -1
c60d3ca move_pages12: include lapi/mmap.h
sh-4.2# uname -r
4.10.0-master-60e8d3e+
sh-4.2# mount | grep test1
/dev/sda3 on /test1 type xfs
(rw,relatime,seclabel,attr2,inode64,logbsize=256k,sunit=512,swidth=512,noquota)
sh-4.2# xfs_info /test1
meta-data=/dev/sda3              isize=512    agcount=16, agsize=245696 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0
data     =                       bsize=4096   blocks=3931136, imaxpct=25
         =                       sunit=64     swidth=64 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
sh-4.2#
sh-4.2# TMPDIR=/test1 ./testcases/kernel/syscalls/write/write03
write03     0  TINFO  :  Enter Block 1: test to check if write
corrupts the file when write fails
write03     1  TFAIL  :  write03.c:125: failure of write(2) corrupted the file
write03     0  TINFO  :  Exit block 1
sh-4.2#
sh-4.2# TMPDIR=/test1 ./testcases/kernel/syscalls/writev/writev07
tst_test.c:760: INFO: Timeout per run is 0h 05m 00s
writev07.c:60: INFO: starting test with initial file offset: 0
writev07.c:82: INFO: got EFAULT
writev07.c:87: FAIL: file was written to
writev07.c:93: PASS: offset stayed unchanged
writev07.c:60: INFO: starting test with initial file offset: 65
writev07.c:82: INFO: got EFAULT
writev07.c:89: PASS: file stayed untouched
writev07.c:93: PASS: offset stayed unchanged
writev07.c:60: INFO: starting test with initial file offset: 4096
writev07.c:82: INFO: got EFAULT
writev07.c:89: PASS: file stayed untouched
writev07.c:93: PASS: offset stayed unchanged
writev07.c:60: INFO: starting test with initial file offset: 4097
writev07.c:82: INFO: got EFAULT
writev07.c:89: PASS: file stayed untouched
writev07.c:93: PASS: offset stayed unchanged

Summary:
passed   7
failed   1
skipped  0
warnings 0
sh-4.2#
sh-4.2# mkfs.xfs -V
mkfs.xfs version 4.7.0
sh-4.2# cd ../xfsprogs/
sh-4.2# git log --oneline -1
d7e1f5f xfsprogs: Release v4.7
sh-4.2#

Thanks,
Xiong
