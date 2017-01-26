Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48267 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752453AbdAZCd4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2017 21:33:56 -0500
Date: Wed, 25 Jan 2017 18:33:52 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_repair: Fix uninit var in process_leaf_attr_level
Message-ID: <20170126023352.GB2584@birch.djwong.org>
References: <fe6cd162-4f2a-d470-f8ea-8a028a649212@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe6cd162-4f2a-d470-f8ea-8a028a649212@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Jan 25, 2017 at 08:30:05PM -0600, Eric Sandeen wrote:
> My unreviewed maintainer adjustment on the way in gets a
> brown paper bag.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 158e31a..9ec2231 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -753,6 +753,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
>  	struct xfs_attr3_icleaf_hdr leafhdr;
>  
>  	da_bno = da_cursor->level[0].bno;
> +	ino = da_cursor->ino;
>  	/*
>  	 * 0 is the root block and no block
>  	 * pointer can point to the root block of the btree
> @@ -764,7 +765,6 @@ process_leaf_attr_level(xfs_mount_t	*mp,
>  		goto error_out;
>  	}
>  
> -	ino = da_cursor->ino;
>  	prev_bno = 0;
>  
>  	do {
> 
