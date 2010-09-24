Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8O8u0TV173795 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 03:56:00 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C98099811
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 01:56:54 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id KDiwG5ZTX5TBBFcy
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 01:56:54 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 1AEB06C04C
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 03:56:54 -0500 (CDT)
Message-ID: <4C9C67D5.7010803@hardwarefreak.com>
Date: Fri, 24 Sep 2010 03:56:53 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS errors on large Infiniband fileserver setup
References: <29252416bd0d9dc973a909e411dbec6a@phys.ethz.ch>	<20100923235355.GO2614@dastard>
	<2276da2491527ca8044fa1daec496b48@phys.ethz.ch>
In-Reply-To: <2276da2491527ca8044fa1daec496b48@phys.ethz.ch>
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

Christian Herzog put forth on 9/24/2010 12:41 AM:
> Do you have any particular/typical
> device in mind? I'd like to check it out nonetheless.

Almost totally ignoring your current hardware investment and Infiniband
back end...

I recommend the following for performance, storage density and total
storage, ease of configuration and management, reliability, and cost:

http://www.nexstor.co.uk/products/3/13/29/526/Disk_Storage/Nexsan/Nexsan_Storage/Nexsan_SATABeast

http://www.nexstor.co.uk/products/3/13/29/3537/Disk_Storage/Nexsan/Nexsan_Storage/Nexsan_60_Disks_in_4U_-_Beast_Expansion_Unit

Using 2TB drives, the Nexsan SATABeast with two dual port 8Gbit FC
controllers combined with the NXS-B60E expansion chassis offers a total
of 204TB in only 8U of rack space with an advertised sustained host data
rate of 1.2GB/s using both controllers.

If your bandwidth needs outweigh your capacity needs, and 1.2GB/s is too
low for a total storage back end, simply acquire multiple SATABeasts and
forgo the NXS-B60E expansion box.  Using 2 Qlogic QLE2564 x8 PCIe Quad
port 8Gbit FC HBAs in your front end server would allow multipath
redundant connection to one FC port on each controller of 4 SATABeast
units.  This would yield an advertised sustained aggregate data rate of
4.8GB/s between the front end server and 336TB of storage across 168
disks in 16U total rack space.

If you have an FC convergence card in your Mellanox IB switch with 4-8
FC ports, you could forgo the HBAs in the front end server and simply
jack the SATABeast(s) directly into the IB fabric.  This would
definitely increase configuration complexity.  I've never done it so I'd
be of no help.  However, it would allow you to assign LUNs on the
SATABeasts directly to any hosts on the IB network, assuming all the
necessary software is installed and configurable on said hosts enabling
their IB HBAs to present the SATABeast LUNs as SCSI devices to Linux.
As far as configuring FC zones within an IB fabric to make the LUNs
visible to the HBAs, I'll leave that to you, as I've never done that
either.  Zero IB experience here, only FC.  ;)

I'm making a somewhat educated guess that a fully configured SATABeast
with dual controllers and 42x2TB disks should be attainable for around
$50K USD today.  If 1.2GB/s sustained is enough performance, from a cost
and rack footprint perspective, the 8Gbit SATABeast with the NXS-B60E 60
drive expansion box is really hard to beat--204TB in only 8U, in the
ballpark of $80K USD.  If my math is correct, that's around $400 USD per
terabyte.  I'm guessing 1TB of similar performance EMC storage is
probably at least 4 times that.


Disclaimer:  I don't work for Nexsan, Qlogic, nor any reseller.  I'm
simply a satisfied customer of both.


-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
