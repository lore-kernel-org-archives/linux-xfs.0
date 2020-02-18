Return-Path: <SRS0=Vmdp=4G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC05C34022
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 02:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69DC5206D5
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 02:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgBRCGW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 21:06:22 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60646 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726171AbgBRCGW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 21:06:22 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DAFA93A21B5;
        Tue, 18 Feb 2020 13:06:18 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j3sHC-0004pv-Aa; Tue, 18 Feb 2020 13:06:18 +1100
Date:   Tue, 18 Feb 2020 13:06:18 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 28/31] xfs: clean up the ATTR_REPLACE checks
Message-ID: <20200218020618.GC10776@dread.disaster.area>
References: <20200217125957.263434-1-hch@lst.de>
 <20200217125957.263434-29-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217125957.263434-29-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=rodXayeNqxarreyLawAA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 01:59:54PM +0100, Christoph Hellwig wrote:
> Remove superflous braces, elses after return statements and use a goto
> label to merge common error handling.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 3b1db2afb104..9c629c7c912d 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -423,9 +423,9 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>  	trace_xfs_attr_sf_addname(args);
>  
>  	retval = xfs_attr_shortform_lookup(args);
> -	if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
> +	if ((args->flags & ATTR_REPLACE) && retval == -ENOATTR)
>  		return retval;
> -	} else if (retval == -EEXIST) {
> +	if (retval == -EEXIST) {
>  		if (args->flags & ATTR_CREATE)
>  			return retval;

If we are cleaning up this code, I'd prefer that the retval vs flags
order was made consistent. i.e.

	if (retval == -ENOATTR && (args->flags & ATTR_REPLACE))
		return retval;
	if (retval == -EEXIST) {
		 if (args->flags & ATTR_CREATE)
			return retval;
	.....

Because then it is clear we are stacking error conditions that are
only relevant to specific operations.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
