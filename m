Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 18:38:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5C1cIWt029334
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 18:38:21 -0700
Date: Tue, 12 Jun 2007 11:38:03 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs_fsr allocation group optimization
Message-ID: <20070612013803.GI86004887@sgi.com>
References: <1181544692.19145.44.camel@gentoo-johan.transmode.se> <20070611073559.GA26257@tuatara.stupidest.org> <1181551409.19145.57.camel@gentoo-johan.transmode.se> <20070611090138.GA28907@tuatara.stupidest.org> <1181553356.19145.65.camel@gentoo-johan.transmode.se> <20070611094133.GA31108@tuatara.stupidest.org> <1181558353.19145.76.camel@gentoo-johan.transmode.se> <20070611155824.GA12668@tuatara.stupidest.org> <1181603256.3758.46.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181603256.3758.46.camel@edge.yarra.acx>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: Chris Wedgwood <cw@f00f.org>, Johan Andersson <johan@e-626.net>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Jun 12, 2007 at 09:07:36AM +1000, Nathan Scott wrote:
> On Mon, 2007-06-11 at 08:58 -0700, Chris Wedgwood wrote:
> > > In the way xfs_fsr operates now, in almost all user space, I don't
> > > see any good way to tell XFS where to place the extents, other than
> > > creating the temporary file in the same directory as the original
> > > file.
> > 
> > Exactly.
> > 
> > > My question is really, is there a better way than "find -xdev -inum"
> > > to find what file points to a given inode?
> > 
> > You can build then entire tree in-core using bulkstat and readdir,
> > doing the bulkstat first means you can try to optimize the order you
> > do the readdirs in somewhat.
> 
> Probably better to change the kernel extent-swap code to not do
> alloc-near-tempinode allocations, and instead find a way to pass
> XFS_ALLOCTYPE_THIS_AG/XFS_ALLOCTYPE_NEAR_BNO/or some saner alloc
> flag down to the allocator for all extent swapping allocations.

/me sighs and points to the generic allocation interface I wanted
for exactly these reasons:

http://marc.info/?l=linux-fsdevel&m=116278169519095&w=2

Instead, we're getting a mostly useless XFS_IOC_RESVSP replacement
called sys_fallocate() that provides us with pretty much nothing.
Given that sys_fallocate() can't be extended to do this sort of
thing, we're going to be stuck with doing our own thing again....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
