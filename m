Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8AA527F51
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 18:33:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 79F04304059
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 16:32:59 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id cYQJ4h22De4QARGD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Jan 2016 16:32:57 -0800 (PST)
Date: Wed, 6 Jan 2016 16:32:27 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: cancel COW in xfs_cancel_ioend
Message-ID: <20160107003227.GB8015@birch.djwong.org>
References: <1451822873-12969-1-git-send-email-hch@lst.de>
	<1451822873-12969-4-git-send-email-hch@lst.de>
	<20160105014310.GK28330@birch.djwong.org>
	<20160105104214.GA16310@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160105104214.GA16310@infradead.org>
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
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Jan 05, 2016 at 02:42:14AM -0800, Christoph Hellwig wrote:
> On Mon, Jan 04, 2016 at 05:43:10PM -0800, Darrick J. Wong wrote:
> > Hmm.  This might be the cause of the occasional complaints I've been seeing
> > where allocated blocks remain in the COW fork when the inode is being cleared
> > out.  That said, the xfs_reflink_end_cow_failed() is apparently missing a
> > xfs_bunmapi_cow() to actually clean out the COW fork.
> 
> I can still reproduce xfs_reflink_cancel_pending_cow tripping over
> allocated blocks in the COW fork over NFS.  generic/154 reproduces
> it 100% over NFS, although when adding a delay before the cleanup
> it disappears.  I'm currently trying to figure out why.

Ok.  I spent a couple of days trying to find all the places where we need to
delete CoW reservations (hole punch, truncate, etc.) and found some places
where the code was leaving reservations behind in the CoW fork (most notable
truncate).  I also made the inode eviction code purge any CoW leftovers, so
that should all go away.

I also wrote some more xfstests that try to hit all the CoW-cancelling code
paths (fpunch, fzero, fcollapse, finsert, truncate, -EIO) to smoke test all
that.  By the way, do you have a testcase handy for the "non-blocking writeback
EAGAIN" case?  I'm guessing that we could hit that pretty easily by lowering
dirty_background_* and dirtying a lot of pages while reflinking?

(Will push new code to github in a day or two.)

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
