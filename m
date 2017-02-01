Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37764 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753005AbdBAWtv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Feb 2017 17:49:51 -0500
Subject: Re: [PATCH] xfs_repair: junk leaf attribute if count == 0
References: <725190d9-6db0-4f6c-628b-76f2dca3071f@redhat.com>
 <2626665.Hsx8YazNWY@libor-nb>
 <a6e607fc-9a54-a372-7ffa-bfdef58b3dc0@sandeen.net>
 <3965431.22NzgsWbJj@libor-nb>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8a918652-f073-6c6e-0926-5a3b3f02e691@sandeen.net>
Date: Wed, 1 Feb 2017 16:49:49 -0600
MIME-Version: 1.0
In-Reply-To: <3965431.22NzgsWbJj@libor-nb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?UTF-8?B?TGlib3IgS2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 2/1/17 6:48 AM, Libor Klepáč wrote:
> Hello,
> we tried also on vps1 reported here in bottom of email
> https://www.spinics.net/lists/linux-xfs/msg01728.html
> and vps3 from this email
> https://www.spinics.net/lists/linux-xfs/msg02672.html
> 
> Both came clean. Does it mean, that corruption was really only in memory 
> and did not made it to disks?

The point of the xfs_repair patch was to fix the problem
on-disk.

I'm not sure what steps your machines have been through, so I
can't really speak to their situation, but assuming the repairs
below were with the patch in place, it appears that they are
clean now.

-Eric

> Both machines are on 4.8.15 and xfsprogs 4.9.0
> 
> #root@vps3 # xfs_repair /dev/mapper/vg2Disk2-lvData
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
>         - agno = 12
>         - agno = 13
>         - agno = 14
>         - agno = 15
>         - agno = 16
>         - agno = 17
>         - agno = 18
>         - agno = 19
>         - agno = 20
>         - agno = 21
>         - agno = 22
>         - agno = 23
>         - agno = 24
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
>         - agno = 8
>         - agno = 9
>         - agno = 10
>         - agno = 11
>         - agno = 12
>         - agno = 13
>         - agno = 14
>         - agno = 15
>         - agno = 16
>         - agno = 17
>         - agno = 18
>         - agno = 19
>         - agno = 20
>         - agno = 21
>         - agno = 22
>         - agno = 23
>         - agno = 24
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> Note - quota info will be regenerated on next quota mount.
> done
> 
> ---------------------------------
> #root@vps1:~# xfs_repair /dev/mapper/vgVPS1Disk2-lvData
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> done
> -------------------------
> 
> Thanks, 
> Libor
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
