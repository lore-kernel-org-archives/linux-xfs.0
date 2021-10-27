Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B574C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Oct 2021 20:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 715016109F
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Oct 2021 20:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238909AbhJ0Uzy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Oct 2021 16:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234080AbhJ0Uzx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Oct 2021 16:55:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E192660720;
        Wed, 27 Oct 2021 20:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635368008;
        bh=lR4BUuybzYA05P+MmciU7UFrNU2jug/xDcDUahEPscw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aK5lTPJhNP7O5M8SRf4tlz12iShtHHSDbSrCZz0cRCHjDGx5qpk2F09b5oE6C3K38
         ap+MitTKVRq4mzQwwBmgg8JwsjblqwDuEXUAsM40tBDpiDQaqm3vHrFyLjHOn5qogx
         TaYJtXwOZgygWr5IQ7faO+723pmoapjQvOEgfNk5YIEE0lcpbcbW/FI2Kdwq6R+AmU
         UJehgWb2Fk8W6H3+6LYzyaBZOtEtlxkkdHf+rYPewSbaFQ5c5nvFWUc9QY176LaWco
         oxpgLk1cRacK+BIFtTJR1BC4p+75BTHOJAdyJ+wAxI6zEVbPLpuW+I2Cr1aRiHTfwM
         aKqrmKtzT65Uw==
Date:   Wed, 27 Oct 2021 13:53:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cgel.zte@gmail.com
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        ran jianping <ran.jianping@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH xfs] xfs: remove duplicate include in xfs_super.c
Message-ID: <20211027205327.GC24307@magnolia>
References: <20211027081652.1946-1-ran.jianping@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027081652.1946-1-ran.jianping@zte.com.cn>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 27, 2021 at 08:16:52AM +0000, cgel.zte@gmail.com wrote:
> From: ran jianping <ran.jianping@zte.com.cn>
> 
> 'xfs_btree.h ' included in 'fs/xfs/xfs_super.c'
>  is duplicated.It is also included on the 40 line.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: ran jianping <ran.jianping@zte.com.cn>

How is this different from the identical patch posted two days ago?

--D

> ---
>  fs/xfs/xfs_super.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f4c508428aad..e21459f9923a 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -37,7 +37,6 @@
>  #include "xfs_reflink.h"
>  #include "xfs_pwork.h"
>  #include "xfs_ag.h"
> -#include "xfs_btree.h"
>  #include "xfs_defer.h"
>  
>  #include <linux/magic.h>
> -- 
> 2.25.1
> 
