Return-Path: <SRS0=BjFQ=46=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4449C10DCE
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 05:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90EFD20724
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Mar 2020 05:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgCMFDr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Mar 2020 01:03:47 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40324 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbgCMFDr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Mar 2020 01:03:47 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5275B3A4A4D;
        Fri, 13 Mar 2020 16:03:43 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jCcU1-0007GD-QW; Fri, 13 Mar 2020 16:03:41 +1100
Date:   Fri, 13 Mar 2020 16:03:41 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Tommi Rantala <tommi.t.rantala@nokia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix regression in "cleanup xfs_dir2_block_getdents"
Message-ID: <20200313050341.GO10776@dread.disaster.area>
References: <20200312085728.22187-1-tommi.t.rantala@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312085728.22187-1-tommi.t.rantala@nokia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=9qxNCY_qAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=k_IqvGaJn7LPgz7umq4A:9 a=6ka8if1nHYrFWHRd:21 a=7qgZNAMl8ypy7hTT:21
        a=CjuIK1q_8ugA:10 a=A2X48xt2e1hG9NJDz63Y:22 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 10:57:28AM +0200, Tommi Rantala wrote:
> Commit 263dde869bd09 ("xfs: cleanup xfs_dir2_block_getdents") introduced
> a getdents regression, when it converted the pointer arithmetics to
> offset calculations: offset is updated in the loop already for the next
> iteration, but the updated offset value is used incorrectly in two
> places, where we should have used the not-yet-updated value.
> 
> This caused for example "git clean -ffdx" failures to cleanup certain
> directory structures when running in a container.
> 
> Fix the regression by making sure we use proper offset in the loop body.
> Thanks to Christoph Hellwig for suggestion how to best fix the code.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Fixes: 263dde869bd09 ("xfs: cleanup xfs_dir2_block_getdents")
> Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>

Needs a "cc: stable@kernel.org" tag, right?

> ---
>  fs/xfs/xfs_dir2_readdir.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 0d3b640cf1cc..871ec22c9aee 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -147,7 +147,7 @@ xfs_dir2_block_getdents(
>  	xfs_off_t		cook;
>  	struct xfs_da_geometry	*geo = args->geo;
>  	int			lock_mode;
> -	unsigned int		offset;
> +	unsigned int		offset, next_offset;
>  	unsigned int		end;
>  
>  	/*
> @@ -173,9 +173,10 @@ xfs_dir2_block_getdents(
>  	 * Loop over the data portion of the block.
>  	 * Each object is a real entry (dep) or an unused one (dup).
>  	 */
> -	offset = geo->data_entry_offset;
>  	end = xfs_dir3_data_end_offset(geo, bp->b_addr);
> -	while (offset < end) {
> +	for (offset = geo->data_entry_offset;
> +	     offset < end;
> +	     offset = next_offset) {
>  		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
>  		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
>  		uint8_t filetype;
> @@ -184,14 +185,15 @@ xfs_dir2_block_getdents(
>  		 * Unused, skip it.
>  		 */
>  		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
> -			offset += be16_to_cpu(dup->length);
> +			next_offset = offset + be16_to_cpu(dup->length);
>  			continue;
>  		}
>  
>  		/*
>  		 * Bump pointer for the next iteration.
>  		 */
> -		offset += xfs_dir2_data_entsize(dp->i_mount, dep->namelen);
> +		next_offset = offset +
> +			xfs_dir2_data_entsize(dp->i_mount, dep->namelen);

Code looks fine, though.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
