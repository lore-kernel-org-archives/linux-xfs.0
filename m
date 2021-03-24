Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7395C433C1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8FF661A1B
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237051AbhCXSED (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236414AbhCXSDX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:03:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4987161A1A;
        Wed, 24 Mar 2021 18:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616609003;
        bh=8XJqf0r0B4OZSAJDsPGUgmabA68WTpkEfYBO2KO8Fq8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nmAEbhOf3i+CfdmNkxvGxtdiqPiKp54D7I2JUDfXkd95mI1ea3iCEHcUkVFIakLtt
         AIDt//xNRXwJapDN/mlqpGGrlxqc6cGU9JgyrkXSSFCCrZjVbuwLtqsaWq6P3VS66a
         krEPXkU+YP7mzzNcDuqXZVDz9+ErHxnD+iCHPxAoOwLTIX36zeo3ltc3M5GZvhZzZ7
         9DhOn2I98lmukrSFlocUwuZCAduSwkI77hbMDjMAoW45LzeqfypXS29OVjiQ4c7E20
         08NJmr8aBmS/xkVwiFazXOtUP7PTg/XzckSnnKQfjyYtgQiICPYC5oAA2aMKgWnFbJ
         PQvnA6D4dA/Fg==
Date:   Wed, 24 Mar 2021 11:03:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: pass struct xfs_eofblocks to the inode scan
 callback
Message-ID: <20210324180322.GY22100@magnolia>
References: <20210324070307.908462-1-hch@lst.de>
 <20210324070307.908462-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324070307.908462-4-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 08:03:07AM +0100, Christoph Hellwig wrote:
> Pass the actual structure instead of a void pointer here now
> that none of the functions is used as a callback.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>  xfs_inode_free_cowblocks(

Assuming this ends up fitting in somewhere,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_icache.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 7fdf77df66269c..06286b5b613252 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -763,7 +763,7 @@ xfs_inode_walk_ag_grab(
>  static int
>  xfs_blockgc_scan_inode(
>  	struct xfs_inode	*ip,
> -	void			*args);
> +	struct xfs_eofblocks	*eofb);
>  
>  /*
>   * For a given per-AG structure @pag, grab, @execute, and rele all incore
> @@ -1228,10 +1228,9 @@ xfs_reclaim_worker(
>  STATIC int
>  xfs_inode_free_eofblocks(
>  	struct xfs_inode	*ip,
> -	void			*args,
> +	struct xfs_eofblocks	*eofb,
>  	unsigned int		*lockflags)
>  {
> -	struct xfs_eofblocks	*eofb = args;
>  	bool			wait;
>  
>  	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
> @@ -1436,10 +1435,9 @@ xfs_prep_free_cowblocks(
>  STATIC int
>  xfs_inode_free_cowblocks(
>  	struct xfs_inode	*ip,
> -	void			*args,
> +	struct xfs_eofblocks	*eofb,
>  	unsigned int		*lockflags)
>  {
> -	struct xfs_eofblocks	*eofb = args;
>  	bool			wait;
>  	int			ret = 0;
>  
> @@ -1534,16 +1532,16 @@ xfs_blockgc_start(
>  static int
>  xfs_blockgc_scan_inode(
>  	struct xfs_inode	*ip,
> -	void			*args)
> +	struct xfs_eofblocks	*eofb)
>  {
>  	unsigned int		lockflags = 0;
>  	int			error;
>  
> -	error = xfs_inode_free_eofblocks(ip, args, &lockflags);
> +	error = xfs_inode_free_eofblocks(ip, eofb, &lockflags);
>  	if (error)
>  		goto unlock;
>  
> -	error = xfs_inode_free_cowblocks(ip, args, &lockflags);
> +	error = xfs_inode_free_cowblocks(ip, eofb, &lockflags);
>  unlock:
>  	if (lockflags)
>  		xfs_iunlock(ip, lockflags);
> -- 
> 2.30.1
> 
