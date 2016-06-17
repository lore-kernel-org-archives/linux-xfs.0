Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3CD357CA6
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 07:16:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0DEE18F8035
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 05:16:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SONsLSlX2AOB8Q9Y (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 17 Jun 2016 05:16:07 -0700 (PDT)
Date: Fri, 17 Jun 2016 08:16:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 002/119] vfs: support FS_XFLAG_REFLINK and
	FS_XFLAG_COWEXTSIZE
Message-ID: <20160617121604.GB23661@bfoster.bfoster>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612628567.12839.3246258786290141903.stgit@birch.djwong.org>
	<20160617114117.GF19042@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160617114117.GF19042@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri, Jun 17, 2016 at 04:41:17AM -0700, Christoph Hellwig wrote:
> On Thu, Jun 16, 2016 at 06:18:05PM -0700, Darrick J. Wong wrote:
> > Introduce XFLAGs for the new XFS reflink inode flag and the CoW extent
> > size hint, and actually plumb the CoW extent size hint into the fsxattr
> > structure.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Should go behind all the updates that are useful without any new
> rmap or reflink functionality.  In fact it would be great if you
> could send out a series with just those little fixes and cleanups
> first.
> 

I'd take that a step further and suggest the entire series be split into
independent feature series, as appropriate. Unless I'm missing
something, I don't think there's any reason these all need to be bundled
together. Further, my expectation is that they probably end up being
merged as independent units, so I think it's easier for everybody for
Darrick to carve that up on the logical boundaries rather than assume
all reviewers and maintainer are going to do so consistently.

Note that I'm not saying this has to be reposted.. I think I can pull
off the rmap bits for the time being. I'm just suggesting that if a
repost is required from this point forward for any of the logical
subunits (deps, rmap, reflink, scrub), I'd suggest to post, version and
changelog those units independently.

Brian

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
