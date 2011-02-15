Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1FMRnKT230406 for <xfs@oss.sgi.com>; Tue, 15 Feb 2011 16:27:49 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 752E52DC9D9
	for <xfs@oss.sgi.com>; Tue, 15 Feb 2011 14:30:25 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	DuFEom0XMNQSyCsk for <xfs@oss.sgi.com>;
	Tue, 15 Feb 2011 14:30:25 -0800 (PST)
Date: Wed, 16 Feb 2011 09:30:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_force_shutdown() called when running xfstests on 2.6.38-rc4
Message-ID: <20110215223022.GE13052@dastard>
References: <1297798863.32230.222.camel@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1297798863.32230.222.camel@chandra-lucid.beaverton.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 15, 2011 at 11:41:03AM -0800, Chandra Seetharaman wrote:
> Hello,
> 
> I am running xfstests on a POWER system with 2.6.38-rc4.
> 
> I see the following in some of the tests. 
> -------------------------
> Feb 15 07:16:23 test2 kernel: Filesystem sdb1: xfs_log_force: error 5 returned.
> Feb 15 07:16:23 test2 kernel: Filesystem sdb1: xfs_log_force: error 5 returned.
> Feb 15 07:16:23 test2 kernel: xfs_force_shutdown(sdb1,0x1) called from line 1111 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xd000000001505c00
> Feb 15 07:16:23 test2 kernel: Filesystem sdb1: xfs_log_force: error 5 returned.
> Feb 15 07:16:23 test2 kernel: Filesystem sdb1: xfs_log_force: error 5 returned.
> Feb 15 07:16:23 test2 kernel: XFS mounting filesystem sdb1
> Feb 15 07:16:23 test2 kernel: Starting XFS recovery on filesystem: sdb1 (logdev: internal)
> Feb 15 07:16:23 test2 kernel: Ending XFS recovery on filesystem: sdb1 (logdev: internal)
> -----------------------
> 
> Is it ok ?
> needs to be debugged ?

Depends on the test. Some tests initiate a forced shutdown on the
filesystem to test certain functionality....

> configuration issues ?

No.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
