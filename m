Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 95EBB7F52
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 18:00:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 867B78F8064
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 16:00:12 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	XO3SHoCaS97jlokZ for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 15:59:54 -0800 (PST)
Date: Sat, 14 Dec 2013 10:59:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Handling of reviewed patch series
Message-ID: <20131213235952.GO31386@dastard>
References: <20131213053611.GQ10988@dastard> <20131213185618.GJ1935@sgi.com>
	<20131213231401.GZ10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213231401.GZ10988@dastard>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Sat, Dec 14, 2013 at 10:14:01AM +1100, Dave Chinner wrote:
> On Fri, Dec 13, 2013 at 12:56:18PM -0600, Ben Myers wrote:
> > On Fri, Dec 13, 2013 at 04:36:11PM +1100, Dave Chinner wrote:
> > > like the -next tree, it is a branch that can be rebased without
> > > impacting the history of the code in the topic branches because
> > > it's just a merge target.
> > > 
> > > What this means is that development can be done against the
> > > master branch without fear of conflicting with other changes
> > > that are being done. Testing, however, can target the for-next
> > > branch, and local integration testing can be done simply by
> > > merging a local topic branch into a local for-next branch....
> > 
> > I'm not too keen on rebasing a published branch, mostly because I
> > tend to log test results by commit id.  If there is a way to keep
> > the initial commit id stable and in the repo so it can be
> > referenced later it would be better.  e.g.  In the [unlikely]
> > event that the for-next branch does need to be rebased, tag it
> > first.
> 
> Well, I'd be surprised if we have to rebase the for-next branch very
> often. If we plan things correctly (e.g. delay disruptive topic
> branchs to the next release, and merge them immediately after an
> -rc1 update) I think we can effectively avoid rebases. The
> difference is that if we ever need to do a rebase, we can.

FWIW, I just realised that this isn't a huge problem. Rebasing the
for-next branch by remerging topic branches is not going to change
the commit IDs of the commits in the topic branches - it only
changes the commit ID of the merge commits. Hence if you are
tracking commit IDs of the patches rather than the merges, a
for-next rebase won't affect your tracking at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
