Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:47705 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753877AbeGCEho (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 00:37:44 -0400
Date: Tue, 3 Jul 2018 14:37:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] fs: xfs: use BUG_ON if writepage call comes from
 direct reclaim
Message-ID: <20180703043738.GG2234@dastard>
References: <1530591079-33813-1-git-send-email-yang.shi@linux.alibaba.com>
 <1530591079-33813-2-git-send-email-yang.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530591079-33813-2-git-send-email-yang.shi@linux.alibaba.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Yang Shi <yang.shi@linux.alibaba.com>
Cc: mgorman@techsingularity.net, tytso@mit.edu, adilger.kernel@dilger.ca, darrick.wong@oracle.com, dchinner@redhat.com, akpm@linux-foundation.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue, Jul 03, 2018 at 12:11:19PM +0800, Yang Shi wrote:
> direct reclaim doesn't write out filesystem page, only kswapd could do
> this. So, if it is called from direct relaim, it is definitely a bug.
> 
> And, Mel Gorman mentioned "Ultimately, this will be a BUG_ON." in commit
> 94054fa3fca1fd78db02cb3d68d5627120f0a1d4 ("xfs: warn if direct reclaim
> tries to writeback pages"),
> 
> It has been many years since that commit, so it should be safe to
> elevate WARN_ON to BUG_ON now.

NACK.

The existing code warns and then handles the situation gracefully -
this is the appropriate way to handle incorrect calling contexts.
There is absolutely no good reason to panic production kernels
in situations like this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
