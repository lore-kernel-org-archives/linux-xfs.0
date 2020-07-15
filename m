Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEDC3C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 22:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C797F2065D
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 22:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgGOW3l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 18:29:41 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41118 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726479AbgGOW3l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 18:29:41 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 01A693A51D8;
        Thu, 16 Jul 2020 08:29:37 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jvpuB-0000t4-Vn; Thu, 16 Jul 2020 08:29:35 +1000
Date:   Thu, 16 Jul 2020 08:29:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix inode allocation block res calculation
 precedence
Message-ID: <20200715222935.GI2005@dread.disaster.area>
References: <20200715193310.22002-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715193310.22002-1-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=1P9MfUh1E_U-ZEJjtQYA:9 a=U2B8RaBiAIf65md-:21 a=l_xirzkhQlUQEynR:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 03:33:10PM -0400, Brian Foster wrote:
> The block reservation calculation for inode allocation is supposed
> to consist of the blocks required for the inode chunk plus
> (maxlevels-1) of the inode btree multiplied by the number of inode
> btrees in the fs (2 when finobt is enabled, 1 otherwise).
> 
> Instead, the macro returns (ialloc_blocks + 2) due to a precedence
> error in the calculation logic. This leads to block reservation
> overruns via generic/531 on small block filesystems with finobt
> enabled. Add braces to fix the calculation and reserve the
> appropriate number of blocks.
> 
> Fixes: 9d43b180af67 ("xfs: update inode allocation/free transaction reservations for finobt")
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_trans_space.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> index 88221c7a04cc..c6df01a2a158 100644
> --- a/fs/xfs/libxfs/xfs_trans_space.h
> +++ b/fs/xfs/libxfs/xfs_trans_space.h
> @@ -57,7 +57,7 @@
>  	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
>  #define	XFS_IALLOC_SPACE_RES(mp)	\
>  	(M_IGEO(mp)->ialloc_blks + \
> -	 (xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1 * \
> +	 ((xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1) * \
>  	  (M_IGEO(mp)->inobt_maxlevels - 1)))

Ugh. THese macros really need rewriting as static inline functions.
This would not have happened if it were written as:

static inline int
xfs_ialloc_space_res(struct xfs_mount *mp)
{
	int	res = M_IGEO(mp)->ialloc_blks;

	res += M_IGEO(mp)->inobt_maxlevels - 1;
	if (xfs_sb_version_hasfinobt(&mp->m_sb))
		res += M_IGEO(mp)->inobt_maxlevels - 1;
	return res;
}

Next question: why is this even a macro that is calculated on demand
instead of a read-only constant held in inode geometry calculated
at mount time? Then it doesn't even need to be an inline function
and can just be rolled into xfs_ialloc_setup_geometry()....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
