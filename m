Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qADLR04D153245 for <xfs@oss.sgi.com>; Tue, 13 Nov 2012 15:27:00 -0600
Date: Tue, 13 Nov 2012 15:29:03 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/4] xfs: remove xfs_tosspages
Message-ID: <20121113212903.GC19387@sgi.com>
References: <1352455804-17045-1-git-send-email-david@fromorbit.com>
	<1352455804-17045-2-git-send-email-david@fromorbit.com>
	<50A15F57.3080900@sgi.com> <20121112230029.GW24575@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121112230029.GW24575@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Andrew Dahl <adahl@sgi.com>

Hi Dave,

On Tue, Nov 13, 2012 at 10:00:29AM +1100, Dave Chinner wrote:
> On Mon, Nov 12, 2012 at 02:43:03PM -0600, Andrew Dahl wrote:
> > On 11/09/2012 04:10 AM, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > It's a buggy, unnecessary wrapper that is duplicating
> > > truncate_pagecache_range().
> > > 
> > > When replacing the call in xfs_change_file_space(), also ensure that
> > > the length being allocated/freed is always positive before making
> > > any changes. These checks are done in the lower extent manipulation
> > > functions, too, but we need to do them before any page cache
> > > operations.
> > > 
> > > Reported-by: Andrew Dahl <adahl@sgi.com>
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ....
> > > @@ -2169,7 +2186,8 @@ xfs_change_file_space(
> > >  	switch (cmd) {
> > >  	case XFS_IOC_ZERO_RANGE:
> > >  		prealloc_type |= XFS_BMAPI_CONVERT;
> > > -		xfs_tosspages(ip, startoffset, startoffset + bf->l_len, 0);
> > > +		truncate_pagecache_range(VFS_I(ip), startoffset,
> > > +			 round_down(startoffset + bf->l_len, PAGE_SIZE) - 1);
> > 
> > When calling XFS_IOC_ZERO_RANGE with a range [0, 4095] or [0,1] it's
> > tossing pages because the call to round_down() is returning 0 and
> > passing -1 in for the end will toss all pages.  So, we need to make sure
> > round_down() isn't going to return a 0, or that (startoffset +
> > bf->l_len) > PAGE_SIZE.
> 
> Right, which was the original bug. I didn't think that through
> fully....
> 
> > So, something like...
> > 
> > 
> > xfs_off_t       end;
> > 
> > [...]
> > 
> > if((end = round_down(startoffset + bf->l_len, PAGE_SIZE)) > 0) {
> > 	truncate_pagecache_range(VFS_I(ip), startoffset, end - 1);
> > }
> 
> Actually, it is more complex than that. Think of the range [4096,
> 4097]. That would result in passing 4096, 4095 to
> truncate_pagecache_range(), which is also wrong but implicitly
> handled correctly in truncate_inode_pages_range(). Hence it should
> be:
> 
> 		end = round_down(startoffset + bf->l_len, PAGE_SIZE) - 1;
> 		if (startoffset > end)
> 			truncate_pagecache_range(VFS_I(ip), startoffset, end);
> 
> That's similar to your original fix, which had a last < first check
> in it. I'll post a fix in a few minutes...

I'd like to pull this in tomorrow.  Could you get this one sorted out today?
If not, I think we could also enlist Andrew to fix it.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
