Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4MDJkXV068513 for <xfs@oss.sgi.com>; Sat, 22 May 2010 08:19:46 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B843736655B
	for <xfs@oss.sgi.com>; Sat, 22 May 2010 06:22:06 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id aLq0EW3MnaetDDyK for
	<xfs@oss.sgi.com>; Sat, 22 May 2010 06:22:06 -0700 (PDT)
Message-ID: <4BF7DA7D.5070405@sandeen.net>
Date: Sat, 22 May 2010 08:22:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Tuning XFS for real time audio on a laptop with encrypted LVM
References: <AANLkTilJD2Jfr4W97BiAlyc_7C9jLEhEzuEWSDyVKXYP@mail.gmail.com>
In-Reply-To: <AANLkTilJD2Jfr4W97BiAlyc_7C9jLEhEzuEWSDyVKXYP@mail.gmail.com>
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
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: xfs@oss.sgi.com

Pedro Ribeiro wrote:
> Hi all,
> 
> I was wondering what is the best scheduler for my use case given my
> current hardware.
> 
> I have a laptop with a fast Core 2 duo at 2.26 and a nice amount of
> ram (4GB) which I use primarily for real time audio (though without a
> -rt kernel). All my partitions are XFS under LVM which itself is
> contained on a LUKS partition (encrypted with AES 128).
> 
> CFQ currently does not perform very well and causes a lot of thrashing
> and high latencies when I/O usage is high. Changing it to the noop
> scheduler solves some of the problems and makes it more responsive.
> Still performance is a bit of a let down: it takes 1m30s to unpack the
> linux-2.6.34 tarball and a massive 2m30s to rm -r.
> I have lazy-count=1, noatime, logbufs=8, logbsize=256k and a 128m log.

Are you optimizing for kernel untars, or "real time audio?"

I would expect that even suboptimal tuning would keep up just fine with
audio demands.

-Eric

> Is there any tunable I should mess with to solve this? And what do you
> think of my scheduler change (I haven't tested it that much to be
> honest)?
> 
> Regards,
> Pedro

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
