Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C05C67CA7
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 02:54:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8FEA630404E
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 00:54:43 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id MjZk6cfYJ2vVUpn5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 31 Mar 2016 00:54:41 -0700 (PDT)
Date: Thu, 31 Mar 2016 00:54:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: fallocate mode flag for "unshare blocks"?
Message-ID: <20160331075440.GA4209@infradead.org>
References: <20160302155007.GB7125@infradead.org>
	<20160330182755.GC2236@birch.djwong.org>
	<20160331011813.GJ30721@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160331011813.GJ30721@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Thu, Mar 31, 2016 at 12:18:13PM +1100, Dave Chinner wrote:
> On Wed, Mar 30, 2016 at 11:27:55AM -0700, Darrick J. Wong wrote:
> > Or is it ok that fallocate could block, potentially for a long time as
> > we stream cows through the page cache (or however unshare works
> > internally)?  Those same programs might not be expecting fallocate to
> > take a long time.
> 
> Yes, it's perfectly fine for fallocate to block for long periods of
> time. See what gfs2 does during preallocation of blocks - it ends up
> calling sb_issue_zerout() because it doesn't have unwritten
> extents, and hence can block for long periods of time....

gfs2 fallocate is an implementation that will cause all but the most
trivial users real pain.  Even the initial XFS implementation just
marking the transactions synchronous made it unusable for all kinds
of applications, and this is much worse.  E.g. a NFS ALLOCATE operation
to gfs2 will probab;ly hand your connection for extended periods of
time.

If we need to support something like what gfs2 does we should have a
separate flag for it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
