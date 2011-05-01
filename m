Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p413E6vt150616 for <xfs@oss.sgi.com>; Sat, 30 Apr 2011 22:14:07 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 037631571919
	for <xfs@oss.sgi.com>; Sat, 30 Apr 2011 20:17:41 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 9vi2UlR2O6zVFBrK
	for <xfs@oss.sgi.com>; Sat, 30 Apr 2011 20:17:41 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 174366C129
	for <xfs@oss.sgi.com>; Sat, 30 Apr 2011 22:17:41 -0500 (CDT)
Message-ID: <4DBCD0D2.3030109@hardwarefreak.com>
Date: Sat, 30 Apr 2011 22:17:38 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: RAID6 r-m-w, op-journaled fs, SSDs
References: <19900.10868.583555.849181@tree.ty.sabi.co.UK>	<20110430180213.6dcfc41c@galadriel2.home>	<4DBC68DA.1090708@hardwarefreak.com>
	<201104302350.32287@zmi.at>
In-Reply-To: <201104302350.32287@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 4/30/2011 4:50 PM, Michael Monnerie wrote:
> On Samstag, 30. April 2011 Stan Hoeppner wrote:
>> Poor cache management, I'd guess, is one reason why you see Areca
>> RAID  cards with 1-4GB cache DRAM whereas competing cards w/ similar
>> price/performance/features from LSI, Adaptec, and others sport
>> 512MB.
>
> On one server (XENserver virtualized with ~14 VMs running Linux) which
> suffered from slow I/O on RAID-6 during heavy times, I upgraded the
> cache from 1G to 4G using an Areca ARC-1260 controller (somewhat
> outdated now), and couldn't see any advantage. Maybe it would have been
> measurable, but the damn thing was still pretty slow, so using more hard
> disks is still the better option than upgrading the cache.
>
> Just for documentation if someone sees slow I/O on Areca. More spindles
> rock. That server had 8x 10krpm WD Raptor 150G drives by the time.

Similar to the case with CPUs, more cache can only take you so far.  The 
benefit resulting from the cache size, locality (on/off chip), and 
algorithm is often very workload dependent, as is the case with RAID 
controller cache.

Adding controller cache can benefit some workloads, depending on the 
controller make/model, but I agree with you that adding spindles, or 
swapping to faster spindles (say 7.2 to 15k, or SSD), will typically 
benefit all workloads.  However, given that DIMMs are so cheap compared 
to hot swap disks, maxing out controller cache on models that have DIMM 
slots is an inexpensive first step to take when faced with an IO bottleneck.

Larger controller cache seemed to have more positive impact on SCSI RAID 
controllers of the mid/late 90s than on modern controllers.  The 
difference between 8MB and 64MB was substantial with many workloads back 
then.  On many modern SAS/SATA controllers the difference between 512MB 
and 1GB isn't nearly as profound, if any at all.  The shared SCSI bus 
dictated sequential access to all 15 drives on the bus which would tend 
to explain why more cache made a big difference, by masking the 
latencies.  SAS/SATA allows concurrent access to all drives 
simultaneously (assuming no expanders) without the SCSI latencies.  This 
may tend to explain why larger RAID cache on today's controllers doesn't 
yield the benefits of previous generation SCSI RAID cards.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
