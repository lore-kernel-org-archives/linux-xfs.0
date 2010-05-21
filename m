Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4L6NRjx251680 for <xfs@oss.sgi.com>; Fri, 21 May 2010 01:23:27 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E959B3621FA
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 23:25:24 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id sOhY0TT3e8tJKPsL
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 23:25:24 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id B5D2A6C24C
	for <xfs@oss.sgi.com>; Fri, 21 May 2010 01:25:23 -0500 (CDT)
Message-ID: <4BF62766.8070105@hardwarefreak.com>
Date: Fri, 21 May 2010 01:25:42 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Tuning XFS for real time audio on a laptop with encrypted LVM
References: <AANLkTilJD2Jfr4W97BiAlyc_7C9jLEhEzuEWSDyVKXYP@mail.gmail.com>
	<20100521041415.GW8120@dastard>
In-Reply-To: <20100521041415.GW8120@dastard>
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
To: xfs@oss.sgi.com

Dave Chinner put forth on 5/20/2010 11:14 PM:

> I only ever use the noop scheduler with XFS these days. CFQ has been
> a steaming pile of ever changing regressions for the past 4 or 5
> kernel releases, so i stopped using it. Besides, XFS is often 10-15%
> faster on no-op for the same workload, anyway...

IIRC the elevator sits below the FS in the stack, and has a tighter
relationship to the block device driver and physical storage subsystem than
to the FS.  I have one box with a 7.2K 500GB WD drive and a sata_sil
controller that doesn't support NCQ.  Without NCQ due to no controller
support or ATA_horkage_NCQ blacklisted drives, the deadline and anticipatory
(now removed from the kernel IIRC) elevators yield vastly superior
performance under load compared to CFQ or noop.

Noop fits well with good hardware RAID, either local machine PCI/x/e RAID
card or straight FC HBA talking to a SAN array controller.  CFQ just gets in
the way with good hardware.  In some testing I've done with FC HBAs and
target LUNs on IBM FasTt and Nexsan SAN arrays, deadline has shown a tiny
advantage over noop with a few synthetic tests.  This testing was performed
on SLED 10 and Debian Etch guests atop VMWare ESX 3 at night on weekends
when load across the ESX blade farm was near zero, but it was still done in
a virtual environment.  On bare hardware, I'm not sure one would get the
same results.  Anyway, the deadline elevator gave such little advantage over
noop, I'd still recommend noop on good hardware due to zero CPU overhead.
Deadline has a few fancy tricks so it will always eat more CPU, even though
it's a modest amount.

I'd sum the elevator choice up this way:  If you have a good storage
hardware and driver combo such as fast SATA disks with good NCQ, or just
about any SCSI, SAS, RAID, or SAN setup, go with noop.  For lesser
hardware/drivers, use deadline (i.e. lacking or crappy NCQ, or on laptops
due to the slow 4200/5400 rpm drives, even if they do have good NCQ).

I agree with Dave that CFQ isn't all that great, and in my testing it's even
worse when used with Linux guests on ESX than it is on bare metal.

Caveat:  I'm no expert, and I don't do storage subsystem performance testing
all day long.  I'm just reporting my first hand experience.  YMMV and all
the normal disclaimers apply.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
