Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 195F57F37
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 04:09:44 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EBD4A304032
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 02:09:40 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Ql9FqSMddFpKCEkz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Jan 2016 02:09:39 -0800 (PST)
Date: Fri, 8 Jan 2016 02:09:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: cancel COW in xfs_cancel_ioend
Message-ID: <20160108100933.GN28330@birch.djwong.org>
References: <1451822873-12969-1-git-send-email-hch@lst.de>
	<1451822873-12969-4-git-send-email-hch@lst.de>
	<20160105014310.GK28330@birch.djwong.org>
	<20160105104214.GA16310@infradead.org>
	<20160107003227.GB8015@birch.djwong.org>
	<20160107152541.GA16982@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160107152541.GA16982@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thu, Jan 07, 2016 at 04:25:42PM +0100, Christoph Hellwig wrote:
> On Wed, Jan 06, 2016 at 04:32:27PM -0800, Darrick J. Wong wrote:
> > Ok.  I spent a couple of days trying to find all the places where we need to
> > delete CoW reservations (hole punch, truncate, etc.) and found some places
> > where the code was leaving reservations behind in the CoW fork (most notable
> > truncate).  I also made the inode eviction code purge any CoW leftovers, so
> > that should all go away.
> 
> Can you send that part out for NFS testing?

Ok, I've uploaded the latest kernel + xfstests to github:
https://github.com/djwong/linux/commits/for-dave
https://github.com/djwong/xfstests/tree/for-dave

(Big pile of new tests to try to exercise the cow cancellation code.)

> 
> > I also wrote some more xfstests that try to hit all the CoW-cancelling code
> > paths (fpunch, fzero, fcollapse, finsert, truncate, -EIO) to smoke test all
> > that.  By the way, do you have a testcase handy for the "non-blocking writeback
> > EAGAIN" case?  I'm guessing that we could hit that pretty easily by lowering
> > dirty_background_* and dirtying a lot of pages while reflinking?
> 
> I did hit it pretty easily testing over NFS to a local nfs server with
> xfstests.

Hmm.  If my latest round of fixes didn't get this one, I'll see next week if
I can get the NFS stuff working so I can test it directly.

--D

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
