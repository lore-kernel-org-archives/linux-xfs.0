Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:51768 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730429AbeGRPSW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jul 2018 11:18:22 -0400
Received: by mail-wm0-f46.google.com with SMTP id h3-v6so2635268wmb.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 07:40:08 -0700 (PDT)
Date: Wed, 18 Jul 2018 16:40:04 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 5/6] xfs: maintain a sequence count for inode fork
 manipulations
Message-ID: <20180718144004.bvvrssvtcpd2b2uw@odin.usersys.redhat.com>
References: <20180717232405.18511-1-hch@lst.de>
 <20180717232405.18511-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180717232405.18511-6-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org



>  struct xfs_ifork {
>  	int			if_bytes;	/* bytes in if_u1 */
> +	unsigned int		if_seq;

I wonder if a comment here wouldn't be helpful in the future, like: /* ext list modification counter */

It's just a suggestion though, any way you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>




>  	struct xfs_btree_block	*if_broot;	/* file's incore btree root */
>  	short			if_broot_bytes;	/* bytes allocated for root */
>  	unsigned char		if_flags;	/* per-fork flags */

> -- 
> 2.18.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
