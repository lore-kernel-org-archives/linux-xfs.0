Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C09C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Feb 2022 22:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343869AbiBQWeq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Feb 2022 17:34:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbiBQWeq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Feb 2022 17:34:46 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0BDB01688D7
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 14:34:31 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9AC4252DAFF;
        Fri, 18 Feb 2022 09:34:26 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nKpM0-00DGj9-LT; Fri, 18 Feb 2022 09:34:24 +1100
Date:   Fri, 18 Feb 2022 09:34:24 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Manish Adkar <madkar@cs.stonybrook.edu>
Cc:     linux-xfs@vger.kernel.org, Erez Zadok <ezk@fsl.cs.sunysb.edu>,
        Yifei Liu <yifeliu@cs.stonybrook.edu>
Subject: Re: "No space left on device" issue
Message-ID: <20220217223424.GB59715@dread.disaster.area>
References: <CAOfCjwOsS+qLc2JsKSohSFc2Uif0tWKG-e3zHj=+jBAa9cKj5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOfCjwOsS+qLc2JsKSohSFc2Uif0tWKG-e3zHj=+jBAa9cKj5Q@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=620ecd74
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=IkcTkHD0fZMA:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=vRapeS5yxLzirv44MDwA:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 17, 2022 at 11:52:36AM -0800, Manish Adkar wrote:
> Hello,
> 
> We have a 16 MB XFS test partition with both plenty of free space

Single AG filesystems are not a supported configuration.

> and inodes (419 out of 424), but we’re still getting the error "No
> space left on device" when trying to create new files (After the
> free space reaches 184320 bytes).

And there's your problem. Not enough free space for a inode
allocation transaction to guarantee success. Transaction
reservations need to take worst case reservations to guarantee
forwards progress, so if there's not enough space for a worst case
space usage operation, it will fail up front.

> It can then only edit and append
> any existing files. (There are good reasons why we want to avoid a
> larger partition.)

XFS is pretty much the worst choice you could make for this
filesystem.

> In the below “freesp” output, we can see that there are plenty of
> contiguous blocks for inode cluster allocation and hence the disk
> is not fragmented.
> 
> # xfs_db -r -c "freesp -s -a 0" /dev/ram1
>    from      to extents  blocks    pct
>       1       1       4       4   1.44
>       4       7       1       6   2.16
>     256     511       1     268  96.40
> total free extents 6
> total free blocks 278
> average free extent size 46.3333
> 
> I came across an email thread from the linux-xfs mailing list that
> described a similar issue. It mentioned, inodes are allocated in
> contiguous chunks of 64. Here, in this case, 1 inode takes 512 bytes
> of space and 1 block has 4096 bytes capacity. Hence there would be 8
> inodes per block (4096 / 512). Now, to allocate 64 inodes, 8 blocks
> would be needed (64 / 8).

Plus whatever is needed to update the inobt, the finbot, the 2 free
space btrees, the rmap btree and filling the AGFL just to allocate
and track the new inode cluster. THen we also have to take into
account the directory update, too, whihc means we might need to
allocate blocks for the directory data segment, the dir hash btree,i
the dir free space index, all the free space btree, rmap and AGFL
updates that dir block allocation requires, etc.

When we add up the *worst case* space requirement for a file create
operation, it quickly balloons out to be much larger than just the
space an inode cluster consumes.

> Looking at the above “freesp” output, we
> can see there are 8 contiguous blocks available so the issue must not
> be a fragmentation one. But the thread suggests, the allocation has
> an alignment requirement, and here, the blocks must be aligned to an

Your understanding is flawed - large contiguous extents can be cut
down to smaller aligned allocations.

Regardless, there are very good reasons we do not support such tiny
XFS filesystems nor attmept to use every last block available in the
filesystem.

If you truly need a 16MB filesystem for your application, *do not
use XFS*. Use a filesystem that is optimised for tiny devices.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
