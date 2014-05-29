Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D3FC57F72
	for <xfs@oss.sgi.com>; Thu, 29 May 2014 02:49:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BCF1B8F8065
	for <xfs@oss.sgi.com>; Thu, 29 May 2014 00:49:14 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ug7bH0BegGHqAh1W for <xfs@oss.sgi.com>;
	Thu, 29 May 2014 00:49:12 -0700 (PDT)
Date: Thu, 29 May 2014 17:49:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: possible deadlock warning
Message-ID: <20140529074909.GI6677@dastard>
References: <538571D4.70904@cn.fujitsu.com> <20140528060050.GK8554@dastard>
	<5386AABD.5070708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5386AABD.5070708@cn.fujitsu.com>
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
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, May 29, 2014 at 11:34:21AM +0800, Gu Zheng wrote:
> Hi Dave,
> 
> On 05/28/2014 02:00 PM, Dave Chinner wrote:
> 
> > On Wed, May 28, 2014 at 01:19:16PM +0800, Gu Zheng wrote:
> >> Hi all,
> >> When running the latest Linus' tree, the following possible deadlock warning occurs.
> > 
> > false positive. There isn't a deadlock between inode locks on
> > different filesystems. i.e. there is no dependency between shmem
> > inodes and xfs inodes, nor on their security contexts.  Nor can you
> > take a page fault on a directory inode, which is the XFS inode lock
> > class it's complaining about.
> 
> If it's really a noisy, can we avoid this?

It's on my list of things to do. The XFs directory locking was
changed slightly to remove race condition that SGI's CXFS filesystem
was hitting, and that introduced all these lockdep false positives.

Unfortunately, to get rid of the lockdep false positives we can
either:

	a) revert the locking change; or
	b) rewrite the readdir code to use more fine grained locking
	   so that we don't hold the lock over filldir() calls.

I don't think that reverting a change that fixed a directory
corruption problem is a good idea, so rewriting the readdir code is
the solution.

SGI have disappeared off the planet so they aren't going to fix it
anytime soon, so it's waiting for me to find the time to finish and
test the patches I have ibeen working on in my spare time that
rework the readdir code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
