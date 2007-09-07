Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 07 Sep 2007 12:15:38 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l87JFX4p013249
	for <xfs@oss.sgi.com>; Fri, 7 Sep 2007 12:15:35 -0700
Date: Fri, 7 Sep 2007 15:15:31 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Subject: Re: [xfs-masters] [Bug 768]  New: Move restrict_chown to
	mount-time option
Message-ID: <20070907191531.GA22883@filer.fsl.cs.sunysb.edu>
References: <200709051831.l85IVsTR016106@oss.sgi.com> <20070906153529.GA3062@lst.de> <20070906161006.GA25035@filer.fsl.cs.sunysb.edu> <20070907190427.GA8062@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070907190427.GA8062@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: nick.couchman@seakr.com, xfs@oss.sgi.com

On Fri, Sep 07, 2007 at 09:04:27PM +0200, Christoph Hellwig wrote:
> On Thu, Sep 06, 2007 at 12:10:06PM -0400, Josef Sipek wrote:
> > > It's quite easily doable.  I don't have time for that right now, but if
> > > anyone wants to do it's just adding the option to the mount option
> > > parser and adding a flag to the mount structure.
> >  
> > Wouldn't making this a generic mount-option make sense? Or is it far too
> > low-level of a concept?
> 
> Basically it's a simple boolean flag that's checked in the inode
> allocator when we decide about the permission of the newly created
> inode.  Because of that the implementation will be inherently
> filesystem-specific.

Couldn't that be done just before the call to ->create as a mask on the
mode?

> We could still add a binary mount flag for it in common code, but my
> stance is to only add these when we actually need to check the flag in
> general code.

Or if the feature is so useful that all fs should support it. Is it useful?
If not, then I agree, not cluttering the VFS is a Good Thing.

Josef 'Jeff' Sipek.

-- 
Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are, by
definition, not smart enough to debug it.
		- Brian W. Kernighan 
