Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Oct 2008 23:03:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9K63g7C017603
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 23:03:43 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B80151A028
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 23:05:25 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 6jG4jP6iSBllrfl2 for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 23:05:25 -0700 (PDT)
Date: Mon, 20 Oct 2008 17:05:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Re: another problem with latest code drops
Message-ID: <20081020060522.GP31761@disturbed>
References: <48F6FCB7.6050905@sgi.com> <20081016222904.GA31761@disturbed> <48F7E7BA.4070209@sgi.com> <20081017012141.GJ25906@disturbed> <20081017020434.GD31761@disturbed> <20081017020718.GE31761@disturbed> <48FBEED9.30609@sgi.com> <20081020031757.GM31761@disturbed> <48FC0B16.9090102@sgi.com> <20081020052929.GN31761@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081020052929.GN31761@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Oct 20, 2008 at 04:29:29PM +1100, Dave Chinner wrote:
> On Mon, Oct 20, 2008 at 02:37:42PM +1000, Lachlan McIlroy wrote:
> > Dave Chinner wrote:
> >> On Mon, Oct 20, 2008 at 12:37:13PM +1000, Lachlan McIlroy wrote:
> >>> I also hit this panic where we have taken a reference on an inode
> >>> that has I_CLEAR set.  I suspect we've made it into xfs_iget_cache_hit()
> >>
> >> I don't think there is an iput() in that path.  The only iput() call
> >> should be the IRELE() I added to xfs_iget_cache_miss(). Can you make
> >> sure the compiler is not inlining functions so we can pin-point
> >> where the iput() call is coming from? (i.e. static > STATIC on the
> >> hit/miss functions)
> > Just disassembled xfs_iget() and xfs_iget_cache_miss() has been inlined
> > and we're calling the IRELE() at the end of that function.
> 
> Ok, that makes more sense.
> 
> >>> and found an inode with XFS_IRECLAIMABLE set and since we don't call
> >>> igrab() we don't do the I_CLEAR check.
> >>
> >> In that case, we call inode_init_always() instead which sets the
> >> state to I_NEW and the reference count to 1. In the error case,
> >> the inode will have already been freed and we make
> > We don't set inode->i_state to i_NEW.  We're stuffing XFS_INEW into
> > the XFS inode's i_flags field and not removing the I_CLEAR from the
> > linux inode.  Note that inode_init_always() doesn't touch i_state.
> 
> Yeah, xfs_setup_inode() is what is doing:
> 
> 	inode->i_state = I_NEW|I_LOCK;
> 
> which happens after the cache miss has been processed.
> 
> Ok, so the initialisation code needs to clear іnode->i_state
> during allocation so that iput() does not complain. The i_state
> field is not accessed by anything until the inode is inserted
> into the superblock lists, so it should be safe to zero it
> in xfs_inode_alloc(). I missed that new_inode() returns an
> inode with a zeroed i_state....

On second thoughts, the inode has not been set up properly
by this stage, so we can't really even expect to be able to
call iput() on it. Hmmmm - maybe the only thing we can do
here is call security_inode_free() before xfs_idestroy.

Christoph - any opinions on what the best thing to do is?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
