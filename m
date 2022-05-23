Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C2D1C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 03:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbiEWDet (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 May 2022 23:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233183AbiEWDes (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 May 2022 23:34:48 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AA7E8167D3
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 20:34:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C9771534454;
        Mon, 23 May 2022 13:34:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nsyqD-00FHog-Vz; Mon, 23 May 2022 13:34:46 +1000
Date:   Mon, 23 May 2022 13:34:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 5/5] xfs: move xfs_attr_use_log_assist out of libxfs
Message-ID: <20220523033445.GQ1098723@dread.disaster.area>
References: <165323329374.78886.11371349029777433302.stgit@magnolia>
 <165323332197.78886.8893427108008735872.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165323332197.78886.8893427108008735872.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=628b00d7
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=t8iYO8sUxWRto4hqnyoA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 22, 2022 at 08:28:42AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> libxfs itself should never be messing with whether or not to enable
> logging for extended attribute updates -- this decision should be made
> on a case-by-case basis by libxfs callers.  Move the code that actually
> enables the log features to xfs_xattr.c, and adjust the callers.
> 
> This removes an awkward coupling point between libxfs and what would be
> libxlog, if the XFS log were actually its own library.  Furthermore, it
> makes bulk attribute updates and inode security initialization a tiny
> bit more efficient, since they now avoid cycling the log feature between
> every single xattr.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c |   12 +-------
>  fs/xfs/xfs_acl.c         |   10 +++++++
>  fs/xfs/xfs_ioctl.c       |   22 +++++++++++++---
>  fs/xfs/xfs_ioctl.h       |    2 +
>  fs/xfs/xfs_ioctl32.c     |    4 ++-
>  fs/xfs/xfs_iops.c        |   25 ++++++++++++++----
>  fs/xfs/xfs_log.c         |   45 --------------------------------
>  fs/xfs/xfs_log.h         |    1 -
>  fs/xfs/xfs_super.h       |    2 +
>  fs/xfs/xfs_xattr.c       |   65 ++++++++++++++++++++++++++++++++++++++++++++++
>  10 files changed, 120 insertions(+), 68 deletions(-)

This seems like the wrong way to approach this. I would have defined
a wrapper function for xfs_attr_set() to do the log state futzing,
not moved it all into callers that don't need (or want) to know
anything about how attrs are logged internally....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
