Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D55FC433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Mar 2022 08:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiCDIQj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Mar 2022 03:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiCDIQi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Mar 2022 03:16:38 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD026197B51
        for <linux-xfs@vger.kernel.org>; Fri,  4 Mar 2022 00:15:50 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1AEB410E234C;
        Fri,  4 Mar 2022 19:15:50 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nQ36L-001Lfo-Gw; Fri, 04 Mar 2022 19:15:49 +1100
Date:   Fri, 4 Mar 2022 19:15:49 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 17/17] xfs: Define max extent length based on on-disk
 format definition
Message-ID: <20220304081549.GL59715@dread.disaster.area>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-18-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301103938.1106808-18-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6221cab6
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=JxtSWZMfg4bXHmjKXcYA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 01, 2022 at 04:09:38PM +0530, Chandan Babu R wrote:
> The maximum extent length depends on maximum block count that can be stored in
> a BMBT record. Hence this commit defines MAXEXTLEN based on
> BMBT_BLOCKCOUNT_BITLEN.
> 
> While at it, the commit also renames MAXEXTLEN to XFS_MAX_BMBT_EXTLEN.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Looks fine, but this should be up near the top of the series where
all the extent count definitions are being changed. Also, minor
formatting nit below.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> @@ -299,7 +299,8 @@ xfs_calc_write_reservation(
>   *    the agf for each of the ags: 2 * sector size
>   *    the agfl for each of the ags: 2 * sector size
>   *    the super block to reflect the freed blocks: sector size
> - *    the realtime bitmap: 2 exts * ((MAXEXTLEN / rtextsize) / NBBY) bytes
> + *    the realtime bitmap: 2 exts * ((XFS_BMBT_MAX_EXTLEN / rtextsize) / NBBY)
> + *    bytes

Break the line at the ":"

 *    the realtime bitmap:
 *		2 exts * ((XFS_BMBT_MAX_EXTLEN / rtextsize) / NBBY) bytes

Which makes it consistent with the rest of the comment:

>   *    the realtime summary: 2 exts * 1 block
>   *    worst case split in allocation btrees per extent assuming 2 extents:
>   *		2 exts * 2 trees * (2 * max depth - 1) * block size

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
