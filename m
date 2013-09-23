Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B73107F3F
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 18:48:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A70388F8054
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 16:48:25 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	RmYZzZ3MddoOZi5v for <xfs@oss.sgi.com>;
	Mon, 23 Sep 2013 16:48:24 -0700 (PDT)
Date: Tue, 24 Sep 2013 09:48:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: v2 fix node forward in xfs_node_toosmall
Message-ID: <20130923234819.GW9901@dastard>
References: <20130920220519.585903357@sgi.com>
	<20130923171911.273669684@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130923171911.273669684@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: stable@vger.kernel.org, xfs@oss.sgi.com

On Mon, Sep 23, 2013 at 12:18:58PM -0500, Mark Tinguely wrote:
> Commit f5ea1100 cleans up the disk to host conversions for
> node directory entries, but because a variable is reused in
> xfs_node_toosmall() the next node is not correctly found.
> If the original node is small enough (<= 3/8 of the node size),
> this change may incorrectly cause a node collapse when it should
> not.

The comment about the size of the node triggering a collapse is
irrelevant - nodes always collapse at that given size. What this
doesn't tell us is why the crash occurs - "the next node is not
correctly found" is not particularly obvious, and would require
quite a bit of code reading to work out from first principles a
couple of years down the track.

The commit message should be more precise and describe what the
underlying cause of the failure was. i.e. that the node is finding itself as the merge
candidate because we go forward, overwrite the pointers and the new
block's backward sibling is the original block which is where we end
up on teh second loop.  And vice versa if we go backwards first...

Also, the "next node" is correctly termed a "sibling", and it's
either the forwards or backwards sibling, not the "next" sibling as
the direction of movement is important. So perhaps this
is better written as:

"When a node is considered for a merge with a sibling, it overwrites
the sibling pointers of the original node with the sibling's
pointers. This leads to loop considering the original node as a
merge candidate with itself in the second pass, and so it
incorrectly determines a merge should occur."

> That will cause an assert in xfstest generic/319:
> 
>    Assertion failed: first <= last && last < BBTOB(bp->b_length),
>    file: /root/newest/xfs/fs/xfs/xfs_trans_buf.c, line: 569
> 
> Keep the original node header to get the correct forward node.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
>  v2 -> Dave's local variable approach.
>     -> send to -stable this bug is in 3.10 and 3.11

The patch title not include "v2". That goes in the "[PATCH v2]"
prefix that gets stripped before commit so that commit messages
don't have patch version numbers in them....

Otherwise the code looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
