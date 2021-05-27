Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF050C4707F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 06:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A125C613D4
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 06:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbhE0GPN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 02:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233765AbhE0GPG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 02:15:06 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE18C06138C
        for <linux-xfs@vger.kernel.org>; Wed, 26 May 2021 23:13:31 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id q67so2848774pfb.4
        for <linux-xfs@vger.kernel.org>; Wed, 26 May 2021 23:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=l65qrQdAhkeag06ft2i2boOkwPhx5tLZSYIgko+z9SI=;
        b=Dbq+8+nQSPQMquH0U73BTOe7Xn17bD8exKaoEbXcBbJ9Aczmyw0x9AZ4mB6CmAWoPf
         3SRvLkLPB0Pf21sHVFgv90/VKb2sQEtccoD91PAbrB0PjPa6cjSNy3cGAWxjtVwwNTzC
         96pexYxJH5E/rejJRMbzE0y+iFCdEdQ5xnj94Z0L1U113iNC/9F3XbWY5zivhvkGK5vF
         mltBGl8wUOdOe/xP8LHG+MAiQrZoznkfzbSx0OEEnKls6mqEcMNKqvVzh+kVkH1Q74MQ
         HmxYv9DJuHbNg/Qkv5Yr66I8+oioabHsIIyqazsLU3KAviSlvVVK6qx9H5K85eYRjWzX
         widg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=l65qrQdAhkeag06ft2i2boOkwPhx5tLZSYIgko+z9SI=;
        b=XJoSqa4jn9IB1xPDyq9o7qECF52mL0fYGqoR69Ih4VJNp4c92dWiNfT04JvKRFB810
         MiBqckgYPqCUrqcV07hMQ6qAXTtHRMZ+8rdc/IHzJsasmNOarIILTSxOC64Qx63JFSPl
         R++KwxKVijQlshaAOLeC3WgZh7RIV3hKneMKnNgWKA3wyuKiE5Ybx747NAHYhSBxNzC5
         eg/q7Y8B4ndnE7QlenD0qNe9vU+7EWBz4UgiycXMLqKPOOKR71wNShKE5BIUFIFzg5H2
         W5rG9HNxwigSFH60DLAlWESt7wMidBNWBKwga94hU/ArObmJwLawBH1AUVOqT0DzXX84
         Efwg==
X-Gm-Message-State: AOAM530ozIbL2sVnkB5rkTJhMxQJkGI4xB1NXtz6ECdpatwzCg4gpURZ
        HvfD4Lm/CjpqUf3j/QNf05IbDOn4PmaoJA==
X-Google-Smtp-Source: ABdhPJwf9Te+gwnScW4vaibKeBWqx1nWI9yk6rKqJeRKEnIA72dR6dOZ1XsMg8+Z20euEwrTX1QO2g==
X-Received: by 2002:a63:b507:: with SMTP id y7mr2253229pge.74.1622096010669;
        Wed, 26 May 2021 23:13:30 -0700 (PDT)
Received: from garuda ([122.171.209.190])
        by smtp.gmail.com with ESMTPSA id x184sm912172pgb.36.2021.05.26.23.13.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 May 2021 23:13:30 -0700 (PDT)
References: <20210525195504.7332-1-allison.henderson@oracle.com> <20210525195504.7332-12-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v19 11/14] xfs: Remove xfs_attr_rmtval_set
In-reply-to: <20210525195504.7332-12-allison.henderson@oracle.com>
Date:   Thu, 27 May 2021 11:43:27 +0530
Message-ID: <87im34ogag.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 26 May 2021 at 01:25, Allison Henderson wrote:
> This function is no longer used, so it is safe to remove
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 66 -----------------------------------------
>  fs/xfs/libxfs/xfs_attr_remote.h |  1 -
>  2 files changed, 67 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index ba3b1c8..b5bc50c 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -562,72 +562,6 @@ xfs_attr_rmtval_stale(
>  }
>  
>  /*
> - * Write the value associated with an attribute into the out-of-line buffer
> - * that we have defined for it.
> - */
> -int
> -xfs_attr_rmtval_set(
> -	struct xfs_da_args	*args)
> -{
> -	struct xfs_inode	*dp = args->dp;
> -	struct xfs_bmbt_irec	map;
> -	xfs_dablk_t		lblkno;
> -	int			blkcnt;
> -	int			nmap;
> -	int			error;
> -
> -	trace_xfs_attr_rmtval_set(args);
> -
> -	error = xfs_attr_rmt_find_hole(args);
> -	if (error)
> -		return error;
> -
> -	blkcnt = args->rmtblkcnt;
> -	lblkno = (xfs_dablk_t)args->rmtblkno;
> -	/*
> -	 * Roll through the "value", allocating blocks on disk as required.
> -	 */
> -	while (blkcnt > 0) {
> -		/*
> -		 * Allocate a single extent, up to the size of the value.
> -		 *
> -		 * Note that we have to consider this a data allocation as we
> -		 * write the remote attribute without logging the contents.
> -		 * Hence we must ensure that we aren't using blocks that are on
> -		 * the busy list so that we don't overwrite blocks which have
> -		 * recently been freed but their transactions are not yet
> -		 * committed to disk. If we overwrite the contents of a busy
> -		 * extent and then crash then the block may not contain the
> -		 * correct metadata after log recovery occurs.
> -		 */
> -		nmap = 1;
> -		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
> -				  blkcnt, XFS_BMAPI_ATTRFORK, args->total, &map,
> -				  &nmap);
> -		if (error)
> -			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> -
> -		ASSERT(nmap == 1);
> -		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
> -		       (map.br_startblock != HOLESTARTBLOCK));
> -		lblkno += map.br_blockcount;
> -		blkcnt -= map.br_blockcount;
> -
> -		/*
> -		 * Start the next trans in the chain.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			return error;
> -	}
> -
> -	return xfs_attr_rmtval_set_value(args);
> -}
> -
> -/*
>   * Find a hole for the attr and store it in the delayed attr context.  This
>   * initializes the context to roll through allocating an attr extent for a
>   * delayed attr operation
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index 8ad68d5..61b85b9 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -9,7 +9,6 @@
>  int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>  
>  int xfs_attr_rmtval_get(struct xfs_da_args *args);
> -int xfs_attr_rmtval_set(struct xfs_da_args *args);
>  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>  		xfs_buf_flags_t incore_flags);
>  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);


-- 
chandan
