Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9E0707CA4
	for <xfs@oss.sgi.com>; Mon, 16 May 2016 08:25:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 54BD48F8033
	for <xfs@oss.sgi.com>; Mon, 16 May 2016 06:25:51 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id eCn4mMzYiuFr5TrH (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 May 2016 06:25:45 -0700 (PDT)
Date: Mon, 16 May 2016 15:25:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Xfs lockdep warning with for-dave-for-4.6 branch
Message-ID: <20160516132541.GP3193@twins.programming.kicks-ass.net>
References: <94cea603-2782-1c5a-e2df-42db4459a8ce@cn.fujitsu.com>
	<20160512055756.GE6648@birch.djwong.org>
	<20160512080321.GA18496@dastard>
	<20160513160341.GW20141@dhcp22.suse.cz>
	<20160516104130.GK3193@twins.programming.kicks-ass.net>
	<20160516130519.GJ23146@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160516130519.GJ23146@dhcp22.suse.cz>
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
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Qu Wenruo <quwenruo@cn.fujitsu.com>, xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Mon, May 16, 2016 at 03:05:19PM +0200, Michal Hocko wrote:
> On Mon 16-05-16 12:41:30, Peter Zijlstra wrote:
> > On Fri, May 13, 2016 at 06:03:41PM +0200, Michal Hocko wrote:

> > How would you like to see it done? The interrupt model works well for
> > reclaim because how is direct reclaim from a !GFP_NOWAIT allocation not
> > an 'interrupt' like thing?
> 
> Unfortunately I do not have any good ideas. It would basically require
> to allow marking the lockdep context transaction specific AFAIU somehow
> and tell that there is no real dependency between !GFP_NOWAIT and
> 'interrupt' context.

But here is; direct reclaim is very much an 'interrupt' in the normal
program flow.

But the problem here appears to be that at some points we 'know' things
cannot get reclaimed because stuff we didn't tell lockdep about (its got
references), and sure then it don't work right.

But that doesn't mean that the 'interrupt' model is wrong.

> IIRC Dave's emails they have tried that by using lockdep classes and
> that turned out to be an overly complex maze which still doesn't work
> 100% reliably.

So that would be the: 

> >  but we can't tell lockdep that easily in any way
> > without going back to the bad old ways of creating a new lockdep
> > class for inode ilocks the moment they enter ->evict. This then
> > disables "entire lifecycle" lockdep checking on the xfs inode ilock,
> > which is why we got rid of it in the first place."
> > 
> > But fails to explain the problems with the 'old' approach.
> > 
> > So clearly this is a 'problem' that has existed for quite a while, so I
> > don't see any need to rush half baked solutions either.
> 
> Well, at least my motivation for _some_ solution here is that xfs has
> worked around this deficiency by forcing GFP_NOFS also for contexts which
> are perfectly OK to do __GFP_FS allocation. And that in turn leads to
> other issues which I would really like to sort out. So the idea was to
> give xfs another way to express that workaround that would be a noop
> without lockdep configured.

Right, that's unfortunate. But I would really like to understand the
problem with the classes vs lifecycle thing.

Is there an email explaining that somewhere?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
