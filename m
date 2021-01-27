Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00166C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 16:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4F2860187
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 16:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhA0Qg1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 11:36:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:32768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232608AbhA0QfT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Jan 2021 11:35:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 132BE60187;
        Wed, 27 Jan 2021 16:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611765278;
        bh=JBwpA9qcri2Q3T9xBGlB20ak7b9T3sAkA4ynLyA/CRU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g5BW16inn83alliwOzxbcOpa3AjdWL4MW/aA3fn7rqNW0tI08meIsaZXg2NXLFFW4
         Ayr4Uz7tMp9jVNePfX446ldmXIPupn2nRPS3L0f8eUJJj3LtpuUb8/8ywRMhKAOFnV
         D7H20dIwhwjQ+zJiy5wmNpeJdXKmG7sm8MULm9oGcMJ7t6mgnuCu9gN0PHNDk5VwHX
         IjR9G3mFFT/fgvT/uMdiM/HNEBNhNzdlgk2zizudIwK1Urom+SvBA+Xu57OS8qoMhb
         fb2rUKueno1R+FqJrrr1ISOITjLU0ARMPoAkCo98UeTsczyn6olRKjlFvwxlQ585OA
         TTdgBdKFwwMLQ==
Date:   Wed, 27 Jan 2021 08:34:37 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [PATCH] xfsprogs: xfs_fsr: Verify bulkstat version information
 in qsort's cmp()
Message-ID: <20210127163437.GH7698@magnolia>
References: <20210127092405.2841857-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127092405.2841857-1-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 02:54:05PM +0530, Chandan Babu R wrote:
> This commit introduces a check to verify that correct bulkstat structures are
> being processed by qsort's cmp() function.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fsr/xfs_fsr.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index b885395e..de7e8190 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -582,8 +582,13 @@ fsrall_cleanup(int timeout)
>  static int
>  cmp(const void *s1, const void *s2)
>  {
> -	return( ((struct xfs_bulkstat *)s2)->bs_extents -
> -	        ((struct xfs_bulkstat *)s1)->bs_extents);
> +	const struct xfs_bulkstat	*bs1 = s1;
> +	const struct xfs_bulkstat	*bs2 = s2;
> +
> +	ASSERT(bs1->bs_version == XFS_BULKSTAT_VERSION_V5
> +		&& bs2->bs_version == XFS_BULKSTAT_VERSION_V5);

Stylistic nit: the '&&' goes on the previous line; and
bs_version can also be XFS_BULKSTAT_VERSION_V1.

--D

> +
> +	return (bs2->bs_extents - bs1->bs_extents);
>  }
>  
>  /*
> -- 
> 2.29.2
> 
