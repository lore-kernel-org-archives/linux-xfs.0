Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8FBEC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 22:02:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 821FA2076D
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 22:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgGPWCB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 18:02:01 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:58274 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726113AbgGPWCA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 18:02:00 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id C8FCB5EC5F1;
        Fri, 17 Jul 2020 08:01:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jwBwy-0000oh-2L; Fri, 17 Jul 2020 08:01:56 +1000
Date:   Fri, 17 Jul 2020 08:01:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: replace ialloc space res macro with inline
 helper
Message-ID: <20200716220156.GL2005@dread.disaster.area>
References: <20200715193310.22002-1-bfoster@redhat.com>
 <20200716121849.36661-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716121849.36661-1-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=SwQ4_jGhSb0S161kMscA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 16, 2020 at 08:18:49AM -0400, Brian Foster wrote:
> Rewrite the macro as a static inline helper to clean up the logic
> and have one less macro.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_trans_space.h | 24 ++++++++++++++++--------
>  fs/xfs/xfs_inode.c              |  4 ++--
>  fs/xfs/xfs_symlink.c            |  2 +-
>  3 files changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> index c6df01a2a158..d08dfc8795c3 100644
> --- a/fs/xfs/libxfs/xfs_trans_space.h
> +++ b/fs/xfs/libxfs/xfs_trans_space.h
> @@ -55,10 +55,18 @@
>  	 XFS_DIRENTER_MAX_SPLIT(mp,nl))
>  #define	XFS_DIRREMOVE_SPACE_RES(mp)	\
>  	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
> -#define	XFS_IALLOC_SPACE_RES(mp)	\
> -	(M_IGEO(mp)->ialloc_blks + \
> -	 ((xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1) * \
> -	  (M_IGEO(mp)->inobt_maxlevels - 1)))
> +
> +static inline int
> +xfs_ialloc_space_res(
> +	struct xfs_mount	*mp)
> +{
> +	int			res = M_IGEO(mp)->ialloc_blks;
> +
> +	res += M_IGEO(mp)->inobt_maxlevels - 1;
> +	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> +		res += M_IGEO(mp)->inobt_maxlevels - 1;
> +	return res;
> +}

This misses the point I made. i.e. that the space reservation is
constant and never changes, yet we calculate it -twice- per inode
create. That means we can be calculating it hundreds of thousands of
times a second instead of just reading a variable that is likely hot
in cache.

IOWs, if we are going to improve this code, it should to be moved to
a pre-calculated, read-only, per-mount variable so the repeated
calculation goes away entirely.

Then the macro/function goes away entirely an is replaced simply
by mp->m_ialloc_space_res or M_IGEO(mp)->alloc_space_res....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
