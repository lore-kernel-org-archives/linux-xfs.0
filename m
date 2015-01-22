Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 21EEE7F6B
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 15:32:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 010AD304032
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 13:32:45 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	5rQciqZMjPIwcKL1 for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 13:32:43 -0800 (PST)
Date: Fri, 23 Jan 2015 08:32:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 4/6] xfs: take i_mmap_lock on extent manipulation
	operations
Message-ID: <20150122213241.GB24722@dastard>
References: <1420669543-8093-1-git-send-email-david@fromorbit.com>
	<1420669543-8093-5-git-send-email-david@fromorbit.com>
	<20150122132307.GB25345@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150122132307.GB25345@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com

On Thu, Jan 22, 2015 at 08:23:08AM -0500, Brian Foster wrote:
> On Thu, Jan 08, 2015 at 09:25:41AM +1100, Dave Chinner wrote:
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index 8be5bb5..f491860 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -768,7 +768,7 @@ xfs_setattr_size(
> >  	if (error)
> >  		return error;
> >  
> > -	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> > +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL));
> 
> Only debug code of course, but xfs_isilocked() doesn't appear to support
> what is intended by this call (e.g., verification of multiple locks).

Ah, right. Didn't think that one though properly. I'll fix it up.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
