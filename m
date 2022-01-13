Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A972C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jan 2022 03:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbiAMDxa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jan 2022 22:53:30 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45358 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232383AbiAMDx1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jan 2022 22:53:27 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 40CF562C229;
        Thu, 13 Jan 2022 14:53:26 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1n7rAz-00EeBN-LO; Thu, 13 Jan 2022 14:53:25 +1100
Date:   Thu, 13 Jan 2022 14:53:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: remove the XFS_IOC_FSSETDM definitions
Message-ID: <20220113035325.GE3290465@dread.disaster.area>
References: <164194336019.3069025.16691952615002573445.stgit@magnolia>
 <164194337697.3069025.4831414268040360601.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164194337697.3069025.4831414268040360601.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=61dfa236
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=1w2l5visoEp6LV_LYIEA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 11, 2022 at 03:22:57PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Remove the definitions for these ioctls, since the functionality (and,
> weirdly, the 32-bit compat ioctl definitions) were removed from the
> kernel in November 2019.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_fs.h |   29 ++++-------------------------
>  1 file changed, 4 insertions(+), 25 deletions(-)

Looks fine to me.

THe only user I know of is xfsdump, and it will only use this
functionality if a special CLI option is given to it. Given that
this would just be writing zeros as this is what will be in the
inodes that are backed up by xfsdump, I don't see it a big problem
if this fails now.

Nothing else out there is likely to be using this ioctl - the DMAPI
state was specific to a long dead proprietary SGI HSM product and
that's the only thing I know of that used this ioctl to set non-zero
values in the first place. 

Hence I think removing this ioctl has very little risk of userspace
regression.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
