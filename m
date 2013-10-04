Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D183D7F5E
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 20:00:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BABFD8F8040
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 18:00:14 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	5HBCBSRkazPRjQTg for <xfs@oss.sgi.com>;
	Thu, 03 Oct 2013 18:00:13 -0700 (PDT)
Date: Fri, 4 Oct 2013 11:00:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/16] xfs: decouple inode and bmap btree header files
Message-ID: <20131004010009.GD4446@dastard>
References: <1380510433-8353-1-git-send-email-david@fromorbit.com>
	<1380510433-8353-6-git-send-email-david@fromorbit.com>
	<20131003145849.GE10316@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131003145849.GE10316@infradead.org>
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
Cc: xfs@oss.sgi.com

On Thu, Oct 03, 2013 at 07:58:49AM -0700, Christoph Hellwig wrote:
> I like this a lot, but it also seems to move the in-core btree records
> and keys to the format header which seems wrong.  Maybe those should be
> centralized in xfs_btree.h instead?

Which structures are you talking about here? there's so many key and
pointer definitions I'm not sure if there's a specific one you had
in mind or whether you mean "all of them"...

Keep in mind here that the real dependency problem is the
xfs_bmbt_rec_host definition being require by xfs_inode_fork.h.
That's an in-core definition, and if we move that to another header
file, we simply create a different dependency instead of removing
the dependency altogether....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
