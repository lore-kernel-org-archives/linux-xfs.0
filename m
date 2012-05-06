Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q46Fjr3c256522 for <xfs@oss.sgi.com>; Sun, 6 May 2012 10:45:53 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 3blCj0ZJll34Ev9K
	for <xfs@oss.sgi.com>; Sun, 06 May 2012 08:45:52 -0700 (PDT)
Message-ID: <4FA69CB0.8000008@hardwarefreak.com>
Date: Sun, 06 May 2012 10:45:52 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: suddenly slow writes on XFS Filesystem
References: <4FA63DDA.9070707@profihost.ag>
	(sfid-20120506_121127_622020_FC89E0F4)
	<201205061233.58496.Martin@lichtvoll.de>
In-Reply-To: <201205061233.58496.Martin@lichtvoll.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Stefan Priebe <s.priebe@profihost.ag>, xfs@oss.sgi.com

On 5/6/2012 5:33 AM, Martin Steigerwald wrote:
> Am Sonntag, 6. Mai 2012 schrieb Stefan Priebe:
>> It is a raid 10 of 20 SATA Disks and i can only write to them with
>> about  700kb/s while doing random i/o. I tried vanilla Kernel 3.0.30
>> and 3.3.4 - no difference. Writing to another partition on another xfs
>> array works fine.
> 
> Additionally what RAID is this? SoftRAID or some - which one? - hardware 
> RAID controller? And what disks are used, whats the rpm of these?

I doubt much of this stuff matters.  Stefan's filesystem is 96% full,
w/~200GB free.  This free space is likely heavily fragmented.  If he's
doing allocation in this fragmented free space I'd think that would
fully explain his write performance dropping off a cliff due to massive
head seeking.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
