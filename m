Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 03 Oct 2008 01:32:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m938WuBn022468
	for <xfs@oss.sgi.com>; Fri, 3 Oct 2008 01:32:56 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B5289CB005
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2008 01:34:33 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id waqYGDB7keSE0QJ4 for <xfs@oss.sgi.com>; Fri, 03 Oct 2008 01:34:33 -0700 (PDT)
Date: Fri, 3 Oct 2008 18:34:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS on 2.6.25.17 kernel issue
Message-ID: <20081003083414.GM30001@disturbed>
References: <50ed5c760810022334j69befdb9pa0bf5ec29aad9126@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50ed5c760810022334j69befdb9pa0bf5ec29aad9126@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?utf-8?B?U8WCYXdvbWly?= Nowakowski <nailman23@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 03, 2008 at 08:34:52AM +0200, Sławomir Nowakowski wrote:
> Dear All,
> 
> We use kernel 2.6.25.17, Promise STEX 8650 RAID controller, LVM2 and
> snapshots. After about 3 hours of working (using SAMBA, RSYNC etc)
> dmesg showed following errors:
> 
> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1546 of file
> fs/xfs/xfs_alloc.c.  Caller 0xc024f387
> Pid: 16557, comm: smbd Not tainted 2.6.25.17-oe32-00000-g553425c #18
>  [<c024e15e>] xfs_free_ag_extent+0x2fe/0x670
>  [<c024f387>] xfs_free_extent+0xc7/0xf0
>  [<c024f387>] xfs_free_extent+0xc7/0xf0

Freespace btree corruption. Run xfs_repair on tへe filesystem
to fix the corruption, upgrade to 2.6.27 when it is released to
get all the fixes for known corruptions.

FWIW, I see iSCSI and DRBD are in use on your machine. In the past,
XFS on top of either of these two transports would randomly suffer
from freespace btree corruptions which were not reproducable on
normal local block devices. So the cause of your problem may not be
XFS at all....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
