Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E98FAC4332B
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 09:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B960F64EBA
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 09:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236218AbhBYJLp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 04:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236134AbhBYJJl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 04:09:41 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8B4C061574
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 01:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Eoc61+0T4OM+LRkvC8rbJv5rRar9iE188mbfEZVxSU4=; b=jsGYVUsznqKjHYS6ix1IOC69UY
        S+7eF7EDxAWhY6b6K/QYWtF43oNI8kGRwuxudr1qw/ScObq3gXocuXzIgqaOXicQaJdg6zjj5v2Nx
        p8Ju2PU2YiUBg/9f95MG4QAO+wu9NZaQDaAAZcDB199xnp4si6K6MSOvCnZbTr856/SQCdBlMG75G
        b4sfGMfyEA1F52BSU+HrCO6RroZK9ILHymRFhCG9j+m/dAH11EvuEZULLJep0+IUSHtmurEjTcSrn
        EijiOmNyKClF+a/324jVSfQa/HyZtcnaNOzF0hJRXT4EglpxpDFX6C+Yad5rdTt8qQo0EWSKKP6bv
        u5QNOnIw==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFCdB-00AVCa-4m; Thu, 25 Feb 2021 09:08:23 +0000
Date:   Thu, 25 Feb 2021 10:06:06 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: No need for inode number error injection in
 __xfs_dir3_data_check
Message-ID: <YDdoftqQw0KQn7k7@infradead.org>
References: <20210223054748.3292734-1-david@fromorbit.com>
 <20210223054748.3292734-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223054748.3292734-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

On Tue, Feb 23, 2021 at 04:47:47PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We call xfs_dir_ino_validate() for every dir entry in a directory
> when doing validity checking of the directory. It calls
> xfs_verify_dir_ino() then emits a corruption report if bad or does
> error injection if good. It is extremely costly:
> 
>   43.27%  [kernel]  [k] xfs_dir3_leaf_check_int
>   10.28%  [kernel]  [k] __xfs_dir3_data_check
>    6.61%  [kernel]  [k] xfs_verify_dir_ino
>    4.16%  [kernel]  [k] xfs_errortag_test
>    4.00%  [kernel]  [k] memcpy
>    3.48%  [kernel]  [k] xfs_dir_ino_validate
> 
> 7% of the cpu usage in this directory traversal workload is
> xfs_dir_ino_validate() doing absolutely nothing.
> 
> We don't need error injection to simulate a bad inode numbers in the
> directory structure because we can do that by fuzzing the structure
> on disk.
> 
> And we don't need a corruption report, because the
> __xfs_dir3_data_check() will emit one if the inode number is bad.
> 
> So just call xfs_verify_dir_ino() directly here, and get rid of all
> this unnecessary overhead:
> 
>   40.30%  [kernel]  [k] xfs_dir3_leaf_check_int
>   10.98%  [kernel]  [k] __xfs_dir3_data_check
>    8.10%  [kernel]  [k] xfs_verify_dir_ino
>    4.42%  [kernel]  [k] memcpy
>    2.22%  [kernel]  [k] xfs_dir2_data_get_ftype
>    1.52%  [kernel]  [k] do_raw_spin_lock
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_data.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 375b3edb2ad2..e67fa086f2c1 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -218,7 +218,7 @@ __xfs_dir3_data_check(
>  		 */
>  		if (dep->namelen == 0)
>  			return __this_address;
> -		if (xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)))
> +		if (!xfs_verify_dir_ino(mp, be64_to_cpu(dep->inumber)))
>  			return __this_address;
>  		if (offset + xfs_dir2_data_entsize(mp, dep->namelen) > end)
>  			return __this_address;
> -- 
> 2.28.0
> 
---end quoted text---
