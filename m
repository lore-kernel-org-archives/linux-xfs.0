Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EBC8C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 05:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbiK2FX3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 00:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235505AbiK2FX0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 00:23:26 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89586172
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 21:23:25 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id 4so12370386pli.0
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 21:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IxIKWVEioCs+RHVXPU4kDjkDlAi81794JMXS5NNgfAw=;
        b=2T52pGRKgEtayT4yprZLraDcBMaAMxVkb2DwqDa9bAp88A83rFMh+jXIW93T1jWerz
         GlXnBY9ySl3V+A0gPRzGAWL8d6Rv7csQIpFTWu4kRJjsxRXouCR4XZy7j5/44q+vwrjB
         rBgvQXAii11F6g4rl+P9V2pkdXMToqqQgIGgnx6tzzzwBmL7DWFqW3Y2Ln6+/eLK868s
         G6g5mo4af3a0lieAGTx0oj5i/pkr3McU28nqUIPUrX0iVPNxOteDWkaSDT5V17+dqc2V
         +zgx4eka0DcMSDRjJd03DoRE8BbkzNvEkhpBY66zb+0ipOs4X1eYzIUEihMcjJqbZ9lQ
         SKng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IxIKWVEioCs+RHVXPU4kDjkDlAi81794JMXS5NNgfAw=;
        b=KrudKjT0p/TnbFpX4TryFeFtmrn39ZAQY6TMjRi79DpQYIxNhbYwyhgn7pdrgy+cPC
         k9GeN+6No7FG0t9Zl0nKK95sqssATYMlGliZ1ojLWIHPslAtqsznYnB5fb0lMqB9npqW
         ctWF5bAYhemoSw+vVb9N/lMWztLpOpsbwGLzWdSsprNi7UUHD2qqfafqNE2Vl6xXWLgi
         8BTHnBuh/lO3Ms7ub+RneHPCjAJxvKY3QDeHs6rV5PXais+QenZtPmQMYKhNQGmbKJez
         3XR1Siz/MgWMmc7fguEnUqoXGtowg9MgB669ZgzubZYH9C4LqCeRSNqsmqwFkyZXhDSx
         /Dig==
X-Gm-Message-State: ANoB5pkYb2gzWa8QOaLBq8XSL78QZYaDbBXWsuyYZpmUsVfPesUEICLn
        9Xp2enEZOPTDEnzXTuGJo5nVXV9FUGY2FQ==
X-Google-Smtp-Source: AA0mqf4pCwcBL3EjaF5Vljk/lj/SfK385iKV7tt4w/zgYAUE7BYu5UjCN4p9tXOp9UPhu86HehvBGg==
X-Received: by 2002:a17:90a:fc92:b0:219:1545:bc57 with SMTP id ci18-20020a17090afc9200b002191545bc57mr18476317pjb.133.1669699405314;
        Mon, 28 Nov 2022 21:23:25 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id y24-20020aa79438000000b0057293b17c8bsm8908073pfo.22.2022.11.28.21.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 21:23:24 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ozt5W-002JFj-7w; Tue, 29 Nov 2022 16:23:22 +1100
Date:   Tue, 29 Nov 2022 16:23:22 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: invalidate block device page cache during
 unmount
Message-ID: <20221129052322.GA3600936@dread.disaster.area>
References: <166930915825.2061853.2470510849612284907.stgit@magnolia>
 <166930916399.2061853.16165124824627761814.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166930916399.2061853.16165124824627761814.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 24, 2022 at 08:59:24AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Every now and then I see fstests failures on aarch64 (64k pages) that
> trigger on the following sequence:
> 
> mkfs.xfs $dev
> mount $dev $mnt
> touch $mnt/a
> umount $mnt
> xfs_db -c 'path /a' -c 'print' $dev
> 
> 99% of the time this succeeds, but every now and then xfs_db cannot find
> /a and fails.  This turns out to be a race involving udev/blkid, the
> page cache for the block device, and the xfs_db process.
> 
> udev is triggered whenever anyone closes a block device or unmounts it.
> The default udev rules invoke blkid to read the fs super and create
> symlinks to the bdev under /dev/disk.  For this, it uses buffered reads
> through the page cache.
> 
> xfs_db also uses buffered reads to examine metadata.  There is no
> coordination between xfs_db and udev, which means that they can run
> concurrently.  Note there is no coordination between the kernel and
> blkid either.
> 
> On a system with 64k pages, the page cache can cache the superblock and
> the root inode (and hence the root dir) with the same 64k page.  If
> udev spawns blkid after the mkfs and the system is busy enough that it
> is still running when xfs_db starts up, they'll both read from the same
> page in the pagecache.
> 
> The unmount writes updated inode metadata to disk directly.  The XFS
> buffer cache does not use the bdev pagecache, nor does it invalidate the
> pagecache on umount.  If the above scenario occurs, the pagecache no
> longer reflects what's on disk, xfs_db reads the stale metadata, and
> fails to find /a.  Most of the time this succeeds because closing a bdev
> invalidates the page cache, but when processes race, everyone loses.
> 
> Fix the problem by invalidating the bdev pagecache after flushing the
> bdev, so that xfs_db will see up to date metadata.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_buf.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index dde346450952..54c774af6e1c 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1945,6 +1945,7 @@ xfs_free_buftarg(
>  	list_lru_destroy(&btp->bt_lru);
>  
>  	blkdev_issue_flush(btp->bt_bdev);
> +	invalidate_bdev(btp->bt_bdev);
>  	fs_put_dax(btp->bt_daxdev, btp->bt_mount);
>  
>  	kmem_free(btp);

Looks OK and because XFS has multiple block devices we have to do
this invalidation for each bdev.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

However: this does not look to be an XFS specific problem.  If we
look at reconfigure_super(), when it completes a remount-ro
operation it calls invalidate_bdev() because:

       /*
         * Some filesystems modify their metadata via some other path than the
         * bdev buffer cache (eg. use a private mapping, or directories in
         * pagecache, etc). Also file data modifications go via their own
         * mappings. So If we try to mount readonly then copy the filesystem
         * from bdev, we could get stale data, so invalidate it to give a best
         * effort at coherency.
         */
        if (remount_ro && sb->s_bdev)
                invalidate_bdev(sb->s_bdev);

This is pretty much the same problem as this patch avoids for XFS in
the unmount path, yes? Shouldn't we be adding a call to
invalidate_bdev(sb->s_bdev) after the fs->kill_sb() call in
deactivate_locked_super() so that this problem goes away for all
filesystems?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
