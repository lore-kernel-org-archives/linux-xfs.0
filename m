Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1I3oaLd191564 for <xfs@oss.sgi.com>; Thu, 17 Feb 2011 21:50:36 -0600
Received: from e6.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 444969BC3A6
	for <xfs@oss.sgi.com>; Thu, 17 Feb 2011 19:53:16 -0800 (PST)
Received: from e6.ny.us.ibm.com (e6.ny.us.ibm.com [32.97.182.146]) by
	cuda.sgi.com with ESMTP id XKpv5IPqhGKJxX8o for
	<xfs@oss.sgi.com>; Thu, 17 Feb 2011 19:53:16 -0800 (PST)
Received: from d01dlp01.pok.ibm.com (d01dlp01.pok.ibm.com [9.56.224.56])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p1I3dFSB007930
	for <xfs@oss.sgi.com>; Thu, 17 Feb 2011 22:39:15 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 241B138CCF0B
	for <xfs@oss.sgi.com>; Thu, 17 Feb 2011 21:06:54 -0500 (EST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p1I26r75462470 for <xfs@oss.sgi.com>; Thu, 17 Feb 2011 21:06:53 -0500
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p1I26rS0011182
	for <xfs@oss.sgi.com>; Thu, 17 Feb 2011 19:06:53 -0700
Subject: Re: xfs_force_shutdown() called when running xfstests on 2.6.38-rc4
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20110217225209.GI13052@dastard>
References: <1297798863.32230.222.camel@chandra-lucid.beaverton.ibm.com>
	<20110215223022.GE13052@dastard>
	<1297886433.32230.224.camel@chandra-lucid.beaverton.ibm.com>
	<20110216221433.GG13052@dastard>
	<1297899728.32230.225.camel@chandra-lucid.beaverton.ibm.com>
	<4D5C8F4D.1060804@sandeen.net>
	<1297968550.32230.307.camel@chandra-lucid.beaverton.ibm.com>
	<20110217225209.GI13052@dastard>
Date: Thu, 17 Feb 2011 18:09:40 -0800
Message-ID: <1297994980.32230.309.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, 2011-02-18 at 09:52 +1100, Dave Chinner wrote:
> On Thu, Feb 17, 2011 at 10:49:10AM -0800, Chandra Seetharaman wrote:
> > Thanks for that info, Eric.
> > 
> > Now I increased the filesystem size and I see the following failure
> > --------------------------------
> > QA output created by 180
> > file /mnt/xfsScratchMntPt/456 has incorrect size - sync failed
> > file /mnt/xfsScratchMntPt/525 has incorrect size - sync failed
> > file /mnt/xfsScratchMntPt/624 has incorrect size - sync failed
> > ---------------------------------
> > 
> > I guess that is not good :)
> 
> No, not good. It passes here on x86_64 and a couple of different
> configurations storage back ends (1/2p on h/w raid1 writing
> @~90MB/s, 8p + s/w RAID0 @ ~700MB/s), so it doesn't seem like there
> is a generic problem.
> 
> what is the hardware you are testing on? 
PPC64

> Does it happen on every run?

No, it is not consistent. It happened as this

+file /mnt/xfsScratchMntPt/993 has incorrect size - sync failed

and ran 10+ times, didn't fail at all.

> What is the size of the files that had incorrect sizes? what is
> their extent layout?

I will run more times and when they fail get the details.

> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
