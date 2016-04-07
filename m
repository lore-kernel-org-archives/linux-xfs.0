Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E22567CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 10:47:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 983D08F8049
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 08:47:33 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id VD9vv9Nj6oKWrN8t (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Apr 2016 08:47:32 -0700 (PDT)
Date: Thu, 7 Apr 2016 08:47:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfs: fix inode validity check in xfs_iflush_cluster
Message-ID: <20160407154731.GC23772@infradead.org>
References: <1459934574-25543-1-git-send-email-david@fromorbit.com>
	<1459934574-25543-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1459934574-25543-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 06, 2016 at 07:22:50PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Some careless idiot wrote crap code in commit 1a3e8f3 ("xfs: convert
> inode cache lookups to use RCU locking") back in late 2010, and so
> xfs_iflush_cluster checks the wrong inode for whether it is still
> valid under RCU protection. Fix it to lock and check the correct
> inode.
> 
> Part of the reason for the screwup was the unconventional naming of
> the cluster inode variable - iq - so also rename all the cluster
> inode variables to use a more conventional prefixes to reduce
> potential future confusion (cilist, cilist_size, cip).

Between all that renaming I didn't actually manage to find the fix :)

Can you split the rename and the fix into separate patches?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
