Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F2E0C7CA1
	for <xfs@oss.sgi.com>; Sat, 10 Sep 2016 11:20:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B95D88F8039
	for <xfs@oss.sgi.com>; Sat, 10 Sep 2016 09:20:41 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id Urjakb5mB79vN7tC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 10 Sep 2016 09:20:39 -0700 (PDT)
Date: Sat, 10 Sep 2016 18:20:37 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160910162037.GA29651@lst.de>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
	<20160811234335.GX16044@dastard> <20160812025026.GA975@lst.de>
	<20160812095813.GZ16044@dastard> <20160905151529.GB16726@lst.de>
	<20160907214536.GQ30056@dastard> <20160909083306.GA19964@lst.de>
	<20160909084450.GF10153@twins.programming.kicks-ass.net>
	<20160909090544.GA21779@lst.de>
	<20160909095148.GH10153@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160909095148.GH10153@twins.programming.kicks-ass.net>
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
Cc: xfs@oss.sgi.com

On Fri, Sep 09, 2016 at 11:51:48AM +0200, Peter Zijlstra wrote:
> Completions and semaphores don't work? And yes, I need to look at that
> cross-release muck, but as is that stuff sets my teeth on edge.

Completions can be used as hacks for some of it - we have two or three
places where we do that in XFS.  Using semaphores doesn't seem very
popular.  Also I'd much prefer to have a proper lock instead of working
around it, most importantly to get good lockdep support.

And none of that addresses the fact that we're talking about a
shared/exclusive lock here.

> > I think everyone would be better server by accepting
> > that this case exists and finding a place for it in the framework.
> > E.g. for RT trying to boost something that is fully under control
> > of hardware is pointless, but if we have a way to transfer a lock
> > from an owner to a hardware owned state we could at least boost
> > until that handoff happened.
> 
> Could be worse than pointless, could indicate borkage.

Yes - pointless is still the best case.

> But yes, once you
> have that event you could propagate it up the PI chain and notify
> things.
> 
> IO rarely is deterministic, so having RT tasks in a blocked-on chain
> with it is fail. And yes, there's exceptions etc..

That's often true, but not always.  There is things like battery backed
DRAM which is very deterministic, and there is a lot of work going on
to provide relatively deterministic ways of using flash storage.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
