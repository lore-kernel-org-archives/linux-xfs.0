Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5C4A37CA1
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2016 04:51:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 06651304048
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2016 02:51:51 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id KZ3rGQLvUMXaQCRi (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 09 Sep 2016 02:51:50 -0700 (PDT)
Date: Fri, 9 Sep 2016 11:51:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160909095148.GH10153@twins.programming.kicks-ass.net>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
	<20160811234335.GX16044@dastard> <20160812025026.GA975@lst.de>
	<20160812095813.GZ16044@dastard> <20160905151529.GB16726@lst.de>
	<20160907214536.GQ30056@dastard> <20160909083306.GA19964@lst.de>
	<20160909084450.GF10153@twins.programming.kicks-ass.net>
	<20160909090544.GA21779@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160909090544.GA21779@lst.de>
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

On Fri, Sep 09, 2016 at 11:05:44AM +0200, Christoph Hellwig wrote:

> Your clearly missed out on our little Linux-RT conference in June :)

Indeed.

> While I basically agree with you there is an important class of problems
> that warrant a non-owner release, and that is I/O.  The easiest example
> (which also happens to be somewhat relevant for this thread) is the
> XFS iolock (or i_rwsem for that matter).  We need to hold this over
> file writes, but for direct I/O those always go out to disk.  In the
> AIO case there simply is no owner left once control is handed off
> to the disk / controller and we'll only be able to unlock once we
> get a completion.  Currenrly we work around that using i_dio_count
> and a hashed waitqueue, but in many ways that solution is worse than
> the problem (and I say that as the person that introduced it!).

Right, the IO problem.

> We have many many similar issues all over the tree, and people are
> "fixing" it using home grown lock primitives like the one above
> or using bitlocks (see the recent thread on cross-release semantics
> for those). 

Completions and semaphores don't work? And yes, I need to look at that
cross-release muck, but as is that stuff sets my teeth on edge.

> I think everyone would be better server by accepting
> that this case exists and finding a place for it in the framework.
> E.g. for RT trying to boost something that is fully under control
> of hardware is pointless, but if we have a way to transfer a lock
> from an owner to a hardware owned state we could at least boost
> until that handoff happened.

Could be worse than pointless, could indicate borkage. But yes, once you
have that event you could propagate it up the PI chain and notify
things.

IO rarely is deterministic, so having RT tasks in a blocked-on chain
with it is fail. And yes, there's exceptions etc..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
