Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1459C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Dec 2021 05:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbhLPFHP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Dec 2021 00:07:15 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:52163 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231639AbhLPFHP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Dec 2021 00:07:15 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6E8F58A521E;
        Thu, 16 Dec 2021 16:07:13 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mxiz2-003dgN-SD; Thu, 16 Dec 2021 16:07:12 +1100
Date:   Thu, 16 Dec 2021 16:07:12 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: fix quotaoff mutex usage now that we don't
 support disabling it
Message-ID: <20211216050712.GB449541@dread.disaster.area>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
 <163961698300.3129691.4408918955613874796.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163961698300.3129691.4408918955613874796.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=61bac981
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=IOMw9HtfNCkA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=rPssqXeWKZwSh4wPeXYA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 15, 2021 at 05:09:43PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Prior to commit 40b52225e58c ("xfs: remove support for disabling quota
> accounting on a mounted file system"), we used the quotaoff mutex to
> protect dquot operations against quotaoff trying to pull down dquots as
> part of disabling quota.
> 
> Now that we only support turning off quota enforcement, the quotaoff
> mutex only protects changes in m_qflags/sb_qflags.  We don't need it to
> protect dquots, which means we can remove it from setqlimits and the
> dquot scrub code.  While we're at it, fix the function that forces
> quotacheck, since it should have been taking the quotaoff mutex.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
