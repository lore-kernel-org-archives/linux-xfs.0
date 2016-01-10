Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7EE507F56
	for <xfs@oss.sgi.com>; Sun, 10 Jan 2016 01:54:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 111FCAC002
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2016 23:54:13 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id bzyE9nFqivVQvYbc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 09 Jan 2016 23:54:10 -0800 (PST)
Date: Sun, 10 Jan 2016 08:54:09 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] xfs: cancel COW in xfs_cancel_ioend
Message-ID: <20160110075409.GA8213@lst.de>
References: <1451822873-12969-1-git-send-email-hch@lst.de>
	<1451822873-12969-4-git-send-email-hch@lst.de>
	<20160105014310.GK28330@birch.djwong.org>
	<20160105104214.GA16310@infradead.org>
	<20160107003227.GB8015@birch.djwong.org>
	<20160107152541.GA16982@lst.de>
	<20160108100933.GN28330@birch.djwong.org>
	<20160108134704.GA6708@lst.de>
	<20160109211713.GB6112@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160109211713.GB6112@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Sat, Jan 09, 2016 at 01:17:13PM -0800, Darrick J. Wong wrote:
> > 
> > I've not seen the inode eviction asserts anymore, but I now hit a
> > corruption warnings in generic/168 reliably.  I did hit before as
> > well, but not very reliably.
> 
> I'll see if I can repro the 168 error; it's been running in a loop all
> night and hasn't bombed yet.

Note that this is over nfs to a local server, not running on xfs directly,
which is doing fine.

> In the meantime, I added some more tests and fixed a CoW corruption when an
> xfs_io_overwrite extent has cow reservations in the middle of the extent.
> 
> I also restarted testing on arm64, ppc64{,el}, and i686; it seems
> stable enough right now to pass all ~130 reflink xfstests here.

I see pretty reliable failures in xfs/128 xfs/132 xfs/139, apparenly
due to content mismatches.

Re the verifier failure:

sees like we're hitting the

	if (level >= pag->pagf_refcount_level)
		return false;

case.  Together with the other garbage in it seems like we're
seeing a btree block that's not properly initialized in some way,
maybe after a split.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
