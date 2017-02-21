Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34599 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751555AbdBURGx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Feb 2017 12:06:53 -0500
Date: Tue, 21 Feb 2017 09:06:20 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/7] fs, xfs: convert xfs_buf_log_item.bli_refcount from
 atomic_t to refcount_t
Message-ID: <20170221170620.GD5846@birch.djwong.org>
References: <1487692147-17066-1-git-send-email-elena.reshetova@intel.com>
 <1487692147-17066-4-git-send-email-elena.reshetova@intel.com>
 <20170221155922.GI6515@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C4E32A@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C4E32A@IRSMSX102.ger.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

On Tue, Feb 21, 2017 at 04:06:30PM +0000, Reshetova, Elena wrote:
> > On Tue, Feb 21, 2017 at 05:49:03PM +0200, Elena Reshetova wrote:
> > > refcount_t type and corresponding API should be
> > > used instead of atomic_t when the variable is used as
> > > a reference counter. This allows to avoid accidental
> > > refcounter overflows that might lead to use-after-free
> > > situations.
> > 
> > Changelog forgets to mention if this was runtime tested..
> 
> It was boot-tested in the whole refcount_t changes pile, which is not very useful for fs anyway. 
> What's why we are sending this through maintainers to get through their tests. 
> I am sure that testing would be better than what we can do. 

If you're going to go around making this many changes to XFS (or any
other filesystem), please run the changes through xfstests first.
Many fs projects (not just XFS) record their test cases there.

I think the kernel 0day build service is supposed to do that
automatically...

--D

> 
> > 
> > 
> > > @@ -371,7 +371,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
> > >  	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
> > >  	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
> > >  	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
> > > -	ASSERT(atomic_read(&bip->bli_refcount) > 0);
> > > +	ASSERT(refcount_read(&bip->bli_refcount) > 0);
> > >
> > >  	trace_xfs_trans_brelse(bip);
> > >
> > > @@ -419,7 +419,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
> > >  	/*
> > >  	 * Drop our reference to the buf log item.
> > >  	 */
> > > -	atomic_dec(&bip->bli_refcount);
> > > +	refcount_dec(&bip->bli_refcount);
> > >
> > >  	/*
> > >  	 * If the buf item is not tracking data in the log, then
> > > @@ -432,7 +432,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
> > >  /***
> > >  		ASSERT(bp->b_pincount == 0);
> > >  ***/
> > > -		ASSERT(atomic_read(&bip->bli_refcount) == 0);
> > > +		ASSERT(refcount_read(&bip->bli_refcount) == 0);
> > >  		ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
> > >  		ASSERT(!(bip->bli_flags &
> > XFS_BLI_INODE_ALLOC_BUF));
> > >  		xfs_buf_item_relse(bp);
> > 
> > 
> > This for example looks dodgy.
> > 
> > That seems to suggest the atomic_dec() there can actually hit 0, which
> > _will_ generate a WARN.
> 
> True, but in some of this cases WARN might be ok, I think? As soon as functionality is not changed and object is not reused (by doing refcount_inc on it) anywhere later on. 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
