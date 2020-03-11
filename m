Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A47D8C10F27
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 05:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88A0321655
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 05:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgCKFv1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 01:51:27 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53923 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725813AbgCKFv1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 01:51:27 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CC7783A2BCD;
        Wed, 11 Mar 2020 16:51:22 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jBuH3-0007GJ-Gw; Wed, 11 Mar 2020 16:51:21 +1100
Date:   Wed, 11 Mar 2020 16:51:21 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: check owner of dir3 data blocks
Message-ID: <20200311055121.GZ10776@dread.disaster.area>
References: <158388763282.939165.6485358230553665775.stgit@magnolia>
 <158388767279.939165.8430173747192985972.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158388767279.939165.8430173747192985972.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=Wg6s4cBzL1PcVMI9xBAA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 10, 2020 at 05:47:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check the owner field of dir3 data block headers.  If it's corrupt,
> release the buffer and return EFSCORRUPTED.  All callers handle this
> properly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_data.c |   31 ++++++++++++++++++++++++++++++-
>  1 file changed, 30 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index b9eba8213180..8de9611387e5 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -394,6 +394,22 @@ static const struct xfs_buf_ops xfs_dir3_data_reada_buf_ops = {
>  	.verify_write = xfs_dir3_data_write_verify,
>  };
>  
> +static xfs_failaddr_t
> +xfs_dir3_data_header_check(
> +	struct xfs_inode	*dp,
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_mount	*mp = dp->i_mount;
> +
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		struct xfs_dir3_data_hdr *hdr3 = bp->b_addr;
> +
> +		if (be64_to_cpu(hdr3->hdr.owner) != dp->i_ino)
> +			return __this_address;
> +	}
> +
> +	return NULL;
> +}
>  
>  int
>  xfs_dir3_data_read(
> @@ -403,11 +419,24 @@ xfs_dir3_data_read(
>  	unsigned int		flags,
>  	struct xfs_buf		**bpp)
>  {
> +	xfs_failaddr_t		fa;
>  	int			err;
>  
>  	err = xfs_da_read_buf(tp, dp, bno, flags, bpp, XFS_DATA_FORK,
>  			&xfs_dir3_data_buf_ops);
> -	if (!err && tp && *bpp)
> +	if (err || !*bpp)
> +		return err;
> +
> +	/* Check things that we can't do in the verifier. */
> +	fa = xfs_dir3_data_header_check(dp, *bpp);
> +	if (fa) {
> +		__xfs_buf_mark_corrupt(*bpp, fa);
> +		xfs_trans_brelse(tp, *bpp);
> +		*bpp = NULL;
> +		return -EFSCORRUPTED;
> +	}
> +
> +	if (tp)
>  		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_DATA_BUF);

xfs_trans_buf_set_type() handles a null tp just fine.

Otherwise OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
