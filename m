Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46323 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726026AbfDYWod (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Apr 2019 18:44:33 -0400
Date: Fri, 26 Apr 2019 08:44:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: rename the speculative block allocation reclaim
 toggle functions
Message-ID: <20190425224431.GC29573@dread.disaster.area>
References: <155563325882.112668.3605935077532891922.stgit@magnolia>
 <155563327108.112668.10133338747548676442.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155563327108.112668.10133338747548676442.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 18, 2019 at 05:21:11PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> "reclaim" is used throughout the icache code to mean reclamation of
> incore inode structures.  It's also used for two helper functions that
> toggle background deletion of speculative preallocations.  Separate
> the second of the two uses to make things less confusing.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Much nicer :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
