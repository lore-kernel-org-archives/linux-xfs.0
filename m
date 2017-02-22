Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:16597 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754629AbdBVLPT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Feb 2017 06:15:19 -0500
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [PATCH 2/7] fs, xfs: convert xfs_buf.b_hold and
 xfs_buf.b_lru_ref from atomic_t to refcount_t
Date: Wed, 22 Feb 2017 11:15:09 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C4EB18@IRSMSX102.ger.corp.intel.com>
References: <1487692147-17066-1-git-send-email-elena.reshetova@intel.com>
 <1487692147-17066-3-git-send-email-elena.reshetova@intel.com>
 <20170221160408.GJ6515@twins.programming.kicks-ass.net>
 <20170221225402.GA23007@dastard>
In-Reply-To: <20170221225402.GA23007@dastard>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

> On Tue, Feb 21, 2017 at 05:04:08PM +0100, Peter Zijlstra wrote:
> > On Tue, Feb 21, 2017 at 05:49:02PM +0200, Elena Reshetova wrote:
> > > @@ -1684,10 +1684,11 @@ xfs_buftarg_isolate(
> > >  	 * zero. If the value is already zero, we need to reclaim the
> > >  	 * buffer, otherwise it gets another trip through the LRU.
> > >  	 */
> > > -	if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
> > > +	if (!refcount_read(&bp->b_lru_ref)) {
> > >  		spin_unlock(&bp->b_lock);
> > >  		return LRU_ROTATE;
> > >  	}
> > > +	refcount_dec_and_test(&bp->b_lru_ref);
> > >
> > >  	bp->b_state |= XFS_BSTATE_DISPOSE;
> > >  	list_lru_isolate_move(lru, item, dispose);
> >
> > This should never have passed testing.. refcount_dec_and_test() has a
> > __must_check.
> >
> > Furthermore the above seems to suggest thingies can live with a 0
> > refcount, so a straight conversion cannot work.
> 
> Yes, 0 is a valid value - the buffer lru reference is *not an object
> lifecycle reference count*. A value of zero means reclaim needs to
> take action if it sees that value - it does not mean that the object
> is not referenced by anyone (that's b_hold). i.e.  b_lru_ref is an
> "active reference weighting" used to provide a heirarchical reclaim
> bias toward less important metadata objects, and has no bearing on
> the actual active users of the object.


OK, so all of this suggests that we should not conver b_lru_ref to the refcount_t then. 
I will remove this conversion from this commit and only leave b_hold.

Thank you!

Best Regards,
Elena.
