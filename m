Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436CAC07E99
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 04:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FEF96143C
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 04:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhGIEIh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 00:08:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhGIEIg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Jul 2021 00:08:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C09061208;
        Fri,  9 Jul 2021 04:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625803554;
        bh=O4aXT7TOZqRrZrwccF9nFKSd3wBSdDDilo/55ZDK/tI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J5GCbuKPo+wQQDuOZNl131dtwdfl0FCDD99iA5bxUd3lbk4mfwGRgiBw3zqbwdPs2
         hC+7w+6ZPDMcVYltUEC/vTtpq6hxY74NxAuE1DA2V+xJzOlkdvDCmCCKbzkqoivYcQ
         3wFPCEq5ORkgjA1PeWyNRAJy/B+PqtlyDQ9IDr1+Z7hCPQ+muewsRKFQ3YJJ/9oR57
         1aJ/b6ifbgU2oKP8AvCuXXmXE9SMmQbX0vxmkxG0g6GYXW5BjC76mweK7QtO9koZbC
         Wtftj/Is5q2I9UMqvu2Ve1jrGx68LUrtegf/QSWx4ZCX8/qHdYwjnyu+K3K+KrDpkr
         tjGl99hnsgItw==
Date:   Thu, 8 Jul 2021 21:05:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v21 01/13] xfs: Return from xfs_attr_set_iter if there
 are no more rmtblks to process
Message-ID: <20210709040553.GL11588@locust>
References: <20210707222111.16339-1-allison.henderson@oracle.com>
 <20210707222111.16339-2-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707222111.16339-2-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 07, 2021 at 03:20:59PM -0700, Allison Henderson wrote:
> During an attr rename operation, blocks are saved for later removal
> as rmtblkno2. The rmtblkno is used in the case of needing to alloc
> more blocks if not enough were available.  However, in the case
> that neither rmtblkno or rmtblkno2 are set, we can return as soon
> as xfs_attr_node_addname completes, rather than rolling the transaction
> with an -EAGAIN return.  This extra loop does not hurt anything right
> now, but it will be a problem later when we get into log items because
> we end up with an empty log transaction.  So, add a simple check to
> cut out the unneeded iteration.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 611dc67..5e81389 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -409,6 +409,13 @@ xfs_attr_set_iter(
>  			if (error)
>  				return error;
>  
> +			/*
> +			 * If addname was successful, and we dont need to alloc
> +			 * or remove anymore blks, we're done.
> +			 */
> +			if (!args->rmtblkno && !args->rmtblkno2)
> +				return error;

Is there actually an error to return here, or could this be a 'return 0;' ?

--D

> +
>  			dac->dela_state = XFS_DAS_FOUND_NBLK;
>  		}
>  		return -EAGAIN;
> -- 
> 2.7.4
> 
