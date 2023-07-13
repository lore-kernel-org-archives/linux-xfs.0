Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78AAFC0015E
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 23:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbjGMXxS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 19:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbjGMXxR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 19:53:17 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7353C1FCD
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 16:53:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 28AFE1F8A8;
        Thu, 13 Jul 2023 23:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1689292395; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PTxnaUhbuIxv2k6Em8QmCO9TD7CphLohO4KxlusUB84=;
        b=WyrRUW59R7F98xObttXxAHJETKtvdjFlE+SZKaaVi6AJqhUU8K0YcgPI8nqa4DM722qBGI
        hsEOrYBUU1qabn3ku5CnJJVqAGMx1uEYEyWwHI/A1+EFvyK+bje7ailjU5hP3PeYtt/RLU
        k2M5UBRlGNpZFRI2fjCRl52+SqH8BtM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DCA0D133D6;
        Thu, 13 Jul 2023 23:53:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5oRnMmqOsGSzfQAAMHmgww
        (envelope-from <ailiop@suse.com>); Thu, 13 Jul 2023 23:53:14 +0000
Date:   Fri, 14 Jul 2023 01:53:14 +0200
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 5/8] xfs: XFS_ICHGTIME_CREATE is unused
Message-ID: <ZLCOaj3Xo0CWL3t2@technoir>
References: <20230713-mgctime-v5-0-9eb795d2ae37@kernel.org>
 <20230713-mgctime-v5-5-9eb795d2ae37@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230713-mgctime-v5-5-9eb795d2ae37@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 13, 2023 at 07:00:54PM -0400, Jeff Layton wrote:
> Nothing ever sets this flag, which makes sense since the create time is
> set at inode instantiation and is never changed. Remove it and the
> handling of it in xfs_trans_ichgtime.

It is currently used by xfs_repair during recreating the root inode and
the internal realtime inodes when needed (libxfs is exported to xfsprogs
so there are userspace consumers of this code).

> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_shared.h      | 2 --
>  fs/xfs/libxfs/xfs_trans_inode.c | 2 --
>  2 files changed, 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index c4381388c0c1..8989fff21723 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -126,8 +126,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>   */
>  #define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
>  #define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
> -#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
> -
>  
>  /*
>   * Symlink decoding/encoding functions
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index 6b2296ff248a..0c9df8df6d4a 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -68,8 +68,6 @@ xfs_trans_ichgtime(
>  		inode->i_mtime = tv;
>  	if (flags & XFS_ICHGTIME_CHG)
>  		inode_set_ctime_to_ts(inode, tv);
> -	if (flags & XFS_ICHGTIME_CREATE)
> -		ip->i_crtime = tv;
>  }
>  
>  /*
> 
> -- 
> 2.41.0
> 
> 
