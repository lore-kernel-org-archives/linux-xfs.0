Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54573 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726380AbfDYWqR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Apr 2019 18:46:17 -0400
Date: Fri, 26 Apr 2019 08:46:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: scrub should check incore counters against
 ondisk headers
Message-ID: <20190425224614.GE29573@dread.disaster.area>
References: <155563325882.112668.3605935077532891922.stgit@magnolia>
 <155563328320.112668.15619698497236667722.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155563328320.112668.15619698497236667722.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 18, 2019 at 05:21:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In theory, the incore per-AG structure counters should match the ones on
> disk, so check that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Yup, we should definitely do this.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
