Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FFE9C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 21:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245483AbiCWVOA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 17:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344864AbiCWVN7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 17:13:59 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7A0D8CCEE
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 14:12:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E5E04533C7E;
        Thu, 24 Mar 2022 08:12:27 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nX8HJ-0093Rj-8J; Thu, 24 Mar 2022 08:12:25 +1100
Date:   Thu, 24 Mar 2022 08:12:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 5/6] xfs: don't report reserved bnobt space as available
Message-ID: <20220323211225.GY1544202@dread.disaster.area>
References: <164779460699.550479.5112721232994728564.stgit@magnolia>
 <164779463505.550479.1031616651852906518.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164779463505.550479.1031616651852906518.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=623b8d3c
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=nFZoz8ktHrLxk1y9EkgA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 20, 2022 at 09:43:55AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On a modern filesystem, we don't allow userspace to allocate blocks for
> data storage from the per-AG space reservations, the user-controlled
> reservation pool that prevents ENOSPC in the middle of internal
> operations, or the internal per-AG set-aside that prevents ENOSPC.
> Since we now consider free space btree blocks as unavailable for
> allocation for data storage, we shouldn't report those blocks via statfs
> either.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Seems reasonable.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
