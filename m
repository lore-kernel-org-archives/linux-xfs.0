Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AB2257F7C
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 17:55:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9CF14304075
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 15:55:46 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id CUAIVilQyDRLGmDK
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 15:55:45 -0800 (PST)
Message-ID: <52E99504.4030902@hardwarefreak.com>
Date: Wed, 29 Jan 2014 17:55:48 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Question regarding XFS on LVM over hardware RAID.
References: <1391005406-sup-1881@al.wesleyan.edu>	<52E91923.4070706@sandeen.net>
	<1391022066-sup-5863@al.wesleyan.edu>
In-Reply-To: <1391022066-sup-5863@al.wesleyan.edu>
Reply-To: stan@hardwarefreak.com
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "C. Morgan Hamill" <chamill@wesleyan.edu>, xfs <xfs@oss.sgi.com>

On 1/29/2014 1:11 PM, C. Morgan Hamill wrote:
> Thanks for the quick reply.
> 
> Excerpts from Eric Sandeen's message of 2014-01-29 10:07:15 -0500:
>> The stripe unit and width are units of geometry of the underlying
>> storage; a filesystem will span some number of stripe units, depending
>> on its size.
>>
>> So no, the filesystem's notion of stripe geometry does not change
>> with the filesystem size.
>>
>> You do want to make sure that stripe geometry is correct and aligned
>> from top to bottom.
> 
> Just to make sure I've understood, for 3 14-disk RAID 6 groups striped
> together into a single RAID 60, with stripe units of 128k, split up into
> some number of LVM logical volumes, I'd create the filesystems with the
> following:
> 
>     mkfs.xfs -d su=128k,sw=36 ...

This is not correct.  You must align to either the outer stripe or the
inner stripe when using a nested array.  In this case it appears your
inner stripe is RAID6 su 128KB * sw 12 = 1536KB.  You did not state your
outer RAID0 stripe geometry.  Which one you align to depends entirely on
your workload.

However, given that you currently intend to assemble one large array
from 3 smaller arrays, then immediately carve it into smaller pieces,
it's seems that RAID60 is probably not the correct architecture for your
workload.  RAID60 is suitable for very large streaming write/read
workloads where you are evenly distributing filesystem blocks across a
very large spindle count, with a deterministic IO pattern, and with no
RMW.  It is not very suitable for consolidation workloads, as you seem
to be describing here.

Everything starts and ends with the workload.  You always design the
storage to meet the needs of the workload, not the other way round.  You
seem to be designing your system from the storage up.  This is often a
recipe for disaster.

Please describe your workload in more detail so we can provide better,
detailed, advice.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
