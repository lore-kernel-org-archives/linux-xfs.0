Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBIIBhmv229820 for <xfs@oss.sgi.com>; Sun, 18 Dec 2011 12:11:45 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	m4KO18851JRCONk1 for <xfs@oss.sgi.com>;
	Sun, 18 Dec 2011 10:11:39 -0800 (PST)
Date: Sun, 18 Dec 2011 13:11:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/11] xfs: replace i_flock with a sleeping bitlock
Message-ID: <20111218181137.GA17569@infradead.org>
References: <20111208155755.323930705@bombadil.infradead.org>
	<20111208155918.493178782@bombadil.infradead.org>
	<20111213221917.GD3179@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111213221917.GD3179@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Dec 14, 2011 at 09:19:17AM +1100, Dave Chinner wrote:
> > +static inline void xfs_ifunlock(struct xfs_inode *ip)
> > +{
> > +	xfs_iflags_clear(ip, XFS_IFLOCK);
> > +	wake_up_bit(&ip->i_flags, __XFS_IFLOCK_BIT);
> > +}
> 
> Should the wakeup be done whilst the ip->i_flags_lock is still held?

There is no reason to do so - __XFS_IFLOCK_BIT is only used as a wakeup key
in wake_up_bit, so it can easily be done after the unlocking.  Doing so
is indeed a lot more efficient as the waiter needs to take the locks as
the first thing after beeing woken.  

> The VFS code does the __I_SYNC wakeup while still holding the
> inode->i_lock so that the clear and wakeup are atomic, similarly the
> __I_NEW bit....

It implements a bit different semantics, and actually needs to hold the
lock for more synchronization than just the wakeup bit.  It does in fact
use the bit wakeup helpers using the atomic test/set bit operations
despite holding a lock for some reason.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
