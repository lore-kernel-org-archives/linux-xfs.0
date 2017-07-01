Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23116 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752566AbdGACmU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jun 2017 22:42:20 -0400
Date: Fri, 30 Jun 2017 19:42:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Large file with a lot of extents: Memory allocation failure
Message-ID: <20170701024211.GQ5874@birch.djwong.org>
References: <0102015cfb8a5638-65ee1c03-edfb-4c2d-880b-691fac15f4e6-000000@eu-west-1.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0102015cfb8a5638-65ee1c03-edfb-4c2d-880b-691fac15f4e6-000000@eu-west-1.amazonses.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Martin Raiber <martin@urbackup.org>
Cc: linux-xfs@vger.kernel.org

On Sat, Jul 01, 2017 at 12:26:06AM +0000, Martin Raiber wrote:
> Hi,
> 
> this came up in the mailing list before and I think devs are aware of
> this issue. I just wanted to add a data point to this issue. Stack
> traces point to xfs_iext_realloc_indirect same as e.g.
> http://oss.sgi.com/archives/xfs/2015-07/msg00075.html .
> I created a large file (2TB) then proceeded to punch a lot of holes into
> it. After a while XFS hangs with e.g.
> 
>  > possible memory allocation deadlock size 131088 in kmem_realloc
> (mode:0x2400240)
> 
> Kernel version is mainline 4.9.22. Memory is horribly fragmented by
> other things (user space program that has fluctuating memory allocs,
> bcache, blk-mq, btrfs).

Known weakness of XFS, it will (I hope) get fixed in 4.14.

Thanks for adding to the list of people complaining about this, that
makes it easier to get it fixed. :)

> Where I guess this issue would be a possible blocker would be with my
> backup software UrBackup. With ZFS/btrfs it can save disk images in a
> raw file, then to create an incremental image backup it snapshots that
> and changes it to reflect the current state, including punching holes
> into the raw file where there is unused file system space.

Normally I'd advise setting a large extent size hint to try to cut down
on the fragmentation, but for a backup server that probably matters less
since you're holepunching anyway.

That said, I /also/ advocate for only punching if you can unmap
a large region of space, because the metadata overhead of punching
single blocks is rather high, as you see.

> With reflinks now in XFS, it would be possible to add XFS to the list of
> file systems able to perform this kind of image backup, only I fear it
> would then hit the memory allocation deadlock issue when free space
> changes a lot (which it often does) and the volume is larger on the client.

Yes, hence the regular and CoW extent size hints.

--D

> 
> 
> Regards,
> Martin Raiber
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
