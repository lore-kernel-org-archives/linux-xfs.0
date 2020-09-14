Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A482C43461
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 22:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D190208DB
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 22:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgINWMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 18:12:05 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42353 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725926AbgINWMF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 18:12:05 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 415593A66F5;
        Tue, 15 Sep 2020 08:12:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kHwhd-0001so-GI; Tue, 15 Sep 2020 08:12:01 +1000
Date:   Tue, 15 Sep 2020 08:12:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [PATCH] mkfs.xfs: fix ASSERT on too-small device with stripe
 geometry
Message-ID: <20200914221201.GW12131@dread.disaster.area>
References: <f06e8b9a-d5c8-f91f-8637-0b9f625d9d48@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f06e8b9a-d5c8-f91f-8637-0b9f625d9d48@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=XJ9OtjpE c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=jZl85KHjS9e1rR1d_uAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 01:26:01PM -0500, Eric Sandeen wrote:
> When a too-small device is created with stripe geometry, we hit an
> assert in align_ag_geometry():
> 
> # truncate --size=10444800 testfile
> # mkfs.xfs -dsu=65536,sw=1 testfile 
> mkfs.xfs: xfs_mkfs.c:2834: align_ag_geometry: Assertion `cfg->agcount != 0' failed.
> 
> This is because align_ag_geometry() finds that the size of the last
> (only) AG is too small, and attempts to trim it off.  Obviously 0
> AGs is invalid, and we hit the ASSERT.
> 
> Fix this by skipping the last-ag-trim if there is only one AG, and
> add a new test to validate_ag_geometry() which offers a very specific,
> clear warning if the device (in dblocks) is smaller than the minimum
> allowed AG size.
> 
> Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index a687f385..da8c5986 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1038,6 +1038,15 @@ validate_ag_geometry(
>  	uint64_t	agsize,
>  	uint64_t	agcount)
>  {
> +	/* Is this device simply too small? */
> +	if (dblocks < XFS_AG_MIN_BLOCKS(blocklog)) {
> +		fprintf(stderr,
> +	_("device (%lld blocks) too small, need at least %lld blocks\n"),
> +			(long long)dblocks,
> +			(long long)XFS_AG_MIN_BLOCKS(blocklog));
> +		usage();
> +	}

Ummm, shouldn't this be caught two checks later down by this:

	if (agsize > dblocks) {
               fprintf(stderr,
        _("agsize (%lld blocks) too big, data area is %lld blocks\n"),
                        (long long)agsize, (long long)dblocks);
                        usage();
        }

because the agsize has already been validated to be within
XFS_AG_MIN_BLOCKS() and XFS_AG_MAX_BLOCKS(), so if dblocks is only
10MB then the agsize must be greater than dblocks as the minimum
valid AG size is 16MB....

Also, what's with the repeated agsize < XFS_AG_MIN_BLOCKS(blocklog)
and agsize > XFS_AG_MAX_BLOCKS(blocklog) checks in that function?

> +
>  	if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
>  		fprintf(stderr,
>  	_("agsize (%lld blocks) too small, need at least %lld blocks\n"),
> @@ -2827,11 +2836,12 @@ validate:
>  	 * and drop the blocks.
>  	 */
>  	if (cfg->dblocks % cfg->agsize != 0 &&
> +	     cfg->agcount > 1 &&
>  	     (cfg->dblocks % cfg->agsize < XFS_AG_MIN_BLOCKS(cfg->blocklog))) {
> +printf("%d %d %d\n", cfg->dblocks, cfg->agsize, cfg->dblocks % cfg->agsize);
>  		ASSERT(!cli_opt_set(&dopts, D_AGCOUNT));
>  		cfg->dblocks = (xfs_rfsblock_t)((cfg->agcount - 1) * cfg->agsize);
>  		cfg->agcount--;
> -		ASSERT(cfg->agcount != 0);
>  	}

We should never get here - this assert and code check is correct and
valid - it's pointed us directly to a logic bug in mkfs, so IMO
it should not be changed/removed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
