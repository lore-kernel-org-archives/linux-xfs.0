Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60136 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726026AbfDYWpI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Apr 2019 18:45:08 -0400
Date: Fri, 26 Apr 2019 08:45:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] xfs: allow scrubbers to pause background reclaim
Message-ID: <20190425224504.GD29573@dread.disaster.area>
References: <155563325882.112668.3605935077532891922.stgit@magnolia>
 <155563327720.112668.11514675530007162880.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155563327720.112668.11514675530007162880.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 18, 2019 at 05:21:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The forthcoming summary counter patch races with regular filesystem
> activity to compute rough expected values for the counters.  This design
> was chosen to avoid having to freeze the entire filesystem to check the
> counters, but while that's running we'd prefer to minimize background
> reclamation activity to reduce the perturbations to the incore free
> block count.  Therefore, provide a way for scrubbers to disable
> background posteof and cowblock reclamation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
