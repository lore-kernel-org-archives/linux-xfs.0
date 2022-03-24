Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A5DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 21:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346156AbiCXVzW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 17:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiCXVzW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Mar 2022 17:55:22 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B57BB7C4E
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 14:53:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6B0EA10E51FB;
        Fri, 25 Mar 2022 08:53:49 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nXVOu-009Sln-CN; Fri, 25 Mar 2022 08:53:48 +1100
Date:   Fri, 25 Mar 2022 08:53:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V8 14/19] xfs: Introduce per-inode 64-bit extent counters
Message-ID: <20220324215348.GK1544202@dread.disaster.area>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
 <20220321051750.400056-15-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321051750.400056-15-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=623ce86d
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=1rQL5oASZZfQD5HC3gIA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 21, 2022 at 10:47:45AM +0530, Chandan Babu R wrote:
> This commit introduces new fields in the on-disk inode format to support
> 64-bit data fork extent counters and 32-bit attribute fork extent
> counters. The new fields will be used only when an inode has
> XFS_DIFLAG2_NREXT64 flag set. Otherwise we continue to use the regular 32-bit
> data fork extent counters and 16-bit attribute fork extent counters.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> Suggested-by: Dave Chinner <dchinner@redhat.com>

Looks good, minor nits below.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> +STATIC int
> +xlog_dinode_verify_extent_counts(
> +	struct xfs_mount	*mp,
> +	struct xfs_log_dinode	*ldip)
> +{
> +	xfs_extnum_t		nextents;
> +	xfs_aextnum_t		anextents;
> +
> +	if (xfs_log_dinode_has_large_extent_counts(ldip)) {
> +		if (!xfs_has_large_extent_counts(mp) ||
> +		    (ldip->di_nrext64_pad != 0)) {
> +			XFS_CORRUPTION_ERROR(
> +				"Bad log dinode large extent count format",
> +				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
> +			xfs_alert(mp,
> +				"Bad inode 0x%llx, nrext64 %d, padding 0x%x",

"large extent counts" rather than "nrext64"?

> +				ldip->di_ino, xfs_has_large_extent_counts(mp),
> +				ldip->di_nrext64_pad);
> +			return -EFSCORRUPTED;
> +		}
> +
> +		nextents = ldip->di_big_nextents;
> +		anextents = ldip->di_big_anextents;
> +	} else {
> +		if (ldip->di_version == 3 && ldip->di_v3_pad != 0) {
> +			XFS_CORRUPTION_ERROR(
> +				"Bad log dinode di_v3_pad",
> +				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
> +			xfs_alert(mp,
> +				"Bad inode 0x%llx, di_v3_pad %llu",
> +				ldip->di_ino, ldip->di_v3_pad);

the padding should be dumped as a hexadecimal value - it's much
easier to see the bit corruption patterns in hex dumps than decimal
output.

> +			return -EFSCORRUPTED;
> +		}
> +
> +		nextents = ldip->di_nextents;
> +		anextents = ldip->di_anextents;
> +	}
> +
> +	if (unlikely(nextents + anextents > ldip->di_nblocks)) {
> +		XFS_CORRUPTION_ERROR("Bad log dinode extent counts",
> +				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
> +		xfs_alert(mp,
> +			"Bad inode 0x%llx, nextents 0x%llx, anextents 0x%x, nblocks 0x%llx",
> +			ldip->di_ino, nextents, anextents, ldip->di_nblocks);
> +		return -EFSCORRUPTED;

Maybe should indicate large extent count status here, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
