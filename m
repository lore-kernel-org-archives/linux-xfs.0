Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13405C4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 21:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDC12222C2
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 21:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbfIZVlH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 17:41:07 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35304 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725280AbfIZVlH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Sep 2019 17:41:07 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7B6F543DEB6;
        Fri, 27 Sep 2019 07:41:03 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iDbVW-0006pf-HG; Fri, 27 Sep 2019 07:41:02 +1000
Date:   Fri, 27 Sep 2019 07:41:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: calculate iext tree geometry in btheight
 command
Message-ID: <20190926214102.GK16973@dread.disaster.area>
References: <156944764785.303060.15428657522073378525.stgit@magnolia>
 <156944765991.303060.7541074919992777157.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156944765991.303060.7541074919992777157.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=WwKIqxeSVOaKwt35D5IA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 25, 2019 at 02:40:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> (Ab)use the btheight command to calculate the geometry of the incore
> extent tree.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/btheight.c |   87 +++++++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 60 insertions(+), 27 deletions(-)
> 
> 
> diff --git a/db/btheight.c b/db/btheight.c
> index e2c9759f..be604ebc 100644
> --- a/db/btheight.c
> +++ b/db/btheight.c
> @@ -22,18 +22,37 @@ static int rmap_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
>  	return libxfs_rmapbt_maxrecs(blocklen, leaf);
>  }
>  
> +static int iext_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
> +{
> +	blocklen -= 2 * sizeof(void *);
> +
> +	return blocklen / sizeof(struct xfs_bmbt_rec);
> +}

This isn't correct for the iext nodes. They hold 16 key/ptr pairs,
not 15.

I suspect you should be lifting the iext btree format definitions
like this one:

enum {                                                                           
        NODE_SIZE       = 256,                                                   
        KEYS_PER_NODE   = NODE_SIZE / (sizeof(uint64_t) + sizeof(void *)),       
        RECS_PER_LEAF   = (NODE_SIZE - (2 * sizeof(struct xfs_iext_leaf *))) /   
                                sizeof(struct xfs_iext_rec),                     
};                                                                               

from libxfs/xfs_iext_tree.c to a libxfs header file and then using
KEYS_PER_NODE and RECS_PER_LEAF here. See the patch below, lifted
from a varaint of my range locking prototypes...

However, these are not on-disk values and so are subject to change,
hence it may be that a warning might be needed when xfs_db is used
to calculate the height of this tree.

> +static int disk_blocksize(struct xfs_mount *mp)
> +{
> +	return mp->m_sb.sb_blocksize;
> +}
> +
> +static int iext_blocksize(struct xfs_mount *mp)
> +{
> +	return 256;
> +}

NODE_SIZE....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
