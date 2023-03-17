Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A94D7C6FD1D
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 10:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbjCQK2N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 06:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbjCQK1y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 06:27:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9461E9182
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 03:27:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B74DB824C8
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 10:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6864AC433D2;
        Fri, 17 Mar 2023 10:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679048839;
        bh=bZaOpD/mSm/Z0q9zLMCflbMZsRQgdv9AWShuO424YrA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jnJLYSH2IH1aWN8UicdGceEq37IebbyB4f3Q0YHS2+tZxs/e3uZGp/svVNppz0cv6
         tH6kTzIQz0zeEkR98QlOiFgxZdQHuBM1fbldoD2UDG55i/N/zVhTVwIzFfR+kSUjT7
         TjfEsAHXVT6MAZ9u8nrQXM5fjC+I/bbN/S7XbP2GzKyZ9VLt3Yp7fszCVHRpN881jQ
         ZRPncQh/S/PJtoEXyDfXXkc8XQw+JyYSNCdBXluaXMC8V4n5daNs8pUOluzbqMLweu
         WnxwseqV8O2s85gufB1LubyV1mg3F5g5NS5f89R/K3Zsh/b7zCdF5inrkK9cYMKZmo
         JKuHbFPht8NWQ==
Date:   Fri, 17 Mar 2023 11:27:14 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_repair: fix incorrect dabtree hashval comparison
Message-ID: <20230317102714.obafwoyt45eogt7o@andromeda>
References: <rLhelIA3PWFSu6pHHRNOAfQqN0ICDO3VHNd96FY5L8TPMWp_Xsd1EKrEIfXV-IcapJ6cjVFwKcqYsknuJHcFng==@protonmail.internalid>
 <20230315010155.GE11376@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315010155.GE11376@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 14, 2023 at 06:01:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If an xattr structure contains enough names with the same hash value to
> fill multiple xattr leaf blocks with names all hashing to the same
> value, then the dabtree nodes will contain consecutive entries with the
> same hash value.
> 
> This causes false corruption reports in xfs_repair because it's not
> expecting such a huge same-hashing structure.  Fix that.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good. Will test.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  repair/da_util.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/repair/da_util.c b/repair/da_util.c
> index 7239c2e2c64..b229422c81e 100644
> --- a/repair/da_util.c
> +++ b/repair/da_util.c
> @@ -330,7 +330,7 @@ _("%s block used/count inconsistency - %d/%hu\n"),
>  	/*
>  	 * hash values monotonically increasing ???
>  	 */
> -	if (cursor->level[this_level].hashval >=
> +	if (cursor->level[this_level].hashval >
>  				be32_to_cpu(nodehdr.btree[entry].hashval)) {
>  		do_warn(
>  _("%s block hashvalue inconsistency, expected > %u / saw %u\n"),

-- 
Carlos Maiolino
