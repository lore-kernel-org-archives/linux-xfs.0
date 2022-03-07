Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A330C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Mar 2022 13:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbiCGN2Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 08:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242871AbiCGN2X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Mar 2022 08:28:23 -0500
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8517F3AA
        for <linux-xfs@vger.kernel.org>; Mon,  7 Mar 2022 05:27:28 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0V6VOlP2_1646659644;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0V6VOlP2_1646659644)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Mar 2022 21:27:25 +0800
Date:   Mon, 7 Mar 2022 21:27:23 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     David Dal Ben <dalben@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Inconsistent "EXPERIMENTAL online shrink feature in use. Use at
 your own risk" alert
Message-ID: <YiYIO2lJf123LA2c@B-P7TQMD6M-0146.local>
Mail-Followup-To: David Dal Ben <dalben@gmail.com>,
        linux-xfs@vger.kernel.org
References: <CALwRca2+UsEZMPwiCtecM87HVVMs27SdawdWXns+PU7+S-DFaQ@mail.gmail.com>
 <CALwRca3yS2q4XYr5aFaPWxNcGsYRFDWeU9je1q31KGguTeX6Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALwRca3yS2q4XYr5aFaPWxNcGsYRFDWeU9je1q31KGguTeX6Rw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

On Mon, Mar 07, 2022 at 08:19:11PM +0800, David Dal Ben wrote:
> The "XFS (md1): EXPERIMENTAL online shrink feature in use. Use at your
> own risk!" alert is appearing in my syslog/on my console.  It started
> after I upgraded a couple of drives to Toshiba MG09ACA18TE 18Tb
> drives.
> 
> Strangely the alert appears for one drive and not the other.  There
> was no configuring or setting anything up wrt the disks, just
> installed them straight out of the box.
> 
> Is there a real risk?  If so, is there a way to disable the feature?
> 
> Kernel used: Linux version 5.14.15-Unraid
> 
> Syslog snippet:
> 
> Mar  6 19:59:21 tdm emhttpd: shcmd (81): mkdir -p /mnt/disk1
> Mar  6 19:59:21 tdm emhttpd: shcmd (82): mount -t xfs -o noatime
> /dev/md1 /mnt/disk1
> Mar  6 19:59:21 tdm kernel: SGI XFS with ACLs, security attributes, no
> debug enabled
> Mar  6 19:59:21 tdm kernel: XFS (md1): Mounting V5 Filesystem
> Mar  6 19:59:21 tdm kernel: XFS (md1): Ending clean mount
> Mar  6 19:59:21 tdm emhttpd: shcmd (83): xfs_growfs /mnt/disk1
> Mar  6 19:59:21 tdm kernel: xfs filesystem being mounted at /mnt/disk1
> supports timestamps until 2038 (0x7fffffff)
> Mar  6 19:59:21 tdm root: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl
> failed: No space left on device

...

May I ask what is xfsprogs version used now?

At the first glance, it seems that some old xfsprogs is used here,
otherwise, it will show "[EXPERIMENTAL] try to shrink unused space"
message together with the kernel message as well.

I'm not sure what's sb_dblocks recorded in on-disk super block
compared with new disk sizes.

I guess the problem may be that the one new disk is larger than
sb_dblocks and the other is smaller than sb_dblocks. But if some
old xfsprogs is used, I'm still confused why old version xfsprogs
didn't block it at the userspace in advance.

Thanks,
Gao Xiang

> Mar  6 19:59:21 tdm root: meta-data=/dev/md1               isize=512
>  agcount=32, agsize=137330687 blks
> Mar  6 19:59:21 tdm root:          =                       sectsz=512
>  attr=2, projid32bit=1
> Mar  6 19:59:21 tdm root:          =                       crc=1
>  finobt=1, sparse=1, rmapbt=0
> Mar  6 19:59:21 tdm root:          =                       reflink=1
>  bigtime=0 inobtcount=0
> Mar  6 19:59:21 tdm root: data     =                       bsize=4096
>  blocks=4394581984, imaxpct=5
> Mar  6 19:59:21 tdm root:          =                       sunit=1
>  swidth=32 blks
> Mar  6 19:59:21 tdm root: naming   =version 2              bsize=4096
>  ascii-ci=0, ftype=1
> Mar  6 19:59:21 tdm root: log      =internal log           bsize=4096
>  blocks=521728, version=2
> Mar  6 19:59:21 tdm root:          =                       sectsz=512
>  sunit=1 blks, lazy-count=1
> Mar  6 19:59:21 tdm root: realtime =none                   extsz=4096
>  blocks=0, rtextents=0
> Mar  6 19:59:21 tdm emhttpd: shcmd (83): exit status: 1
> Mar  6 19:59:21 tdm emhttpd: shcmd (84): mkdir -p /mnt/disk2
> Mar  6 19:59:21 tdm kernel: XFS (md1): EXPERIMENTAL online shrink
> feature in use. Use at your own risk!
> Mar  6 19:59:21 tdm emhttpd: shcmd (85): mount -t xfs -o noatime
> /dev/md2 /mnt/disk2
> Mar  6 19:59:21 tdm kernel: XFS (md2): Mounting V5 Filesystem
> Mar  6 19:59:22 tdm kernel: XFS (md2): Ending clean mount
> Mar  6 19:59:22 tdm kernel: xfs filesystem being mounted at /mnt/disk2
> supports timestamps until 2038 (0x7fffffff)
> Mar  6 19:59:22 tdm emhttpd: shcmd (86): xfs_growfs /mnt/disk2
> Mar  6 19:59:22 tdm root: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl
> failed: No space left on device


> Mar  6 19:59:22 tdm root: meta-data=/dev/md2               isize=512
>  agcount=32, agsize=137330687 blks
> Mar  6 19:59:22 tdm root:          =                       sectsz=512
>  attr=2, projid32bit=1
> Mar  6 19:59:22 tdm root:          =                       crc=1
>  finobt=1, sparse=1, rmapbt=0
> Mar  6 19:59:22 tdm root:          =                       reflink=1
>  bigtime=0 inobtcount=0
> Mar  6 19:59:22 tdm root: data     =                       bsize=4096
>  blocks=4394581984, imaxpct=5
> Mar  6 19:59:22 tdm root:          =                       sunit=1
>  swidth=32 blks
> Mar  6 19:59:22 tdm root: naming   =version 2              bsize=4096
>  ascii-ci=0, ftype=1
> Mar  6 19:59:22 tdm root: log      =internal log           bsize=4096
>  blocks=521728, version=2
> Mar  6 19:59:22 tdm root:          =                       sectsz=512
>  sunit=1 blks, lazy-count=1
> Mar  6 19:59:22 tdm root: realtime =none                   extsz=4096
>  blocks=0, rtextents=0
> Mar  6 19:59:22 tdm emhttpd: shcmd (86): exit status: 1
