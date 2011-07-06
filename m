Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p667MP22089676 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 02:22:26 -0500
Date: Wed, 6 Jul 2011 17:22:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS internal error (memory corruption)
Message-ID: <20110706072221.GZ1026@dastard>
References: <4E12A927.9020102@gmail.com> <20110705130932.GF1026@dastard>
	<4E1313C1.6020309@gmail.com> <20110706040403.GW1026@dastard>
	<20110706070756.GA25800@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110706070756.GA25800@infradead.org>
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
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, T?r?k Edwin <edwintorok@gmail.com>

On Wed, Jul 06, 2011 at 03:07:56AM -0400, Christoph Hellwig wrote:
> On Wed, Jul 06, 2011 at 02:04:03PM +1000, Dave Chinner wrote:
> > > Although is there supposed to be a performance benefit from having
> > > a separate log disk with XFS?
> > 
> > There used to be. Now everyone just uses delayed logging, which is
> > far faster and more scalable that even using an external log.
> 
> Even with delayed logging external logs are a huge benefit if you
> hit the log hard, e.g. for fsync intensive workloads.  E.g. when
> using fs_mark in fsync mode it gives speedups over 100% for the
> setups I've tested.  You'll see similar speedups for NFS server
> loads that are log force heavy as well.

Unless you have a good sized chunk of BBWC in front of your disks,
in which case internal logs are just as fast. In fact, internal logs
can are often faster in this case because an internal log on a 12
disk RAID6 array can sink a whole log more bandwidth than an external
log on a 2-disk RAID0 mirror.....

At least, that's what my hardware tells me. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
