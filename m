Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Nov 2006 14:51:09 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kANMouaG027386
	for <xfs@oss.sgi.com>; Thu, 23 Nov 2006 14:51:00 -0800
Date: Fri, 24 Nov 2006 09:49:52 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
Message-ID: <20061123224952.GZ11034@melbourne.sgi.com>
References: <455CB54F.8080901@sandeen.net> <455CE1E3.7020703@sandeen.net> <45612621.5010404@sandeen.net> <45627A4D.3020502@sandeen.net> <1164157336.19915.43.camel@xenon.msp.redhat.com> <5A1AC29043EE33BEB778198A@timothy-shimmins-power-mac-g5.local> <45647042.2040604@sandeen.net> <1164212695.19915.65.camel@xenon.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1164212695.19915.65.camel@xenon.msp.redhat.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

On Wed, Nov 22, 2006 at 10:24:55AM -0600, Russell Cattelan wrote:
> On Wed, 2006-11-22 at 09:44 -0600, Eric Sandeen wrote:
> > Timothy Shimmin wrote:
> > > Thanks, Russell.
> > > 
> > > I've been going thru the irc and just started looking at the patch.
> > > I'll get back to you about it tomorrow.
> > > 
> > > I agree it would be good to have the fixed forkoff for data btree roots
> > > as the first fix. And look into redoing the btree root for a later change.
> > 
> > My only question is, how much does this defeat the purpose of attr2?
> Well from the standpoint that attr2 currently corrupts inodes anything
> to prevent that is good, since  currently attr2 can't be used at all.
> When the di_u is extent based the attr2 code works as expected, giving
> space to which ever segment gets there first.The attr2 code should still
> be a big win for most file/dir inodes since they are probably able to do
> their block mapping with local or extent mode.

I suggest that dbench -x might be the best way to determine the
perfomrance impact - attr1 on a single disk would get ~5MB/s; attr2
on the same disk for the same test gave about 50MB/s (IIRC). I'd
hope that this fix retains that kind of advantage for attr2....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
