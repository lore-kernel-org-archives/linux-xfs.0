Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2NBZPCX089311 for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 06:35:31 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F2C136D1CA
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 04:38:25 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	nBLLE4lQlz5S0koT for <xfs@oss.sgi.com>;
	Wed, 23 Mar 2011 04:38:25 -0700 (PDT)
Date: Wed, 23 Mar 2011 22:38:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: outstanding patches for 2.6.39
Message-ID: <20110323113803.GB26611@dastard>
References: <1300860870-15471-1-git-send-email-david@fromorbit.com>
	<m24o6u48xu.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <m24o6u48xu.fsf@firstfloor.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andi Kleen <andi@firstfloor.org>
Cc: aelder@sgi.com, xfs@oss.sgi.com

On Wed, Mar 23, 2011 at 12:01:17AM -0700, Andi Kleen wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > Of course, the major patch in this series is the conversion of the
> > buffer cache to using kmalloc and get_free_page() directly rather
> > than using the page cache. This has many benefits and I haven't
> > found any regressions due to making that change yet.
> 
> One (somewhat obscure) regression will be that you won't be able to
> recover from uncorrected memory errors in the buffer cache anymore.

We can't do that right now, anyway.

> Previously memory_failure() could just drop it transparently when that
> happens and the page is currently not used.

If the page is not in use, we don't care about it after this patch
set is applied - the page is either active in a buffer or it has been
freed. If it is in use, then we'll shut the filesystem down if we
detect the memory corruption just like we currently do. Hence I
don't see any regression here.

As it is, there is no way for the filesytem to be notified about
such failures on active pages in buffers, so in reality we can't
reliably detect them so there is little point in trying to recover
from such errors.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
