Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C191FC04FE0
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Aug 2023 13:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbjHCN0M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Aug 2023 09:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbjHCN0H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2023 09:26:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B819A1704;
        Thu,  3 Aug 2023 06:25:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 677B61F749;
        Thu,  3 Aug 2023 13:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1691069150; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UDPtnYSNM4hfZ7dEGKrwZaeKN847Hc2R5Tx9DTRoPVo=;
        b=E7UZ1iiufRd6HQ+34iZcMYVFaaRe8SvsUrT0SQQvYAiV7H0ow4HMtpOSs0XFfDLsK6mofq
        m8IW+7BHidAqacwvDXpUtYQ/stwlGUq8qmHod1q3RRCoVv9jmLoSr02udJ08ZthhcQ8goZ
        YrmN6xC5D8mhbxcLHkRP7y9BvhATuBE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1691069150;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UDPtnYSNM4hfZ7dEGKrwZaeKN847Hc2R5Tx9DTRoPVo=;
        b=B5xphLHA7/FHGZBWy7OlEj6b7ZdzMhzyW2fcwI1Lqy4kV7PED0c6lIhQPKoGPMxCPtcEYu
        4Ivy0DuFbz5vzjCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 57A06134B0;
        Thu,  3 Aug 2023 13:25:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nLRfFd6qy2THbgAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 03 Aug 2023 13:25:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id DDE5DA076B; Thu,  3 Aug 2023 15:25:49 +0200 (CEST)
Date:   Thu, 3 Aug 2023 15:25:49 +0200
From:   Jan Kara <jack@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jan Kara <jack@suse.cz>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 09/12] ext4: drop s_umount over opening the log device
Message-ID: <20230803132549.s3rz4au5adagwdtf@quack3>
References: <20230802154131.2221419-1-hch@lst.de>
 <20230802154131.2221419-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230802154131.2221419-10-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed 02-08-23 17:41:28, Christoph Hellwig wrote:
> Just like get_tree_bdev needs to drop s_umount when opening the main
> device, we need to do the same for the ext4 log device to avoid a
> potential lock order reversal with s_unmount for the mark_dead path.
> 
> It might be preferable to just drop s_umount over ->fill_super entirely,
> but that will require a fairly massive audit first, so we'll do the easy
> version here first.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 193d665813b611..2ccb19d345c6dd 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5854,7 +5854,10 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
>  	if (WARN_ON_ONCE(!ext4_has_feature_journal(sb)))
>  		return NULL;
>  
> +	/* see get_tree_bdev why this is needed and safe */
> +	up_write(&sb->s_umount);
>  	bdev = ext4_blkdev_get(j_dev, sb);
> +	down_write(&sb->s_umount);
>  	if (bdev == NULL)
>  		return NULL;
>  
> -- 
> 2.39.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
