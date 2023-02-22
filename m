Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE6BC6379F
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Feb 2023 08:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjBVIox (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Feb 2023 03:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbjBVIox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Feb 2023 03:44:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F872E815
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2023 00:44:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACD1CB811F9
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2023 08:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FE4C433D2;
        Wed, 22 Feb 2023 08:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677055489;
        bh=jmmVDDwn5W3rHtvd7LDH8qkKlGhg/egjBmSeAA9b/F8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WCEpuXbcxBY7dgsVQq/jCpCPkhskf0jsz7XVFpgLv0WMgb6NHTim1WOZ/pTbBfNNk
         WlnanTdQOd3B1mTLWj4+YO08opjYJ2GgNkdpWct0dGXwSzh1BmFNBmsrv0oNOgVQ+t
         WLRXHVkBdqwFa9nZPMST2NUSgLzyMWKtPg5Ux6IC90CAb8e3RhnRXqMsREBCgOU2m0
         JQ7D54Izi1wDFOMRci1P4BurdCghQ6JpW2B9Z8ZrAbBjAdCEPm+/ctKmiW+EU0f7B7
         qYG798A1yqFzkypW4ykT42+YoUgGFdxiYKwGpfmasXCVtcBu4zBzw5PSh2K01DLNcu
         G5zSZ2f1uhHYA==
Date:   Wed, 22 Feb 2023 09:44:44 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, daan.j.demeyer@gmail.com
Subject: Re: [PATCH 2/5] xfs_scrub: fix broken realtime free blocks unit
 conversions
Message-ID: <20230222084444.547gg6kxcx6pe4qh@andromeda>
References: <167658436759.3590000.3700844510708970684.stgit@magnolia>
 <KVsti3gKjhj34K8MX62mKIt3RqKbzz8_drUjIBi29WUPe5QO4xoDcUGrNgXjSi9SV5TwafCj5fxvYEbM_CwVDg==@protonmail.internalid>
 <167658437893.3590000.1698651202541264559.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167658437893.3590000.1698651202541264559.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 16, 2023 at 01:52:58PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> r_blocks is in units of fs blocks, but freertx is in units of realtime
> extents.  Add the missing conversion factor so we don't end up with
> bogus things like this:
> 
> Pretend that sda and sdb are both 100T volumes.
> 
> # mkfs.xfs -f /dev/sda -b -r rtdev=/dev/sdb,extsize=2m
> # mount /dev/sda /mnt -o rtdev=/dev/sdb
> # xfs_scrub -dTvn /mnt
> <snip>
> Phase 7: Check summary counters.
> 3.5TiB data used;  99.8TiB realtime data used;  55 inodes used.
> 2.0GiB data found; 50.0MiB realtime data found; 55 inodes found.
> 55 inodes counted; 0 inodes checked.
> 
> We just created the filesystem, the realtime volume should be empty.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  scrub/fscounters.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/scrub/fscounters.c b/scrub/fscounters.c
> index f21b24e0935..3ceae3715dc 100644
> --- a/scrub/fscounters.c
> +++ b/scrub/fscounters.c
> @@ -138,7 +138,7 @@ scrub_scan_estimate_blocks(
>  	*d_blocks = ctx->mnt.fsgeom.datablocks;
>  	*d_bfree = fc.freedata;
>  	*r_blocks = ctx->mnt.fsgeom.rtblocks;
> -	*r_bfree = fc.freertx;
> +	*r_bfree = fc.freertx * ctx->mnt.fsgeom.rtextsize;
>  	*f_files_used = fc.allocino - fc.freeino;
> 
>  	return 0;
> 

-- 
Carlos Maiolino
