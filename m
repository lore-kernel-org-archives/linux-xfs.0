Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f178.google.com ([209.85.160.178]:42895 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfBRPNv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Feb 2019 10:13:51 -0500
Received: by mail-qt1-f178.google.com with SMTP id b8so19478642qtr.9
        for <linux-xfs@vger.kernel.org>; Mon, 18 Feb 2019 07:13:50 -0800 (PST)
MIME-Version: 1.0
References: <CABAwU-adU9ChA7XbT5_LVGvyK_5tUmq-t3eOmbPRAGCFD3Md0g@mail.gmail.com>
 <20190218143122.GA33924@bfoster>
In-Reply-To: <20190218143122.GA33924@bfoster>
From: huang jun <hjwsm1989@gmail.com>
Date: Mon, 18 Feb 2019 23:13:38 +0800
Message-ID: <CABAwU-Z7dSNqfpH2wxF63C=UeBWoH8Au+P+Z8j1VERg1t_aZ5w@mail.gmail.com>
Subject: Re: inode not recycled after delete file
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Thank you for reply, i notice the warning message as you mentioned,
and found that:

[root@xefs-51 ~]# abrt-cli list --since 1550483811
id 95c775cc6f18c083fb771a27accbb9a7a03e8515
reason:         BUG: Dentry ffff8803ae02c600{i=3D68,n=3D333} still in use
(1) [unmount of xfs sdc2]
time:           2019=E5=B9=B402=E6=9C=8818=E6=97=A5 =E6=98=9F=E6=9C=9F=E4=
=B8=80 18=E6=97=B619=E5=88=8651=E7=A7=92
uid:            0 (root)
count:          1
Directory:      /var/spool/abrt/vmcore-127.0.0.1-2019-02-18-18:15:31
=E5=B7=B2=E6=8A=A5=E5=91=8A=EF=BC=9A    =E6=97=A0=E6=B3=95=E6=8A=A5=E5=91=
=8A

id 224daa72a910003dceebe315d59cb9c4a2a6504e
reason:         BUG: Dentry ffff880e3f7d8540{i=3D6e,n=3D110} still in use
(1) [unmount of xfs sdc2]
time:           2019=E5=B9=B402=E6=9C=8818=E6=97=A5 =E6=98=9F=E6=9C=9F=E4=
=B8=80 18=E6=97=B619=E5=88=8624=E7=A7=92
uid:            0 (root)
count:          1
Directory:      /var/spool/abrt/vmcore-127.0.0.1-2019-02-18-17:41:56
=E5=B7=B2=E6=8A=A5=E5=91=8A=EF=BC=9A    =E6=97=A0=E6=B3=95=E6=8A=A5=E5=91=
=8A

=E5=B7=B2=E7=A6=81=E7=94=A8=E8=87=AA=E5=8A=A8=E6=8A=A5=E5=91=8A=E5=8A=9F=E8=
=83=BD=E3=80=82=E8=AF=B7=E8=80=83=E8=99=91=E5=90=AF=E7=94=A8=E8=AF=A5=E5=8A=
=9F=E8=83=BD=EF=BC=8C=E6=96=B9=E6=B3=95=E6=98=AF
=E4=BD=9C=E4=B8=BA=E6=9C=89 root =E7=89=B9=E6=9D=83=E7=9A=84=E7=94=A8=E6=88=
=B7=E4=BD=BF=E7=94=A8=E5=91=BD=E4=BB=A4 'abrt-auto-reporting enabled'

i will check this now.

>
> On Mon, Feb 18, 2019 at 07:18:20PM +0800, huang jun wrote:
> > Hello
> > Recently we have a problem on xfs.
> >
> > The environment is:
> > CentOS Linux release 7.4.1708 (Core)
> > Linux xefs-51 3.10.0-693.el7.x86_64 #1 SMP Tue Aug 22 21:09:27 UTC
> > 2017 x86_64 x86_64 x86_64 GNU/Linux
> >
> > [root@xefs-51 ~]# modinfo xfs
> > filename:       /lib/modules/3.10.0-693.el7.x86_64/kernel/fs/xfs/xfs.ko=
.xz
> > license:        GPL
> > description:    SGI XFS with ACLs, security attributes, no debug enable=
d
> > author:         Silicon Graphics, Inc.
> > alias:          fs-xfs
> > rhelversion:    7.4
> > srcversion:     6CAAE7A01207B73522C8412
> > depends:        libcrc32c
> > intree:         Y
> > vermagic:       3.10.0-693.el7.x86_64 SMP mod_unload modversions
> > signer:         CentOS Linux kernel signing key
> > sig_key:        DA:18:7D:CA:7D:BE:53:AB:05:BD:13:BD:0C:4E:21:F4:22:B6:A=
4:9C
> > sig_hashalgo:   sha256
> >
> > We mount /dev/sdc2 on /mnt after machine boot
> > [root@xefs-51 ~]# df -iT /mnt/
> > =E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Inode=
 =E5=B7=B2=E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=
=8C=82=E8=BD=BD=E7=82=B9
> > /dev/sdc2      xfs  107374144       6 107374138       1% /mnt
> > [root@xefs-51 ~]# ls /mnt
> > jjj  kkk  xfs.strace
> >
> > And we add files to /mnt at first,
> > [root@xefs-51 ~]# cp /mnt/jjj /mnt/123
> > [root@xefs-51 ~]# df -iT /mnt
> > =E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Inode=
 =E5=B7=B2=E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=
=8C=82=E8=BD=BD=E7=82=B9
> > /dev/sdc2      xfs  107374144       7 107374137       1% /mnt
> > [root@xefs-51 ~]# cp /mnt/jjj /mnt/111
> > [root@xefs-51 ~]# df -iT /mnt
> > =E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Inode=
 =E5=B7=B2=E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=
=8C=82=E8=BD=BD=E7=82=B9
> > /dev/sdc2      xfs  107374144       8 107374136       1% /mnt
> > [root@xefs-51 ~]# cp /mnt/jjj /mnt/222
> > [root@xefs-51 ~]# df -iT /mnt
> > =E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Inode=
 =E5=B7=B2=E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=
=8C=82=E8=BD=BD=E7=82=B9
> > /dev/sdc2      xfs  107374144       9 107374135       1% /mnt
> > [root@xefs-51 ~]# cp /mnt/jjj /mnt/333
> > [root@xefs-51 ~]# df -iT /mnt
> > =E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Inode=
 =E5=B7=B2=E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=
=8C=82=E8=BD=BD=E7=82=B9
> > /dev/sdc2      xfs  107374144      10 107374134       1% /mnt
> >
> > and then remove some, but the inodes used in 'df -iT /mnt' not changed
> > [root@xefs-51 ~]# rm -f /mnt/jjj
> > [root@xefs-51 ~]# df -iT /mnt
> > =E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Inode=
 =E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=8C=82=E8=
=BD=BD=E7=82=B9
> > /dev/sdc2      xfs  107374144      10 107374134       1% /mnt
> > [root@xefs-51 ~]# rm -f /mnt/kkk
> > [root@xefs-51 ~]# df -iT /mnt
> > =E6=96=87=E4=BB=B6=E7=B3=BB=E7=BB=9F       =E7=B1=BB=E5=9E=8B     Inode=
 =E5=B7=B2=E7=94=A8(I)   =E5=8F=AF=E7=94=A8(I) =E5=B7=B2=E7=94=A8(I)% =E6=
=8C=82=E8=BD=BD=E7=82=B9
> > /dev/sdc2      xfs  107374144      10 107374134       1% /mnt
> >
> > and if we umount /mnt at this time, the machine will reboot,
> > and no related log in /var/log/messages after boot and the inodes used
> > become normal.
>
> You have a filesystem that causes the machine to reboot when it is
> unmounted? If so, you need to identify why that happens first and
> foremost. I'd start by checking the filesystem for issues with
> 'xfs_repair -n' after a mount cycle (to perform log recovery). After
> that, perhaps check dmesg after each operation above before the unmount
> to rule out any preceding errors/shutdowns putting the system in an
> unexpected state. As for the unmount itself, I suppose you'll have to
> find a way to get a console that shows alert output or whatnot when the
> unmount occurs.
>
> Brian
>
> > As googled a lot, we tried some ways:
> > 1) lsof /mnt: shows nobody use this mount point.
> > 2) lsof |grep deleted: shows empty
> > What should i do to find the problem out?
> >
> > --
> > Thank you!



--
Thank you!
HuangJun
