Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 611B07CA1
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2016 04:05:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2E525304043
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2016 02:05:48 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id TV9TiZrpsP38uzWX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 09 Sep 2016 02:05:45 -0700 (PDT)
Date: Fri, 9 Sep 2016 11:05:44 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160909090544.GA21779@lst.de>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
	<20160811234335.GX16044@dastard> <20160812025026.GA975@lst.de>
	<20160812095813.GZ16044@dastard> <20160905151529.GB16726@lst.de>
	<20160907214536.GQ30056@dastard> <20160909083306.GA19964@lst.de>
	<20160909084450.GF10153@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160909084450.GF10153@twins.programming.kicks-ass.net>
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
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Sep 09, 2016 at 10:44:50AM +0200, Peter Zijlstra wrote:
> Do tell; note however that due to the strict write owner, we can do
> things like the optimistic spinning which improved writer->writer
> performance significantly.
> 
> Also note that !owner locks create problems for RT.

Your clearly missed out on our little Linux-RT conference in June :)

While I basically agree with you there is an important class of problems
that warrant a non-owner release, and that is I/O.  The easiest example
(which also happens to be somewhat relevant for this thread) is the
XFS iolock (or i_rwsem for that matter).  We need to hold this over
file writes, but for direct I/O those always go out to disk.  In the
AIO case there simply is no owner left once control is handed off
to the disk / controller and we'll only be able to unlock once we
get a completion.  Currenrly we work around that using i_dio_count
and a hashed waitqueue, but in many ways that solution is worse than
the problem (and I say that as the person that introduced it!).

We have many many similar issues all over the tree, and people are
"fixing" it using home grown lock primitives like the one above
or using bitlocks (see the recent thread on cross-release semantics
for those).  I think everyone would be better server by accepting
that this case exists and finding a place for it in the framework.
E.g. for RT trying to boost something that is fully under control
of hardware is pointless, but if we have a way to transfer a lock
from an owner to a hardware owned state we could at least boost
until that handoff happened.

None of that is really relevant for this thread though - no cross
release involved in the case that's tripping up lockdep here, just
lock "borrowing" using a synchronous work item.  The real root cause
here is the too small kernel stack that led to this workqueue.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
