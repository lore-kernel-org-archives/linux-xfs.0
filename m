Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51238 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbfFDOYe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 10:24:34 -0400
Date: Tue, 4 Jun 2019 07:24:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/11] xfs: bulkstat should copy lastip whenever
 userspace supplies one
Message-ID: <20190604142427.GC1200785@magnolia>
References: <155916877311.757870.11060347556535201032.stgit@magnolia>
 <155916880004.757870.14054258865473950566.stgit@magnolia>
 <20190604075442.GX29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604075442.GX29573@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 05:54:42PM +1000, Dave Chinner wrote:
> On Wed, May 29, 2019 at 03:26:40PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When userspace passes in a @lastip pointer we should copy the results
> > back, even if the @ocount pointer is NULL.
> 
> Makes sense and the code change is simple enough, but this changes
> what we return to userspace, right?  Does any of xfsprogs or fstests
> test code actually exercise this case? If not, how have you
> determined it isn't going to break anything?

Coming in a future xfstests submission along with other basic
functionality checks. :)

(Future, as in "later today"...)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
