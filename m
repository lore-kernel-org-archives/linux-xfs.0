Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0C56C7CA4
	for <xfs@oss.sgi.com>; Mon, 16 May 2016 05:41:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D3F71304032
	for <xfs@oss.sgi.com>; Mon, 16 May 2016 03:41:43 -0700 (PDT)
Received: from merlin.infradead.org (merlin.infradead.org [205.233.59.134]) by
	cuda.sgi.com with ESMTP id NHSOs96N8D4CcjTh (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 May 2016 03:41:40 -0700 (PDT)
Date: Mon, 16 May 2016 12:41:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Xfs lockdep warning with for-dave-for-4.6 branch
Message-ID: <20160516104130.GK3193@twins.programming.kicks-ass.net>
References: <94cea603-2782-1c5a-e2df-42db4459a8ce@cn.fujitsu.com>
	<20160512055756.GE6648@birch.djwong.org>
	<20160512080321.GA18496@dastard>
	<20160513160341.GW20141@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160513160341.GW20141@dhcp22.suse.cz>
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

On Fri, May 13, 2016 at 06:03:41PM +0200, Michal Hocko wrote:

> To quote Dave:
> "
> Ignoring whether reflink should be doing anything or not, that's a
> "xfs_refcountbt_init_cursor() gets called both outside and inside
> transactions" lockdep false positive case. The problem here is
> lockdep has seen this allocation from within a transaction, hence a
> GFP_NOFS allocation, and now it's seeing it in a GFP_KERNEL context.
> Also note that we have an active reference to this inode.

So the only thing that distinguishes the good from the bad case is that
reference; how should that then not do anything?

> So, because the reclaim annotations overload the interrupt level
> detections and it's seen the inode ilock been taken in reclaim
> ("interrupt") context, this triggers a reclaim context warning where
> it thinks it is unsafe to do this allocation in GFP_KERNEL context
> holding the inode ilock...
> "
> 
> This sounds like a fundamental problem of the reclaim lock detection.
> It is really impossible to annotate such a special usecase IMHO unless
> the reclaim lockup detection is reworked completely.

How would you like to see it done? The interrupt model works well for
reclaim because how is direct reclaim from a !GFP_NOWAIT allocation not
an 'interrupt' like thing?

> Until then it
> is much better to provide a way to add "I know what I am doing flag"
> and mark problematic places. This would prevent from abusing GFP_NOFS
> flag which has a runtime effect even on configurations which have
> lockdep disabled.

So without more context; no. The mail you referenced mentions:

"The reclaim -> lock context that it's complaining about here is on
an inode being reclaimed - it has no active references and so, by
definition, cannot deadlock with a context holding an active
reference to an inode ilock. Hence there cannot possibly be a
deadlock here, but we can't tell lockdep that easily in any way
without going back to the bad old ways of creating a new lockdep
class for inode ilocks the moment they enter ->evict. This then
disables "entire lifecycle" lockdep checking on the xfs inode ilock,
which is why we got rid of it in the first place."

But fails to explain the problems with the 'old' approach.

So clearly this is a 'problem' that has existed for quite a while, so I
don't see any need to rush half baked solutions either.

Please better explain things.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
