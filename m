Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B50C77B7C
	for <linux-xfs@archiver.kernel.org>; Wed, 10 May 2023 14:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237045AbjEJOAh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 May 2023 10:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236367AbjEJOAf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2023 10:00:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D254430C0
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2023 07:00:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFBA464950
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2023 14:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E05C4339B;
        Wed, 10 May 2023 14:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683727232;
        bh=CayqfsTXEblZmWU5E4RrUqkfSsDLuAglOqb0AEfAi+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kc/n5g0g61YLFwOCHnbTe+7JIhfKDbfabCMsqxZs69m2oE/1S0rDEgAzfr7lXQ7EX
         szc3G982AvFReOW01BPVw4v/YqIkpJY7Cr8LbdItmdUDLI/BAwx9droffbGkwXgqzb
         PEj2obNXVhRCzsgGfapu/LJbrJMRjrTivZOXEs/pSlU/XU3WVpdFM634nRadvzdRvs
         +5yPxoj6dIIVV9F0+dt7ZKDpZeDcczZGkeP8Lg7ojIcqVluw6I3mx7yYgcKTFzoIgZ
         rGt+ZLE1qZpqwpMGLGKrf7GdL8P/+Xixv+g71LDXfnXhwZTouZj5o7Ie1CTa5HWV9P
         cpGV5rY16jrxw==
Date:   Wed, 10 May 2023 16:00:27 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: dont leak buffer when discarding directories
Message-ID: <20230510140027.irjroa5duvbpkvb2@andromeda>
References: <hisABZGtTerz9q4LHi-k52Q9qnsVnsnnpL0ZyXEQleLbIaF5zCFcA_URJ65VWBQpaCD_1oSQW9iBbmheoPZ8TA==@protonmail.internalid>
 <20230503151515.GD15394@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503151515.GD15394@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 03, 2023 at 08:15:15AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Commit 1f7c7553489c tried to reduce the memory requirements of phase 6
> of repair by redesigning longform_dir2_entry_check without the bplist
> array.  Unfortunately, none of us noticed that the code that rejects a
> dir block with a bad header now leaks the xfs_buf object because we no
> longer have a bplist to drop the buffer references.  Any time we hold a
> buffer and decide to move on in the dabno loop, we must release the
> buffer.
> 
> The immediate result of this error is that dir_binval complains about
> the recursive lock count of the buffer when we blow out the directory.
> However, if the block is reallocated by another thread, repair will
> deadlock when it tries to get the buffer and cannot take the buffer
> lock.
> 
> Found via xfs/113 fuzzing data format directory blocks.  For whatever
> reason this happens much more frequently when su=128k,sw=4, but this
> applies to everyone equally.
> 
> While we're at it, make the relse at the bottom of the function run for
> any remaining buffer reference, even if this isn't a block format
> directory to avoid leaving a landmine in case we ever add a "goto
> fix" inside the loop for a non-block directory.
> 
> Fixes: 1f7c7553489 ("repair: don't duplicate names in phase 6")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  repair/phase6.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 0be2c9c9705..48bf57359c5 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -2332,6 +2332,9 @@ longform_dir2_entry_check(
>  				fixit++;
>  				if (isblock)
>  					goto out_fix;
> +
> +				libxfs_buf_relse(bp);
> +				bp = NULL;
>  				continue;
>  			}
>  		}
> @@ -2343,6 +2346,7 @@ longform_dir2_entry_check(
>  			break;
> 
>  		libxfs_buf_relse(bp);
> +		bp = NULL;
>  	}
>  	fixit |= (*num_illegal != 0) || dir2_is_badino(ino) || *need_dot;
> 
> @@ -2370,7 +2374,7 @@ longform_dir2_entry_check(
>  		}
>  	}
>  out_fix:
> -	if (isblock && bp)
> +	if (bp)
>  		libxfs_buf_relse(bp);
> 
>  	if (!no_modify && (fixit || dotdot_update)) {

-- 
Carlos Maiolino
