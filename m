Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B91F07CB2
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 02:58:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 36198AC005
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 00:58:04 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ryiRvaKpSKLxWiJ0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 31 Mar 2016 00:58:02 -0700 (PDT)
Date: Thu, 31 Mar 2016 00:58:01 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: fallocate mode flag for "unshare blocks"?
Message-ID: <20160331075801.GC4209@infradead.org>
References: <20160302155007.GB7125@infradead.org>
	<20160330182755.GC2236@birch.djwong.org>
	<56FC21DE.7090308@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56FC21DE.7090308@gmail.com>
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
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Wed, Mar 30, 2016 at 02:58:38PM -0400, Austin S. Hemmelgarn wrote:
> Nothing that I can find in the man-pages or API documentation for Linux's
> fallocate explicitly says that it will be fast.  There are bits that say it
> should be efficient, but that is not itself well defined (given context, I
> would assume it to mean that it doesn't use as much I/O as writing out that
> many bytes of zero data, not necessarily that it will return quickly).

And that's pretty much as narrow as an defintion we get.  But apparently
gfs2 already breaks that expectation :(

> >delalloc system is careful enough to check that there are enough free
> >blocks to handle both the allocation and the metadata updates.  The
> >only gap in this scheme that I can see is if we fallocate, crash, and
> >upon restart the program then tries to write without retrying the
> >fallocate.  Can we trade some performance for the added requirement
> >that we must fallocate -> write -> fsync, and retry the trio if we
> >crash before the fsync returns?  I think that's already an implicit
> >requirement, so we might be ok here.
> Most of the software I've seen that doesn't use fallocate like this is
> either doing odd things otherwise, or is just making sure it has space for
> temporary files, so I think it is probably safe to require this.

posix_fallocate gurantees you that you don't get ENOSPC from the write,
and there is plenty of software relying on that or crashing / cause data
integrity problems that way.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
