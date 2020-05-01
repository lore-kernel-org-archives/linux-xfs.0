Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D427CC47258
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 13:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B26AA2051A
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 13:54:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PuEUtPLT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730639AbgEANfA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 09:35:00 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54782 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730632AbgEANe7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 09:34:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588340097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fcuspp5wu6MRLdvLZPHkT1Qppe5I6RrBGoBcfageTVo=;
        b=PuEUtPLTxCTA/+VGG/+lvXgE5WzN3I/5jZfUMA7+tMG4EWpJ71/iF5Annqjs7oBr3XCNil
        54lD4VKpFLsoN5EiIch1TlpFJ8uNA+l6nIS5YSNEDeMcptumOtbNYMJobjCSH3+WjEviZI
        erzcPpY1IfsSTxFS79jVy0zOvdnfWMo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-91Cy2MJaP3mG0c28gykq2A-1; Fri, 01 May 2020 09:34:56 -0400
X-MC-Unique: 91Cy2MJaP3mG0c28gykq2A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3212845F;
        Fri,  1 May 2020 13:34:55 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B95825EE11;
        Fri,  1 May 2020 13:34:54 +0000 (UTC)
Date:   Fri, 1 May 2020 09:34:52 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: call xfs_dinode_verify from
 xfs_inode_from_disk
Message-ID: <20200501133452.GL40250@bfoster>
References: <20200501081424.2598914-1-hch@lst.de>
 <20200501081424.2598914-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501081424.2598914-6-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 10:14:17AM +0200, Christoph Hellwig wrote:
> Keep the code dealing with the dinode together, and also ensure we verify
> the dinode in the onwer change log recovery case as well.

		    owner

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  .../xfs-self-describing-metadata.txt           | 10 +++++-----
>  fs/xfs/libxfs/xfs_inode_buf.c                  | 18 ++++++++----------
>  2 files changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/filesystems/xfs-self-describing-metadata.txt b/Documentation/filesystems/xfs-self-describing-metadata.txt
> index 8db0121d0980c..e912699d74301 100644
> --- a/Documentation/filesystems/xfs-self-describing-metadata.txt
> +++ b/Documentation/filesystems/xfs-self-describing-metadata.txt
> @@ -337,11 +337,11 @@ buffer.
>  
>  The structure of the verifiers and the identifiers checks is very similar to the
>  buffer code described above. The only difference is where they are called. For
> -example, inode read verification is done in xfs_iread() when the inode is first
> -read out of the buffer and the struct xfs_inode is instantiated. The inode is
> -already extensively verified during writeback in xfs_iflush_int, so the only
> -addition here is to add the LSN and CRC to the inode as it is copied back into
> -the buffer.
> +example, inode read verification is done in xfs_inode_from_disk() when the inode
> +is first read out of the buffer and the struct xfs_inode is instantiated. The
> +inode is already extensively verified during writeback in xfs_iflush_int, so the
> +only addition here is to add the LSN and CRC to the inode as it is copied back
> +into the buffer.
>  
>  XXX: inode unlinked list modification doesn't recalculate the inode CRC! None of
>  the unlinked list modifications check or update CRCs, neither during unlink nor
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index b136f29f7d9d3..a00001a2336ef 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -194,10 +194,18 @@ xfs_inode_from_disk(
>  	struct xfs_icdinode	*to = &ip->i_d;
>  	struct inode		*inode = VFS_I(ip);
>  	int			error;
> +	xfs_failaddr_t		fa;
>  
>  	ASSERT(ip->i_cowfp == NULL);
>  	ASSERT(ip->i_afp == NULL);
>  
> +	fa = xfs_dinode_verify(ip->i_mount, ip->i_ino, from);
> +	if (fa) {
> +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "dinode", from,
> +				sizeof(*from), fa);
> +		return -EFSCORRUPTED;
> +	}
> +
>  	/*
>  	 * Get the truly permanent information first that is not overwritten by
>  	 * xfs_ialloc first.  This also includes i_mode so that a newly read
> @@ -637,7 +645,6 @@ xfs_iread(
>  {
>  	xfs_buf_t	*bp;
>  	xfs_dinode_t	*dip;
> -	xfs_failaddr_t	fa;
>  	int		error;
>  
>  	/*
> @@ -662,15 +669,6 @@ xfs_iread(
>  	if (error)
>  		return error;
>  
> -	/* even unallocated inodes are verified */
> -	fa = xfs_dinode_verify(mp, ip->i_ino, dip);
> -	if (fa) {
> -		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "dinode", dip,
> -				sizeof(*dip), fa);
> -		error = -EFSCORRUPTED;
> -		goto out_brelse;
> -	}
> -
>  	error = xfs_inode_from_disk(ip, dip);
>  	if (error)
>  		goto out_brelse;
> -- 
> 2.26.2
> 

