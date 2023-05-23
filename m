Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9BAC7EE26
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 16:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbjEWQdA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 12:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234390AbjEWQc7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 12:32:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2261E18F
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 09:32:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A71862862
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 16:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23B1C4339B;
        Tue, 23 May 2023 16:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684859573;
        bh=3dFDp7cJ7YwqY4eYv6VARq7alMYZaAKhPQJ1Y0ST6tM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XmU9wYVOw1GZcRCfwBWZlMEW8FbCoUULeVR10HAJG2/LzA5AczM+YZzghWpwK6HAo
         onIS5ekMaxhKKMAYN3bT1zAj8IepXjnKQrMOdARlc07Pa7oR/nWClbVRYAfSIw0DLN
         vfxu62nAR0GlkkKSTpXjYgmRNgcLIzsprmvrWbqnIwXrwbe/8BBo4WnvSy+y8lYhJa
         YpssYmdDd5RF730EPzKqGeFXw+o4H9hwcyLfwB/oHL0i+UASZ/mszRPFFsjjAwzF8I
         IiBa0vmA7q1IZumCPstenR+RC1Gz5wXuih5me0blDqVN9h+kr+Q7qyB1LJVlWGu1iq
         iEzYuX1BGBjuw==
Date:   Tue, 23 May 2023 09:32:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/24] mdrestore: Fix logic used to check if target
 device is large enough
Message-ID: <20230523163253.GI11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-3-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-3-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:28PM +0530, Chandan Babu R wrote:
> The device size verification code should be writing XFS_MAX_SECTORSIZE bytes
> to the end of the device rather than "sizeof(char *) * XFS_MAX_SECTORSIZE"
> bytes.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Yikes.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  mdrestore/xfs_mdrestore.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 7c1a66c40..333282ed2 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -115,7 +115,7 @@ perform_restore(
>  	} else  {
>  		/* ensure device is sufficiently large enough */
>  
> -		char		*lb[XFS_MAX_SECTORSIZE] = { NULL };
> +		char		lb[XFS_MAX_SECTORSIZE] = { 0 };
>  		off64_t		off;
>  
>  		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
> -- 
> 2.39.1
> 
