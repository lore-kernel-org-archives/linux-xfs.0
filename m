Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19933C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 03:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiETDvE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 23:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbiETDuz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 23:50:55 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EFC803917C
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 20:50:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DC05D10E6859;
        Fri, 20 May 2022 13:50:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nrtf9-00E6Z7-L0; Fri, 20 May 2022 13:50:51 +1000
Date:   Fri, 20 May 2022 13:50:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: use a separate slab cache for deferred xattr
 work state
Message-ID: <20220520035051.GF1098723@dread.disaster.area>
References: <165290014409.1647637.4876706578208264219.stgit@magnolia>
 <165290016116.1647637.7261522980413646490.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165290016116.1647637.7261522980413646490.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6287101d
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=MreqOf8DLQP65j5zHlwA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 18, 2022 at 11:56:01AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a separate slab cache for struct xfs_attr_item objects, since we
> can pack the (104-byte) intent items more tightly than we can with the
> general slab cache objects.  On x86, this means 39 intents per memory
> page instead of 32.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c  |   20 +++++++++++++++++++-
>  fs/xfs/libxfs/xfs_attr.h  |    4 ++++
>  fs/xfs/libxfs/xfs_defer.c |    4 ++++
>  fs/xfs/xfs_attr_item.c    |    5 ++++-
>  4 files changed, 31 insertions(+), 2 deletions(-)

Looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>


-- 
Dave Chinner
david@fromorbit.com
