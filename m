Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4V6BlJ5030833 for <xfs@oss.sgi.com>; Tue, 31 May 2011 01:11:47 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C99D15D9741
	for <xfs@oss.sgi.com>; Mon, 30 May 2011 23:11:44 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	pjtdnx4E9XzxOSlI for <xfs@oss.sgi.com>;
	Mon, 30 May 2011 23:11:44 -0700 (PDT)
Date: Tue, 31 May 2011 16:11:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question about Number of Allocation Groups
Message-ID: <20110531061142.GH561@dastard>
References: <164529.98085.qm@web77701.mail.sg1.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <164529.98085.qm@web77701.mail.sg1.yahoo.com>
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
To: Gim Leong Chin <chingimleong@yahoo.com.sg>
Cc: xfs@oss.sgi.com

On Tue, May 31, 2011 at 01:30:08PM +0800, Gim Leong Chin wrote:
> Hi,
> 
> I have a question about the number of allocation groups in XFS.
> 
> In SUSE Linux Enterprise 10 SP2 kernel 2.6.16, the default number
> of allocation groups from what I have seen is 16 for a 144 GB
> filesystem, 32 for a 1.1 TB filesystem.
> 
> In SUSE Linux Enterprise 11 kernel 2.6.27, the default number of
> allocation groups is 4 even for a 800 GB filesystem (from what I
> have observed on openSUSE 11.4 kernel 2.6.37, that number is still
> 4).  I have observed that for XFS on mdraid the default is 16 for
> a 101 GB filesytem, 32 for a 4.5 TB filesystem.

Yes, that sounds like the way the defaults currently work.

> 1) May I know what is the  method for computing the default number
> of allocation groups,

See the mkfs source code. It's described in the function
calc_default_ag_geometry().

> and why the big change from kernel 2.6.16 to
> 2.6.27 (16, 32 to 4)?

Because disks are getting bigger. Defaults designed for disks of
10GB in size make no sense for current TB-sized disks....

> 2) What are the guide lines for deciding how many allocation
> groups we should specify?  Is the number related to filesystem
> size, the IO bandwidth, the number of processor cores, the number
> of parallelism threads we want to occupy the system, system
> usage/workload characteristics?

All of the above, and more.

> 3) I am sure there is some point for any system where an
> increasing number of allocation groups will first increase
> performance, and then the performance will start to drop?

Yes, there is. In general, increasing the # of AGs increases the
inherent parallelism in the filesystem, but the tradeoff is that it
will also increase the number of seeks workloads do. The optimum
value is generally dependent on your storage hardware....

> 4) What would be an optimum number for the root filesystem for the
> operating system?  As I have 100 GB for the "/", my OS partitions
> not on mdraid have the default 4 allocation groups for kernel
> 2.6.27 and 2.6.37.

The default, of course.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
