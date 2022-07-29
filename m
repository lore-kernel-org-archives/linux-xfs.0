Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F5D5C00144
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jul 2022 15:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237985AbiG2PoZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Jul 2022 11:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237951AbiG2PoX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Jul 2022 11:44:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8EE87F52
        for <linux-xfs@vger.kernel.org>; Fri, 29 Jul 2022 08:44:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F47C61D95
        for <linux-xfs@vger.kernel.org>; Fri, 29 Jul 2022 15:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6871FC433C1;
        Fri, 29 Jul 2022 15:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659109454;
        bh=LmvbcAnYkjuhIFKAqACZBJE2yfOfsu1v7A85lgr8Nts=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MOLQ+AFwd6vvemsvW2Z/Z2ySRfMQmLW9sRTqDag3nbz90wCnuVwM7RuxL4QEdUVg0
         TptpK5I5gXcG2m0NvwyK/JC+7qBYqYfPthsCuWuMEZ1hooUy2+f05Njdlacv9NKaQ6
         AiEGkwjklqa1a7t/de8eAOu+WZ1zpqrJACX6g1z3V/L49xd/F5TVQMSOvFh2VrNDFu
         H9f8GLsiItXx+/68HBKT/OC/wro8hs+Zm9UXXLda4iC5QKpONrDg4PZ08EufOrCKcI
         1CoiwG365jYEVdLyPqBrvNNNKIHdfAY4/al2BRjaTQAlVpyuUqQ+2LqpKIttwea5ZX
         Q54RPV1gl9B8w==
Date:   Fri, 29 Jul 2022 08:44:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Stephen Zhang <starzhangzsd@gmail.com>
Cc:     sandeen@redhat.com, hch@lst.de, zhangshida@kylinos.cn,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libfrog: fix the if condition in xfrog_bulk_req_v1_setup
Message-ID: <YuQATS8/CujZV3lh@magnolia>
References: <20220729075746.1918783-1-zhangshida@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729075746.1918783-1-zhangshida@kylinos.cn>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 29, 2022 at 03:57:46PM +0800, Stephen Zhang wrote:
> when scanning all inodes in each ag, hdr->ino serves as a iterator to
> specify the ino to start scanning with.
> 
> After hdr->ino-- , we can get the last ino returned from the previous
> iteration.
> 
> But there are cases that hdr->ino-- is pointless, that is,the case when
> starting to scan inodes in each ag.
> 
> Hence the condition should be cvt_ino_to_agno(xfd, hdr->ino) ==0, which
> represents the start of scan in each ag,

Er, cvt_ino_to_agno extracts the AG number from an inumber;
cvt_ino_to_agino extracts the inumber within an AG.  Given your
description of the problem (not wanting hdr->ino to go backwards in the
inumber space when it's already at the start of an AG), I think you want
the latter here?

> instead of hdr->ino ==0, which represents the start of scan in ag 0 only.
> 
> Signed-off-by: Stephen Zhang <zhangshida@kylinos.cn>
> ---
>  libfrog/bulkstat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
> index 195f6ea0..77a385bb 100644
> --- a/libfrog/bulkstat.c
> +++ b/libfrog/bulkstat.c
> @@ -172,7 +172,7 @@ xfrog_bulk_req_v1_setup(
>  	if (!buf)
>  		return -errno;
>  
> -	if (hdr->ino)
> +	if (cvt_ino_to_agno(xfd, hdr->ino))

...because I think this change means that we go backwards for any inode
in AG 0, and we do not go backwards for any other AG.

--D

>  		hdr->ino--;
>  	bulkreq->lastip = (__u64 *)&hdr->ino,
>  	bulkreq->icount = hdr->icount,
> -- 
> 2.25.1
> 
