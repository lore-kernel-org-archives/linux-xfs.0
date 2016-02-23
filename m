Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0744D7F50
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 16:58:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7B309AC005
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 14:58:44 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	fjtOAWkcWJ2q854M for <xfs@oss.sgi.com>;
	Tue, 23 Feb 2016 14:45:57 -0800 (PST)
Date: Wed, 24 Feb 2016 09:45:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: backport 7a29ac474a47eb8cf212b45917683ae89d6fa13b to stable ?
Message-ID: <20160223224555.GM25832@dastard>
References: <56CC852F.7010507@corp.ovh.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56CC852F.7010507@corp.ovh.com>
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
To: Jean-Tiare Le Bigot <jean-tiare.le-bigot@corp.ovh.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 23, 2016 at 05:13:35PM +0100, Jean-Tiare Le Bigot wrote:
> Hi,
> 
> We've hit kernel hang related to XFS reclaim under heavy I/O load on a
> couple of storage servers using XFS over flashcache over a 3.13.y kernel.
> 
> On the crash dumps, kthreadd is blocked, waiting for XFS to reclaim some
> memory but the related reclaim job is queued on a worker_pool stuck
> waiting for some I/O, itself depending on other jobs on other queues
> which would require additional threads to go forward. Unfortunately
> kthreadd is blocked.
> The host has plenty of memory (~128GB), about 80% of which being used
> for the page cache.
> 
> It looks like this is fixed by commit
> 7a29ac474a47eb8cf212b45917683ae89d6fa13b.

That commit fixed a regression introduced, IIRC, in 3.19. The
problem it fixed didn't exist before then, so I doubt you are seeing
the problem that the above commit fixed. Perhaps you'd like to
describe your problem along with the stack traces, etc so we have
some idea of what you are trying to to fix?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
