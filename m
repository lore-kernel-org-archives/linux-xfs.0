Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 07 Sep 2007 12:04:40 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l87J4V4p011560
	for <xfs@oss.sgi.com>; Fri, 7 Sep 2007 12:04:36 -0700
Date: Fri, 7 Sep 2007 21:04:27 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [xfs-masters] [Bug 768]  New: Move restrict_chown to mount-time option
Message-ID: <20070907190427.GA8062@lst.de>
References: <200709051831.l85IVsTR016106@oss.sgi.com> <20070906153529.GA3062@lst.de> <20070906161006.GA25035@filer.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070906161006.GA25035@filer.fsl.cs.sunysb.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Christoph Hellwig <hch@lst.de>, nick.couchman@seakr.com, xfs@oss.sgi.com

On Thu, Sep 06, 2007 at 12:10:06PM -0400, Josef Sipek wrote:
> > It's quite easily doable.  I don't have time for that right now, but if
> > anyone wants to do it's just adding the option to the mount option
> > parser and adding a flag to the mount structure.
>  
> Wouldn't making this a generic mount-option make sense? Or is it far too
> low-level of a concept?

Basically it's a simple boolean flag that's checked in the inode
allocator when we decide about the permission of the newly created
inode.  Because of that the implementation will be inherently
filesystem-specific.  We could still add a binary mount flag for it in
common code, but my stance is to only add these when we actually need
to check the flag in general code.
