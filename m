Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 May 2008 08:55:41 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4MFtaax021405
	for <xfs@oss.sgi.com>; Thu, 22 May 2008 08:55:37 -0700
Date: Thu, 22 May 2008 17:56:16 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: TAKE streamline init/exit path
Message-ID: <20080522155616.GA7682@lst.de>
References: <20080518130511.GA28501@lst.de> <nccprrg32vr.fsf@sgi.com> <20080521060103.GA25003@lst.de> <nccej7w2l9c.fsf@sgi.com> <20080521072425.GA29889@lst.de> <ncc7ido2i1g.fsf_-_@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ncc7ido2i1g.fsf_-_@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, May 21, 2008 at 06:11:23PM +1000, Niv Sardi wrote:
> 
> Christoph Hellwig <hch@lst.de> writes:
> 
> > Updated patch below.  There's now split out function to create/destroy
> > the kmem zones and alloc/free the trace buffers.  I've also changed the
> > ktrace allocations to KM_MAYFAIL and handled errors resulting from that.
> >
> > And yes, we really should replace the XFS_*_TRACE ifdefs with a single
> > XFS_TRACE..
> 
> Thanks, 
> 
> it's in, forgot to send the TAKE message to oss, here it comes:
> 
> Subject: TAKE 976035 -  streamline init/exit path
> 
> Date:  Wed, 21 May 2008 18:02:18 +1000
> Workarea:  chook.melbourne.sgi.com:/build/xaiki/isms/mangrove-1.3
> Inspected by:  hch

Well, mangrove was the sles10 NAS tree if I remember correctly.  And it
indeed hasn't made it to either the CVS or git tree on oss.sgi.com yet.
