Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47362 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753253AbdCPPVz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Mar 2017 11:21:55 -0400
Subject: Re: [PATCH] xfs_repair: junk leaf attribute if count == 0
References: <725190d9-6db0-4f6c-628b-76f2dca3071f@redhat.com>
 <74482935.PWezjV9Qp4@libor-nb>
 <64592e33-6597-a4b4-3e1a-3ec41beeda8c@sandeen.net>
 <2727630.ZS8FFPfE3C@libor-nb>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b6492357-4bf3-c570-be33-90010e3b1967@sandeen.net>
Date: Thu, 16 Mar 2017 08:21:43 -0700
MIME-Version: 1.0
In-Reply-To: <2727630.ZS8FFPfE3C@libor-nb>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?UTF-8?B?TGlib3IgS2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 3/16/17 1:58 AM, Libor Klepáč wrote:
> Hi,
> On středa 15. března 2017 10:22:05 CET Eric Sandeen wrote:
>> On 3/15/17 5:07 AM, Libor Klepáč wrote:
>>> Hello,
>>
>> ...
>>
>>>> Unfortunately the read path is a bit less interesting.  We found something
>>>> on disk, but we're not sure how it got there.
>>>> If we could catch a write verifier failing that /might/ be a little more
>>>> useful.
>>>
>>> I'm prepared to run all affected hosts with error_level=11 , if it doesn't mean performance hit.
>>
>> It shouldn't.  It only changes logging behavior on error.  The printks to the
>> console probably take a bit of extra time but at that point you've already lost,
>> right?
> 
> Ok, thanks for clarification, I was wondering whether higher error_level isn't triggering some extra code paths during normal operation.
> I will leave it on 11 on all machines with problems.

Understood.  Yup, it's really not, it only changes reporting post-error.

> Btw. i naively created 
> /etc/sysctl.d/fs_xfs_error_level.conf
> with 
> fs.xfs.error_level=11
> inside.
> But it's not set after reboot. May it be because XFS module (not root filesystem) is loaded after sysctl is set?

Must be, the systctl file will not appear until xfs is loaded.
 
> Bellow is result of repair.
> I was expecting 
> bad attribute count 0 in attr block 0, inode 2152616264
> to be
> bad attribute count 0 in attr block 0x24e70268, inode 2152616264
> 
> Function process_leaf_attr_block should be called with non-zero da_bno in process_leaf_attr_level , right?
> But it's called with da_bno = 0 in process_longform_attr .

typedef __uint32_t      xfs_dablk_t;    /* dir/attr block number (in file) */

It's the relative block number in the attribute, i.e. block 0 (first block)

> Of course I don't know the code.
> 
> Libor
> 
> # xfs_repair  /dev/mapper/vgDisk2-lvData
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
> bad attribute count 0 in attr block 0, inode 2152616264
> problem with attribute contents in inode 2152616264
> clearing inode 2152616264 attributes
> correcting nblocks for inode 2152616264, was 1 - counted 0
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
> bad attribute format 1 in inode 2152616264, resetting value
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> Done
> 
> 
