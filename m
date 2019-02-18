Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f180.google.com ([209.85.160.180]:41129 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbfBRLSd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Feb 2019 06:18:33 -0500
Received: by mail-qt1-f180.google.com with SMTP id v10so18703968qtp.8
        for <linux-xfs@vger.kernel.org>; Mon, 18 Feb 2019 03:18:32 -0800 (PST)
MIME-Version: 1.0
From: huang jun <hjwsm1989@gmail.com>
Date: Mon, 18 Feb 2019 19:18:20 +0800
Message-ID: <CABAwU-adU9ChA7XbT5_LVGvyK_5tUmq-t3eOmbPRAGCFD3Md0g@mail.gmail.com>
Subject: inode not recycled after delete file
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello
Recently we have a problem on xfs.

The environment is:
CentOS Linux release 7.4.1708 (Core)
Linux xefs-51 3.10.0-693.el7.x86_64 #1 SMP Tue Aug 22 21:09:27 UTC
2017 x86_64 x86_64 x86_64 GNU/Linux

[root@xefs-51 ~]# modinfo xfs
filename:       /lib/modules/3.10.0-693.el7.x86_64/kernel/fs/xfs/xfs.ko.xz
license:        GPL
description:    SGI XFS with ACLs, security attributes, no debug enabled
author:         Silicon Graphics, Inc.
alias:          fs-xfs
rhelversion:    7.4
srcversion:     6CAAE7A01207B73522C8412
depends:        libcrc32c
intree:         Y
vermagic:       3.10.0-693.el7.x86_64 SMP mod_unload modversions
signer:         CentOS Linux kernel signing key
sig_key:        DA:18:7D:CA:7D:BE:53:AB:05:BD:13:BD:0C:4E:21:F4:22:B6:A4:9C
sig_hashalgo:   sha256

We mount /dev/sdc2 on /mnt after machine boot
[root@xefs-51 ~]# df -iT /mnt/
=E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Inode =E5=
=B7=B2=E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=8C=82=
=E8=BD=BD=E7=82=B9
/dev/sdc2      xfs  107374144       6 107374138       1% /mnt
[root@xefs-51 ~]# ls /mnt
jjj  kkk  xfs.strace

And we add files to /mnt at first,
[root@xefs-51 ~]# cp /mnt/jjj /mnt/123
[root@xefs-51 ~]# df -iT /mnt
=E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Inode =E5=
=B7=B2=E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=8C=82=
=E8=BD=BD=E7=82=B9
/dev/sdc2      xfs  107374144       7 107374137       1% /mnt
[root@xefs-51 ~]# cp /mnt/jjj /mnt/111
[root@xefs-51 ~]# df -iT /mnt
=E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Inode =E5=
=B7=B2=E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=8C=82=
=E8=BD=BD=E7=82=B9
/dev/sdc2      xfs  107374144       8 107374136       1% /mnt
[root@xefs-51 ~]# cp /mnt/jjj /mnt/222
[root@xefs-51 ~]# df -iT /mnt
=E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Inode =E5=
=B7=B2=E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=8C=82=
=E8=BD=BD=E7=82=B9
/dev/sdc2      xfs  107374144       9 107374135       1% /mnt
[root@xefs-51 ~]# cp /mnt/jjj /mnt/333
[root@xefs-51 ~]# df -iT /mnt
=E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Inode =E5=
=B7=B2=E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=8C=82=
=E8=BD=BD=E7=82=B9
/dev/sdc2      xfs  107374144      10 107374134       1% /mnt

and then remove some, but the inodes used in 'df -iT /mnt' not changed
[root@xefs-51 ~]# rm -f /mnt/jjj
[root@xefs-51 ~]# df -iT /mnt
=E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Inode =E7=
=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=8C=82=E8=BD=BD=
=E7=82=B9
/dev/sdc2      xfs  107374144      10 107374134       1% /mnt
[root@xefs-51 ~]# rm -f /mnt/kkk
[root@xefs-51 ~]# df -iT /mnt
=E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Inode =E5=
=B7=B2=E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=8C=82=
=E8=BD=BD=E7=82=B9
/dev/sdc2      xfs  107374144      10 107374134       1% /mnt

and if we umount /mnt at this time, the machine will reboot,
and no related log in /var/log/messages after boot and the inodes used
become normal.
As googled a lot, we tried some ways:
1) lsof /mnt: shows nobody use this mount point.
2) lsof |grep deleted: shows empty
What should i do to find the problem out?

--
Thank you!
