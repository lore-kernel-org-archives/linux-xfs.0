Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Jul 2008 02:14:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6Q9DwkL020775
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:13:59 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 817BC331B8D
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:15:09 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 1NXUtEttb4OleBBz for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:15:09 -0700 (PDT)
Date: Sat, 26 Jul 2008 11:14:59 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] update timestamp in xfs_ialloc manually
Message-ID: <20080726091459.GB29710@lst.de>
References: <20080726063331.GA22603@lst.de> <20080726090725.GR5947@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080726090725.GR5947@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Sat, Jul 26, 2008 at 07:07:25PM +1000, Dave Chinner wrote:
> On Sat, Jul 26, 2008 at 08:33:31AM +0200, Christoph Hellwig wrote:
> > In xfs_ialloc we just want to set all timestamps to the current time.
> > We don't need to mark the inode dirty like xfs_ichgtime does, and we
> > don't need nor want the opimizations in xfs_ichgtime that I will
> > introduce in the next patch.
> 
> Looks sane, and solves an issue with code I'm working on, too.
> 
> FWIW, the conditional check against I_NEW before marking the
> indo dirty can be removed as well, as this was call that required
> avoiding avoiding it.

Yeah.  Will update and retest the patch.
