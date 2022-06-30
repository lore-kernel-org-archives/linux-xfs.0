Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B01DBC43334
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jun 2022 00:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbiF3AlD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 20:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiF3AlC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 20:41:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73763FBF2
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 17:41:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 762F2B82615
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jun 2022 00:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D67C34114;
        Thu, 30 Jun 2022 00:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656549659;
        bh=HDi3wLJoR4iXmDGPpJqXjrIMG8FVwZOo8HdKmZbgekw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TYBQNY9FZirm8va8U/3N+8H3rfzq4a+Zcomero1BZ3ikVfsB03gLq1eDqhgmLnKfw
         uEDU8BM8jOmkBDiA2eLwZpVxrkREA0epwQlnNuo1IhBO1KVGj2eUnQMcB7H5kACqlP
         LRAyAvQvSKoaetqNbL/4SSFNODxCOFDi7KjSIrkhPCHEc8sQp/tH77mvru69YfS99H
         DQIqr922n+gq5kILfVeFaT5mVdpLVrqj13Gl/dPKDZeCStoWBnZaW0MBObRSTzvEBJ
         CfCGauwfDQSQAB6DNrUj1vKlbQvU0PyANch2Lq7IOKBnKFq1+nAmiNDY1RtlqHdkPS
         ebvWNRCVbhQjA==
Date:   Wed, 29 Jun 2022 17:40:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [5.15] MAINTAINERS: add Leah as xfs maintainer for 5.15.y
Message-ID: <YrzxGtGQvWXfCKnq@magnolia>
References: <20220629235546.3843096-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629235546.3843096-1-leah.rumancik@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 29, 2022 at 04:55:46PM -0700, Leah Rumancik wrote:
> Update MAINTAINERS for xfs in an effort to help direct bots/questions
> about xfs in 5.15.y.
> 
> Note: 5.10.y [1] and 5.4.y will have different updates to their
> respective MAINTAINERS files for this effort.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>

LGTM for 5.15
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> [1] https://lore.kernel.org/linux-xfs/20220629213236.495647-1-amir73il@gmail.com/
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 393706e85ba2..a60d7e0466af 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20579,6 +20579,7 @@ F:	drivers/xen/*swiotlb*
>  
>  XFS FILESYSTEM
>  C:	irc://irc.oftc.net/xfs
> +M:	Leah Rumancik <leah.rumancik@gmail.com>
>  M:	Darrick J. Wong <djwong@kernel.org>
>  M:	linux-xfs@vger.kernel.org
>  L:	linux-xfs@vger.kernel.org
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
> 
