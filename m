Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9HV31T132249 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 11:31:03 -0600
Date: Fri, 9 Nov 2012 11:32:59 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 1/2] xfs: xfs_tosspages() bug
Message-ID: <20121109173259.GU9783@sgi.com>
References: <20121108222315.505370321@sgi.com>
	<20121108222315.626928496@sgi.com> <20121108230649.GU6434@dastard>
	<20121108234642.GR9783@sgi.com> <20121109010517.GW6434@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121109010517.GW6434@dastard>
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
Cc: Andrew Dahl <adahl@sgi.com>, xfs@oss.sgi.com

Hey Dave,

On Fri, Nov 09, 2012 at 12:05:17PM +1100, Dave Chinner wrote:
> On Thu, Nov 08, 2012 at 05:46:42PM -0600, Ben Myers wrote:
> > Hey Dave,
> > 
> > On Fri, Nov 09, 2012 at 10:06:49AM +1100, Dave Chinner wrote:
> > > On Thu, Nov 08, 2012 at 04:23:16PM -0600, Andrew Dahl wrote:
> > > > xfs_tosspages() takes a closed interval as an argument, take 
> > > > this into account when rounding down to the last byte of the
> > > > last complete page. If the request consists of a single 
> > > > partial page, there will be nothing to toss. 
> > > > 
> > > > Signed-off-by: Andrew Dahl <adahl@sgi.com>
> > > > 
> > > > ---
> > 
> > ...
> > 
> > > So the change is good.
> > > 
> > > However, there's a bigger issue here. We've planned to remove these
> > > wrappers for a long time, just never got around to doing it. Seeing
> > > as there is a bug in this wrapper and it needs to be fixed, now
> > > seems like the right time to remove it.
> > 
> > The removal of the wrappers would not be appropriate for -stable.  This fix
> > needs to go in separately from any refactoring so that it can be pulled back
> > within the rules outlined in Documentation/stable_kernel_rules.txt.
> 
> You're acting like I've never read those rules before. I know
> exactly what they say, and patch that removes a busted helper is
> well and truly within the scope of a stable backport. Quoting rules
> at me like I'm a newbie only serves to annoy me....

Whoa there, relax!  There's no intent to annoy you here.  It's Andrew who is
the newbie.  I am adressing you here but I'm also keeping in mind that he'll
read it too.  You're both in the To: line.

> As it is, looking at what xfs_tosspages is supposed to be doing,
> calling truncate_inode_pages_range() is actually the wrong thing to
> do.  We should be calling truncate_pagecache_range(), because we
> should be unmapping pages before truncating them away. And for that
> same reason, xfs_flushinvalidate() is also wrong and broken.
> 
> That is, the call in xfs_swap_extents() changes to:
> 
> -	xfs_tosspages(ip, 0, -1, FI_REMAPF);
> +	truncate_pagecache_range(VFS_I(ip), 0, -1);
> 
> And the one in xfs_change_file_space becomes:
> 
> -		xfs_tosspages(ip, startoffset, startoffset + bf->l_len, 0);
> +		truncate_pagecache_range(VFS_I(ip), startoffset,
> +					 startoffset + bf->l_len);
> 
> and xfs_tosspages() goes away. That's a far better fix for the
> problem than what has been proposed, IMO, and in no way is
> inappropriate for -stable.

Sounds reasonable.

> As it is, I wouldn't even consider this a fix that is needed for
> stable kernels - XFS_IOC_ZERO is an obscure interface, and
> xfs_swap_extents works just fine as it stands....

We support even the obscure interfaces.

> ....
> > > >  		prealloc_type |= XFS_BMAPI_CONVERT;
> > > > -		xfs_tosspages(ip, startoffset, startoffset + bf->l_len, 0);
> > > > +		xfs_tosspages(ip, startoffset, bf->l_len ? startoffset + llen : -1, 0);
> > > >  		/* FALLTHRU */
> > > >  	case XFS_IOC_RESVSP:
> > > >  	case XFS_IOC_RESVSP64:
> > > 
> > > What's this hunk for? Indeed, one of the first things that the
> > > xfs_alloc_file_space() checks is this:
> > > 
> > >         if (len <= 0)
> > > 		return XFS_ERROR(EINVAL);
> > > 
> > > xfs_free_file_space() does the same check, so it is invalid to pass
> > > a bf_len <= 0 for any of these specific functions. Hence this change
> > > is wrong regardless of what the comment on the struct xfs_flock64_t
> > > says - preallocation and hole punch operations must have a positive
> > > length associated with them.
> > 
> > Andrew, if you agree that this second change is unnecessary go ahead and remove
> > it and repost.  Otherwise,
> 
> I didn't say it was unnecessary - I said it was wrong. We shouldn't
> even be getting as far as the xfs_tosspages() call if bf_len is zero
> or negative. That's the bug that needs fixing in this function.

Aha.  I think I see it now.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
