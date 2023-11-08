Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0336BC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 18:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjKHSIb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 13:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjKHSIa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 13:08:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881E8186
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 10:08:28 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D34C433C9;
        Wed,  8 Nov 2023 18:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699466908;
        bh=Skh+n18tbifsPIhewvC/rbaSVXdREsJScBGvpl6nUl8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qt2KATz9Sr03WIoD/bFBtiaI3w2ja3961+CBaAjCQgfvNK5IvKg63/ywka7s6+gI3
         S+99/+4+v0Iyp8nsvNLBxLTOPLb1KjQqfuUrof5pIMhE+8oRVuBmI0hWck0o1jOhJp
         yz7cyanEwsHPRLcnIDxLBc19XPGi/SwS4tySXKGoewQtdjgJm/tfNVVLQtNKKS/SfF
         HhGxRa2GK0qA5KU13Qjem+SfIDnISBhOrfxXrq/PjXhZ/t0ib0XpfEsl7JaiQVGrE/
         VpMzQ1iXZuKZMnY6nuc0rZ58VmuBQBtj++/SfNHzXe+DlAy/LQtkbslQ6rIHfFU9ru
         aPyZI8oOtx1/w==
Date:   Wed, 8 Nov 2023 10:08:27 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] repair: fix process_rt_rec_dups
Message-ID: <20231108180827.GW1205143@frogsfrogsfrogs>
References: <20231108175320.500847-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231108175320.500847-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 08, 2023 at 06:53:20PM +0100, Christoph Hellwig wrote:
> search_rt_dup_extent takes a xfs_rtblock_t, not an RT extent number.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> 
> What scares me about this is that no test seems to hit this and report
> false duplicates.  I'll need to see if I can come up with an
> artifical reproducers of some kind.

I think you've misread the code -- phase 4 builds the rt_dup tree by
walks all the rtextents, and adding the duplicates:

	for (rtx = 0; rtx < mp->m_sb.sb_rextents; rtx++)  {
		bstate = get_rtbmap(rtx);
		switch (bstate)  {
			...
		case XR_E_FS_MAP:
			if (rt_start == 0)
				continue;
			else  {
				/*
				 * add extent and reset extent state
				 */
				add_rt_dup_extent(rt_start, rt_len);
				rt_start = 0;
				rt_len = 0;
			}
			break;
		case XR_E_MULT:
			if (rt_start == 0)  {
				rt_start = rtx;
				rt_len = 1;
			} else if (rt_len == XFS_MAX_BMBT_EXTLEN)  {
				/*
				 * large extent case
				 */
				add_rt_dup_extent(rt_start, rt_len);
				rt_start = rtx;
				rt_len = 1;
			} else
				rt_len++;
			break;

So I think the reason why you've never seen false duplicates is that the
rt_dup tree intervals measure rt extents, not rt blocks.  The units
conversion in process_rt_rec_dups is correct.

However, none of that is at all obvious because of the dual uses of
xfs_rtblock_t for rt blocks and rt extents.

I guess I ought to post the xfsprogs version of those rt units cleanups.
:)

--D

>  repair/dinode.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index c10dd1fa3..9aa367138 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -194,13 +194,11 @@ process_rt_rec_dups(
>  	struct xfs_bmbt_irec	*irec)
>  {
>  	xfs_fsblock_t		b;
> -	xfs_rtblock_t		ext;
>  
>  	for (b = rounddown(irec->br_startblock, mp->m_sb.sb_rextsize);
>  	     b < irec->br_startblock + irec->br_blockcount;
>  	     b += mp->m_sb.sb_rextsize) {
> -		ext = (xfs_rtblock_t) b / mp->m_sb.sb_rextsize;
> -		if (search_rt_dup_extent(mp, ext))  {
> +		if (search_rt_dup_extent(mp, b))  {
>  			do_warn(
>  _("data fork in rt ino %" PRIu64 " claims dup rt extent,"
>  "off - %" PRIu64 ", start - %" PRIu64 ", count %" PRIu64 "\n"),
> -- 
> 2.39.2
> 
