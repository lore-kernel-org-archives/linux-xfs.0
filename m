Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FCA6C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 23:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiF1XA3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 19:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiF1XA2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 19:00:28 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 476DF37034
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 16:00:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 80E7310E78DC;
        Wed, 29 Jun 2022 09:00:27 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o6KC2-00CFUG-Da; Wed, 29 Jun 2022 09:00:26 +1000
Date:   Wed, 29 Jun 2022 09:00:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] mkfs: document the large extent count switch in the
 --help screen
Message-ID: <20220628230026.GR227878@dread.disaster.area>
References: <165644935451.1089996.13716062701488693755.stgit@magnolia>
 <165644938238.1089996.650756637007296156.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644938238.1089996.650756637007296156.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62bb880b
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=vhDP1Hs9c0j-EwcPPIwA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 01:49:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We should document this feature in the --help screen for mkfs.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  mkfs/xfs_mkfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index a4705ee4..db322b3a 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -952,7 +952,7 @@ usage( void )
>  			    sectsize=num\n\
>  /* force overwrite */	[-f]\n\
>  /* inode size */	[-i perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
> -			    projid32bit=0|1,sparse=0|1]\n\
> +			    projid32bit=0|1,sparse=0|1,nrext64=0|1]\n\
>  /* no discard */	[-K]\n\
>  /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
>  			    sunit=value|su=num,sectsize=num,lazy-count=0|1]\n\

LGTM

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
