Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54562 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753837AbdBUQ2F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Feb 2017 11:28:05 -0500
Date: Tue, 21 Feb 2017 17:27:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/7] fs, xfs: convert xfs_buf_log_item.bli_refcount from
 atomic_t to refcount_t
Message-ID: <20170221162758.GK6515@twins.programming.kicks-ass.net>
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

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

For FS changes, I would recommend at the very least running xfstests on
an instance (which unlike the name suggests is good for most block
filesystems Linux has).

> > > @@ -432,7 +432,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
> > >  /***
> > >  		ASSERT(bp->b_pincount == 0);
> > >  ***/
> > > -		ASSERT(atomic_read(&bip->bli_refcount) == 0);
> > > +		ASSERT(refcount_read(&bip->bli_refcount) == 0);
> > >  		ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
> > >  		ASSERT(!(bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF));
> > >  		xfs_buf_item_relse(bp);
> > 
> > 
> > This for example looks dodgy.
> > 
> > That seems to suggest the atomic_dec() there can actually hit 0, which
> > _will_ generate a WARN.
> 
> True, but in some of this cases WARN might be ok, I think? As soon as
> functionality is not changed and object is not reused (by doing
> refcount_inc on it) anywhere later on. 

No, your conversion should not generate spurious WARN()s.

And also no, atomic_dec() must not hit 0. If you've been _that_ careful
with your reference counting and you absolutely _know_ this is the very
last one, write something like:

  WARN_ON(!refcount_dec_if_one());


Please, stop sending out conversions that haven't been tested. And take
the time to actually look at your own patches. If I can spot fail just
looking through them, so can you (or any of the other many people in
your SoB chain).

Take a little more time and a little extra care.
