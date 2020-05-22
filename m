Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74CD5C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:23:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42C1620759
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:23:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nnjey3eh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgEVMXb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 08:23:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53499 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728409AbgEVMXb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 08:23:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590150210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wHDCYAnTSeroWYmMA5aIedwoTCgrC12JdKX0jxqXk4c=;
        b=Nnjey3ehHw3wSAhGGrDMGXFjZcvx3OQe3MATo+cdXx12JPNjYOKAV03km/EyeCLXWzJ5Nd
        y39zCU70kzYpPwQdWTO2XBiFwBBNZzhLfoXjYtT71t4odRG2rP6VRvQxUl7icXWVWtNk+j
        ulEc2/TVpcRwbD/55djzK0fAQSt6sBY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-C0r9mtLeNKanX-aQAlWvlA-1; Fri, 22 May 2020 08:23:26 -0400
X-MC-Unique: C0r9mtLeNKanX-aQAlWvlA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A83019057A0;
        Fri, 22 May 2020 12:23:25 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B6F299ED;
        Fri, 22 May 2020 12:23:25 +0000 (UTC)
Date:   Fri, 22 May 2020 08:23:23 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 07/12] xfs: refactor eofb matching into a single helper
Message-ID: <20200522122323.GH50656@bfoster>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
 <159011605255.77079.12439333473840564314.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159011605255.77079.12439333473840564314.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:54:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the two eofb-matching logics into a single helper so that we
> don't repeat ourselves.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c |   62 ++++++++++++++++++++++++++++-----------------------
>  1 file changed, 34 insertions(+), 28 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 11a5e6897639..3a45ec948c1a 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1436,6 +1436,36 @@ xfs_inode_match_id_union(
>  	return 0;
>  }
>  
> +/*
> + * Is this inode @ip eligible for eof/cow block reclamation, given some
> + * filtering parameters @eofb?  The inode is eligible if @eofb is null or
> + * if the predicate functions match.
> + */
> +static bool
> +xfs_inode_matches_eofb(
> +	struct xfs_inode	*ip,
> +	struct xfs_eofblocks	*eofb)
> +{
> +	int			match;
> +
> +	if (!eofb)
> +		return true;
> +
> +	if (eofb->eof_flags & XFS_EOF_FLAGS_UNION)
> +		match = xfs_inode_match_id_union(ip, eofb);
> +	else
> +		match = xfs_inode_match_id(ip, eofb);
> +	if (!match)
> +		return false;
> +
> +	/* skip the inode if the file size is too small */
> +	if ((eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE) &&
> +	    XFS_ISIZE(ip) < eofb->eof_min_file_size)
> +		return false;
> +
> +	return true;
> +}
> +
>  STATIC int
>  xfs_inode_free_eofblocks(
>  	struct xfs_inode	*ip,
> @@ -1443,7 +1473,6 @@ xfs_inode_free_eofblocks(
>  {
>  	struct xfs_eofblocks	*eofb = args;
>  	bool			wait;
> -	int			match;
>  	int			ret;
>  
>  	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
> @@ -1462,19 +1491,8 @@ xfs_inode_free_eofblocks(
>  	if (!wait && mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
>  		return 0;
>  
> -	if (eofb) {
> -		if (eofb->eof_flags & XFS_EOF_FLAGS_UNION)
> -			match = xfs_inode_match_id_union(ip, eofb);
> -		else
> -			match = xfs_inode_match_id(ip, eofb);
> -		if (!match)
> -			return 0;
> -
> -		/* skip the inode if the file size is too small */
> -		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
> -		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
> -			return 0;
> -	}
> +	if (!xfs_inode_matches_eofb(ip, eofb))
> +		return 0;
>  
>  	/*
>  	 * If the caller is waiting, return -EAGAIN to keep the background
> @@ -1717,25 +1735,13 @@ xfs_inode_free_cowblocks(
>  	void			*args)
>  {
>  	struct xfs_eofblocks	*eofb = args;
> -	int			match;
>  	int			ret = 0;
>  
>  	if (!xfs_prep_free_cowblocks(ip))
>  		return 0;
>  
> -	if (eofb) {
> -		if (eofb->eof_flags & XFS_EOF_FLAGS_UNION)
> -			match = xfs_inode_match_id_union(ip, eofb);
> -		else
> -			match = xfs_inode_match_id(ip, eofb);
> -		if (!match)
> -			return 0;
> -
> -		/* skip the inode if the file size is too small */
> -		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
> -		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
> -			return 0;
> -	}
> +	if (!xfs_inode_matches_eofb(ip, eofb))
> +		return 0;
>  
>  	/* Free the CoW blocks */
>  	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> 

