Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CC3C10F25
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 05:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B279208E4
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 05:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgCKFrq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 01:47:46 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48524 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725813AbgCKFrq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 01:47:46 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 487E87E9A00;
        Wed, 11 Mar 2020 16:47:45 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jBuDY-0007Fy-OI; Wed, 11 Mar 2020 16:47:44 +1100
Date:   Wed, 11 Mar 2020 16:47:44 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/7] xfs: check owner of dir3 free blocks
Message-ID: <20200311054744.GY10776@dread.disaster.area>
References: <158388763282.939165.6485358230553665775.stgit@magnolia>
 <158388766642.939165.18097752003465610656.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158388766642.939165.18097752003465610656.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=ZqFsCqFU9_ltOa5j7AMA:9
        a=mAo-VT8HvJqFpu31:21 a=IIJnXZKwnPefSTiO:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 10, 2020 at 05:47:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check the owner field of dir3 free block headers and reject the metadata
> if there's something wrong with it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_dir2_node.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index bbd478ec75c9..6ac4aad98cd7 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -194,6 +194,8 @@ xfs_dir3_free_header_check(
>  			return __this_address;
>  		if (be32_to_cpu(hdr3->nvalid) < be32_to_cpu(hdr3->nused))
>  			return __this_address;
> +		if (be64_to_cpu(hdr3->hdr.owner) != dp->i_ino)
> +			return __this_address;
>  	} else {
>  		struct xfs_dir2_free_hdr *hdr = bp->b_addr;

Yup.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
