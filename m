Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 08 Sep 2007 06:18:48 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l88DIg4p025772
	for <xfs@oss.sgi.com>; Sat, 8 Sep 2007 06:18:45 -0700
Date: Sat, 8 Sep 2007 15:18:40 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [xfs-masters] [Bug 768]  New: Move restrict_chown to mount-time option
Message-ID: <20070908131840.GA18653@lst.de>
References: <200709051831.l85IVsTR016106@oss.sgi.com> <20070906153529.GA3062@lst.de> <20070906161006.GA25035@filer.fsl.cs.sunysb.edu> <20070907190427.GA8062@lst.de> <20070907191531.GA22883@filer.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070907191531.GA22883@filer.fsl.cs.sunysb.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Christoph Hellwig <hch@lst.de>, nick.couchman@seakr.com, xfs@oss.sgi.com

On Fri, Sep 07, 2007 at 03:15:31PM -0400, Josef Sipek wrote:
> On Fri, Sep 07, 2007 at 09:04:27PM +0200, Christoph Hellwig wrote:
> > On Thu, Sep 06, 2007 at 12:10:06PM -0400, Josef Sipek wrote:
> > > > It's quite easily doable.  I don't have time for that right now, but if
> > > > anyone wants to do it's just adding the option to the mount option
> > > > parser and adding a flag to the mount structure.
> > >  
> > > Wouldn't making this a generic mount-option make sense? Or is it far too
> > > low-level of a concept?
> > 
> > Basically it's a simple boolean flag that's checked in the inode
> > allocator when we decide about the permission of the newly created
> > inode.  Because of that the implementation will be inherently
> > filesystem-specific.
> 
> Couldn't that be done just before the call to ->create as a mask on the
> mode?

Sorry, my post above was talking about the bsd group semantics for which
we had a similar discussion before.  For restricted_chown the method
handling it is ->setattr and given how it's defined to be filesystem
specific I can't see how to do it generically.

> > We could still add a binary mount flag for it in common code, but my
> > stance is to only add these when we actually need to check the flag in
> > general code.
> 
> Or if the feature is so useful that all fs should support it. Is it useful?
> If not, then I agree, not cluttering the VFS is a Good Thing.

It's not really a feature, more a workaround for legacy behaviour in
other Unix variants.  It basically disallows chown in some cases where
it's normally allowed.
