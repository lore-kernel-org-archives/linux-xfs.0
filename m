Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA9AAC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 23:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238569AbiEJXy2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 19:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238550AbiEJXy1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 19:54:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F6A1F8C63
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 16:54:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E62660EDA
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 23:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9828C385CC;
        Tue, 10 May 2022 23:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652226865;
        bh=sF/0rwHwZSUFOna2mmIAd7HbXUj63ZKkx35ikNodm0M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BUsMn0RWW/IUGLH8BU5PIFCRJQ4dQfG+7WQSkqs4oQgQktty+9YMqzEGhtIYC+Dds
         Ni5LEyxKEXRthkWND14JpNQHbksx3E45wcIu7T5lJz4OqTAem+O7VEzZnubyGTOmwT
         fZ2Aveyc3IMFC/gwrUFnyLkGLYNaFUaUjf1joDaejE5W9zGSOIf4C8yGX2UXvt8HSh
         hBBfn0bfca7oDny6J6In7NHmSMAYP7iXFyg73m4qLBjkizdg1YguLa4zXLOMyLx/yH
         5JJ34jgCW5GBHKNBrWSoKcgNiaiVWgReE/rqziSZhk54FhMBttBfXuhiC64XGnCJQH
         mlhO4hIr7UdKQ==
Date:   Tue, 10 May 2022 16:54:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/18] xfs: detect empty attr leaf blocks in
 xfs_attr3_leaf_verify
Message-ID: <20220510235425.GW27195@magnolia>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-19-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509004138.762556-19-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 09, 2022 at 10:41:38AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_repair flags these as a corruption error, so the verifier should
> catch software bugs that result in empty leaf blocks being written
> to disk, too.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index d15e92858bf0..15a990409463 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -310,6 +310,15 @@ xfs_attr3_leaf_verify(
>  	if (fa)
>  		return fa;
>  
> +	/*
> +	 * Empty leaf blocks should never occur;  they imply the existence of a
> +	 * software bug that needs fixing. xfs_repair also flags them as a
> +	 * corruption that needs fixing, so we should never let these go to
> +	 * disk.
> +	 */
> +	if (ichdr.count == 0)
> +		return __this_address;
> +
>  	/*
>  	 * firstused is the block offset of the first name info structure.
>  	 * Make sure it doesn't go off the block or crash into the header.
> -- 
> 2.35.1
> 
