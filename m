Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43362 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbeG3LhQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 07:37:16 -0400
Received: by mail-pg1-f195.google.com with SMTP id d17-v6so2547631pgv.10
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 03:03:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAKAc_Gwh-KMdnK6LqX3kE9jTmSHsg8_kzQE5fPsnL3xETD1O+w@mail.gmail.com>
 <3895eebe-3fa2-a977-4021-3bd6ef645fdd@sandeen.net> <CAKAc_GwXi4U=WceoWo_6dsjT_ThTYKbebOzxkcTAW2_-vfgt=g@mail.gmail.com>
 <CAKAc_GxsR9UxswqJMLhPOqR6HeYLi-rHZiEY8LLxs-hj0n=uMQ@mail.gmail.com>
 <20180717092626.pxb6wzhcswf2f77p@odin.usersys.redhat.com> <CAKAc_Gx5RaiEC1C8aSYZXAcZcyyPHPNWHy6ALuzOJvkgkg5nkA@mail.gmail.com>
 <830a7de7-34ca-7d79-d94a-ff16c98381a3@sandeen.net>
In-Reply-To: <830a7de7-34ca-7d79-d94a-ff16c98381a3@sandeen.net>
From: Filippo Giunchedi <fgiunchedi@wikimedia.org>
Date: Mon, 30 Jul 2018 12:02:50 +0200
Message-ID: <CAKAc_Gwh36OhTs9DfsfqxniRw+jZ5c-Tyh2P5D3tA+JJW31Y6g@mail.gmail.com>
Subject: Re: Recently-formatted XFS filesystems reporting negative used space
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Sun, Jul 22, 2018 at 2:03 AM Eric Sandeen <sandeen@sandeen.net> wrote:
> On 7/20/18 3:20 AM, Filippo Giunchedi wrote:
> > To recap what we've seen, hardware bit flipping is extremely unlikely:
> > the same type of sb_fdblocks corruption has appeared on four different
> > hosts affecting at most one third of xfs filesystems per host. Also
> > the corruption looks always the same, namely the 33rd bit flipped
> > which also seems suspicious.
>
> Running a debug kernel with memory poisoning, KASAN, or something similar might
> help catch it if it's a stray memory write of some sort...

Thanks! BTW we've experienced this again on a FS at around 77% usage
and xfs_repair reports a flip in the 32nd bit (output below). We'll
enable memory poisoning on said host and see if other filesystems on
that host experience the same.
I see in the patch thread it has been mentioned this particular
condition will be checked and fixed/prevented in 4.19 though the root
cause isn't know (?)

Thanks again!
Filippo

# xfs_repair -n /dev/sdc1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
sb_fdblocks 4515987426, counted 221020130
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
