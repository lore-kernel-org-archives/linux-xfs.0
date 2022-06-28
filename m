Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC14C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 23:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiF1XBJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 19:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbiF1XBI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 19:01:08 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E2AE9377EF
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 16:01:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 344BC5ECD91;
        Wed, 29 Jun 2022 09:01:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o6KCf-00CFUw-Mt; Wed, 29 Jun 2022 09:01:05 +1000
Date:   Wed, 29 Jun 2022 09:01:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] mkfs: always use new_diflags2 to initialize new
 inodes
Message-ID: <20220628230105.GS227878@dread.disaster.area>
References: <165644935451.1089996.13716062701488693755.stgit@magnolia>
 <165644938793.1089996.3898370820373975650.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644938793.1089996.3898370820373975650.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62bb8833
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=CPfy1Pc9caROwDR8uKQA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 01:49:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The new_diflags2 field that's set in the inode geometry represent
> features that we want enabled for /all/ newly created inodes.
> Unfortunately, mkfs doesn't do that because xfs_flags2diflags2 doesn't
> read new_diflags2.  Change the new_diflags2 logic to match the kernel.
> 
> Without this fix, the root directory gets created without the
> DIFLAG2_NREXT64 iflag set, but files created by a protofile /do/ have it
> turned on.
> 
> This wasn't an issue with DIFLAG2_BIGTIME because xfs_trans_log_inode
> quietly turns that on whenever possible.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  libxfs/util.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/libxfs/util.c b/libxfs/util.c
> index d2389198..5d2383e9 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -286,8 +286,10 @@ libxfs_init_new_inode(
>  
>  	if (xfs_has_v3inodes(ip->i_mount)) {
>  		VFS_I(ip)->i_version = 1;
> -		ip->i_diflags2 = pip ? ip->i_mount->m_ino_geo.new_diflags2 :
> -				xfs_flags2diflags2(ip, fsx->fsx_xflags);
> +		ip->i_diflags2 = ip->i_mount->m_ino_geo.new_diflags2;
> +		if (!pip)
> +			ip->i_diflags2 = xfs_flags2diflags2(ip,
> +							fsx->fsx_xflags);
>  		ip->i_crtime = VFS_I(ip)->i_mtime; /* struct copy */
>  		ip->i_cowextsize = pip ? 0 : fsx->fsx_cowextsize;
>  	}

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
