Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACMwTvH258479 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 16:58:29 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	cXFpYkLil2K2JDtf for <xfs@oss.sgi.com>;
	Mon, 12 Nov 2012 15:00:31 -0800 (PST)
Date: Tue, 13 Nov 2012 10:00:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: remove xfs_tosspages
Message-ID: <20121112230029.GW24575@dastard>
References: <1352455804-17045-1-git-send-email-david@fromorbit.com>
	<1352455804-17045-2-git-send-email-david@fromorbit.com>
	<50A15F57.3080900@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50A15F57.3080900@sgi.com>
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
To: Andrew Dahl <adahl@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Nov 12, 2012 at 02:43:03PM -0600, Andrew Dahl wrote:
> On 11/09/2012 04:10 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > It's a buggy, unnecessary wrapper that is duplicating
> > truncate_pagecache_range().
> > 
> > When replacing the call in xfs_change_file_space(), also ensure that
> > the length being allocated/freed is always positive before making
> > any changes. These checks are done in the lower extent manipulation
> > functions, too, but we need to do them before any page cache
> > operations.
> > 
> > Reported-by: Andrew Dahl <adahl@sgi.com>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
....
> > @@ -2169,7 +2186,8 @@ xfs_change_file_space(
> >  	switch (cmd) {
> >  	case XFS_IOC_ZERO_RANGE:
> >  		prealloc_type |= XFS_BMAPI_CONVERT;
> > -		xfs_tosspages(ip, startoffset, startoffset + bf->l_len, 0);
> > +		truncate_pagecache_range(VFS_I(ip), startoffset,
> > +			 round_down(startoffset + bf->l_len, PAGE_SIZE) - 1);
> 
> When calling XFS_IOC_ZERO_RANGE with a range [0, 4095] or [0,1] it's
> tossing pages because the call to round_down() is returning 0 and
> passing -1 in for the end will toss all pages.  So, we need to make sure
> round_down() isn't going to return a 0, or that (startoffset +
> bf->l_len) > PAGE_SIZE.

Right, which was the original bug. I didn't think that through
fully....

> So, something like...
> 
> 
> xfs_off_t       end;
> 
> [...]
> 
> if((end = round_down(startoffset + bf->l_len, PAGE_SIZE)) > 0) {
> 	truncate_pagecache_range(VFS_I(ip), startoffset, end - 1);
> }

Actually, it is more complex than that. Think of the range [4096,
4097]. That would result in passing 4096, 4095 to
truncate_pagecache_range(), which is also wrong but implicitly
handled correctly in truncate_inode_pages_range(). Hence it should
be:

		end = round_down(startoffset + bf->l_len, PAGE_SIZE) - 1;
		if (startoffset > end)
			truncate_pagecache_range(VFS_I(ip), startoffset, end);

That's similar to your original fix, which had a last < first check
in it. I'll post a fix in a few minutes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
