Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3CCEC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C4E220723
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:23:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LxKSy8xH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgEVMXj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 08:23:39 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30054 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728409AbgEVMXi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 08:23:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590150217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uz7UKvL9ObtWe7MCkLR8NXTUpYXeoyP9RGYGHZM3vJc=;
        b=LxKSy8xHz27st0mR1gaid2iuxem/+WY1xPthqx3bB6at3ewJmuta7PrYyLBXObEWKxFCKP
        xOOhaPZY7sUnwgTaUk6o3IeCM+k6nWF0wnlx6T0pH4MSXI2FABj1J/up9roqq1IS1eUCoQ
        sp7V1fEF2i3v3atszcDKCkhK8/C7W1I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-JVG0pWdOMl-EVIwWdMackA-1; Fri, 22 May 2020 08:23:33 -0400
X-MC-Unique: JVG0pWdOMl-EVIwWdMackA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97073107ACF5;
        Fri, 22 May 2020 12:23:32 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 41560100239B;
        Fri, 22 May 2020 12:23:32 +0000 (UTC)
Date:   Fri, 22 May 2020 08:23:30 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: fix inode ag walk predicate function return
 values
Message-ID: <20200522122330.GI50656@bfoster>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
 <159011605915.77079.7480200493011915081.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159011605915.77079.7480200493011915081.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 07:54:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> There are a number of predicate functions that help the incore inode
> walking code decide if we really want to apply the iteration function to
> the inode.  These are boolean decisions, so change the return types to
> boolean to match.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c |   39 ++++++++++++++++++++++-----------------
>  1 file changed, 22 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 3a45ec948c1a..31d85cc4bd8b 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -741,7 +741,12 @@ xfs_icache_inode_is_allocated(
>   */
>  #define XFS_LOOKUP_BATCH	32
>  
> -STATIC int
> +/*
> + * Decide if the given @ip is eligible to be a part of the inode walk, and
> + * grab it if so.  Returns true if it's ready to go or false if we should just
> + * ignore it.
> + */
> +STATIC bool
>  xfs_inode_ag_walk_grab(
>  	struct xfs_inode	*ip,
>  	int			flags)
> @@ -772,18 +777,18 @@ xfs_inode_ag_walk_grab(
>  
>  	/* nothing to sync during shutdown */
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
> -		return -EFSCORRUPTED;
> +		return false;
>  
>  	/* If we can't grab the inode, it must on it's way to reclaim. */
>  	if (!igrab(inode))
> -		return -ENOENT;
> +		return false;
>  
>  	/* inode is valid */
> -	return 0;
> +	return true;
>  
>  out_unlock_noent:
>  	spin_unlock(&ip->i_flags_lock);
> -	return -ENOENT;
> +	return false;
>  }
>  
>  STATIC int
> @@ -835,7 +840,7 @@ xfs_inode_ag_walk(
>  		for (i = 0; i < nr_found; i++) {
>  			struct xfs_inode *ip = batch[i];
>  
> -			if (done || xfs_inode_ag_walk_grab(ip, iter_flags))
> +			if (done || !xfs_inode_ag_walk_grab(ip, iter_flags))
>  				batch[i] = NULL;
>  
>  			/*
> @@ -1392,48 +1397,48 @@ xfs_reclaim_inodes_count(
>  	return reclaimable;
>  }
>  
> -STATIC int
> +STATIC bool
>  xfs_inode_match_id(
>  	struct xfs_inode	*ip,
>  	struct xfs_eofblocks	*eofb)
>  {
>  	if ((eofb->eof_flags & XFS_EOF_FLAGS_UID) &&
>  	    !uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
> -		return 0;
> +		return false;
>  
>  	if ((eofb->eof_flags & XFS_EOF_FLAGS_GID) &&
>  	    !gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
> -		return 0;
> +		return false;
>  
>  	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
>  	    ip->i_d.di_projid != eofb->eof_prid)
> -		return 0;
> +		return false;
>  
> -	return 1;
> +	return true;
>  }
>  
>  /*
>   * A union-based inode filtering algorithm. Process the inode if any of the
>   * criteria match. This is for global/internal scans only.
>   */
> -STATIC int
> +STATIC bool
>  xfs_inode_match_id_union(
>  	struct xfs_inode	*ip,
>  	struct xfs_eofblocks	*eofb)
>  {
>  	if ((eofb->eof_flags & XFS_EOF_FLAGS_UID) &&
>  	    uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
> -		return 1;
> +		return true;
>  
>  	if ((eofb->eof_flags & XFS_EOF_FLAGS_GID) &&
>  	    gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
> -		return 1;
> +		return true;
>  
>  	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
>  	    ip->i_d.di_projid == eofb->eof_prid)
> -		return 1;
> +		return true;
>  
> -	return 0;
> +	return false;
>  }
>  
>  /*
> @@ -1446,7 +1451,7 @@ xfs_inode_matches_eofb(
>  	struct xfs_inode	*ip,
>  	struct xfs_eofblocks	*eofb)
>  {
> -	int			match;
> +	bool			match;
>  
>  	if (!eofb)
>  		return true;
> 

