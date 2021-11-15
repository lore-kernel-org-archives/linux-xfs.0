Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE1EC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 14:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50A5A61B97
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 14:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhKOO3Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Nov 2021 09:29:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28427 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236504AbhKOO3E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Nov 2021 09:29:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636986368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+ALcr2hBv0/5mr/xvaYe4i1pUe6U5ifZBmZWXOZTMS8=;
        b=QUC2pUmslTqFEr8m4Ot5cTxIBPIoQi+8NIE44OtH7pt5D2X0hgtr3yxt7y9qkwvSusTWQ7
        5nUYowamTDuh8VaLlkHqevB65nbvsGE0/Kbtg19OMOrOyqNA16HztduMAgcGRkMRt2Gmj0
        nnGaGgEmNjgBPPAAriGi6IZpbrX2RMc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-THHlEnq3MkyYAb5tkepP8w-1; Mon, 15 Nov 2021 09:26:07 -0500
X-MC-Unique: THHlEnq3MkyYAb5tkepP8w-1
Received: by mail-qv1-f71.google.com with SMTP id n4-20020a0ce944000000b003bdcabf4cdfso15946319qvo.16
        for <linux-xfs@vger.kernel.org>; Mon, 15 Nov 2021 06:26:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+ALcr2hBv0/5mr/xvaYe4i1pUe6U5ifZBmZWXOZTMS8=;
        b=PgM6SVCP7j2scXKZEuDOC1FiO/CPlP5V/ZbIVBiu67EknBmgqKwOLmSMC+2QTuqm3b
         HYIvXwa27ao43vIjLaOxfEYu4onsATsTTIj+vbU0i9e4lZyCq5jrp1YbEMrJikngifVj
         iJaT4x7gSgpj1e6usUlR4DiX4NLOoKs5SAi448G70mFanZqAauG55zy5RSsLZFre/M7e
         aJNwEPXGXr8gcs6Xvjf4WOacc6gRxJUVeJFQ1OyXBqYT22zfCbF/0mrOUzbDfiWbsJ7z
         hRrmCvzhZWPwgw4MnwP6iRIRNBO+zvWrOh3h7GDpoLQM6Kr7d6UQcJ5wy+431pUfSdSF
         fCwA==
X-Gm-Message-State: AOAM532q97fC7jWrnoB6JZq/AfJLzzbcC0bECigpqBNfTxma9Bpgd7ir
        G8u+kt2f7bF/FiF8JjXwvRw2U2UUM+CXxpEaidFXNcayrUz1DO15uKbbUD228s4FaKuQHAzQUiC
        yZXfYaLUVqMgvExbmgmjy
X-Received: by 2002:a05:620a:24c9:: with SMTP id m9mr29301136qkn.317.1636986367048;
        Mon, 15 Nov 2021 06:26:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzIieOCH8XBBKkFRzB2kiCVp/b3IRXdIQbasdTR/AWtsNQYCewWUeF/fukzWjKRHkfXJea1AQ==
X-Received: by 2002:a05:620a:24c9:: with SMTP id m9mr29301116qkn.317.1636986366849;
        Mon, 15 Nov 2021 06:26:06 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id bj1sm6929902qkb.75.2021.11.15.06.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 06:26:06 -0800 (PST)
Date:   Mon, 15 Nov 2021 09:26:04 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] xfs: remove xfs_inew_wait
Message-ID: <YZJt/J7k0Q+OypO5@bfoster>
References: <20211115095643.91254-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115095643.91254-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 15, 2021 at 10:56:43AM +0100, Christoph Hellwig wrote:
> With the remove of xfs_dqrele_all_inodes, xfs_inew_wait and all the
> infrastructure used to wake the XFS_INEW bit waitqueue is unused.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 777eb1fa857e ("xfs: remove xfs_dqrele_all_inodes")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c | 21 ---------------------
>  fs/xfs/xfs_inode.h  |  4 +---
>  2 files changed, 1 insertion(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index e1472004170e8..da4af2142a2b4 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -289,22 +289,6 @@ xfs_perag_clear_inode_tag(
>  	trace_xfs_perag_clear_inode_tag(mp, pag->pag_agno, tag, _RET_IP_);
>  }
>  
> -static inline void
> -xfs_inew_wait(
> -	struct xfs_inode	*ip)
> -{
> -	wait_queue_head_t *wq = bit_waitqueue(&ip->i_flags, __XFS_INEW_BIT);
> -	DEFINE_WAIT_BIT(wait, &ip->i_flags, __XFS_INEW_BIT);
> -
> -	do {
> -		prepare_to_wait(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
> -		if (!xfs_iflags_test(ip, XFS_INEW))
> -			break;
> -		schedule();
> -	} while (true);
> -	finish_wait(wq, &wait.wq_entry);
> -}
> -
>  /*
>   * When we recycle a reclaimable inode, we need to re-initialise the VFS inode
>   * part of the structure. This is made more complex by the fact we store
> @@ -368,18 +352,13 @@ xfs_iget_recycle(
>  	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
>  	error = xfs_reinit_inode(mp, inode);
>  	if (error) {
> -		bool	wake;
> -
>  		/*
>  		 * Re-initializing the inode failed, and we are in deep
>  		 * trouble.  Try to re-add it to the reclaim list.
>  		 */
>  		rcu_read_lock();
>  		spin_lock(&ip->i_flags_lock);
> -		wake = !!__xfs_iflags_test(ip, XFS_INEW);
>  		ip->i_flags &= ~(XFS_INEW | XFS_IRECLAIM);
> -		if (wake)
> -			wake_up_bit(&ip->i_flags, __XFS_INEW_BIT);
>  		ASSERT(ip->i_flags & XFS_IRECLAIMABLE);
>  		spin_unlock(&ip->i_flags_lock);
>  		rcu_read_unlock();
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index e635a3d64cba2..c447bf04205a8 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -231,8 +231,7 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
>  #define XFS_IRECLAIM		(1 << 0) /* started reclaiming this inode */
>  #define XFS_ISTALE		(1 << 1) /* inode has been staled */
>  #define XFS_IRECLAIMABLE	(1 << 2) /* inode can be reclaimed */
> -#define __XFS_INEW_BIT		3	 /* inode has just been allocated */
> -#define XFS_INEW		(1 << __XFS_INEW_BIT)
> +#define XFS_INEW		(1 << 3) /* inode has just been allocated */
>  #define XFS_IPRESERVE_DM_FIELDS	(1 << 4) /* has legacy DMAPI fields set */
>  #define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
>  #define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
> @@ -492,7 +491,6 @@ static inline void xfs_finish_inode_setup(struct xfs_inode *ip)
>  	xfs_iflags_clear(ip, XFS_INEW);
>  	barrier();
>  	unlock_new_inode(VFS_I(ip));
> -	wake_up_bit(&ip->i_flags, __XFS_INEW_BIT);
>  }
>  
>  static inline void xfs_setup_existing_inode(struct xfs_inode *ip)
> -- 
> 2.30.2
> 

