Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1HMnYft180813 for <xfs@oss.sgi.com>; Thu, 17 Feb 2011 16:49:35 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8CE492E6134
	for <xfs@oss.sgi.com>; Thu, 17 Feb 2011 14:52:13 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	CeXR8DvaB1QfHU08 for <xfs@oss.sgi.com>;
	Thu, 17 Feb 2011 14:52:13 -0800 (PST)
Date: Fri, 18 Feb 2011 09:52:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_force_shutdown() called when running xfstests on 2.6.38-rc4
Message-ID: <20110217225209.GI13052@dastard>
References: <1297798863.32230.222.camel@chandra-lucid.beaverton.ibm.com>
	<20110215223022.GE13052@dastard>
	<1297886433.32230.224.camel@chandra-lucid.beaverton.ibm.com>
	<20110216221433.GG13052@dastard>
	<1297899728.32230.225.camel@chandra-lucid.beaverton.ibm.com>
	<4D5C8F4D.1060804@sandeen.net>
	<1297968550.32230.307.camel@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1297968550.32230.307.camel@chandra-lucid.beaverton.ibm.com>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Feb 17, 2011 at 10:49:10AM -0800, Chandra Seetharaman wrote:
> Thanks for that info, Eric.
> 
> Now I increased the filesystem size and I see the following failure
> --------------------------------
> QA output created by 180
> file /mnt/xfsScratchMntPt/456 has incorrect size - sync failed
> file /mnt/xfsScratchMntPt/525 has incorrect size - sync failed
> file /mnt/xfsScratchMntPt/624 has incorrect size - sync failed
> ---------------------------------
> 
> I guess that is not good :)

No, not good. It passes here on x86_64 and a couple of different
configurations storage back ends (1/2p on h/w raid1 writing
@~90MB/s, 8p + s/w RAID0 @ ~700MB/s), so it doesn't seem like there
is a generic problem.

what is the hardware you are testing on? Does it happen on every
run? What is the size of the files that had incorrect sizes? what is
their extent layout?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
