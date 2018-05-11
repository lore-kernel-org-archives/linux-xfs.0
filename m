Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:37783 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750722AbeEKBme (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 21:42:34 -0400
Received: by mail-vk0-f54.google.com with SMTP id m144-v6so2370087vke.4
        for <linux-xfs@vger.kernel.org>; Thu, 10 May 2018 18:42:34 -0700 (PDT)
MIME-Version: 1.0
References: <CABnRu57R+xakqCPmhM7bjLoAfLAAEuoQDtoU9F9t6CxeNOaPJg@mail.gmail.com>
 <d7e616a7-9978-939a-2056-9846aadf20ef@sandeen.net>
In-Reply-To: <d7e616a7-9978-939a-2056-9846aadf20ef@sandeen.net>
From: Su Yue <damenly.su@gmail.com>
Date: Fri, 11 May 2018 09:48:20 +0800
Message-ID: <CABnRu57cVkQXEjV2BbuEShOZovco6C-DbrrKyva7TOh-+7xrbg@mail.gmail.com>
Subject: Re: Question about inode64
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

Thanks a lot!

After one-night sleep, my brain is clear to figure out
inode bits and inode64 mount option with your explanation.
And your suggestions are helpful too. : )

Su

On Fri, May 11, 2018 at 5:20 AM Eric Sandeen <sandeen@sandeen.net> wrote:

> On 5/10/18 12:31 PM, Su Yue wrote:
> > Hi, XFS developers
> >
> > Recently, I was told that some 32bit applications don't work
> > on large XFS filesystems. And it is caused by ino overflow in syscalls.
> >
> > If I don't misunderstand libxfs/xfs_format, XFS' absolute inode number
> > consists of agno_log
> > -agblklog-inopblog bits.
> > So significative bits = ROUND(log2(Disk size / AG size)) + ROUND(log2(AG
> > size / BLK size)) + ROUND(log2(BLK size / inode size)). Right?

> > Does it mean that it's feasible to avoid ino overflow by control of disk
> > size, AG size, block size, inode size when mkfs even the disk will be
mount
> > with option inode64.

> Yes, inode number is an encoded disk location, and the encoding depends
> on various other bits of filesystem geometry.

> Note that "inode64" only means that it will /allow/ some inodes to exceed
> 32 bits, it does not mean that every inode number /will/ be > 32 bits.

> But most people don't want to constrain their filesystem geometry around
> inode number sizing; if you require 32-bit inodes, just use the inode32
mount
> option.

> Or better yet, fix the application.  :)

> -Eric

> > Thanks,
> > Su
