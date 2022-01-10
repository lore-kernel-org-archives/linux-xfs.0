Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28CE3C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jan 2022 21:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241200AbiAJVKF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 16:10:05 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33648 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240516AbiAJVKD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jan 2022 16:10:03 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DEFE610C1283;
        Tue, 11 Jan 2022 08:10:01 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1n71vV-00DkQp-7z; Tue, 11 Jan 2022 08:10:01 +1100
Date:   Tue, 11 Jan 2022 08:10:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] xfs: hide the XFS_IOC_{ALLOC,FREE}SP* definitions
Message-ID: <20220110211001.GA945095@dread.disaster.area>
References: <20220110174827.GW656707@magnolia>
 <20220110175154.GX656707@magnolia>
 <20220110195854.GY656707@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110195854.GY656707@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61dca0aa
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=dImF1bAJSuKnBdsdcJUA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 10, 2022 at 11:58:54AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've made these ioctls defunct, move them from xfs_fs.h to
> xfs_ioctl.c, which effectively removes them from the publicly supported
> ioctl interfaces for XFS.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: nuke the 32-bit compat definitions too
> ---
>  fs/xfs/libxfs/xfs_fs.h |    8 ++++----
>  fs/xfs/xfs_ioctl.c     |    9 +++++++++
>  fs/xfs/xfs_ioctl32.h   |    4 ----
>  3 files changed, 13 insertions(+), 8 deletions(-)

Looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
