Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C02B0C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Apr 2022 23:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiDVXxv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Apr 2022 19:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbiDVXxf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Apr 2022 19:53:35 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9AE47128CD3
        for <linux-xfs@vger.kernel.org>; Fri, 22 Apr 2022 16:50:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D7B7210E5EB3;
        Sat, 23 Apr 2022 09:50:37 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ni32q-003MYd-JD; Sat, 23 Apr 2022 09:50:36 +1000
Date:   Sat, 23 Apr 2022 09:50:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: rewrite xfs_reflink_end_cow to use intents
Message-ID: <20220422235036.GF1544202@dread.disaster.area>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
 <164997689961.383881.592770760091459460.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164997689961.383881.592770760091459460.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62633f4e
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=QjQ_duBCKnjNy366QvMA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 14, 2022 at 03:54:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, the code that performs CoW remapping after a write has this
> odd behavior where it walks /backwards/ through the data fork to remap
> extents in reverse order.  Earlier, we rewrote the reflink remap
> function to use deferred bmap log items instead of trying to cram as
> much into the first transaction that we could.  Now do the same for the
> CoW remap code.  There doesn't seem to be any performance impact; we're
> just making better use of code that we added for the benefit of reflink.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_reflink.c |   88 ++++++++++++++++++++++++++++++++------------------
>  fs/xfs/xfs_trace.h   |    3 +-
>  2 files changed, 58 insertions(+), 33 deletions(-)

Looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
