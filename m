Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D637C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 05:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235610AbiK2F7b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 00:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235647AbiK2F7a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 00:59:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DC85130F
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 21:59:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 981666157E
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 05:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F9BC433C1;
        Tue, 29 Nov 2022 05:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669701568;
        bh=6FxSIMcABMgtj8WfQBE0JLFTs5VVtBUNesoQrMSHZHk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pC2OQY2vmLLXnSMA84JnOvE/EK1Kk3HcUBdanbXZzHkGl5FokWvpJa/Ez8pEXNhyC
         btpGZm1TDqTFjwiUPEfdWT0qYLj+WiXjDTMIBvD/L2vAcVQk4p8xzZCEDpnWWiOQK3
         Iw66bQLlJqMr+6fXcrXoutfHUzNIvk01qEu28V0DxOyFkPXOebffFCr5JdBsG1aTL5
         ev97bwivi30tHFQ5AL1ktc58/t+21GNd9KPEDIaodMtZ1iNaDyO6O2xj3VCYurSF11
         bMqCB4iLOmpLJ6sshlX/YeKAtJ3soWgPpLAdcDwOyOQ3EFgrV1JsfcpkD8yRRfu+7O
         fDVZfPSksmvcg==
Date:   Mon, 28 Nov 2022 21:59:27 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: invalidate block device page cache during
 unmount
Message-ID: <Y4Wfvzqd7YPkxb31@magnolia>
References: <166930915825.2061853.2470510849612284907.stgit@magnolia>
 <166930916399.2061853.16165124824627761814.stgit@magnolia>
 <20221129052322.GA3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129052322.GA3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 29, 2022 at 04:23:22PM +1100, Dave Chinner wrote:
> On Thu, Nov 24, 2022 at 08:59:24AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Every now and then I see fstests failures on aarch64 (64k pages) that
> > trigger on the following sequence:
> > 
> > mkfs.xfs $dev
> > mount $dev $mnt
> > touch $mnt/a
> > umount $mnt
> > xfs_db -c 'path /a' -c 'print' $dev
> > 
> > 99% of the time this succeeds, but every now and then xfs_db cannot find
> > /a and fails.  This turns out to be a race involving udev/blkid, the
> > page cache for the block device, and the xfs_db process.
> > 
> > udev is triggered whenever anyone closes a block device or unmounts it.
> > The default udev rules invoke blkid to read the fs super and create
> > symlinks to the bdev under /dev/disk.  For this, it uses buffered reads
> > through the page cache.
> > 
> > xfs_db also uses buffered reads to examine metadata.  There is no
> > coordination between xfs_db and udev, which means that they can run
> > concurrently.  Note there is no coordination between the kernel and
> > blkid either.
> > 
> > On a system with 64k pages, the page cache can cache the superblock and
> > the root inode (and hence the root dir) with the same 64k page.  If
> > udev spawns blkid after the mkfs and the system is busy enough that it
> > is still running when xfs_db starts up, they'll both read from the same
> > page in the pagecache.
> > 
> > The unmount writes updated inode metadata to disk directly.  The XFS
> > buffer cache does not use the bdev pagecache, nor does it invalidate the
> > pagecache on umount.  If the above scenario occurs, the pagecache no
> > longer reflects what's on disk, xfs_db reads the stale metadata, and
> > fails to find /a.  Most of the time this succeeds because closing a bdev
> > invalidates the page cache, but when processes race, everyone loses.
> > 
> > Fix the problem by invalidating the bdev pagecache after flushing the
> > bdev, so that xfs_db will see up to date metadata.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_buf.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index dde346450952..54c774af6e1c 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -1945,6 +1945,7 @@ xfs_free_buftarg(
> >  	list_lru_destroy(&btp->bt_lru);
> >  
> >  	blkdev_issue_flush(btp->bt_bdev);
> > +	invalidate_bdev(btp->bt_bdev);
> >  	fs_put_dax(btp->bt_daxdev, btp->bt_mount);
> >  
> >  	kmem_free(btp);
> 
> Looks OK and because XFS has multiple block devices we have to do
> this invalidation for each bdev.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> However: this does not look to be an XFS specific problem.  If we
> look at reconfigure_super(), when it completes a remount-ro
> operation it calls invalidate_bdev() because:
> 
>        /*
>          * Some filesystems modify their metadata via some other path than the
>          * bdev buffer cache (eg. use a private mapping, or directories in
>          * pagecache, etc). Also file data modifications go via their own
>          * mappings. So If we try to mount readonly then copy the filesystem
>          * from bdev, we could get stale data, so invalidate it to give a best
>          * effort at coherency.
>          */
>         if (remount_ro && sb->s_bdev)
>                 invalidate_bdev(sb->s_bdev);
> 
> This is pretty much the same problem as this patch avoids for XFS in
> the unmount path, yes? Shouldn't we be adding a call to
> invalidate_bdev(sb->s_bdev) after the fs->kill_sb() call in
> deactivate_locked_super() so that this problem goes away for all
> filesystems?

I'm not sure this applies to everyone -- AFAICT, ext2/4 still write
everything through the bdev page cache, which means that the
invalidation isn't necessary there, except for perhaps the MMP block.

Years ago I remember Andreas rolling his eyes at how the kernel would
usually drop the whole pagecache between umount and e2fsck starting.
But I guess that's *usually* what we get anyways, so adding an
invalidation everywhere for the long tail of simple bdev filesystems
wouldn't hurt much.  Hmm.  Ok, I'm more convinced now.

I'll ask on the ext4 concall this week, and in the meantime try to
figure out what's the deal with btrfs.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
