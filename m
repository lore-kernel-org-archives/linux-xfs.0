Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0614C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 19:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjKJTgH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Nov 2023 14:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236025AbjKJTfY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2023 14:35:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0AB5BA0
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2023 11:32:56 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E338DC433C9;
        Fri, 10 Nov 2023 19:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699644776;
        bh=jXyYNtS7Hffg9VNAIkY+NMOh1kxve6qy26oKkXAoZTE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O/Xnz/BSYq39dzI53wAX9NFqHnsSyf/SGF9jvLaGZdFYBAZ4C92M96VFAVwgulji/
         AdK9Z+DBX0ehYoCxtm2HxDYlcjRW/ZVZP8bZdPdO+HffNs9Ru7WLjwyOLhuajlCs7f
         RfSR8swQSUmIK7RgiV7qmvcLqSVLs//XCYVGExkSSvFco8qD/MFJrV9sMPkbfx9nv+
         pCttajgkxRzXs1BW41MZwDroMjxlQSS7d4KVYCdA9IZ8Nl6ntbyG9M2Wz9Zw5/TtqW
         +ZYCiQEDqndl8zZM43TzZLmvUeXmFFrvGPOJG4VBPbQimKFtB6pxLnD1X7ihDw92qO
         LG9J0v25cWJeg==
Date:   Fri, 10 Nov 2023 11:32:55 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH 2/2] xfs: recovery should not clear di_flushiter
 unconditionally
Message-ID: <20231110193255.GK1205143@frogsfrogsfrogs>
References: <20231110044500.718022-1-david@fromorbit.com>
 <20231110044500.718022-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231110044500.718022-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 10, 2023 at 03:33:14PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because on v3 inodes, di_flushiter doesn't exist. It overlaps with
> zero padding in the inode, except when NREXT64=1 configurations are
> in use and the zero padding is no longer padding but holds the 64
> bit extent counter.
> 
> This manifests obviously on big endian platforms (e.g. s390) because
> the log dinode is in host order and the overlap is the LSBs of the
> extent count field. It is not noticed on little endian machines
> because the overlap is at the MSB end of the extent count field and
> we need to get more than 2^^48 extents in the inode before it
> manifests. i.e. the heat death of the universe will occur before we
> see the problem in little endian machines.
> 
> This is a zero-day issue for NREXT64=1 configuraitons on big endian
> machines. Fix it by only clearing di_flushiter on v2 inodes during
> recovery.
> 
> Fixes: 9b7d16e34bbe ("xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers")
> cc: stable@kernel.org # 5.19+
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode_item_recover.c | 32 +++++++++++++++++---------------
>  1 file changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index f4c31c2b60d5..dbdab4ce7c44 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -371,24 +371,26 @@ xlog_recover_inode_commit_pass2(
>  	 * superblock flag to determine whether we need to look at di_flushiter
>  	 * to skip replay when the on disk inode is newer than the log one
>  	 */
> -	if (!xfs_has_v3inodes(mp) &&
> -	    ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
> -		/*
> -		 * Deal with the wrap case, DI_MAX_FLUSH is less
> -		 * than smaller numbers
> -		 */
> -		if (be16_to_cpu(dip->di_flushiter) == DI_MAX_FLUSH &&
> -		    ldip->di_flushiter < (DI_MAX_FLUSH >> 1)) {
> -			/* do nothing */
> -		} else {
> -			trace_xfs_log_recover_inode_skip(log, in_f);
> -			error = 0;
> -			goto out_release;
> +	if (!xfs_has_v3inodes(mp)) {
> +		if (ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
> +			/*
> +			 * Deal with the wrap case, DI_MAX_FLUSH is less
> +			 * than smaller numbers
> +			 */
> +			if (be16_to_cpu(dip->di_flushiter) == DI_MAX_FLUSH &&
> +			    ldip->di_flushiter < (DI_MAX_FLUSH >> 1)) {
> +				/* do nothing */
> +			} else {
> +				trace_xfs_log_recover_inode_skip(log, in_f);
> +				error = 0;
> +				goto out_release;
> +			}
>  		}
> +
> +		/* Take the opportunity to reset the flush iteration count */
> +		ldip->di_flushiter = 0;

Hmm.  Well this fixes the zeroday problem, so thank you for getting the
root of this!

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Though hch did suggest reducing the amount of indenting here by
compressing the if tests together.  I can't decide if it's worth
rearranging that old V4 code since none of it's scheduled for removal
until 2030, but it /is/ legacy code that maybe we just don't care to
touch?

<shrug>

--D

>  	}
>  
> -	/* Take the opportunity to reset the flush iteration count */
> -	ldip->di_flushiter = 0;
>  
>  	if (unlikely(S_ISREG(ldip->di_mode))) {
>  		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
> -- 
> 2.42.0
> 
