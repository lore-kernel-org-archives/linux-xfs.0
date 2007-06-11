Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 16:08:40 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5BN8XWt004298
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 16:08:36 -0700
Subject: Re: xfs_fsr allocation group optimization
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20070611155824.GA12668@tuatara.stupidest.org>
References: <1181544692.19145.44.camel@gentoo-johan.transmode.se>
	 <20070611073559.GA26257@tuatara.stupidest.org>
	 <1181551409.19145.57.camel@gentoo-johan.transmode.se>
	 <20070611090138.GA28907@tuatara.stupidest.org>
	 <1181553356.19145.65.camel@gentoo-johan.transmode.se>
	 <20070611094133.GA31108@tuatara.stupidest.org>
	 <1181558353.19145.76.camel@gentoo-johan.transmode.se>
	 <20070611155824.GA12668@tuatara.stupidest.org>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 09:07:36 +1000
Message-Id: <1181603256.3758.46.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Johan Andersson <johan@e-626.net>, xfs@oss.sgi.com

On Mon, 2007-06-11 at 08:58 -0700, Chris Wedgwood wrote:
> 
> 
> > In the way xfs_fsr operates now, in almost all user space, I don't
> > see any good way to tell XFS where to place the extents, other than
> > creating the temporary file in the same directory as the original
> > file.
> 
> Exactly.
> 
> > My question is really, is there a better way than "find -xdev -inum"
> > to find what file points to a given inode?
> 
> You can build then entire tree in-core using bulkstat and readdir,
> doing the bulkstat first means you can try to optimize the order you
> do the readdirs in somewhat.
> 

Probably better to change the kernel extent-swap code to not do
alloc-near-tempinode allocations, and instead find a way to pass
XFS_ALLOCTYPE_THIS_AG/XFS_ALLOCTYPE_NEAR_BNO/or some saner alloc
flag down to the allocator for all extent swapping allocations.

cheers.
