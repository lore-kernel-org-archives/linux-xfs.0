Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44663C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 21:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2778560E54
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 21:12:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhKAVPW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Nov 2021 17:15:22 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:51757 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229501AbhKAVPW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Nov 2021 17:15:22 -0400
Received: from dread.disaster.area (pa49-180-20-157.pa.nsw.optusnet.com.au [49.180.20.157])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 7B7B7E0D645;
        Tue,  2 Nov 2021 08:12:45 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mhebk-003jjC-Ih; Tue, 02 Nov 2021 08:12:44 +1100
Date:   Tue, 2 Nov 2021 08:12:44 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     L A Walsh <xfs@tlinx.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: cause of xfsdump msg: root ino 192 differs from mount dir ino 256
Message-ID: <20211101211244.GC449541@dread.disaster.area>
References: <617721E0.5000009@tlinx.org>
 <20211026004814.GA5111@dread.disaster.area>
 <617F0A6D.6060506@tlinx.org>
 <61804CD4.8070103@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61804CD4.8070103@tlinx.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6180584e
        a=t5ERiztT/VoIE8AqcczM6g==:117 a=t5ERiztT/VoIE8AqcczM6g==:17
        a=kj9zAlcOel0A:10 a=vIxV3rELxO4A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=IliGbiGXCudp5Wcdu68A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 01, 2021 at 01:23:48PM -0700, L A Walsh wrote:
> 
> Addendum to the below: get_blocks showed no error messages.
> 
> 
> When I xfsdump my /home partition, I see the above diagnostic
> where it  lists "bind mount?" might be involved, but as far as
> I can see, that's not the case.

Can you attach the full output for the xfs_dump and xfsrestore
commands 
> 
> grepping for '/home\s' on output of mount:
> 
> /bin/mount|grep -P '/home\s'
> 
> shows only 1 entry -- nothing mounted on top of it:
> 
> /dev/mapper/Space-Home2 on /home type xfs (...)
> 
> I have bind-mounts of things like
> /home/opt  on /opt, but that shouldn't affect the root node,
> as far as I know.
> 
> So what would cause the root node to differ from the mountdir
> ino?
> 
> I try mounting the same filesystem someplace new:
> 
> # df .
> Filesystem        Size  Used Avail Use% Mounted on
> /dev/Space/Home2  2.0T  1.5T  569G  73% /home
> mkdir /home2
> Ishtar:home# mount /dev/Space/Home2 /home2
> Ishtar:home# ll -di /home /home2
> 256 drwxr-xr-x 40 4096 Nov  1 10:23 /home/
> 256 drwxr-xr-x 40 4096 Nov  1 10:23 /home2/
> 
> Shows 256 as the root inode.  So why is xfsdump claiming
> 192 is root inode?

IIRC, it's because xfsdump thinks that the first inode in the
filesystem is the root inode. Which is not always true - there are
corner cases to do with stripe alignment, btree roots relocating and
now sparse inodes that can result in new inodes being allocated at a
lower number than the root inode.

Indeed, the "bind mount?" message is an indication that xfsdump
found that the first inode was not the same as the root inode, and
so that's likely what has happened here.

Now that I think about this, ISTR the above "inodes before root
inode" situation being reported at some point in the past. Yeah:

https://lore.kernel.org/linux-xfs/f66f26f7-5e29-80fc-206c-9a53cf4640fa@redhat.com/

Eric, can you remember what came of those patches?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
