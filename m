Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6OLJ3QC196014 for <xfs@oss.sgi.com>; Tue, 24 Jul 2012 16:19:04 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	A8mC6uQJyRmwQx98 for <xfs@oss.sgi.com>;
	Tue, 24 Jul 2012 14:19:01 -0700 (PDT)
Date: Wed, 25 Jul 2012 07:18:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V5] xfs: cleanup the mount options
Message-ID: <20120724211857.GO23387@dastard>
References: <20120711022609.GX19223@dastard>
	<1341988145-12994-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<20120723232813.GL23387@dastard> <500E0217.90405@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <500E0217.90405@cn.fujitsu.com>
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
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Zach Brown <zab@zabbo.net>, xfs@oss.sgi.com

On Tue, Jul 24, 2012 at 10:01:59AM +0800, Wanlong Gao wrote:
> On 07/24/2012 07:28 AM, Dave Chinner wrote:
> > On Wed, Jul 11, 2012 at 02:29:05PM +0800, Wanlong Gao wrote:
> >> @@ -208,175 +292,192 @@ xfs_parseargs(
> >>  	if (!options)
> >>  		goto done;
> >>  
> >> -	while ((this_char = strsep(&options, ",")) != NULL) {
> >> -		if (!*this_char)
> >> +	options = kstrdup(options, GFP_NOFS);
> > 
> > GFP_NOFS allocation. Why is this GFP_NOFS, and all the other
> > allocations GFP_KERNEL? If it is not safe to use GFP_KERNEL
> > allocations here, then all of the above allocations need to be
> > GFP_NOFS, too.
> 
> Since strsep() will change the options, so we should make GFP_NOFS
> safely to dup the orig options, but the parse functions can safely
> use GFP_KERNEL.

I unerstand why you are using kstrdup(). My question is why are you
using GFP_NOFS here? What filesystem recursion deadlock are you
tryin gto avoid here, and why don't the other allocations in the
string parsing need to avoid the same problem as they are called
from the same context?

If there is no recursion deadlock (I can't see that there is one),
then GFP_KERNEL is what you should be using here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
