Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 762AAC7EE22
	for <linux-xfs@archiver.kernel.org>; Mon,  8 May 2023 13:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbjEHNBj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 May 2023 09:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234300AbjEHNBf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 May 2023 09:01:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FD139B83;
        Mon,  8 May 2023 06:01:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4715821FBB;
        Mon,  8 May 2023 13:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1683550891; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OzoUvL9aj4orkqwyXqIQaZaU3/l176K6F3PuwHlLL6Y=;
        b=ELdn+jd+3/dtgSrcrL6u1jo0dQrJtA0//tU8Z/zhUIIesfMARy1JYYwXtKZyVt/XzlGLV0
        JBkS8/0/F+zyQNhheRiHIWzM5IDt7M1g0lsbfqzHa9Gso60/uwVtjmV3urG1GOzLoEu86c
        z2E6Z6NbWwBu8FmivoCxBmr0XMpH2MY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1683550891;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OzoUvL9aj4orkqwyXqIQaZaU3/l176K6F3PuwHlLL6Y=;
        b=vCK6TAG4k4/MK2pTzxkjqMy+EThHuJwxTXptnYhjm90o+eapYRjs0hKAmD+z3tXszzwli9
        IzvF+/Jua5PcwkCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 06C2C13A5F;
        Mon,  8 May 2023 13:01:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Jag8AKvyWGSqXQAAMHmgww
        (envelope-from <jack@suse.cz>); Mon, 08 May 2023 13:01:31 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id B0054A0764; Sun,  7 May 2023 21:20:50 +0200 (CEST)
Date:   Sun, 7 May 2023 21:20:50 +0200
From:   Jan Kara <jack@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] fs: add a method to shut down the file system
Message-ID: <20230507192050.h7amddtghearusxi@quack3>
References: <20230505175132.2236632-1-hch@lst.de>
 <20230505175132.2236632-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505175132.2236632-8-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri 05-05-23 13:51:30, Christoph Hellwig wrote:
> Add a new ->shutdown super operation that can be used to tell the file
> system to shut down, and call it from newly created holder ops when the
> block device under a file system shuts down.
> 
> This only covers the main block device for "simple" file systems using
> get_tree_bdev / mount_bdev.  File systems their own get_tree method
> or opening additional devices will need to set up their own
> blk_holder_ops.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/super.c         | 21 +++++++++++++++++++--
>  include/linux/fs.h |  1 +
>  2 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 012ce140080375..f127589700ab25 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1206,6 +1206,22 @@ int get_tree_keyed(struct fs_context *fc,
>  EXPORT_SYMBOL(get_tree_keyed);
>  
>  #ifdef CONFIG_BLOCK
> +static void fs_mark_dead(struct block_device *bdev)
> +{
> +	struct super_block *sb;
> +
> +	sb = get_super(bdev);
> +	if (!sb)
> +		return;
> +
> +	if (sb->s_op->shutdown)
> +		sb->s_op->shutdown(sb);
> +	drop_super(sb);
> +}
> +
> +static const struct blk_holder_ops fs_holder_ops = {
> +	.mark_dead		= fs_mark_dead,
> +};
>  
>  static int set_bdev_super(struct super_block *s, void *data)
>  {
> @@ -1248,7 +1264,8 @@ int get_tree_bdev(struct fs_context *fc,
>  	if (!fc->source)
>  		return invalf(fc, "No source specified");
>  
> -	bdev = blkdev_get_by_path(fc->source, mode, fc->fs_type, NULL);
> +	bdev = blkdev_get_by_path(fc->source, mode, fc->fs_type,
> +				  &fs_holder_ops);
>  	if (IS_ERR(bdev)) {
>  		errorf(fc, "%s: Can't open blockdev", fc->source);
>  		return PTR_ERR(bdev);
> @@ -1333,7 +1350,7 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
>  	if (!(flags & SB_RDONLY))
>  		mode |= FMODE_WRITE;
>  
> -	bdev = blkdev_get_by_path(dev_name, mode, fs_type, NULL);
> +	bdev = blkdev_get_by_path(dev_name, mode, fs_type, &fs_holder_ops);
>  	if (IS_ERR(bdev))
>  		return ERR_CAST(bdev);
>  
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 21a98168085641..cf3042641b9b30 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1932,6 +1932,7 @@ struct super_operations {
>  				  struct shrink_control *);
>  	long (*free_cached_objects)(struct super_block *,
>  				    struct shrink_control *);
> +	void (*shutdown)(struct super_block *sb);
>  };
>  
>  /*
> -- 
> 2.39.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
