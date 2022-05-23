Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36F6C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 23 May 2022 05:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiEWF7l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 01:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiEWF7j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 01:59:39 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1DA1033355
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 22:59:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CD0045346F4;
        Mon, 23 May 2022 15:59:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nt16M-00FKHi-Dq; Mon, 23 May 2022 15:59:34 +1000
Date:   Mon, 23 May 2022 15:59:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 3/4] xfs: share xattr name and value buffers when logging
 xattr updates
Message-ID: <20220523055934.GS1098723@dread.disaster.area>
References: <165323326679.78754.13346434666230687214.stgit@magnolia>
 <165323328378.78754.13988952314410368815.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165323328378.78754.13988952314410368815.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=628b22c8
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=h_gidBsr9d5Xo4-cB3kA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 22, 2022 at 08:28:03AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While running xfs/297 and generic/642, I noticed a crash in
> xfs_attri_item_relog when it tries to copy the attr name to the new
> xattri log item.  I think what happened here was that we called
> ->iop_commit on the old attri item (which nulls out the pointers) as
> part of a log force at the same time that a chained attr operation was
> ongoing.  The system was busy enough that at some later point, the defer
> ops operation decided it was necessary to relog the attri log item, but
> as we've detached the name buffer from the old attri log item, we can't
> copy it to the new one, and kaboom.
> 
> I think there's a broader refcounting problem with LARP mode -- the
> setxattr code can return to userspace before the CIL actually formats
> and commits the log item, which results in a UAF bug.  Therefore, the
> xattr log item needs to be able to retain a reference to the name and
> value buffers until the log items have completely cleared the log.
> Furthermore, each time we create an intent log item, we allocate new
> memory and (re)copy the contents; sharing here would be very useful.
> 
> Solve the UAF and the unnecessary memory allocations by having the log
> code create a single refcounted buffer to contain the name and value
> contents.  This buffer can be passed from old to new during a relog
> operation, and the logging code can (optionally) attach it to the
> xfs_attr_item for reuse when LARP mode is enabled.
> 
> This also fixes a problem where the xfs_attri_log_item objects weren't
> being freed back to the same cache where they came from.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.h |    8 +
>  fs/xfs/xfs_attr_item.c   |  271 ++++++++++++++++++++++++++--------------------
>  fs/xfs/xfs_attr_item.h   |   13 ++
>  fs/xfs/xfs_log.h         |    7 +
>  4 files changed, 178 insertions(+), 121 deletions(-)

Lots neater!

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
