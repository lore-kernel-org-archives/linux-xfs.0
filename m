Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0QMCLlx035658 for <xfs@oss.sgi.com>; Thu, 26 Jan 2012 16:12:22 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	9B4ondKkMJWJTP2w for <xfs@oss.sgi.com>;
	Thu, 26 Jan 2012 14:12:19 -0800 (PST)
Date: Fri, 27 Jan 2012 09:12:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 04/12] xfs: cleanup xfs_log_space_wake
Message-ID: <20120126221216.GW15102@dastard>
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141434.065702206@bombadil.infradead.org>
	<4F1DB36E.3060207@sgi.com> <20120125161041.GB8360@infradead.org>
	<4F205358.5070702@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F205358.5070702@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jan 25, 2012 at 01:09:12PM -0600, Mark Tinguely wrote:
> On 01/25/12 10:10, Christoph Hellwig wrote:
> >On Mon, Jan 23, 2012 at 01:22:22PM -0600, Mark Tinguely wrote:
> >>On 01/-10/63 13:59, Christoph Hellwig wrote:
> >>>Remove the now unused opportunistic parameter, and use the the
> >>>xlog_writeq_wake and xlog_reserveq_wake helpers now that we don't have
> >>>to care about the opportunistic wakeups.
> >>>
> >>>Signed-off-by: Christoph Hellwig<hch@lst.de>
> >>
> >>Looks good. My only concern is the way that xlog_grant_push_ail()
> >>tries to kick start the writing of the log. It seems to me that a
> >>combination of very large log requests could plug the log until the
> >>next sync.
> >
> >How exactly?
> >
> 
> Thanks for giving me enough rope to hang myself :)
> 
> I looked at it again and it could plug for a while, but not
> necessarily until the next sync.
> 
> I was looking at the fact that when the log is full,
> xlog_grant_push_ail() will overlap cleaning threshold lsn for a
> bunch of requests come in. This is because xlog_grant_push_ail()
> uses the current tail when calculating cleaning threshold. This
> cleaning overlap will happen until xfs_ail_push() cleans the space
> and the moves the log tail.
> 
> If a (unrealistically) big request sized greater than MAX(log
> size/4, 256) follows some other requests then the big request

The sizes of requests are known in advance. on a 4k block size
filesystem, the largest request (transaction reservation) will be
around 300KB. The smallest log size we support is 10MB for a 4K
block size filesystem. Hence this isn't actually a problem.

Even for larger block size filesystems, the minimum log size is
scaled according to the largest possible transaction reservation.
IIRC, that blows out to around 3MB in size and so the minimum log
size grows accordingly.

4k filesystem:

$ sudo mkfs.xfs -f -b size=4k -l size=10m /dev/vdb
meta-data=/dev/vdb               isize=256    agcount=4, agsize=655360 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=2621440, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$

64k fileystem:

$ sudo mkfs.xfs -f -b size=64k -l size=10m /dev/vdb
log size 160 blocks too small, minimum size is 512 blocks
Usage: mkfs.xfs
....

Which means the minimum log size for a 64k block size filesytem is
32MB. Hence the situation you suggest cannot happen.....


> determines the amount cleaned out of the queue. When the space is
> cleaned out, the earlier processes waiting for the log are awoken
> and use up the cleaned space, and there will not be enough space for
> the big request. Future requests will clean up to MAX(their request
> size, log size/4, 256). This will not be enough to satisfy the big
> request at the front of the request queue. We will have to wait
> another cleaning cycle for the tail to move and another log space
> request but even this big request would eventually get satisfied.

.... and so push a quarter of the log is always larger than any single
request and therefore safe.

Indeed, delayed logging makes use of this physical bound to
determine when to checkpoint the aggregated changes. See the comment
in xfs_log_priv.h above the definition of XLOG_CIL_SPACE_LIMIT and
XLOG_CIL_HARD_SPACE_LIMIT  and how they are used in xlog_cil_push()
for more information about this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
