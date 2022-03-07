Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DCEAC433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Mar 2022 22:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240550AbiCGWsV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 17:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237095AbiCGWsV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Mar 2022 17:48:21 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33CB2A278
        for <linux-xfs@vger.kernel.org>; Mon,  7 Mar 2022 14:47:25 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id g20so22062850edw.6
        for <linux-xfs@vger.kernel.org>; Mon, 07 Mar 2022 14:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RuXalIgexcx4/oOogQAa0UsqPlGiDurKy8Yxx7dB4Gg=;
        b=ceT6wpBAkViBNstBB4MlkkPqnOxVhFYF9Rpsr3d+E5twH7f2fPqqmbnUbOqA6Vrs/6
         amNolL7Xj96R/WOHMiVfFkNZttSt3yeRzD/BywAuHh+n35sfgV23rm/wjCsmMkPPaC7M
         iSJiEH9YdM29Dks1nq60YzmmngyGFlHRIuY5+xYzxuM/LlqD2UnKTdQsIZ0gu0mRvFFj
         u5S7zc330Y8AKWrQ+bmAJQdYll6ns38p3nUl5b7+qHyGaVkEU7wRX/Jfmy4E178iZzna
         uCSJCj4YIUCxNMNpAPNVE/J2Gq00tPOh3h/EdMrorXf/9aILITxyQl1B0ci2jUGskLI6
         DD5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RuXalIgexcx4/oOogQAa0UsqPlGiDurKy8Yxx7dB4Gg=;
        b=CFGFE6BFRa0dv2znhC7dceasj9Vl5BLkbfhmg4/gD70KQSxQzRsKiAMBuqKy72d1V3
         w18bJL0NeThwnqJlNgC8VeZ50K7stn+DmbLHTUfOorQKX8ENnLymONtZIiZOdNg8xULp
         rYnuncsRKHp3qEYOtvNa6+o4aVgZ/yEU+xEsWcKNlpNPcwF0a5iLMJi5y9V0kDWd+d77
         J7JvXYYRiVK1zYDSJcNmwPg5J82+1u1WkVly0IRf5G4kuIciugDkyTesKfSkL5uuw9UY
         bNGdDeqHWVSO/zQpiRNfzwjCD+kz7CNnxVDVWOVEpxMMiong6dx6oF20bErwW3hpIADq
         PGeA==
X-Gm-Message-State: AOAM5330LCBcdWkPHGXQRvMeWDEJ4wGW6AIu3KldL0OZOl5yx46A2BdY
        x+MQFU6FFXR+m0ZXfw4Xzc3Sn7WPsGNpkBYGFjeg2IsGzEY=
X-Google-Smtp-Source: ABdhPJyhokUYIYJ4s4ZQjWsuKoxOWREfXzPyHWvE12vLzMFgxV3anRm1eFmS8dJcYWvY/wHqaYGWck2ufHibS9Fmn9M=
X-Received: by 2002:a05:6402:644:b0:416:4ade:54e3 with SMTP id
 u4-20020a056402064400b004164ade54e3mr6026193edx.222.1646693243937; Mon, 07
 Mar 2022 14:47:23 -0800 (PST)
MIME-Version: 1.0
References: <CALwRca2+UsEZMPwiCtecM87HVVMs27SdawdWXns+PU7+S-DFaQ@mail.gmail.com>
 <CALwRca3yS2q4XYr5aFaPWxNcGsYRFDWeU9je1q31KGguTeX6Rw@mail.gmail.com>
 <YiYIO2lJf123LA2c@B-P7TQMD6M-0146.local> <CALwRca2bZD5tXmL5kzCdL97LpqWGVhYXMNSWSvqn=FkMuMrbjQ@mail.gmail.com>
 <9f957f7a-0f08-9cb4-d8ff-76440a488184@redhat.com>
In-Reply-To: <9f957f7a-0f08-9cb4-d8ff-76440a488184@redhat.com>
From:   David Dal Ben <dalben@gmail.com>
Date:   Tue, 8 Mar 2022 06:46:58 +0800
Message-ID: <CALwRca2Xdp8F_xjXSFXxO-Ra96W685o2qY1xoo=Ko9OWF4oRvw@mail.gmail.com>
Subject: Re: Inconsistent "EXPERIMENTAL online shrink feature in use. Use at
 your own risk" alert
To:     Eric Sandeen <esandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is where I get out of my depth. I added the drives to unraid, it
asked if I wanted to format them, I said yes, when that was completed
I started migrating data.

I didn't enter any XFS or disk commands from the CLI.

What I can tell you is that there are a couple of others who have
reported this alert on the Unraid forums, all seem to have larger
disks, over 14tb.


On Mon, 7 Mar 2022 at 23:29, Eric Sandeen <esandeen@redhat.com> wrote:
>
> On 3/7/22 9:16 AM, David Dal Ben wrote:
> > xfs_repair version 5.13.0
> >
> > Some background.  File system was 24Tb,  Expanded out to 52Tb then
> > back down 40Tb where it is now after migration data to the new disks.
> > Both 18Tb disks were added to the array at the same time.
>
> So, xfs_growfs has historically been unable to shrink the filesystem at
> all. Thanks to Gao's work, it can be shrunk but only in very unique cases,
> i.e. the case where there is no data or metadata located in the space
> that would be removed at the end of the filesystem.  More complete
> functionality remains unimplemented.
>
> So to be clear, did you did you actually shrink the underlying device size?
>
> And/or did you issue an "xfs_growfs" command with a size smaller than the
> current size?
>
> If you shrunk the block device without successfully shrinking the filesystem
> first, then you have a corrupted filesystem and lost data, I'm afraid.
>
> But AFAIK xfs_growfs should have failed gracefully, and your filesystem
> should be the same size as before, and should still be consistent, as long
> as the actual storage was not reduced.
>
> The concern is re: whether you shrunk the storage.
>
> What was the actual sequence of commands you issued?
>
> -Eric
>
>
> > Not sure how much more info I can give you as I'm relaying info
> > between Unraid techs and you.  My main concern is whether I do have
> > any real risk at the moment.
>
>
>
>
> > On Mon, 7 Mar 2022 at 21:27, Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
> >>
> >> Hi,
> >>
> >> On Mon, Mar 07, 2022 at 08:19:11PM +0800, David Dal Ben wrote:
> >>> The "XFS (md1): EXPERIMENTAL online shrink feature in use. Use at your
> >>> own risk!" alert is appearing in my syslog/on my console.  It started
> >>> after I upgraded a couple of drives to Toshiba MG09ACA18TE 18Tb
> >>> drives.
> >>>
> >>> Strangely the alert appears for one drive and not the other.  There
> >>> was no configuring or setting anything up wrt the disks, just
> >>> installed them straight out of the box.
> >>>
> >>> Is there a real risk?  If so, is there a way to disable the feature?
> >>>
> >>> Kernel used: Linux version 5.14.15-Unraid
> >>>
> >>> Syslog snippet:
> >>>
> >>> Mar  6 19:59:21 tdm emhttpd: shcmd (81): mkdir -p /mnt/disk1
> >>> Mar  6 19:59:21 tdm emhttpd: shcmd (82): mount -t xfs -o noatime
> >>> /dev/md1 /mnt/disk1
> >>> Mar  6 19:59:21 tdm kernel: SGI XFS with ACLs, security attributes, no
> >>> debug enabled
> >>> Mar  6 19:59:21 tdm kernel: XFS (md1): Mounting V5 Filesystem
> >>> Mar  6 19:59:21 tdm kernel: XFS (md1): Ending clean mount
> >>> Mar  6 19:59:21 tdm emhttpd: shcmd (83): xfs_growfs /mnt/disk1
> >>> Mar  6 19:59:21 tdm kernel: xfs filesystem being mounted at /mnt/disk1
> >>> supports timestamps until 2038 (0x7fffffff)
> >>> Mar  6 19:59:21 tdm root: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl
> >>> failed: No space left on device
> >>
> >> ...
> >>
> >> May I ask what is xfsprogs version used now?
> >>
> >> At the first glance, it seems that some old xfsprogs is used here,
> >> otherwise, it will show "[EXPERIMENTAL] try to shrink unused space"
> >> message together with the kernel message as well.
> >>
> >> I'm not sure what's sb_dblocks recorded in on-disk super block
> >> compared with new disk sizes.
> >>
> >> I guess the problem may be that the one new disk is larger than
> >> sb_dblocks and the other is smaller than sb_dblocks. But if some
> >> old xfsprogs is used, I'm still confused why old version xfsprogs
> >> didn't block it at the userspace in advance.
> >>
> >> Thanks,
> >> Gao Xiang
> >>
> >>> Mar  6 19:59:21 tdm root: meta-data=/dev/md1               isize=512
> >>>  agcount=32, agsize=137330687 blks
> >>> Mar  6 19:59:21 tdm root:          =                       sectsz=512
> >>>  attr=2, projid32bit=1
> >>> Mar  6 19:59:21 tdm root:          =                       crc=1
> >>>  finobt=1, sparse=1, rmapbt=0
> >>> Mar  6 19:59:21 tdm root:          =                       reflink=1
> >>>  bigtime=0 inobtcount=0
> >>> Mar  6 19:59:21 tdm root: data     =                       bsize=4096
> >>>  blocks=4394581984, imaxpct=5
> >>> Mar  6 19:59:21 tdm root:          =                       sunit=1
> >>>  swidth=32 blks
> >>> Mar  6 19:59:21 tdm root: naming   =version 2              bsize=4096
> >>>  ascii-ci=0, ftype=1
> >>> Mar  6 19:59:21 tdm root: log      =internal log           bsize=4096
> >>>  blocks=521728, version=2
> >>> Mar  6 19:59:21 tdm root:          =                       sectsz=512
> >>>  sunit=1 blks, lazy-count=1
> >>> Mar  6 19:59:21 tdm root: realtime =none                   extsz=4096
> >>>  blocks=0, rtextents=0
> >>> Mar  6 19:59:21 tdm emhttpd: shcmd (83): exit status: 1
> >>> Mar  6 19:59:21 tdm emhttpd: shcmd (84): mkdir -p /mnt/disk2
> >>> Mar  6 19:59:21 tdm kernel: XFS (md1): EXPERIMENTAL online shrink
> >>> feature in use. Use at your own risk!
> >>> Mar  6 19:59:21 tdm emhttpd: shcmd (85): mount -t xfs -o noatime
> >>> /dev/md2 /mnt/disk2
> >>> Mar  6 19:59:21 tdm kernel: XFS (md2): Mounting V5 Filesystem
> >>> Mar  6 19:59:22 tdm kernel: XFS (md2): Ending clean mount
> >>> Mar  6 19:59:22 tdm kernel: xfs filesystem being mounted at /mnt/disk2
> >>> supports timestamps until 2038 (0x7fffffff)
> >>> Mar  6 19:59:22 tdm emhttpd: shcmd (86): xfs_growfs /mnt/disk2
> >>> Mar  6 19:59:22 tdm root: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl
> >>> failed: No space left on device
> >>
> >>
> >>> Mar  6 19:59:22 tdm root: meta-data=/dev/md2               isize=512
> >>>  agcount=32, agsize=137330687 blks
> >>> Mar  6 19:59:22 tdm root:          =                       sectsz=512
> >>>  attr=2, projid32bit=1
> >>> Mar  6 19:59:22 tdm root:          =                       crc=1
> >>>  finobt=1, sparse=1, rmapbt=0
> >>> Mar  6 19:59:22 tdm root:          =                       reflink=1
> >>>  bigtime=0 inobtcount=0
> >>> Mar  6 19:59:22 tdm root: data     =                       bsize=4096
> >>>  blocks=4394581984, imaxpct=5
> >>> Mar  6 19:59:22 tdm root:          =                       sunit=1
> >>>  swidth=32 blks
> >>> Mar  6 19:59:22 tdm root: naming   =version 2              bsize=4096
> >>>  ascii-ci=0, ftype=1
> >>> Mar  6 19:59:22 tdm root: log      =internal log           bsize=4096
> >>>  blocks=521728, version=2
> >>> Mar  6 19:59:22 tdm root:          =                       sectsz=512
> >>>  sunit=1 blks, lazy-count=1
> >>> Mar  6 19:59:22 tdm root: realtime =none                   extsz=4096
> >>>  blocks=0, rtextents=0
> >>> Mar  6 19:59:22 tdm emhttpd: shcmd (86): exit status: 1
> >
> >
>
