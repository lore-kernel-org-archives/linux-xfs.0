Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1CFBEDEC4D
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Sep 2023 12:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbjIMMul (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Sep 2023 08:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbjIMMuk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2023 08:50:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6299E19B1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Sep 2023 05:50:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329A1C433C7;
        Wed, 13 Sep 2023 12:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694609436;
        bh=zO/PSdcISQb+nRSXdfiHgPlB4Eaz/ttzxvFJZrhMoKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FqLLvyVcItAWoKpZySUTtPddfhWg6cxoT3nEVWgVTdc9qCuW+EbRJ0cu3pwZJjUS+
         4paHeEoIpdHFQj2n8EC0B5T8cGnEi0mx2EQDHSGXlraQTkYBF+GTrgSd8+Evkw08HM
         Oi1NUDqcM8fl/KNXmLw6jiMB7sKCNRJk/tJJHkTsRdCL6SfGRlL+zKLKz4PDA3KMWE
         2U7+D49fbYZ+kyarw3c2GuCU08SmSN0b5yLrMTpM5wpvKeJEYr3sHBU6O+b8tjGkEn
         wDCL+IOWMpSj8qql9pc98cRgb+v9oPPqpAw/LZPXTrJI8A/hAEhQmM7aKmi7Up75ps
         67QZ//3WXPL8Q==
Date:   Wed, 13 Sep 2023 14:50:32 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] libfrog: don't fail on XFS_FSOP_GEOM_FLAGS_NREXT64
 in xfrog_bulkstat_single5
Message-ID: <20230913125032.eecxnndvo2rr5udr@andromeda>
References: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
 <NF8rVwlXGIHrvtDGbhB883YSSmB9e5S4z8J5TkeebTXOqW5RK6Fe7rg78kd5YjVZhwXUvmrxgmkdTaK1HlRkbw==@protonmail.internalid>
 <169454758720.3539425.12997334128444146623.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169454758720.3539425.12997334128444146623.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 12, 2023 at 12:39:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This flag is perfectly acceptable for bulkstatting a single file;
> there's no reason not to allow it.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> ---
>  libfrog/bulkstat.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
> index 0a90947fb29..c863bcb6bf8 100644
> --- a/libfrog/bulkstat.c
> +++ b/libfrog/bulkstat.c
> @@ -53,7 +53,7 @@ xfrog_bulkstat_single5(
>  	struct xfs_bulkstat_req		*req;
>  	int				ret;
> 
> -	if (flags & ~(XFS_BULK_IREQ_SPECIAL))
> +	if (flags & ~(XFS_BULK_IREQ_SPECIAL | XFS_BULK_IREQ_NREXT64))
>  		return -EINVAL;
> 
>  	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)
> 
