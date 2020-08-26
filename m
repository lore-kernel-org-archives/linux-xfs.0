Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76C6C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:00:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A455A2087C
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 22:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgHZWAr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 18:00:47 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:47320 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726765AbgHZWAq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 18:00:46 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 1EC5B6ACE30;
        Thu, 27 Aug 2020 08:00:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kB3TH-0003qB-1v; Thu, 27 Aug 2020 08:00:43 +1000
Date:   Thu, 27 Aug 2020 08:00:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: Remove kmem_zalloc_large()
Message-ID: <20200826220043.GW12131@dread.disaster.area>
References: <20200826161402.55132-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826161402.55132-1-cmaiolino@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=XJ9OtjpE c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=hbkM4bGCs55bkfxU2ssA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 06:14:02PM +0200, Carlos Maiolino wrote:
> This patch aims to replace kmem_zalloc_large() with global kernel memory
> API. So, all its callers are now using kvzalloc() directly, so kmalloc()
> fallsback to vmalloc() automatically.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> Changelog:
> 
> 	V2:
> 		Remove __GFP_RETRY_MAYFAIL from the kvzalloc() calls
> 
>  fs/xfs/kmem.h          | 6 ------
>  fs/xfs/scrub/symlink.c | 3 ++-
>  fs/xfs/xfs_acl.c       | 2 +-
>  fs/xfs/xfs_ioctl.c     | 4 ++--
>  fs/xfs/xfs_rtalloc.c   | 2 +-
>  5 files changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index fb1d066770723..38007117697ef 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -71,12 +71,6 @@ kmem_zalloc(size_t size, xfs_km_flags_t flags)
>  	return kmem_alloc(size, flags | KM_ZERO);
>  }
>  
> -static inline void *
> -kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
> -{
> -	return kmem_alloc_large(size, flags | KM_ZERO);
> -}
> -
>  /*
>   * Zone interfaces
>   */
> diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
> index 5641ae512c9ef..5a721a9adea78 100644
> --- a/fs/xfs/scrub/symlink.c
> +++ b/fs/xfs/scrub/symlink.c
> @@ -22,11 +22,12 @@ xchk_setup_symlink(
>  	struct xfs_inode	*ip)
>  {
>  	/* Allocate the buffer without the inode lock held. */
> -	sc->buf = kmem_zalloc_large(XFS_SYMLINK_MAXLEN + 1, 0);
> +	sc->buf = kvzalloc(XFS_SYMLINK_MAXLEN + 1, GFP_KERNEL);
>  	if (!sc->buf)
>  		return -ENOMEM;
>  
>  	return xchk_setup_inode_contents(sc, ip, 0);
> +
>  }

With the extra added line removed,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
