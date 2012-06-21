Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5L62teL254606 for <xfs@oss.sgi.com>; Thu, 21 Jun 2012 01:02:55 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	83rVjzHAmFHJRdNp for <xfs@oss.sgi.com>;
	Wed, 20 Jun 2012 23:02:53 -0700 (PDT)
Date: Thu, 21 Jun 2012 16:02:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Debugging file truncation problem
Message-ID: <20120621060249.GR30705@dastard>
References: <4FE27E2B.2060705@slac.stanford.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FE27E2B.2060705@slac.stanford.edu>
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
To: Ling Ho <ling@slac.stanford.edu>
Cc: xfs@oss.sgi.com

On Wed, Jun 20, 2012 at 06:51:39PM -0700, Ling Ho wrote:
> Hello,
> 
> I am trying to debug a problem that has bugged us for the last few months.
> 
> We have set up a large storage system using GlusterFS, and XFS
> underneath it. We have 5 RHEL6.2 servers (running
> 2.6.32-220.7.1.el6.x86_64 when problem last occurred), with LSI
> 9285-8e Raid Controller with Battery Backup Unit. System memory is
> 48GB.

Perhaps you should report the problem to your RedHat support
engineer and tell them to raise a bug - it's entire possible that
the RH kernel needs this fix:

be4f1ac xfs: log all dirty inodes in xfs_fs_sync_fs

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
