Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4522D7CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 03:17:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2618F8F8039
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 01:17:15 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	J2TR1V6BhDK8gA80 for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2016 01:17:13 -0800 (PST)
Date: Mon, 8 Feb 2016 20:16:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: don't use ioends for direct write completions
Message-ID: <20160208091644.GD27429@dastard>
References: <1454524816-11392-1-git-send-email-hch@lst.de>
	<1454524816-11392-3-git-send-email-hch@lst.de>
	<20160208010026.GL31407@dastard> <20160208061731.GC27429@dastard>
	<20160208073121.GA30092@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160208073121.GA30092@lst.de>
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Mon, Feb 08, 2016 at 08:31:21AM +0100, Christoph Hellwig wrote:
> On Mon, Feb 08, 2016 at 05:17:31PM +1100, Dave Chinner wrote:
> > Right now this series is in a stable branch in the XFS tree:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-dio-fix-4.6
> > 
> > If you want to push it through some other tree, please let me know
> > when/where it is committed so I can rebuild the XFS for-next branch
> > appropriately from a stable commit/branch...
> 
> That's how I think it should be handled.  This would also allow the
> ext4 and ocfs2 maintainers to depend on the stable branch to clean
> up their direct I/O completion handling in this merge window if they
> want to.

I can't tell if you are saying what I've done is fine if the
xfs-dio-fix-4.6 branch is stable (so others can pull it) or whether
it should be in some other tree. Can you clarify, Christoph?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
