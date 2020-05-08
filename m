Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF295C4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 15:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFDF621655
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 15:05:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BWqic2P+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgEHPFY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 11:05:24 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43823 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbgEHPFY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 11:05:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588950323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2z4WpSAAM0SVeRJea7jYFa7nWhcBVRwcOr+OMQ6+L/M=;
        b=BWqic2P+qsRrfPrtOWxNyYQYXMH6LkfwWHAZSPWgJGDEJdy6aly8t2Fvh/dwCGmNYL8WyH
        tKpfr0nQs702B4EReg+ASKqvFR0ZV8/oXt36EgpSN1GxW2h3TFwXp7M1vl6Yif0eSugSYm
        hRcHg78Koids8lJuVVU/QD/SrVlyiOE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-Np6elmJKNA6P5sP4mN3DRA-1; Fri, 08 May 2020 11:05:19 -0400
X-MC-Unique: Np6elmJKNA6P5sP4mN3DRA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 320C583DC11;
        Fri,  8 May 2020 15:05:18 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DA82F60F8A;
        Fri,  8 May 2020 15:05:17 +0000 (UTC)
Date:   Fri, 8 May 2020 11:05:16 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] xfs: handle unallocated inodes in
 xfs_inode_from_disk
Message-ID: <20200508150516.GE27577@bfoster>
References: <20200508063423.482370-1-hch@lst.de>
 <20200508063423.482370-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508063423.482370-5-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 08:34:15AM +0200, Christoph Hellwig wrote:
> Handle inodes with a 0 di_mode in xfs_inode_from_disk, instead of partially
> duplicating inode reading in xfs_iread.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_inode_buf.c | 50 ++++++++++-------------------------
>  1 file changed, 14 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index abdecc80579e3..686a026b5f6ed 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -192,6 +192,17 @@ xfs_inode_from_disk(
>  	ASSERT(ip->i_cowfp == NULL);
>  	ASSERT(ip->i_afp == NULL);
>  
> +	/*
> +	 * First get the permanent information that is needed to allocate an
> +	 * inode. If the inode is unused, mode is zero and we shouldn't mess
> +	 * with the unitialized part of it.
> +	 */
> +	to->di_flushiter = be16_to_cpu(from->di_flushiter);
> +	inode->i_generation = be32_to_cpu(from->di_gen);
> +	inode->i_mode = be16_to_cpu(from->di_mode);
> +	if (!inode->i_mode)
> +		return 0;
> +
>  	/*
>  	 * Convert v1 inodes immediately to v2 inode format as this is the
>  	 * minimum inode version format we support in the rest of the code.
> @@ -209,7 +220,6 @@ xfs_inode_from_disk(
>  	to->di_format = from->di_format;
>  	i_uid_write(inode, be32_to_cpu(from->di_uid));
>  	i_gid_write(inode, be32_to_cpu(from->di_gid));
> -	to->di_flushiter = be16_to_cpu(from->di_flushiter);
>  
>  	/*
>  	 * Time is signed, so need to convert to signed 32 bit before
> @@ -223,8 +233,6 @@ xfs_inode_from_disk(
>  	inode->i_mtime.tv_nsec = (int)be32_to_cpu(from->di_mtime.t_nsec);
>  	inode->i_ctime.tv_sec = (int)be32_to_cpu(from->di_ctime.t_sec);
>  	inode->i_ctime.tv_nsec = (int)be32_to_cpu(from->di_ctime.t_nsec);
> -	inode->i_generation = be32_to_cpu(from->di_gen);
> -	inode->i_mode = be16_to_cpu(from->di_mode);
>  
>  	to->di_size = be64_to_cpu(from->di_size);
>  	to->di_nblocks = be64_to_cpu(from->di_nblocks);
> @@ -653,39 +661,9 @@ xfs_iread(
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

