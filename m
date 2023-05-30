Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE141C7EE23
	for <linux-xfs@archiver.kernel.org>; Tue, 30 May 2023 13:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbjE3NFb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 May 2023 09:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbjE3NFa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 May 2023 09:05:30 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C786C7;
        Tue, 30 May 2023 06:05:25 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EFF0121AC5;
        Tue, 30 May 2023 13:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1685451923; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DcEAgA2JZ0KR1tmWedLbxw3Dp0QbOIFwZ3jOl5YXKUo=;
        b=NfNSBWZQOY4KtoSbpIVpCTMZU42CC4m/TZgNyIl6kFfWgBI3y7wMOevplKAirJVgoXQ8di
        h0LBKiTAr8syzdP/65WlTipk4gntlVUoRP6rkwnc6c/dr57yZ1XanODjyZ5jToGqxM3Qjz
        rD1oP2H+wxqZMCTHkFzph02hOYW94sA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1685451923;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DcEAgA2JZ0KR1tmWedLbxw3Dp0QbOIFwZ3jOl5YXKUo=;
        b=G6xoq38JZvxOJjrWTzcfa8QvJB5oF1lQJ7A3mgc2YAkQZoG1IsgQUG9e+Qbhp8CsfFtHTe
        uet/JQcl/ANu2ECQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DC7FA13478;
        Tue, 30 May 2023 13:05:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AJfQNZP0dWSgMwAAMHmgww
        (envelope-from <jack@suse.cz>); Tue, 30 May 2023 13:05:23 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 52E41A0754; Tue, 30 May 2023 15:05:23 +0200 (CEST)
Date:   Tue, 30 May 2023 15:05:23 +0200
From:   Jan Kara <jack@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/13] block: add a mark_dead holder operation
Message-ID: <20230530130523.5bl3cg3rfzia4vqm@quack3>
References: <20230518042323.663189-1-hch@lst.de>
 <20230518042323.663189-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518042323.663189-11-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu 18-05-23 06:23:19, Christoph Hellwig wrote:
> Add a mark_dead method to blk_holder_ops that is called from blk_mark_disk_dead
> to notify the holder that the block device it is using has been marked dead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Christian Brauner <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  block/genhd.c          | 24 ++++++++++++++++++++++++
>  include/linux/blkdev.h |  1 +
>  2 files changed, 25 insertions(+)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index 226ddb8329f751..42aebf0e1e2628 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -565,6 +565,28 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
>  }
>  EXPORT_SYMBOL(device_add_disk);
>  
> +static void blk_report_disk_dead(struct gendisk *disk)
> +{
> +	struct block_device *bdev;
> +	unsigned long idx;
> +
> +	rcu_read_lock();
> +	xa_for_each(&disk->part_tbl, idx, bdev) {
> +		if (!kobject_get_unless_zero(&bdev->bd_device.kobj))
> +			continue;
> +		rcu_read_unlock();
> +
> +		mutex_lock(&bdev->bd_holder_lock);
> +		if (bdev->bd_holder_ops && bdev->bd_holder_ops->mark_dead)
> +			bdev->bd_holder_ops->mark_dead(bdev);
> +		mutex_unlock(&bdev->bd_holder_lock);
> +
> +		put_device(&bdev->bd_device);
> +		rcu_read_lock();
> +	}
> +	rcu_read_unlock();
> +}
> +
>  /**
>   * blk_mark_disk_dead - mark a disk as dead
>   * @disk: disk to mark as dead
> @@ -592,6 +614,8 @@ void blk_mark_disk_dead(struct gendisk *disk)
>  	 * Prevent new I/O from crossing bio_queue_enter().
>  	 */
>  	blk_queue_start_drain(disk->queue);
> +
> +	blk_report_disk_dead(disk);
>  }
>  EXPORT_SYMBOL_GPL(blk_mark_disk_dead);
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index c94f3b63c86422..41f894f6355f96 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1466,6 +1466,7 @@ void blkdev_show(struct seq_file *seqf, off_t offset);
>  #endif
>  
>  struct blk_holder_ops {
> +	void (*mark_dead)(struct block_device *bdev);
>  };
>  
>  struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode, void *holder,
> -- 
> 2.39.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
