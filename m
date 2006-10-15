Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Oct 2006 14:58:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9FLwGaG029551
	for <xfs@oss.sgi.com>; Sun, 15 Oct 2006 14:58:19 -0700
Date: Mon, 16 Oct 2006 07:57:19 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Remove DIO_OWN_LOCKING
Message-ID: <20061015215719.GL19345@melbourne.sgi.com>
References: <1160700998.5723.65.camel@xenon.msp.redhat.com> <20061013024830.GF11034@melbourne.sgi.com> <1160762973.5723.81.camel@xenon.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1160762973.5723.81.camel@xenon.msp.redhat.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Oct 13, 2006 at 01:09:33PM -0500, Russell Cattelan wrote:
> On Fri, 2006-10-13 at 12:48 +1000, David Chinner wrote:
> > On Thu, Oct 12, 2006 at 07:56:38PM -0500, Russell Cattelan wrote:
> > > While trying to fix up GFS2 directio and reading through the code
> > > involving the various lock flags I discovered the DIO_OWN_LOCKING 
> > > flag is no longer used.
> > >  
> > > XFS recently changed it xfs_vm_direct_IO function to call
> > > blockdev_direct_IO_no_locking for reads and
> > > blockdev_direct_IO_own_locking
> > > for writes. But DIO_OWN_LOCKING is only used in the direct IO read case
> > > so effectively the flag is never checked an therefore can probably be
> > > removed.
> > 
> > NACK.
> > 
> > This breaks XFS direct writes - the DIO_OWN_LOCKING flag has meaning
> > for direct writes even though a simple grep doesn't give you any
> > hits. get_more_blocks() sets the create flag unconditionally on
> > writes when DIO_OWN_LOCKING is set, and this is needed for XFS to be
> > able to allocate underlying blocks if the direct write is over a
> > hole or past EOF.
>
> Arrghh you are correct!
> Even more reason to clean this logic up.

No argument here ;)

> look this version over and see what you think.
> 
> comments not in final state but is describing what
> is being changed an why.
> 
> Basically the idea is to have separate flags for locking
> and creation, overloading the flags meant that they were
> specific for XFS needs and therefore did not work for
> GFS.

*nod*

That was always going to happen as soon as another filesystem
wanted to use it's own locking and had different create semantics...

> Also go to a TRUE state if flag on and a FALSE state if flag off.
> vs the mix of true flag (DIO_LOCKING) vs false flag
> (DIO_NO_LOCKING)

Looks like a good approach to me - it's cleaner and more extensible
that what we have now....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
