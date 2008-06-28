Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 28 Jun 2008 08:22:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5SFMDGd010812
	for <xfs@oss.sgi.com>; Sat, 28 Jun 2008 08:22:14 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD4AD79707D
	for <xfs@oss.sgi.com>; Sat, 28 Jun 2008 08:23:14 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 2l2eyhuGMIWF0Z5S for <xfs@oss.sgi.com>; Sat, 28 Jun 2008 08:23:14 -0700 (PDT)
Date: Sat, 28 Jun 2008 17:23:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: rfc: kill ino64 mount option
Message-ID: <20080628152303.GA22484@lst.de>
References: <20080627153928.GA31384@lst.de> <20080628000914.GE29319@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080628000914.GE29319@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Sat, Jun 28, 2008 at 10:09:14AM +1000, Dave Chinner wrote:
> On Fri, Jun 27, 2008 at 05:39:28PM +0200, Christoph Hellwig wrote:
> > Does anyone have objections to kill the ino64 mount option?  It's purely
> > a debug tool to force inode numbers outside of the range representable
> > in 32bits and is quite invasive for something that could easily be
> > debugged by just having a large enough filesystem..
> 
> It's the "large enough fs" that is the problem. XFSQA uses
> small partitions for the most part, and this allows testing
> of 64 bit inode numbers with a standard qa config.

Well, it allows showing 64bit inode numbers to userspace.  All XFS
internal codepathes are still using the smaller inode numbers and we
only add a fixed offset to them just before the inode number is returned
to userspace.
