Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC09C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 19 May 2022 01:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiESBhh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 21:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbiESBhe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 21:37:34 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC2395FF11
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:37:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 06F9A53453C;
        Thu, 19 May 2022 11:37:32 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nrV6Y-00DfiK-VS; Thu, 19 May 2022 11:37:31 +1000
Date:   Thu, 19 May 2022 11:37:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 4/4] xfs: reject unknown xattri log item filter flags
 during recovery
Message-ID: <20220519013730.GV1098723@dread.disaster.area>
References: <165290007585.1646028.11376304341026166988.stgit@magnolia>
 <165290009876.1646028.9980499225084838287.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165290009876.1646028.9980499225084838287.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62859f5d
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=JuDxSlhT3OO6blO4plAA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 18, 2022 at 11:54:58AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure we screen the "attr flags" field of recovered xattr intent log
> items to reject flag bits that we don't know about.  This is really the
> attr *filter* field from xfs_da_args, so rename the field and create
> a mask to make checking for invalid bits easier.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_log_format.h |   10 +++++++++-
>  fs/xfs/xfs_attr_item.c         |   10 +++++++---
>  2 files changed, 16 insertions(+), 4 deletions(-)

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
