Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:40646 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752103AbeF2RCS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Jun 2018 13:02:18 -0400
Received: by mail-qk0-f196.google.com with SMTP id b129-v6so5282171qke.7
        for <linux-xfs@vger.kernel.org>; Fri, 29 Jun 2018 10:02:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180604070239.GP10363@dastard>
References: <CANrHXgzLvaud2HEv3jAFGTfn5S80d7Rwj-ztJNWPT8eyFTohMg@mail.gmail.com>
 <20180603223435.GU10363@dastard> <20180603230341.GV10363@dastard>
 <20180603233114.GW10363@dastard> <CANrHXgwP5nOaG6nZwUs-bM_oJDNdUnXj=33xrrLJ-OvyCaz_EA@mail.gmail.com>
 <20180604042227.GO10363@dastard> <20180604070239.GP10363@dastard>
From: Wen Xu <xuwen.sjtu@gmail.com>
Date: Fri, 29 Jun 2018 13:02:17 -0400
Message-ID: <CANrHXgw7qRwg7N6NuD5wXq4Tn-6ieZHoNHaJ_7yjV1YcaiW+Jg@mail.gmail.com>
Subject: Re: NULL pointer dereference in xfs_bmap_extents_to_btree() when
 mounting and operating a crafted image
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hi Dave,

Is the patch for this issue available online?...I would like to have a look.

Thanks,
Wen

On Mon, Jun 4, 2018 at 3:02 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Jun 04, 2018 at 02:22:27PM +1000, Dave Chinner wrote:
>> On Sun, Jun 03, 2018 at 10:07:52PM -0400, Wen Xu wrote:
>> But, yeah, xfs_db tells me the by-size freespace btree is full of
>> crap, but the by-cnt tree is completely empty (i.e. corrupt) so
>> allocation should definitely be failing long before if gets anywhere
>> near returning an allocated block.
>
> Running a debug kernel assert fails in extent allocation setup for
> writeback, tripping over a bad extent alignment. The superblock
> has an invalid stripe alignment/width setup, which I've fixed.
> The extent size hint on the inode also has an invalid alignment (not
> a multiple of block size), which the inode verifiers will now catch,
> such as this:
>
> XFS (loop0): Metadata corruption detected at xfs_inode_validate_extsize+0xe5/0x110, inode 0x6d5 dinode
> XFS (loop0): Unmount and run xfs_repair
> XFS (loop0): First 128 bytes of corrupted metadata buffer:
> ....
>
> And the alignment assert has now gone away. Now there's an assert
> like this:
>
> XFS: Assertion failed: *len > 0, file: fs/xfs/xfs_extent_busy.c, line: 344
> Call Trace:
>  xfs_extent_busy_trim+0x243/0x250
>  xfs_alloc_ag_vextent_exact+0xc3/0x3b0
>  xfs_alloc_ag_vextent+0x1c9/0x330
>  xfs_alloc_vextent+0x56a/0x870
>  xfs_ialloc_ag_alloc+0x160/0x6f0
>  xfs_dialloc+0x116/0x270
>  xfs_ialloc+0x5c/0x5e0
>  xfs_dir_ialloc+0x6a/0x260
>  xfs_create+0x418/0x670
>  xfs_generic_create+0x1f6/0x2c0
>  vfs_create+0xf9/0x180
>  do_mknodat+0x1f9/0x210
>  do_syscall_64+0x5a/0x180
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> I'm pretty sure this is because there are bogus extent records in
> the free space tree - pretty sure we can catch them on lookup
> via a change to ->init_key_from_rec() to validate the record before
> letting them be used.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
