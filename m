Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAO0Io9f033183 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 18:18:50 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B014915282EF
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 16:20:26 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	kZ1mZ7rilCeZrqoL for <xfs@oss.sgi.com>;
	Tue, 23 Nov 2010 16:20:26 -0800 (PST)
Date: Wed, 24 Nov 2010 11:20:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs delaylog hanged up
Message-ID: <20101124002023.GA22876@dastard>
References: <4CEAC412.9000406@shiftmail.org> <20101122232929.GJ13830@dastard>
	<4CEBA2D5.2020708@shiftmail.org> <20101123204609.GW22876@dastard>
	<4CEC3CB8.8000509@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CEC3CB8.8000509@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 23, 2010 at 04:14:16PM -0600, Stan Hoeppner wrote:
> Dave Chinner put forth on 11/23/2010 2:46 PM:
> 
> > I've been unable to reproduce the problem with your test case (been
> > running over night) on a 12-disk, 16TB dm RAID0 array, but I'll keep
> > trying to reproduce it for a while. I note that the load is
> > generating close to 10,000 iops on my test system, so it may very
> > well be triggering load related problems in your raid controller...
> 
> Somewhat off topic, but how are you generating 10,000 IOPS by carving a
> 16TB LUN/volume from 12 x 2TB SATA disk spindles?  Such drives aren't
> even capable of 200 seeks per second.  Even if they were you'd top out
> at less than 2,500 IOPS (random).  16TB/12=1.33 TB per disk.  No such
> capacity disk exists.  So I assume you're using 12 x 2TB disks and
> slicing/dicing out 16TB.  What am I missing Dave?

512MB of BBWC backing the disks. The BBWC does a much better job of
reordering out-of-order writes than the Linux elevators because
512MB is a much bigger window than a couple of thousand 4k IOs.
Hence metadata/small file intensive workloads go much faster than
you'd expect from just looking at the IO patterns and the capability
of the disks.

IOWs, for write workloads that are not purely random, the disk
subsystem behaves more like an SSD than a RAID0 array of spinning
rust...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
