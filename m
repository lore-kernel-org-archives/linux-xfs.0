Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7355BC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 04:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357635AbiD0EbQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 00:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350114AbiD0EbP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 00:31:15 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CBB4D13EBC
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 21:28:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7AF8110E6161;
        Wed, 27 Apr 2022 14:28:03 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njZHV-0051HY-Vh; Wed, 27 Apr 2022 14:28:01 +1000
Date:   Wed, 27 Apr 2022 14:28:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: create shadow transaction reservations for
 computing minimum log size
Message-ID: <20220427042801.GG1098723@dread.disaster.area>
References: <165102071223.3922658.5241787533081256670.stgit@magnolia>
 <165102073482.3922658.3874181264513799865.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165102073482.3922658.3874181264513799865.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6268c654
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=69ttfD6lQxp1MaYIlv8A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 05:52:14PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Every time someone changes the transaction reservation sizes, they
> introduce potential compatibility problems if the changes affect the
> minimum log size that we validate at mount time.  If the minimum log
> size gets larger (which should be avoided because doing so presents a
> serious risk of log livelock), filesystems created with old mkfs will
> not mount on a newer kernel; if the minimum size shrinks, filesystems
> created with newer mkfs will not mount on older kernels.
> 
> Therefore, enable the creation of a shadow log reservation structure
> where we can "undo" the effects of tweaks when computing minimum log
> sizes.  These shadow reservations should never be used in practice, but
> they insulate us from perturbations in minimum log size.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_log_rlimit.c |   15 +++++++++++----
>  fs/xfs/xfs_trace.h             |   12 ++++++++++--
>  2 files changed, 21 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
> index 67798ff5e14e..4d04568ab07e 100644
> --- a/fs/xfs/libxfs/xfs_log_rlimit.c
> +++ b/fs/xfs/libxfs/xfs_log_rlimit.c
> @@ -14,6 +14,7 @@
>  #include "xfs_trans_space.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_bmap_btree.h"
> +#include "xfs_trace.h"
>  
>  /*
>   * Calculate the maximum length in bytes that would be required for a local
> @@ -46,19 +47,25 @@ xfs_log_get_max_trans_res(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans_res	*max_resp)
>  {
> +	struct xfs_trans_resv	resv;
>  	struct xfs_trans_res	*resp;
>  	struct xfs_trans_res	*end_resp;
> +	unsigned int		i;
>  	int			log_space = 0;
>  	int			attr_space;
>  
>  	attr_space = xfs_log_calc_max_attrsetm_res(mp);
>  
> -	resp = (struct xfs_trans_res *)M_RES(mp);
> -	end_resp = (struct xfs_trans_res *)(M_RES(mp) + 1);
> -	for (; resp < end_resp; resp++) {
> +	memcpy(&resv, M_RES(mp), sizeof(struct xfs_trans_resv));

Looks much nicer, but I had to read on further into the patchset
before it made sense. As it all ends up ok:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
