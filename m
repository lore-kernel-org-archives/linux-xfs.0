Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE8BC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD2FF22CF5
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbfIDEBD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:01:03 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:38257 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725947AbfIDEBC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:01:02 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 49D45360E83;
        Wed,  4 Sep 2019 14:01:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5MTc-0007Hw-8F; Wed, 04 Sep 2019 14:01:00 +1000
Date:   Wed, 4 Sep 2019 14:01:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3] xfs: define a flags field for the AG geometry ioctl
 structure
Message-ID: <20190904040100.GA1119@dread.disaster.area>
References: <20190903230537.GI5340@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903230537.GI5340@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=sg_cNFlFF0uKCH_A41YA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 03, 2019 at 04:05:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Define a flags field for the AG geometry ioctl structure.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: define ag_flags as an in/out field and check required zeroness
> ---
>  fs/xfs/libxfs/xfs_fs.h |    2 +-
>  fs/xfs/xfs_ioctl.c     |    4 ++++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 52d03a3a02a4..39dd2b908106 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -287,7 +287,7 @@ struct xfs_ag_geometry {
>  	uint32_t	ag_ifree;	/* o: inodes free */
>  	uint32_t	ag_sick;	/* o: sick things in ag */
>  	uint32_t	ag_checked;	/* o: checked metadata in ag */
> -	uint32_t	ag_reserved32;	/* o: zero */
> +	uint32_t	ag_flags;	/* i/o: flags for this ag */
>  	uint64_t	ag_reserved[12];/* o: zero */
>  };
>  #define XFS_AG_GEOM_SICK_SB	(1 << 0)  /* superblock */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 9a6823e29661..c93501f42675 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1038,6 +1038,10 @@ xfs_ioc_ag_geometry(
>  
>  	if (copy_from_user(&ageo, arg, sizeof(ageo)))
>  		return -EFAULT;
> +	if (ageo.ag_flags)
> +		return -EINVAL;
> +	if (memchr_inv(&ageo.ag_reserved, 0, sizeof(ageo.ag_reserved)))
> +		return -EINVAL;

Looks good. All that should be zero until we start using them. :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
