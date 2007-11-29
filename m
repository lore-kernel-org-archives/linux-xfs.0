Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Nov 2007 12:47:25 -0800 (PST)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lATKlIo3009936
	for <xfs@oss.sgi.com>; Thu, 29 Nov 2007 12:47:21 -0800
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: XFS related Oops (suspend/resume related)
Date: Thu, 29 Nov 2007 22:05:24 +0100
References: <20071112064706.GA23595@dose.home.local> <20071127211155.GK119954183@sgi.com> <200711272253.01136.rjw@sisk.pl>
In-Reply-To: <200711272253.01136.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711292205.25431.rjw@sisk.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tino Keitel <tino.keitel@gmx.de>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tuesday, 27 of November 2007, Rafael J. Wysocki wrote:
> On Tuesday, 27 of November 2007, David Chinner wrote:
> > On Tue, Nov 27, 2007 at 04:51:38PM +0100, Rafael J. Wysocki wrote:
> > > On Monday, 26 of November 2007, Rafael J. Wysocki wrote:
> > > > On Monday, 26 of November 2007, David Chinner wrote:
> > > > > Now there's a message that I haven't seen in about 3 years.
> > > > > 
> > > > > It indicates that the linux inode connected to the xfs_inode is not
> > > > > the correct one. i.e. that the linux inode cache is out of step with
> > > > > the XFS inode cache.
> > > > > 
> > > > > Basically, that is not supposed to happen. I suspect that the way
> > > > > threads are frozen is resulting in an inode lookup racing with
> > > > > a reclaim. The reclaim thread gets stopped after any use threads,
> > > > > and so we could have the situation that a process blocked in lookup
> > > > > has the XFS inode reclaimed and reused before it gets unblocked.
> > > > > 
> > > > > The question is why is it happening now when none of that code in
> > > > > XFS has changed?
> > > > > 
> > > > > Rafael, when are threads frozen? Only when they schedule or call
> > > > > try_to_freeze()?
> > > > 
> > > > Kernel threads freeze only when they call try_to_freeze().  User space tasks
> > > > freeze while executing the signals handling code.
> > > > 
> > > > > Did the freezer mechanism change in 2.6.23 (this is on 2.6.23.1)?
> > > > 
> > > > Yes.  Kernel threads are not sent fake signals by the freezer any more.
> > > 
> > > Ah, sorry, this change has been merged after 2.6.23.  However, before 2.6.23
> > > we had another important change that caused all kernel threads to have
> > > PF_NOFREEZE set by default, unless they call set_freezable() explicitly.
> > 
> > So try_to_freeze() will never freeze a thread if it has not been
> > set_freezable()? And xfsbufd will never be frozen?
> 
> No, it won't.
> 
> I must have overlooked it, probably because it calls refrigerator() directly
> and not try_to_freeze() ...
> 
> I think something like the appended patch will help, then.

Tino, can you check if this patch helps, please?

Greetings,
Rafael


> ---
> Fix breakage caused by commit 831441862956fffa17b9801db37e6ea1650b0f69
> that did not introduce the necessary call to set_freezable() in
> xfs/linux-2.6/xfs_buf.c .
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  fs/xfs/linux-2.6/xfs_buf.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
> @@ -1750,6 +1750,8 @@ xfsbufd(
>  
>  	current->flags |= PF_MEMALLOC;
>  
> +	set_freezable();
> +
>  	do {
>  		if (unlikely(freezing(current))) {
>  			set_bit(XBT_FORCE_SLEEP, &target->bt_flags);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
