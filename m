Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62AF7C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jul 2022 03:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbiGEDzm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jul 2022 23:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234670AbiGEDzl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jul 2022 23:55:41 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38EF613CD0
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jul 2022 20:55:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EE8E05ED2BE;
        Tue,  5 Jul 2022 13:55:37 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o8Zey-00EhHL-7k; Tue, 05 Jul 2022 13:55:36 +1000
Date:   Tue, 5 Jul 2022 13:55:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Srikanth C S <srikanth.c.s@oracle.com>
Cc:     linux-xfs@vger.kernel.org, rajesh.sivaramasubramaniom@oracle.com,
        junxiao.bi@oracle.com
Subject: Re: [PATCH] mkfs: custom agcount that renders AG size <
 XFS_AG_MIN_BYTES gives "Assertion failed. Aborted"
Message-ID: <20220705035536.GE227878@dread.disaster.area>
References: <20220705031958.407-1-srikanth.c.s@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705031958.407-1-srikanth.c.s@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62c3b63a
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=-CCH5FmnQdtOtD79zLcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 05, 2022 at 08:49:58AM +0530, Srikanth C S wrote:
> For a 2GB FS we have
> $ mkfs.xfs -f -d agcount=129 test.img
> mkfs.xfs: xfs_mkfs.c:3021: align_ag_geometry: Assertion `!cli_opt_set(&dopts, D_AGCOUNT)' failed.
> Aborted

Ok, that's because the size of the last AG is too small when trying
to align the AG size to stripe geometry. It fails an assert that
says "we should not get here if the agcount was specified on the
CLI".

> 
> With this change we have
> $ mkfs.xfs -f -d agcount=129 test.img
> Invalid value 129 for -d agcount option. Value is too large.

OK, but....

> 
> Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
> ---
>  mkfs/xfs_mkfs.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 057b3b09..32dcbfff 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2897,6 +2897,13 @@ _("agsize (%s) not a multiple of fs blk size (%d)\n"),
>  		cfg->agcount = cli->agcount;
>  		cfg->agsize = cfg->dblocks / cfg->agcount +
>  				(cfg->dblocks % cfg->agcount != 0);
> +		if (cfg->agsize < XFS_AG_MIN_BYTES >> cfg->blocklog)
> +		{
> +			fprintf(stderr,
> +_("Invalid value %lld for -d agcount option. Value is too large.\n"),
> +				(long long)cli->agcount);
> +			usage();	
> +		}

.... that's not where we validate the calculated ag size. That
happens via align_ag_geometry() -> validate_ag_geometry(). i.e. we
can't reject an AG specification until after we've applied all the
necessary modifiers to it first (such as stripe alignment
requirements).

IOWs, we do actually check for valid AG sizes, it's just that this
specific case hit an ASSERT() check before we got to validating the
AG size. I'm pretty sure just removing the ASSERT - which assumes
that "-d agcount=xxx" is not so large that it produces undersized
AGs - will fix the problem and result in the correct error message
being returned.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
