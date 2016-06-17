Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 95C597CBA
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 11:54:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 65B918F8037
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 09:54:33 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id mJDMa1Um3f7dA2sm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 17 Jun 2016 09:54:30 -0700 (PDT)
Date: Fri, 17 Jun 2016 09:54:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 002/119] vfs: support FS_XFLAG_REFLINK and
	FS_XFLAG_COWEXTSIZE
Message-ID: <20160617165400.GC6376@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612628567.12839.3246258786290141903.stgit@birch.djwong.org>
	<20160617114117.GF19042@infradead.org>
	<20160617121604.GB23661@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160617121604.GB23661@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, vishal.l.verma@intel.com

On Fri, Jun 17, 2016 at 08:16:05AM -0400, Brian Foster wrote:
> On Fri, Jun 17, 2016 at 04:41:17AM -0700, Christoph Hellwig wrote:
> > On Thu, Jun 16, 2016 at 06:18:05PM -0700, Darrick J. Wong wrote:
> > > Introduce XFLAGs for the new XFS reflink inode flag and the CoW extent
> > > size hint, and actually plumb the CoW extent size hint into the fsxattr
> > > structure.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Should go behind all the updates that are useful without any new
> > rmap or reflink functionality.  In fact it would be great if you
> > could send out a series with just those little fixes and cleanups
> > first.
> > 
> 
> I'd take that a step further and suggest the entire series be split into
> independent feature series, as appropriate. Unless I'm missing
> something, I don't think there's any reason these all need to be bundled
> together. Further, my expectation is that they probably end up being
> merged as independent units, so I think it's easier for everybody for
> Darrick to carve that up on the logical boundaries rather than assume
> all reviewers and maintainer are going to do so consistently.
> 
> Note that I'm not saying this has to be reposted.. I think I can pull
> off the rmap bits for the time being. I'm just suggesting that if a
> repost is required from this point forward for any of the logical
> subunits (deps, rmap, reflink, scrub), I'd suggest to post, version and
> changelog those units independently.

I'd thought about continuing my old practice of listing which patches
go with which feature... but then got lazy. :(  Cleanups/rmap/reflink/scrub
actually are in their own contiguous sections of the patchbomb, though that
isn't obvious from looking at it.

You ought to be able to pull only as far as the end of the rmap series and
still have a working XFS.  I only did the intensive testing with the full
patchset, but the quick xfstests group ran fine with just the rmap pieces.

Kernel patches:
===============
Cleanups, 1-11
rmap + dependencies, 12-49
    Overlapped interval btree, 12-15
    Deferred operations, 16-22
    rmap, 23-49
reflink + dependencies, 50-111
    AG reservations, 50-52
    refcount btree, 53-68
    deferred remap, 69-73
    cow, 74-88
    reflink, 89-111
getfsmapx, 112
scrub, 113-119

xfsprogs:
=========
Cleanups, 1-15
rmap + deps, 16-70
    Overlapped interval btree, 16-19
    Deferred operations, 20-27
    rmap, 28-70
reflink + dependencies, 71-135
    AG reservations, 71-72
    refcount btree, 73-85
    deferred remap, 86-90
    reflink, 91-135
getfsmapx, 136-138
scrub, 139-145

--D

> 
> Brian
> 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
