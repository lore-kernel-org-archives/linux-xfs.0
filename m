Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4BDB97FAC
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 18:01:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 29BF88F8059
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 16:01:41 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	RSfOQAuZORBXgh4F for <xfs@oss.sgi.com>;
	Thu, 31 Jul 2014 16:01:40 -0700 (PDT)
Date: Fri, 1 Aug 2014 09:01:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6] xfs: discombobulate sb updates and kill xfs_vnode.h
Message-ID: <20140731230136.GS26465@dastard>
References: <1406791995-14723-1-git-send-email-david@fromorbit.com>
	<20140731171655.GA30301@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140731171655.GA30301@infradead.org>
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

On Thu, Jul 31, 2014 at 10:16:55AM -0700, Christoph Hellwig wrote:
> On Thu, Jul 31, 2014 at 05:33:09PM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > Really two patch series in one. The first two patches remove the
> > bitfield based superblock update method and replace it with a simple
> > "update and log everything" operation. Superblock updates are
> > now relatively rare so there's no need to optimise for single field
> > updates. This patchset removes all that complex code and makes
> > everything nice and simple.
> 
> Is there any deeper rationale why you want to get rid of it?

Tangential - cleaning up the mess of separate project quota inode
support. We do lots of dancing around with bit flags and updates in
different functions, and it really just complicates the code.
The recent problems with the quota flags getting
screwed up by repair due not using the sb-to-disk code properly
in userspace was the initial source of the problem - it's just an
unmaintainable PITA that leads to bugs. So the first step to fixing
that is removing all of the unnecessary obfuscation and complexity
from the kernel code, then port it over to userspace(*).

Besides, when we log a single field in the superblock, we're really
logging the surrounding 128 byte chunk, so we really are logging
most of the superbock on every change right now. And if we want to
move to single regions for logged buffers, then we'll be logging the
entire sb every time anyway. So, really, it makes no sense to do
this special bitfield based update and logging stuff anymore.

Cheers,

Dave.

(*) I haven't posted the "trash all quota state" patch set for
repair yet - given that repair doesn't validate the quota inode
contents, and we quotacheck unconditionally after a repair
run, there's no point trying to check or repair quota state or
inodes at all - just trash them and let the kernel rebuild it from
scratch on the next mount....
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
