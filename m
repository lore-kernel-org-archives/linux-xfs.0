Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75638C4167D
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 16:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjKIQNX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 11:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjKIQNW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 11:13:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4BA3272
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2023 08:13:20 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B411C433C7;
        Thu,  9 Nov 2023 16:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699546400;
        bh=yhCR7Dz1EJMUW5KQ2ahXpNvfH3rssBr1uC9t7m4qKXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nEErO+wwudjIVe1AJy2R83vxUm7xq5ey/Aq957SERYSR9WJUQ4DZEkoqmpYi3Tolp
         +om31HPIhx8hNKYIK4XW0hiBLNwN/wvBTGOYM1bcLWUf4KWX31mO//G8DRqoFi44e/
         b/3Mz800Li0dY8MApRbSUp3zr/nEFnNNyMpb5NN8zB6qOR4JfneJQvZWI6iMeNvnQJ
         fDlEypTH+MOaa1Tq+8LXmsr7hEzpgI8RuJD0Qy6DceNifsPNrLnWARDKFMg4wxRNeK
         dMbaHDUeQn+HJIqjapatkiMQT8fq/V9rCA6FkX3HvEqJkgYoodfmfsFP1RZiX0UXXu
         CA73tBC5ZvEGQ==
Date:   Thu, 9 Nov 2023 08:13:19 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] repair: fix the call to search_rt_dup_extent in
 scan_bmapbt
Message-ID: <20231109161319.GF1205143@frogsfrogsfrogs>
References: <20231109160233.703566-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231109160233.703566-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 09, 2023 at 05:02:33PM +0100, Christoph Hellwig wrote:
> search_rt_dup_extent expects an RT extent number and not a fsbno.
> Convert the units before the call.  Without this we are unlikely
> to ever found a legit duplicate extent on the RT subvolume because
> the search will always be off the end.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks familiar! :)

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

In the longer run: whenever the libxfs 6.7 sync hits the list, I'll be
ready to go with a pair of broader patches to fix all the confusing /
incorrect units and variable names in xfs_repair.  This ought to get
merged to xfsprogs 6.6.

--D

> ---
>  repair/scan.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/repair/scan.c b/repair/scan.c
> index 27a33286a..7a0587615 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -402,8 +402,10 @@ _("bad state %d, inode %" PRIu64 " bmap block 0x%" PRIx64 "\n"),
>  					XFS_FSB_TO_AGBNO(mp, bno) + 1))
>  				return(1);
>  		} else  {
> -			if (search_rt_dup_extent(mp, bno))
> -				return(1);
> +			xfs_rtblock_t	ext = bno / mp->m_sb.sb_rextsize;
> +
> +			if (search_rt_dup_extent(mp, ext))
> +				return 1;
>  		}
>  	}
>  	(*tot)++;
> -- 
> 2.39.2
> 
