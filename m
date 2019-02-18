Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733147AbfBROb0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Feb 2019 09:31:26 -0500
Date: Mon, 18 Feb 2019 09:31:23 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: inode not recycled after delete file
Message-ID: <20190218143122.GA33924@bfoster>
References: <CABAwU-adU9ChA7XbT5_LVGvyK_5tUmq-t3eOmbPRAGCFD3Md0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABAwU-adU9ChA7XbT5_LVGvyK_5tUmq-t3eOmbPRAGCFD3Md0g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: huang jun <hjwsm1989@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 18, 2019 at 07:18:20PM +0800, huang jun wrote:
> Hello
> Recently we have a problem on xfs.
> 
> The environment is:
> CentOS Linux release 7.4.1708 (Core)
> Linux xefs-51 3.10.0-693.el7.x86_64 #1 SMP Tue Aug 22 21:09:27 UTC
> 2017 x86_64 x86_64 x86_64 GNU/Linux
> 
> [root@xefs-51 ~]# modinfo xfs
> filename:       /lib/modules/3.10.0-693.el7.x86_64/kernel/fs/xfs/xfs.ko.xz
> license:        GPL
> description:    SGI XFS with ACLs, security attributes, no debug enabled
> author:         Silicon Graphics, Inc.
> alias:          fs-xfs
> rhelversion:    7.4
> srcversion:     6CAAE7A01207B73522C8412
> depends:        libcrc32c
> intree:         Y
> vermagic:       3.10.0-693.el7.x86_64 SMP mod_unload modversions
> signer:         CentOS Linux kernel signing key
> sig_key:        DA:18:7D:CA:7D:BE:53:AB:05:BD:13:BD:0C:4E:21:F4:22:B6:A4:9C
> sig_hashalgo:   sha256
> 
> We mount /dev/sdc2 on /mnt after machine boot
> [root@xefs-51 ~]# df -iT /mnt/
> 文件系统       类型     Inode 已用(I)   可用(I) 已用(I)% 挂载点
> /dev/sdc2      xfs  107374144       6 107374138       1% /mnt
> [root@xefs-51 ~]# ls /mnt
> jjj  kkk  xfs.strace
> 
> And we add files to /mnt at first,
> [root@xefs-51 ~]# cp /mnt/jjj /mnt/123
> [root@xefs-51 ~]# df -iT /mnt
> 文件系统       类型     Inode 已用(I)   可用(I) 已用(I)% 挂载点
> /dev/sdc2      xfs  107374144       7 107374137       1% /mnt
> [root@xefs-51 ~]# cp /mnt/jjj /mnt/111
> [root@xefs-51 ~]# df -iT /mnt
> 文件系统       类型     Inode 已用(I)   可用(I) 已用(I)% 挂载点
> /dev/sdc2      xfs  107374144       8 107374136       1% /mnt
> [root@xefs-51 ~]# cp /mnt/jjj /mnt/222
> [root@xefs-51 ~]# df -iT /mnt
> 文件系统       类型     Inode 已用(I)   可用(I) 已用(I)% 挂载点
> /dev/sdc2      xfs  107374144       9 107374135       1% /mnt
> [root@xefs-51 ~]# cp /mnt/jjj /mnt/333
> [root@xefs-51 ~]# df -iT /mnt
> 文件系统       类型     Inode 已用(I)   可用(I) 已用(I)% 挂载点
> /dev/sdc2      xfs  107374144      10 107374134       1% /mnt
> 
> and then remove some, but the inodes used in 'df -iT /mnt' not changed
> [root@xefs-51 ~]# rm -f /mnt/jjj
> [root@xefs-51 ~]# df -iT /mnt
> 文件系统       类型     Inode 用(I)   可用(I) 已用(I)% 挂载点
> /dev/sdc2      xfs  107374144      10 107374134       1% /mnt
> [root@xefs-51 ~]# rm -f /mnt/kkk
> [root@xefs-51 ~]# df -iT /mnt
> 文件系统       类型     Inode 已用(I)   可用(I) 已用(I)% 挂载点
> /dev/sdc2      xfs  107374144      10 107374134       1% /mnt
> 
> and if we umount /mnt at this time, the machine will reboot,
> and no related log in /var/log/messages after boot and the inodes used
> become normal.

You have a filesystem that causes the machine to reboot when it is
unmounted? If so, you need to identify why that happens first and
foremost. I'd start by checking the filesystem for issues with
'xfs_repair -n' after a mount cycle (to perform log recovery). After
that, perhaps check dmesg after each operation above before the unmount
to rule out any preceding errors/shutdowns putting the system in an
unexpected state. As for the unmount itself, I suppose you'll have to
find a way to get a console that shows alert output or whatnot when the
unmount occurs.

Brian

> As googled a lot, we tried some ways:
> 1) lsof /mnt: shows nobody use this mount point.
> 2) lsof |grep deleted: shows empty
> What should i do to find the problem out?
> 
> --
> Thank you!
