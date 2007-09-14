Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 15:05:24 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8EM5J4p003701
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2007 15:05:21 -0700
Date: Sat, 15 Sep 2007 00:05:20 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/4] simplify xfs_create/mknod/symlink prototype
Message-ID: <20070914220520.GA19567@lst.de>
References: <20070914163041.GG7110@lst.de> <46EAD364.7060305@sandeen.net> <46EAD432.1030704@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EAD432.1030704@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Sep 14, 2007 at 01:34:26PM -0500, Eric Sandeen wrote:
> > -xfs_symlink [xfs]: 240
> > +xfs_symlink [xfs]: 256
> 
> Although, that one is a little unfortunate ;)

and rather odd.  16 bytes more stack for passing in a 32bit scalar
instead of a 32/64bit pointer, huh?  Then again we could just kill
that parameter because symlinks always get the same mode..
