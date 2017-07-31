Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33634 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbdGaIwK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jul 2017 04:52:10 -0400
Received: by mail-io0-f173.google.com with SMTP id j32so87768053iod.0
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jul 2017 01:52:10 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?546L5YuH?= <wang.yong@datatom.com>
Date: Mon, 31 Jul 2017 16:51:29 +0800
Message-ID: <CA+jpiF7jK8m+a6LGKfj-CbfMEHqjsL5ZdagnzOAdRRwNxZg0oA@mail.gmail.com>
Subject: xfs seems performance lower when long time seq write into ssd
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>, xfs <xfs@oss.sgi.com>, "wang.yong" <wang.yong@datatom.com>

Hi All,
Recently, I meet a  strange quetion. I have done seq write
(blocksize=1m) into mount folders.
If total bytes is small, the avg write rate is 370MBs (little files :
 4MB * 256 * 60 )
If total bytes is big, the avg write rate is 180MBs  (a lot of files :
  4MB * 256 * 600)
the raw ssd benchmark, seq write is 400MBs.

Can anybody help to explain it?  argument is wrong, or something else.

Below argument list:

Hardware:        Intel 3750 ssd  480GB  (sata3)
centos:             7.3  x86_64
kernel:              3.10.0-514.el7.x86_64
software:          mkfs.xfs
mount feature:   /dev/sdb1  type xfs
(rw,noatime,attr2,inode64,logbsize=256k,noquota)

xfs_info /dev/sdl1 :
meta-data=/dev/sdl1              isize=512    agcount=4, agsize=28975477 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=115901905, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=56592, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Tks and Rgds
