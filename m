Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66BA8C12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:50:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 457D5613CB
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbhGNXxo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:53:44 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:40546 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229535AbhGNXxn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 19:53:43 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 61E7C863E0A;
        Thu, 15 Jul 2021 09:50:50 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3oeP-006cbu-Nb; Thu, 15 Jul 2021 09:50:49 +1000
Date:   Thu, 15 Jul 2021 09:50:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: detect misaligned rtinherit directory extent size
 hints
Message-ID: <20210714235049.GF664593@dread.disaster.area>
References: <20210714213542.GK22402@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714213542.GK22402@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=Wc5g1iE_ZIsZWtd2Ef0A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:35:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we encounter a directory that has been configured to pass on an
> extent size hint to a new realtime file and the hint isn't an integer
> multiple of the rt extent size, we should flag the hint for
> administrative review because that is a misconfiguration (that other
> parts of the kernel will fix automatically).
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/inode.c |   18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 61f90b2c9430..76fbc7ca4cec 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -73,11 +73,25 @@ xchk_inode_extsize(
>  	uint16_t		flags)
>  {
>  	xfs_failaddr_t		fa;
> +	uint32_t		value = be32_to_cpu(dip->di_extsize);
>  
> -	fa = xfs_inode_validate_extsize(sc->mp, be32_to_cpu(dip->di_extsize),
> -			mode, flags);
> +	fa = xfs_inode_validate_extsize(sc->mp, value, mode, flags);
>  	if (fa)
>  		xchk_ino_set_corrupt(sc, ino);
> +
> +	/*
> +	 * XFS allows a sysadmin to change the rt extent size when adding a rt
> +	 * section to a filesystem after formatting.  If there are any
> +	 * directories with extszinherit and rtinherit set, the hint could
> +	 * become misaligned with the new rextsize.  The verifier doesn't check
> +	 * this, because we allow rtinherit directories even without an rt
> +	 * device.  Flag this as an administrative warning since we will clean
> +	 * this up eventually.
> +	 */
> +	if ((flags & XFS_DIFLAG_RTINHERIT) &&
> +	    (flags & XFS_DIFLAG_EXTSZINHERIT) &&
> +	    value % sc->mp->m_sb.sb_rextsize > 0)
> +		xchk_ino_set_warning(sc, ino);
>  }
>  
>  /*

Looks good. A warning seems appropriate for scrub in this corner
case...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
