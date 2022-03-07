Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08339C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Mar 2022 15:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237359AbiCGPRj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 10:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236295AbiCGPRi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Mar 2022 10:17:38 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB13F8CD96
        for <linux-xfs@vger.kernel.org>; Mon,  7 Mar 2022 07:16:43 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id y12so659698edc.13
        for <linux-xfs@vger.kernel.org>; Mon, 07 Mar 2022 07:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=GVvhYd/MZgq5TAg66j4Tzz26q/FP8uzIyWTBG2MNEV8=;
        b=RPVR7+zmsuYuvCeojHwmZNi/dAo4SxdeI4Q/6cnEsXJLSsY19JRbN2Ag2pvB557CAX
         8fBS2Hay02qsCyQfm8XdaIWAB5oBlUSAKlFEsB/51hSL7mPKEiOhwEQSplCXWReapdez
         2G4U7nEFNVLpiwz6Zxx66TJzA3BhH0uXomEzZtJLt1XLHVklzrs7VWHDPdIyEcKwlJ1F
         7rv2sfS6ykw7CxoQQax3lvSghRQxFXSmKUmnpUMxUA2Z2bFVZBvsinxmWzh7YtFbxIyj
         dK4ffJtTLuHZE5uHJG8GF1IAh7PylYXX2uXPL7bge4exw/p/tPen18VJ0CZ/xQaDu/9U
         dsjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=GVvhYd/MZgq5TAg66j4Tzz26q/FP8uzIyWTBG2MNEV8=;
        b=D1hZWD5NXSWhEysRd1+gV1JoFDqxi87uUu9cBt7MUmPkSKxQlA9uHCW3089bevX1Af
         JYz0Sp7B1MZTVriHk91Kv3tMX0jVgT7Q/B5zLf+26m/O3GeLgJTE7VyIpivdT1xcjcXJ
         CoJFkxsG+qQ9Jvb9HKCZS7XETcXbdl0BptqWcVWrSSZbEIqhj0tJBvMO8m6bvPNsuaD5
         9Vl8mBWWtYBHcCtjmqvPau1/ni++tei2hp6foqxnzWWPsym/FgCU3hA8L+szPAjNfSmb
         Cs1owHPio6JbLJysd5P/8jFt2VVj8Njg0nHwaxF53x5tynnf3Uk2roXj4nNL4MIydg+3
         Yg2A==
X-Gm-Message-State: AOAM532tL/ghVcooUBxu4sj4/l+O9Api56T1hvC+RsDC0Er4opziHLYq
        D5Ayxefafs0bpdlz5JlAjKsy5EYK8wybSBXwpZHoNVhOAWo=
X-Google-Smtp-Source: ABdhPJy6eYbui4RMy9onZsXDwYZXlyB8lHGvM9GeuSb2FBqoJzqT5MJvV7FLOIUHGLZZ6eym4JUkri6EiwxmgzRz1X8=
X-Received: by 2002:a05:6402:2711:b0:416:6442:76dc with SMTP id
 y17-20020a056402271100b00416644276dcmr878913edd.314.1646666202142; Mon, 07
 Mar 2022 07:16:42 -0800 (PST)
MIME-Version: 1.0
References: <CALwRca2+UsEZMPwiCtecM87HVVMs27SdawdWXns+PU7+S-DFaQ@mail.gmail.com>
 <CALwRca3yS2q4XYr5aFaPWxNcGsYRFDWeU9je1q31KGguTeX6Rw@mail.gmail.com> <YiYIO2lJf123LA2c@B-P7TQMD6M-0146.local>
In-Reply-To: <YiYIO2lJf123LA2c@B-P7TQMD6M-0146.local>
From:   David Dal Ben <dalben@gmail.com>
Date:   Mon, 7 Mar 2022 23:16:15 +0800
Message-ID: <CALwRca2bZD5tXmL5kzCdL97LpqWGVhYXMNSWSvqn=FkMuMrbjQ@mail.gmail.com>
Subject: Re: Inconsistent "EXPERIMENTAL online shrink feature in use. Use at
 your own risk" alert
To:     David Dal Ben <dalben@gmail.com>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_repair version 5.13.0

Some background.  File system was 24Tb,  Expanded out to 52Tb then
back down 40Tb where it is now after migration data to the new disks.
Both 18Tb disks were added to the array at the same time.

Not sure how much more info I can give you as I'm relaying info
between Unraid techs and you.  My main concern is whether I do have
any real risk at the moment.

On Mon, 7 Mar 2022 at 21:27, Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>
> Hi,
>
> On Mon, Mar 07, 2022 at 08:19:11PM +0800, David Dal Ben wrote:
> > The "XFS (md1): EXPERIMENTAL online shrink feature in use. Use at your
> > own risk!" alert is appearing in my syslog/on my console.  It started
> > after I upgraded a couple of drives to Toshiba MG09ACA18TE 18Tb
> > drives.
> >
> > Strangely the alert appears for one drive and not the other.  There
> > was no configuring or setting anything up wrt the disks, just
> > installed them straight out of the box.
> >
> > Is there a real risk?  If so, is there a way to disable the feature?
> >
> > Kernel used: Linux version 5.14.15-Unraid
> >
> > Syslog snippet:
> >
> > Mar  6 19:59:21 tdm emhttpd: shcmd (81): mkdir -p /mnt/disk1
> > Mar  6 19:59:21 tdm emhttpd: shcmd (82): mount -t xfs -o noatime
> > /dev/md1 /mnt/disk1
> > Mar  6 19:59:21 tdm kernel: SGI XFS with ACLs, security attributes, no
> > debug enabled
> > Mar  6 19:59:21 tdm kernel: XFS (md1): Mounting V5 Filesystem
> > Mar  6 19:59:21 tdm kernel: XFS (md1): Ending clean mount
> > Mar  6 19:59:21 tdm emhttpd: shcmd (83): xfs_growfs /mnt/disk1
> > Mar  6 19:59:21 tdm kernel: xfs filesystem being mounted at /mnt/disk1
> > supports timestamps until 2038 (0x7fffffff)
> > Mar  6 19:59:21 tdm root: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl
> > failed: No space left on device
>
> ...
>
> May I ask what is xfsprogs version used now?
>
> At the first glance, it seems that some old xfsprogs is used here,
> otherwise, it will show "[EXPERIMENTAL] try to shrink unused space"
> message together with the kernel message as well.
>
> I'm not sure what's sb_dblocks recorded in on-disk super block
> compared with new disk sizes.
>
> I guess the problem may be that the one new disk is larger than
> sb_dblocks and the other is smaller than sb_dblocks. But if some
> old xfsprogs is used, I'm still confused why old version xfsprogs
> didn't block it at the userspace in advance.
>
> Thanks,
> Gao Xiang
>
> > Mar  6 19:59:21 tdm root: meta-data=/dev/md1               isize=512
> >  agcount=32, agsize=137330687 blks
> > Mar  6 19:59:21 tdm root:          =                       sectsz=512
> >  attr=2, projid32bit=1
> > Mar  6 19:59:21 tdm root:          =                       crc=1
> >  finobt=1, sparse=1, rmapbt=0
> > Mar  6 19:59:21 tdm root:          =                       reflink=1
> >  bigtime=0 inobtcount=0
> > Mar  6 19:59:21 tdm root: data     =                       bsize=4096
> >  blocks=4394581984, imaxpct=5
> > Mar  6 19:59:21 tdm root:          =                       sunit=1
> >  swidth=32 blks
> > Mar  6 19:59:21 tdm root: naming   =version 2              bsize=4096
> >  ascii-ci=0, ftype=1
> > Mar  6 19:59:21 tdm root: log      =internal log           bsize=4096
> >  blocks=521728, version=2
> > Mar  6 19:59:21 tdm root:          =                       sectsz=512
> >  sunit=1 blks, lazy-count=1
> > Mar  6 19:59:21 tdm root: realtime =none                   extsz=4096
> >  blocks=0, rtextents=0
> > Mar  6 19:59:21 tdm emhttpd: shcmd (83): exit status: 1
> > Mar  6 19:59:21 tdm emhttpd: shcmd (84): mkdir -p /mnt/disk2
> > Mar  6 19:59:21 tdm kernel: XFS (md1): EXPERIMENTAL online shrink
> > feature in use. Use at your own risk!
> > Mar  6 19:59:21 tdm emhttpd: shcmd (85): mount -t xfs -o noatime
> > /dev/md2 /mnt/disk2
> > Mar  6 19:59:21 tdm kernel: XFS (md2): Mounting V5 Filesystem
> > Mar  6 19:59:22 tdm kernel: XFS (md2): Ending clean mount
> > Mar  6 19:59:22 tdm kernel: xfs filesystem being mounted at /mnt/disk2
> > supports timestamps until 2038 (0x7fffffff)
> > Mar  6 19:59:22 tdm emhttpd: shcmd (86): xfs_growfs /mnt/disk2
> > Mar  6 19:59:22 tdm root: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl
> > failed: No space left on device
>
>
> > Mar  6 19:59:22 tdm root: meta-data=/dev/md2               isize=512
> >  agcount=32, agsize=137330687 blks
> > Mar  6 19:59:22 tdm root:          =                       sectsz=512
> >  attr=2, projid32bit=1
> > Mar  6 19:59:22 tdm root:          =                       crc=1
> >  finobt=1, sparse=1, rmapbt=0
> > Mar  6 19:59:22 tdm root:          =                       reflink=1
> >  bigtime=0 inobtcount=0
> > Mar  6 19:59:22 tdm root: data     =                       bsize=4096
> >  blocks=4394581984, imaxpct=5
> > Mar  6 19:59:22 tdm root:          =                       sunit=1
> >  swidth=32 blks
> > Mar  6 19:59:22 tdm root: naming   =version 2              bsize=4096
> >  ascii-ci=0, ftype=1
> > Mar  6 19:59:22 tdm root: log      =internal log           bsize=4096
> >  blocks=521728, version=2
> > Mar  6 19:59:22 tdm root:          =                       sectsz=512
> >  sunit=1 blks, lazy-count=1
> > Mar  6 19:59:22 tdm root: realtime =none                   extsz=4096
> >  blocks=0, rtextents=0
> > Mar  6 19:59:22 tdm emhttpd: shcmd (86): exit status: 1
