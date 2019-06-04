Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:40618 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726808AbfFDHyr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 03:54:47 -0400
Date: Tue, 4 Jun 2019 17:54:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/11] xfs: bulkstat should copy lastip whenever
 userspace supplies one
Message-ID: <20190604075442.GX29573@dread.disaster.area>
References: <155916877311.757870.11060347556535201032.stgit@magnolia>
 <155916880004.757870.14054258865473950566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155916880004.757870.14054258865473950566.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 29, 2019 at 03:26:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When userspace passes in a @lastip pointer we should copy the results
> back, even if the @ocount pointer is NULL.

Makes sense and the code change is simple enough, but this changes
what we return to userspace, right?  Does any of xfsprogs or fstests
test code actually exercise this case? If not, how have you
determined it isn't going to break anything?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
