Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0508DC7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 23:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjDKXdA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 19:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjDKXc7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 19:32:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25AD10F1
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 16:32:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DF1D60FE3
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 23:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D8CC433D2;
        Tue, 11 Apr 2023 23:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681255977;
        bh=lIjCWgcWc1beMhahgZqkvZ5qkS55PSlzLIPIPBj055Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LMOvGudboSS9QCIZavv7NaeFUElhlIy7iKefdnDcEMVkc9f/y8ksIVhOHI+fiiwBw
         Gq/CY9pVh6EZC6zgxzOjPdQbGtRmEsqEhQKey3nNroxou44Gl00o4KyiulLLBijdUT
         eQL+eOo+mvDncuCWjy0/kgfmg928LAL1wBP3FT8vGWAqb1CKFLrnQWVnKH8PMnhpEG
         kUuVyLuphxPVoLh3m55C79dP++lz4RZgBngiRA3yrGQi7oSknKCcFPKqxGWlCD0OOC
         u+aRJu4cBW+8tcBUNZRb/d7Lug+O6WHtr5wDBCUZSVQ4Ldr2c7wH3UvtssDR2I5nIH
         BBB9jsTw4MC6g==
Date:   Tue, 11 Apr 2023 16:32:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove WARN when dquot cache insertion fails
Message-ID: <20230411233257.GN360889@frogsfrogsfrogs>
References: <20230411232342.233433-1-david@fromorbit.com>
 <20230411232342.233433-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411232342.233433-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 12, 2023 at 09:23:41AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It just creates unnecessary bot noise these days.
> 
> Reported-by: syzbot+6ae213503fb12e87934f@syzkaller.appspotmail.com
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_dquot.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 8fb90da89787..7f071757f278 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -798,7 +798,6 @@ xfs_qm_dqget_cache_insert(
>  	error = radix_tree_insert(tree, id, dqp);
>  	if (unlikely(error)) {
>  		/* Duplicate found!  Caller must try again. */
> -		WARN_ON(error != -EEXIST);
>  		mutex_unlock(&qi->qi_tree_lock);
>  		trace_xfs_dqget_dup(dqp);
>  		return error;
> -- 
> 2.39.2
> 
