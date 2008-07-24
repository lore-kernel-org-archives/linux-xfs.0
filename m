Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 22:24:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6O5NeVP032685
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 22:23:42 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87E24E919CA
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 22:24:50 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id bFhmQhUX2d5We471 for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 22:24:50 -0700 (PDT)
Date: Thu, 24 Jul 2008 07:24:40 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/5] more vnode related macro cleanups
Message-ID: <20080724052440.GA24613@lst.de>
References: <20080723194930.GA6188@lst.de> <20080723232702.GP6761@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723232702.GP6761@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Jul 24, 2008 at 09:27:02AM +1000, Dave Chinner wrote:
> On Wed, Jul 23, 2008 at 09:49:30PM +0200, Christoph Hellwig wrote:
> > As Dave's cleanups got in so fast (thanks Niv!) I'll give these patches
> > a spin to.  They are all over so I'd love to get them in fast too and
> > get the leftover bhv_vnode_t bits sorted out ASAP.
> 
> This series applies on a pristine tree? Not on top of your
> other changes (like the sanitize init vnode one)? Several of
> the patches won't apply to my incoming branch because of that.

Yes, this applies straight ontop of your patches.  Interestingly I only had
to rediff '[PATCH] sanitize xfs_initialize_vnode' and the generic ACL patch
for these - I expected a lot more.
