Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2T8qoao054300 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 03:52:50 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	j5SWeorVmyqYH0gI for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 01:52:49 -0700 (PDT)
Date: Thu, 29 Mar 2012 19:52:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Do background CIL flushes via a workqueue
Message-ID: <20120329085226.GR5091@dastard>
References: <1332841605-3538-1-git-send-email-david@fromorbit.com>
	<20120327143127.GA11434@infradead.org>
	<20120327155759.GB28707@redhat.com>
	<20120327160300.GA22555@infradead.org>
	<20120327161941.GC28707@redhat.com>
	<20120327170309.GA6712@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327170309.GA6712@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, xfs@oss.sgi.com

On Tue, Mar 27, 2012 at 01:03:09PM -0400, Christoph Hellwig wrote:
> On Tue, Mar 27, 2012 at 12:19:41PM -0400, Vivek Goyal wrote:
> > So xfs either need to resort to similar optimizaiton where IO type from
> > both the process context is of same type or try to do all the IO from
> > one process context. 
> 
> All XFS log I/O is marked SYNC and (FUA and/or FLUSH).

Not if the filesystem is mounted nobarrier, as is recommended
for filesystems on hardware RAID with BBWCs....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
