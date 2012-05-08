Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q48MZ9Np033778 for <xfs@oss.sgi.com>; Tue, 8 May 2012 17:35:09 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	FC0FhZpyXGPr4CN0 for <xfs@oss.sgi.com>;
	Tue, 08 May 2012 15:35:07 -0700 (PDT)
Date: Wed, 9 May 2012 08:35:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix delalloc quota accounting on failure
Message-ID: <20120508223505.GI5091@dastard>
References: <1336474133-27732-1-git-send-email-david@fromorbit.com>
	<4FA92DA7.4090809@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FA92DA7.4090809@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, May 08, 2012 at 09:28:55AM -0500, Eric Sandeen wrote:
> On 5/8/12 5:48 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfstest 270 was causing quota reservations way beyond what was sane
> > (ten to hundreds of TB) for a 4GB filesystem. There's a sign problem
> > in the error handling path of xfs_bmapi_reserve_delalloc() because
> > xfs_trans_unreserve_quota_nblks() simple negates the value passed -
> > which doesn't work for an unsigned variable. This causes
> > reservations of close to 2^32 block instead of removing a
> > reservation of a handful of blocks.
> > 
> > Fix the same problem in the other xfs_trans_unreserve_quota_nblks()
> > callers where unsigned integer variables are used, too.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Ouch!
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> as far as it goes, but a couple thoughts:
> 
> 1) Should the cast be done in the macro so new callers don't get tripped up?
> 2) Should we just remove the ninos argument from the macro?  It's always passed as 0 (and could potentially suffer the same problem)
> 
> something like:

3) I'm going to remove the problematic macro altogether.

I just wanted to get this fix out there while I look at the other
quota problems I've found. Hint: xfstests _check_quota_usage()
doesn't actually work *at all* on XFS (always passes without
actually checking quotas), and so it has been hiding problems with
either the tests that use it or the quota code for some time....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
