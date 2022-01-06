Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36225C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jan 2022 01:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344420AbiAFBkI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 20:40:08 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42074 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344417AbiAFBkG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 20:40:06 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2B2C710C002C;
        Thu,  6 Jan 2022 12:40:05 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1n5Hl6-00BqvL-7C; Thu, 06 Jan 2022 12:40:04 +1100
Date:   Thu, 6 Jan 2022 12:40:04 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: hold quota inode ILOCK_EXCL until the end of dqalloc
Message-ID: <20220106014004.GQ945095@dread.disaster.area>
References: <20220104234216.GI31583@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104234216.GI31583@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=61d64875
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=dh9Wz_qOIK3R3n7gzFAA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 04, 2022 at 03:42:16PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Online fsck depends on callers holding ILOCK_EXCL from the time they
> decide to update a block mapping until after they've updated the reverse
> mapping records to guarantee the stability of both mapping records.
> Unfortunately, the quota code drops ILOCK_EXCL at the first transaction
> roll in the dquot allocation process, which breaks that assertion.  This
> leads to sporadic failures in the online rmap repair code if the repair
> code grabs the AGF after bmapi_write maps a new block into the quota
> file's data fork but before it can finish the deferred rmap update.
> 
> Fix this by rewriting the function to hold the ILOCK until after the
> transaction commit like all other bmap updates do, and get rid of the
> dqread wrapper that does nothing but complicate the codebase.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_dquot.c |   79 ++++++++++++++++++----------------------------------
>  1 file changed, 28 insertions(+), 51 deletions(-)

Yup, much nicer. I was just pondering if I should clean up the weird
transaction stuff when looking at the xfs_bmapi_write() call in this
function, but now I don't have to :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
