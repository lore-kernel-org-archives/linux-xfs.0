Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 566EAC7EE2A
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Jun 2023 10:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbjFAKPT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Jun 2023 06:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbjFAKOf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 06:14:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44FCA13D;
        Thu,  1 Jun 2023 03:12:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 98FFF1F86C;
        Thu,  1 Jun 2023 10:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1685614319; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DLLP8gyADZVDDuV0X+GkKR6n6EEpbisuDZrItmpzprY=;
        b=ded42nRa0d7cCzRFn6+K8mT9HL9nzejKGMHs80uS/p4LFDdEQHSZ8loqe2y+IGAD9NjcL5
        wz3BVw5AByxghNIza58T20WsKUwbhyWhgfrKyVcik3voE6DHEAkOEk0IPmhw/EEaOnTiKB
        FIkiqxcdpfW4SKVYc5JDmjpJiLAd/m8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1685614319;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DLLP8gyADZVDDuV0X+GkKR6n6EEpbisuDZrItmpzprY=;
        b=khv8NCfHxEJa/e10c47mU0aDKJlTNkznZuJV3arX0UxOa+GEHynxt96d6QJRkFoyAx5A9+
        WXD2K06SvOgl95AQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8A3F2139B7;
        Thu,  1 Jun 2023 10:11:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2wS9Ie9ueGQTPgAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 01 Jun 2023 10:11:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 0C72BA0754; Thu,  1 Jun 2023 12:11:59 +0200 (CEST)
Date:   Thu, 1 Jun 2023 12:11:59 +0200
From:   Jan Kara <jack@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/16] ext4: wire up the ->mark_dead holder operation for
 log devices
Message-ID: <20230601101159.no5gta5kpztgcdyb@quack3>
References: <20230601094459.1350643-1-hch@lst.de>
 <20230601094459.1350643-17-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601094459.1350643-17-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu 01-06-23 11:44:59, Christoph Hellwig wrote:
> Implement a set of holder_ops that shut down the file system when the
> block device used as log device is removed undeneath the file system.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index a177a16c4d2fe5..9070ea9154d727 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1096,6 +1096,15 @@ void ext4_update_dynamic_rev(struct super_block *sb)
>  	 */
>  }
>  
> +static void ext4_bdev_mark_dead(struct block_device *bdev)
> +{
> +	ext4_force_shutdown(bdev->bd_holder, EXT4_GOING_FLAGS_NOLOGFLUSH);
> +}
> +
> +static const struct blk_holder_ops ext4_holder_ops = {
> +	.mark_dead		= ext4_bdev_mark_dead,
> +};
> +
>  /*
>   * Open the external journal device
>   */
> @@ -1104,7 +1113,7 @@ static struct block_device *ext4_blkdev_get(dev_t dev, struct super_block *sb)
>  	struct block_device *bdev;
>  
>  	bdev = blkdev_get_by_dev(dev, FMODE_READ|FMODE_WRITE|FMODE_EXCL, sb,
> -				 NULL);
> +				 &ext4_holder_ops);
>  	if (IS_ERR(bdev))
>  		goto fail;
>  	return bdev;
> -- 
> 2.39.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
