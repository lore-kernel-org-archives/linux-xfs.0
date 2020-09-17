Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAFC5C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0D592072E
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgIQIFe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 04:05:34 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40948 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726373AbgIQIEh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 04:04:37 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D1B643ABB92;
        Thu, 17 Sep 2020 18:03:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kIotS-0001vS-PP; Thu, 17 Sep 2020 18:03:50 +1000
Date:   Thu, 17 Sep 2020 18:03:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: attach inode to dquot in xfs_bui_item_recover
Message-ID: <20200917080350.GJ12131@dread.disaster.area>
References: <160031332353.3624373.16349101558356065522.stgit@magnolia>
 <160031333615.3624373.7775190767495604737.stgit@magnolia>
 <20200917070103.GU7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917070103.GU7955@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=XJ9OtjpE c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=DDAALGIGjT3U65XUBN4A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 12:01:03AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In the bmap intent item recovery code, we must be careful to attach the
> inode to its dquots (if quotas are enabled) so that a change in the
> shape of the bmap btree doesn't cause the quota counters to be
> incorrect.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: use dqattach_locked
> ---
>  fs/xfs/xfs_bmap_item.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 815a0563288f..2b1cf3ed8172 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -24,6 +24,7 @@
>  #include "xfs_error.h"
>  #include "xfs_log_priv.h"
>  #include "xfs_log_recover.h"
> +#include "xfs_quota.h"
>  
>  kmem_zone_t	*xfs_bui_zone;
>  kmem_zone_t	*xfs_bud_zone;
> @@ -498,6 +499,10 @@ xfs_bui_item_recover(
>  	if (error)
>  		goto err_inode;
>  
> +	error = xfs_qm_dqattach_locked(ip, false);
> +	if (error)
> +		goto err_inode;
> +
>  	if (VFS_I(ip)->i_nlink == 0)
>  		xfs_iflags_set(ip, XFS_IRECOVERY);

Looks good now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
