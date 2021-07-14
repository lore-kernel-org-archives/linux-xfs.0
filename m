Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2884C1B08C
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8E04613D1
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237695AbhGNXdm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229657AbhGNXdl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 19:33:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72369613BF;
        Wed, 14 Jul 2021 23:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626305449;
        bh=hbPuVaL2v7eMQNXFFmFql11u7H/ZIhN0wnuzVerePeA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n+UZ4ZnQonKSYKnwlDp2EdqGYnWZzo1RG5C3V8w9YxDdKWvQYmghjfXYpn4hgxYOr
         mruUo6sVND+UCShjBM9lRNu3r+zZ0JVBjBiiAlzfnrAYVDPlbqUDkvo8JCI7Rex/SH
         EIAPzKBzW6jHcZgeqJYibJ7gybcbA8UZqywFnTE9dapQakBmOkhT//gSYaf7+qA5XU
         N1Eqn5vTagLWb3svy4+zAH4326xU1NjkYndKMImEfQ+H65Qs96eukMCEB/rf1qVFsR
         zjxRL1DH8dPdB/BOKo7EocVfsiCQMRGJnONi7U4zEGbgEGtjhH1rIc2hKR/Ys6/8Nv
         2a+HEzFGEIXRQ==
Date:   Wed, 14 Jul 2021 16:30:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs/220: avoid failure when disabling quota
 accounting is not supported
Message-ID: <20210714233049.GO22402@magnolia>
References: <20210712111146.82734-1-hch@lst.de>
 <20210712111146.82734-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712111146.82734-5-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 12, 2021 at 01:11:44PM +0200, Christoph Hellwig wrote:
> Doing a proper _requires for quotaoff support is rather hard, as we need
> to test it on a specific file system.  Instead just use sed to remove
> the warning and let the test case pass.  Eventually it should just be
> removed entirely.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
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

Please replace 'xfs_quota' with '$XFS_QUOTA_PROG' in all these tests
you're touching.

> +	sed -e '/XFS_QUOTARM: Invalid argument/d'

Between 'off' and 'remove', which one returned EINVAL?

--D

>  
>  # and unmount again
>  _scratch_unmount
> -- 
> 2.30.2
> 
