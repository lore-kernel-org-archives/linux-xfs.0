Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F82C10F1B
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 11:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiLULQj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Dec 2022 06:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbiLULQf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2022 06:16:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D87A1A0
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 03:16:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0906561778
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 11:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78883C433D2;
        Wed, 21 Dec 2022 11:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671621393;
        bh=Y151axLu3r5rWUJqGqzlsXqRgHBjdKL6MOlzDVh7y8U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YNjT5+VVasF6BjehFgFoYeigczWAgDEmEHl7S1PC6OzJN7ZIr0/BGfOF5kw8+KRZT
         V1LCHOeWKzAf363N+KM5nf6Pq373y4bQ1j07ya+7BgM0i1daqs70uOySikfgXUWk94
         OZrzmTAfGcubkqtkN3lKUgazUUMNIibVfNC7lyOF7agpcX16YMTWSJO/NDrBwOw3T5
         gOAeiIz8qXowDyPtwgmwZWlLCmpvoZyqFKP6wrqAW22QQ7Y4+4nLF1Ah0tdK/9DQso
         hP3Urw2YXwzMyiHQleGqVWtYi3uKFNQBOHycOx+8xwxT+CmFny5Uqk+opGJ485yetR
         rnRJfqnyuELaQ==
Date:   Wed, 21 Dec 2022 12:16:28 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs_db: fix dir3 block magic check
Message-ID: <20221221111628.jiivfgcwwblxyywz@andromeda>
References: <167158400859.315997.2365290256986240896.stgit@magnolia>
 <cBJlBsyU5hZ1SLc-TeJvOX8PQctoc8i-X_cxmiEoNh_XFpG3Wc8ot8BaTytc9ovkac6GQt9QVSTuW9cBZ7N30Q==@protonmail.internalid>
 <167158401424.315997.9124675033467112155.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167158401424.315997.9124675033467112155.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 20, 2022 at 04:53:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix this broken check, which (amazingly) went unnoticed until I cranked
> up the warning level /and/ built the system for s390x.
> 
> Fixes: e96864ff4d4 ("xfs_db: enable blockget for v5 filesystems")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Aaaand, we've got an exception for 6.1 this week :) I'll add it to this Friday's
6.1 release

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  db/check.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/db/check.c b/db/check.c
> index bb27ce58053..964756d0ae5 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -2578,7 +2578,7 @@ process_data_dir_v2(
>  		error++;
>  	}
>  	if ((be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC ||
> -	     be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC) &&
> +	     be32_to_cpu(data->magic) == XFS_DIR3_BLOCK_MAGIC) &&
>  					stale != be32_to_cpu(btp->stale)) {
>  		if (!sflag || v)
>  			dbprintf(_("dir %lld block %d bad stale tail count %d\n"),
> 

-- 
Carlos Maiolino
