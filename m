Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8B02D7F6C
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 15:15:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4FCC88F8040
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 13:15:51 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	YG7Sc4gacrMif6lc for <xfs@oss.sgi.com>;
	Mon, 22 Feb 2016 13:15:42 -0800 (PST)
Date: Tue, 23 Feb 2016 08:14:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: better xfs_trans_alloc interface
Message-ID: <20160222211410.GH25832@dastard>
References: <1455699159-20906-1-git-send-email-hch@lst.de>
	<1455699159-20906-2-git-send-email-hch@lst.de>
	<20160217134006.GA4065@bfoster.bfoster>
	<20160217220436.GI19486@dastard> <20160222133943.GA26966@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160222133943.GA26966@lst.de>
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
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Mon, Feb 22, 2016 at 02:39:43PM +0100, Christoph Hellwig wrote:
> On Thu, Feb 18, 2016 at 09:04:36AM +1100, Dave Chinner wrote:
> > I've considered doing this removal myself in the past - doing
> > somethign like embedding the return address of the
> > xfs-trans_reserve() call in the ticket that is allocated tells us
> > exactly where the call was made. This can be printed with %pS, and
> > that gives us the function (and location in the function) the
> > reservation was made. Hence we solve the problem of not
> > knowing which call path triggered the problem.
> > 
> > Hence I don't think we actually need to the type in every function
> > call.
> 
> This brings up a question:  do we care about the type of the transaction,
> or the caller?  The existing types were rather confused about that.
> If it's the transaction type we could simply add a name field to
> struct xfs_trans_res, if we care about caller the trick from Dave
> should do the job.

I think the caller is more important, because that gives us the
entire context of the transaction. We reuse the same transaction
type in several different places, so it can be ambiguous if we only
have a transaction type in an error message at commit and nothing
else...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
