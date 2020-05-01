Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4235BC4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 13:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 215802054F
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 13:54:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eYAMLvbi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbgEANyh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 09:54:37 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32721 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730649AbgEANfF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 09:35:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588340104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1NsuvHdlur3IwyxlJfAvEWkwBgeYZpc2HuRXsnkNBwc=;
        b=eYAMLvbiqm6x3tVo6q0ap+J4GlLkQQObKsTo+Lt577mjeWtbVsoGl/hvnYa2CddnrZcp/8
        LoyYy/cQhPlzPEDkv7IIGkhSXnCaFD9lXiHdfI4x/fJ89+QX2QI30x6Be3nv4BQcoIuwEs
        X+f7VrFfUKtftYQETELe6wW8N3wHP5E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-eEoLXxntPVah1ofi7DaaUw-1; Fri, 01 May 2020 09:34:48 -0400
X-MC-Unique: eEoLXxntPVah1ofi7DaaUw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C79F45F;
        Fri,  1 May 2020 13:34:47 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C00DB5EDF1;
        Fri,  1 May 2020 13:34:46 +0000 (UTC)
Date:   Fri, 1 May 2020 09:34:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] xfs: handle unallocated inodes in
 xfs_inode_from_disk
Message-ID: <20200501133444.GK40250@bfoster>
References: <20200501081424.2598914-1-hch@lst.de>
 <20200501081424.2598914-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501081424.2598914-5-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 10:14:16AM +0200, Christoph Hellwig wrote:
> Handle inodes with a 0 di_mode in xfs_inode_from_disk, instead of partially
> duplicating inode reading in xfs_iread.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 54 ++++++++++++-----------------------
>  1 file changed, 18 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 983beb680e81a..b136f29f7d9d3 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -198,6 +198,21 @@ xfs_inode_from_disk(
>  	ASSERT(ip->i_cowfp == NULL);
>  	ASSERT(ip->i_afp == NULL);
>  
> +	/*
> +	 * Get the truly permanent information first that is not overwritten by
> +	 * xfs_ialloc first.  This also includes i_mode so that a newly read
> +	 * in inode structure for an allocation is marked as already free.
> +	 */

The first sentence has a wording issue and the second is kind of
confusing. I think this can be simplified and condensed further (see the
diff below for example). Otherwise looks good.

Brian

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index b136f29f7d9d..ed02649138aa 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -199,17 +199,14 @@ xfs_inode_from_disk(
 	ASSERT(ip->i_afp == NULL);
 
 	/*
-	 * Get the truly permanent information first that is not overwritten by
-	 * xfs_ialloc first.  This also includes i_mode so that a newly read
-	 * in inode structure for an allocation is marked as already free.
+	 * First get the permanent information that is needed to allocate an
+	 * inode. If the inode is unused, mode is zero and we shouldn't mess
+	 * with the unitialized part of it.
 	 */
+	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 	inode->i_generation = be32_to_cpu(from->di_gen);
 	inode->i_mode = be16_to_cpu(from->di_mode);
-	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 
-	/*
-	 * Only copy the rest if the inode is actually allocated.
-	 */
 	if (!inode->i_mode)
 		return 0;
 

> +	inode->i_generation = be32_to_cpu(from->di_gen);
> +	inode->i_mode = be16_to_cpu(from->di_mode);
> +	to->di_flushiter = be16_to_cpu(from->di_flushiter);
> +
> +	/*
> +	 * Only copy the rest if the inode is actually allocated.
> +	 */
> +	if (!inode->i_mode)
> +		return 0;
> +
>  	/*
>  	 * Convert v1 inodes immediately to v2 inode format as this is the
>  	 * minimum inode version format we support in the rest of the code.
> @@ -215,7 +230,6 @@ xfs_inode_from_disk(
>  	to->di_format = from->di_format;
>  	i_uid_write(inode, be32_to_cpu(from->di_uid));
>  	i_gid_write(inode, be32_to_cpu(from->di_gid));
> -	to->di_flushiter = be16_to_cpu(from->di_flushiter);
>  
>  	/*
>  	 * Time is signed, so need to convert to signed 32 bit before
> @@ -229,8 +243,6 @@ xfs_inode_from_disk(
>  	inode->i_mtime.tv_nsec = (int)be32_to_cpu(from->di_mtime.t_nsec);
>  	inode->i_ctime.tv_sec = (int)be32_to_cpu(from->di_ctime.t_sec);
>  	inode->i_ctime.tv_nsec = (int)be32_to_cpu(from->di_ctime.t_nsec);
> -	inode->i_generation = be32_to_cpu(from->di_gen);
> -	inode->i_mode = be16_to_cpu(from->di_mode);
>  
>  	to->di_size = be64_to_cpu(from->di_size);
>  	to->di_nblocks = be64_to_cpu(from->di_nblocks);
> @@ -659,39 +671,9 @@ xfs_iread(
>  		goto out_brelse;
>  	}
>  
> -	/*
> -	 * If the on-disk inode is already linked to a directory
> -	 * entry, copy all of the inode into the in-core inode.
> -	 * xfs_iformat_fork() handles copying in the inode format
> -	 * specific information.
> -	 * Otherwise, just get the truly permanent information.
> -	 */
> -	if (dip->di_mode) {
> -		error = xfs_inode_from_disk(ip, dip);
> -		if (error)  {
> -#ifdef DEBUG
> -			xfs_alert(mp, "%s: xfs_iformat() returned error %d",
> -				__func__, error);
> -#endif /* DEBUG */
> -			goto out_brelse;
> -		}
> -	} else {
> -		/*
> -		 * Partial initialisation of the in-core inode. Just the bits
> -		 * that xfs_ialloc won't overwrite or relies on being correct.
> -		 */
> -		VFS_I(ip)->i_generation = be32_to_cpu(dip->di_gen);
> -		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
> -
> -		/*
> -		 * Make sure to pull in the mode here as well in
> -		 * case the inode is released without being used.
> -		 * This ensures that xfs_inactive() will see that
> -		 * the inode is already free and not try to mess
> -		 * with the uninitialized part of it.
> -		 */
> -		VFS_I(ip)->i_mode = 0;
> -	}
> +	error = xfs_inode_from_disk(ip, dip);
> +	if (error)
> +		goto out_brelse;
>  
>  	ip->i_delayed_blks = 0;
>  
> -- 
> 2.26.2
> 

