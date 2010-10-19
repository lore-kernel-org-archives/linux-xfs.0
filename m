Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9JN769j253943 for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 18:07:07 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D48F1051F0
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 16:08:17 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	KWpyt4viyTiJnDbC for <xfs@oss.sgi.com>;
	Tue, 19 Oct 2010 16:08:17 -0700 (PDT)
Date: Wed, 20 Oct 2010 10:08:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question/Problem: Mounting of XFS filesystem takes a lot of time
Message-ID: <20101019230811.GB12506@dastard>
References: <1287521058.2000.21.camel@x200>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1287521058.2000.21.camel@x200>
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
To: Andreas Hasenkopf <andreas.hasenkopf@physik.uni-regensburg.de>
Cc: xfs@oss.sgi.com

On Tue, Oct 19, 2010 at 10:44:18PM +0200, Andreas Hasenkopf wrote:
> Hello,
> since today I have quite a big problem and I'd like to get some opinions
> from experts on how to proceed in solving the problem.
> 
> The Problem:
> Since today mounting and unmounting of any XFS partition on my system
> takes (depending on size of partition) up to 15 minutes and more.

How big is the journal? (xfs_info output will tell us).

> The system in its current configuration was working fine for over 6
> months and I did not change anything recently with respect of upgrades.
> 
> I have already tried booting a Linux-LiveCD and mounting the XFS
> partitions in that system: same result.
> Also I have run xfs_check and xfs_repair -n on the partitions on the
> RAID1 configuration: mounting still takes a lot of time (15 mins +).

Was it a clean unmount, or is it doing journal replay? 

If you do:

# mount <dev> <mtpt> ; umount <mtpt> ; time mount <dev> <mtpt>

Does the second mount take 15 minutes?

> And now to my question:
> Could my problem be a software related problem (Linux, XFS, something
> else) or should I consider hardware problems?

Sounds suspiciously like failing hardware to me. Any errors in
dmesg?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
