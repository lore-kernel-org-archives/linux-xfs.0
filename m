Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Apr 2007 07:33:37 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3MEXTfB011841
	for <xfs@oss.sgi.com>; Sun, 22 Apr 2007 07:33:32 -0700
Date: Sun, 22 Apr 2007 16:33:26 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] kill macro noise in xfs_dir2*.h
Message-ID: <20070422143326.GA15747@lst.de>
References: <20070418175859.GB18315@lst.de> <20070419000940.GL48531920@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419000940.GL48531920@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Apr 19, 2007 at 10:09:40AM +1000, David Chinner wrote:
> On Wed, Apr 18, 2007 at 07:59:00PM +0200, Christoph Hellwig wrote:
> > Remove all the macros that just give inline functions uppercase names.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> BTW, you'll need this patch to make debug kernels build....

Well, there's not xfsidb in mainline and that's the tree I tend to
work with for all my patches.  I suspect you'll have to fixup xfsidb
for whatever patches come from normal mainline-using developers :)
