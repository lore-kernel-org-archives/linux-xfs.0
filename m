Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847B6C63797
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 18:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6420A6069B
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 18:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhGVRoW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 13:44:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhGVRoW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jul 2021 13:44:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4840E60698;
        Thu, 22 Jul 2021 18:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626978297;
        bh=i1kRG0IKkjIeorlzF3+rJSD0jYrD1qUt25v+ly51Q5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KuBQ8IqUuofN6R3oOpVM0MLml4ABELXT0TGrX0Tq5XGH7PrF663QRw8lcNdsURXDx
         AkjhV73VVAwGoLewfAMbKRXJcbafTc0C+ybN4TRX4bgOZda86Z7emW0w5U+lBdKHJ+
         78z59SrknPmEV3mPECd9d1jj1RHBik4ADX27clF2BJKfEBU8/BBEq9a0lBARyWJBH4
         /lQv9c6Rd9ynl/Rn8ZVO5WJO9F3rpW5gEOk8lbXR7ocCinlM89vP3lUoB4ua7P5qVE
         r0liDHOmPPp5URRPnTVTuybz2kC5rcbjECahLp7iFOaf+CMP+dakHZNXusiQ9c4rgt
         awvMp8WMhCRbg==
Date:   Thu, 22 Jul 2021 11:24:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs/220: avoid failure when disabling quota
 accounting is not supported
Message-ID: <20210722182411.GD559212@magnolia>
References: <20210722073832.976547-1-hch@lst.de>
 <20210722073832.976547-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722073832.976547-5-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 09:38:29AM +0200, Christoph Hellwig wrote:
> Doing a proper _requires for quotaoff support is rather hard, as we need
> to test it on a specific file system.  Instead just use sed to remove
> the warning and let the test case pass.  Eventually it should just be
> removed entirely.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/220 | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/220 b/tests/xfs/220
> index 8d955225..c847a0dc 100755
> --- a/tests/xfs/220
> +++ b/tests/xfs/220
> @@ -54,7 +54,12 @@ _scratch_mount -o uquota
>  
>  # turn off quota and remove space allocated to the quota files
>  # (this used to give wrong ENOSYS returns in 2.6.31)
> -xfs_quota -x -c off -c remove $SCRATCH_DEV
> +#
> +# The sed expression below replaces a notrun to cater for kernels that have
> +# removed the ability to disable quota accounting at runtime.  On those
> +# kernel this test is rather useless, and in a few years we can drop it.
> +xfs_quota -x -c off -c remove $SCRATCH_DEV 2>&1 | \
> +	sed -e '/XFS_QUOTARM: Invalid argument/d'
>  
>  # and unmount again
>  _scratch_unmount
> -- 
> 2.30.2
> 
