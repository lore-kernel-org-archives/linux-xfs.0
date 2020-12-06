Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 680E2C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F8DB22D08
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgLFXs5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:48:57 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:48424 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbgLFXs5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:48:57 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 4F8C4765B37;
        Mon,  7 Dec 2020 10:48:15 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1km3lG-001GHb-QN; Mon, 07 Dec 2020 10:48:14 +1100
Date:   Mon, 7 Dec 2020 10:48:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, bfoster@redhat.com,
        Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: enable the needsrepair feature
Message-ID: <20201206234814.GN3913616@dread.disaster.area>
References: <160729616025.1606994.13590463307385382944.stgit@magnolia>
 <160729617967.1606994.16303813050126665103.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160729617967.1606994.16303813050126665103.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=PMvn5WeMIdAEWABoJfoA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 06, 2020 at 03:09:39PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make it so that libxfs recognizes the needsrepair feature.  Note that
> the kernel will still refuse to mount these.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_format.h |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 5d8ba609ac0b..f64eed3ccfed 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -473,7 +473,8 @@ xfs_sb_has_ro_compat_feature(
>  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
>  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
>  		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
> -		 XFS_SB_FEAT_INCOMPAT_BIGTIME)
> +		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
> +		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
>  
>  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
>  static inline bool

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
