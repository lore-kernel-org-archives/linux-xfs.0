Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52D5C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 23:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiF1XAB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 19:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbiF1W76 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 18:59:58 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42D583A735
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 15:59:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 62C6610E787E;
        Wed, 29 Jun 2022 08:59:55 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o6KBW-00CFTA-9C; Wed, 29 Jun 2022 08:59:54 +1000
Date:   Wed, 29 Jun 2022 08:59:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] mkfs: preserve DIFLAG2_NREXT64 when setting other
 inode attributes
Message-ID: <20220628225954.GQ227878@dread.disaster.area>
References: <165644935451.1089996.13716062701488693755.stgit@magnolia>
 <165644937684.1089996.8013011825931751515.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644937684.1089996.8013011825931751515.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62bb87eb
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=ulFAMPnTsEz_ogPEE4YA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 01:49:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Preserve the state of the NREXT64 inode flag when we're changing the
> other flags2 fields.  This is only vital for the kernel version of this
> function, but we should keep these in sync.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  libxfs/util.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/libxfs/util.c b/libxfs/util.c
> index ef01fcf8..d2389198 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -198,7 +198,8 @@ xfs_flags2diflags2(
>  {
>  	uint64_t		di_flags2 =
>  		(ip->i_diflags2 & (XFS_DIFLAG2_REFLINK |
> -				   XFS_DIFLAG2_BIGTIME));
> +				   XFS_DIFLAG2_BIGTIME |
> +				   XFS_DIFLAG2_NREXT64));

*nod*

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
