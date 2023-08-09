Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8203C41513
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Aug 2023 13:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjHINJM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Aug 2023 09:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjHINJL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2023 09:09:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B74B1FF9;
        Wed,  9 Aug 2023 06:09:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01D4D639CD;
        Wed,  9 Aug 2023 13:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73691C433C8;
        Wed,  9 Aug 2023 13:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691586550;
        bh=RP3a1yCokfgzUe01alZGGBBHrvBOhkP0Oj8s3lt3FLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A3qf0Solz/HQtLEfafinM+HaCYc8Ft1YmkZBmDztHwy6j6yR8EQCuObDGd++0B5bQ
         Wv2bnzQIp/uoasevq+oEInQzVuhjReDedDNDONveL7reIqCveZr/6fRzhsNubOxGJX
         FHhm8jzIj9iCI4nxnCX2txwi3LHpQc/8in3sNGbsiWeLCaRDATmUpYEF8Vv7Xamihw
         LDhj03safM2CiKKDW0zWV+xL9N5/YECvXBeDOX9drm0KP8ZGfd9bgZ2qCcWAMawtkD
         17IWyurnx8xaB0bn6dj7SE57vzQylpmSjU4TdMMc3aw4qSW9lRNdpHArymx/wtcNVQ
         98M0uLkuBljcg==
Date:   Wed, 9 Aug 2023 15:09:04 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, sandeen@sandeen.net, amir73il@gmail.com,
        leah.rumancik@gmail.com, zlang@kernel.org, fstests@vger.kernel.org,
        willy@infradead.org, shirley.ma@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH 3/3] MAINTAINERS: add Chandan Babu as XFS release manager
Message-ID: <20230809130904.veisiszzzssp6ohr@andromeda>
References: <169116629797.3243794.7024231508559123519.stgit@frogsfrogsfrogs>
 <RxME8o56Hr2QxC47qqkEkiU90SY26D2ubgubhreqqss6dZP5GfdYjpy_mDZyHLGDeOrPceqWuPwPJ4jX3SM_Gg==@protonmail.internalid>
 <169116631533.3243794.12031505140377581673.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169116631533.3243794.12031505140377581673.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 04, 2023 at 09:25:15AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I nominate Chandan Babu to take over release management for the upstream
> kernel's XFS code.  He has had sufficient experience merging backports
> to the 5.4 LTS tree, testing them, and sending them on to the LTS leads.
> 
> NOTE: I am /not/ nominating Chandan to take on any of the other roles I
> have just dropped.  Bug triager, testing lead, and community manager are
> open positions that need to be filled.  There's also maintainer for
> supported LTS releases (4.14, 4.19, 5.10...).
> 
> Cc: Chandan Babu R <chandan.babu@oracle.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Acked-by: Chandan Babu R <chandan.babu@oracle.com>

Reviewed-by: Carlos Maiolino <cem@kernel.org>

> ---
>  MAINTAINERS |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d6b82aac42a4..f059e7c30f90 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -23324,6 +23324,7 @@ F:	include/xen/arm/swiotlb-xen.h
>  F:	include/xen/swiotlb-xen.h
> 
>  XFS FILESYSTEM
> +M:	Chandan Babu R <chandan.babu@oracle.com>
>  R:	Darrick J. Wong <djwong@kernel.org>
>  L:	linux-xfs@vger.kernel.org
>  S:	Supported
> 
