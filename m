Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4LY7eJ004022 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 15:34:08 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFCB116A87B2
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 13:34:05 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	ZXeRlCqR0jqDmTm8 for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2008 13:34:05 -0800 (PST)
Date: Fri, 5 Dec 2008 08:34:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.27.7 vanilla, project quota enabled and process stuck in D
	state (repeatable every time)
Message-ID: <20081204213401.GC32301@disturbed>
References: <200812021949.55463.arekm@maven.pl>
	<200812031406.41882.arekm@maven.pl>
	<20081203213028.GW18236@disturbed>
	<200812032242.29326.arekm@maven.pl>
	<20081203220934.GA32301@disturbed>
	<20081204123206.GA6935@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081204123206.GA6935@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Dec 04, 2008 at 07:32:06AM -0500, Christoph Hellwig wrote:
> On Thu, Dec 04, 2008 at 09:09:34AM +1100, Dave Chinner wrote:
> > Is that the unlock of the inodes is using the incorrect lock
> > type for the unlock, (inodes lock XFS_ILOCK_EXCL, unlocked XFS_ILOCK_SHARED)
> > which means they don't get unlocked and the next attempt to do anything
> > with those inodes will hang.
> > 
> > Compile-tested-only patch below that should fix the problem.
> 
> Yeah, that also explains why my patch fixes it :)  I'd say let's put
> yours into 2.6.28 and -stable, and I'll rediff mine ontop for the 2.6.29
> queue.  I'll also write a testcase for xfsqa based on Arkadiusz's
> report.

I agree that this is probably the best approach - your fix is the
better long term solution, I think.

SGI folk, can we get my patch pushed to linus and stable ASAP?
Probably be an idea to add a:

Tested-by: Arkadiusz Miskiewicz <arekm@maven.pl>

tag to it as well to make it easy for the stable review process....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
