Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46BA1ECAAD3
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Sep 2022 08:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiIIIkS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Sep 2022 04:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiIIIkR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Sep 2022 04:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7297852DEE
        for <linux-xfs@vger.kernel.org>; Fri,  9 Sep 2022 01:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F11361F2E
        for <linux-xfs@vger.kernel.org>; Fri,  9 Sep 2022 08:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD45BC433D6;
        Fri,  9 Sep 2022 08:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662712812;
        bh=rDomJggv4qeqI8ELuZ2lDdF9cZmRKLlcyK/NyxpzDEM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kMkl4ohcKVc0c1MboUhmujMwmkqyfAdAijj5VrBLKmSSPVqWvYp6b36FZdZnCBpjt
         bTXEX/0sxhCBFIuJ9hKntKMDslhlx4vcT7kw+9mX5lUK9ZikeAuizHaMC2hT2cTnDl
         +SYRroqt0s70Fj09OZLmJjqOftDw7LRR62gWqRUqB9/QNeFVMljthGpFBlQxSiewX5
         sQLpsxLjendYN88BDUTzWmiXuZuekilhBlp6ESsGws5MyXJMiUFlAAzjmpYzD89/3b
         Z8OMJrnWeUoN8GjssQeIk9XDZv+Ym3xtvxawjtgMwDYbIibhZ9mACFXJ8W1+MjeZLO
         sWCrDWdMsdyEA==
Date:   Fri, 9 Sep 2022 10:40:08 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     Stephen Zhang <starzhangzsd@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the redundant check in xfs_bmap_first_unused
Message-ID: <20220909084008.66iuexux5n4dxv55@andromeda>
References: <RvLnePt27HgpmHDaQfv_H_I1X7XIRunaGC4MkIy89psvEFb-03LRlGRtQgB2Hv05B5DXvw9SW2QIawlri8Z6pg==@protonmail.internalid>
 <20220909030756.3916297-1-zhangshida@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909030756.3916297-1-zhangshida@kylinos.cn>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 09, 2022 at 11:07:56AM +0800, Stephen Zhang wrote:
> Given that
>         max >= lowest,
> hence if
>         got.br_startoff >= max + len,
> then, at the same time,
>         got.br_startoff >= lowest + len,
> 
> So the check here is redundant, remove it.
> 
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>

Change seems ok, I wonder if this wouldn't mask a bit the intention of this
condition, but this does not seem a big deal, so.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


P.S.

There is no need to send xfs specific patches to LKML, this just cause extra
noise there without any gain.

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index e56723dc9cd5..f8a984c41b01 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1230,8 +1230,7 @@ xfs_bmap_first_unused(
>  		/*
>  		 * See if the hole before this extent will work.
>  		 */
> -		if (got.br_startoff >= lowest + len &&
> -		    got.br_startoff - max >= len)
> +		if (got.br_startoff - max >= len)
>  			break;
>  		lastaddr = got.br_startoff + got.br_blockcount;
>  		max = XFS_FILEOFF_MAX(lastaddr, lowest);
> --
> 2.25.1
> 

-- 
Carlos Maiolino
