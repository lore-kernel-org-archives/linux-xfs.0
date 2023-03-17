Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E12C74A5B
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 10:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjCQK0b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 06:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjCQK0W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 06:26:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE922E6DBB
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 03:26:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D14AA62268
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 10:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAFDC433EF;
        Fri, 17 Mar 2023 10:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679048763;
        bh=5kqjIvvv+ujERhdiNwxx6hYmRgO1sssa8lGKLgI7JIA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RTaSkqed5EyiSBRjVhNvNM+uH+jDMRNhRzsGyAZoKkMHb9Nkss7MxRmGTOpLmBdNk
         OnSfpj3K9kgtQrWgrKPhC0wb4abfLoR3rGBX/invgIsxcf5rXKeSToU9ibDGOYKaaw
         +ir2MpGtcwBvvvSpmLqYGQKPsaTmK1fCVxswD19wyRDPVaigf5JW++q7HHRLAo1C0I
         oF+gOq49X+YRVqMI9LjGB6MSJ9DwYs9fA2VrperznHCKCVDB977JjqsZOdR0zBM8RF
         k/pB3sRasTrJegVoogWF+81ZA3QemXpP5b619PFG9c8bMCktwoDP5s5A5cTXUKxpAQ
         ZsYD6a29Z55GA==
Date:   Fri, 17 Mar 2023 11:25:59 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_db: fix complaints about unsigned char casting
Message-ID: <20230317102559.agpsaa2fmgd32mc6@andromeda>
References: <yd5KB_VD7Oe2M-1JTpW8yKsKQ7SaQV9hnFIguCvPI-CuHqrQHOECUVh2Ar9oGpOi5jLK1LKpQ0D_NqN-kz5eyw==@protonmail.internalid>
 <20230315010110.GD11376@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315010110.GD11376@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 14, 2023 at 06:01:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make the warnings about signed/unsigned char pointer casting go away.
> For printing dirent names it doesn't matter at all.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good, will test.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  db/namei.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/db/namei.c b/db/namei.c
> index 00e8c8dc6d5..063721ca98f 100644
> --- a/db/namei.c
> +++ b/db/namei.c
> @@ -98,7 +98,7 @@ path_navigate(
> 
>  	for (i = 0; i < dirpath->depth; i++) {
>  		struct xfs_name	xname = {
> -			.name	= dirpath->path[i],
> +			.name	= (unsigned char *)dirpath->path[i],
>  			.len	= strlen(dirpath->path[i]),
>  		};
> 
> @@ -250,7 +250,7 @@ dir_emit(
>  	uint8_t			dtype)
>  {
>  	char			*display_name;
> -	struct xfs_name		xname = { .name = name };
> +	struct xfs_name		xname = { .name = (unsigned char *)name };
>  	const char		*dstr = get_dstr(mp, dtype);
>  	xfs_dahash_t		hash;
>  	bool			good;

-- 
Carlos Maiolino
