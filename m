Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F52C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 17:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2333E64E10
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 17:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhA1Rhq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 12:37:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232975AbhA1Rha (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 12:37:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C98364D9A;
        Thu, 28 Jan 2021 17:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611855409;
        bh=FbEZvysS0qW32yUYxP5/3wXWgI8hu6+by0kJ4O6pCe4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LFuuNCjJUWBIgZHO3+ZhjaDeWjkhR6m4J541XVeVpmN/Ln77rtRJTJY4rOua2D80p
         fB6NdgO8s+V+mVfUQEOox0cDeY8FhUJ6IKdmUVrUPlLNH2x/+GGzEeiPc2yZMQm+Jx
         itacNedOFBuCu+GBdMm0n5kbh68fVh9ON1j2nXIwRowdOPvPGzmLSMydc9c6EfNKh9
         XqXHnpC+y7jwOUQdZzTMZICnuJ4BriAqJCfuaFKaKqJjP9ZXPpmuCvYoHn02zJbhjt
         dDuCodIX3LrTDo0LdOzQ7QCHO1/TQnj3rrBaDysXOVFwPcK62lAM9pN55WHiI99adH
         vRKENn+SaDUHg==
Date:   Thu, 28 Jan 2021 09:36:48 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [PATCH V2] xfsprogs: xfs_fsr: Verify bulkstat version
 information in qsort's cmp()
Message-ID: <20210128173648.GR7698@magnolia>
References: <20210128052058.30328-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128052058.30328-1-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 10:50:58AM +0530, Chandan Babu R wrote:
> This commit introduces a check to verify that correct bulkstat structures are
> being processed by qsort's cmp() function.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> V1 -> V2:
>    1. Include XFS_BULKSTAT_VERSION_V1 as a possible bulkstat version
>       number. 
>    2. Fix coding style issue.
>    
>  fsr/xfs_fsr.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index b885395e..6cf8bfb7 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -582,8 +582,15 @@ fsrall_cleanup(int timeout)
>  static int
>  cmp(const void *s1, const void *s2)
>  {
> -	return( ((struct xfs_bulkstat *)s2)->bs_extents -
> -	        ((struct xfs_bulkstat *)s1)->bs_extents);
> +	const struct xfs_bulkstat	*bs1 = s1;
> +	const struct xfs_bulkstat	*bs2 = s2;
> +
> +	ASSERT((bs1->bs_version == XFS_BULKSTAT_VERSION_V1 &&
> +		bs2->bs_version == XFS_BULKSTAT_VERSION_V1) ||
> +		(bs1->bs_version == XFS_BULKSTAT_VERSION_V5 &&
> +		bs2->bs_version == XFS_BULKSTAT_VERSION_V5));
> +
> +	return (bs2->bs_extents - bs1->bs_extents);
>  }
>  
>  /*
> -- 
> 2.29.2
> 
