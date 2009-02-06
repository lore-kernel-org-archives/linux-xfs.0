Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n16Fx4GW036748 for <xfs@oss.sgi.com>; Fri, 6 Feb 2009 09:59:05 -0600
Received: from mo-p05-ob.rzone.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BFF0F4B06
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2009 07:58:25 -0800 (PST)
Received: from mo-p05-ob.rzone.de (mo-p05-ob.rzone.de [81.169.146.182]) by
	cuda.sgi.com with ESMTP id toH4lC5hEUznZ0Pk for
	<xfs@oss.sgi.com>; Fri, 06 Feb 2009 07:58:25 -0800 (PST)
Message-ID: <498C5DE1.9070200@renderforce.de>
Date: Fri, 06 Feb 2009 16:57:21 +0100
From: Steffen Knauf <Steffen.Knauf@renderforce.de>
MIME-Version: 1.0
Subject: Re: xfs_force_shutdown after Raid crash
References: <498376CF.8020806@renderforce.de>
	<20090131105712.GA30061@infradead.org>
In-Reply-To: <20090131105712.GA30061@infradead.org>
Reply-To: Steffen.Knauf@liga01.de
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hello,

sorry for the delay. I don't know whether it is interesting, but after a 
xfs_repair, the filesystem could completely rebuild.
Thanks Chritoph. I'm a little bit confused about "write back cache" and 
the "barrier" option.
On the RAID Controller "Write Cache" is enabled, "Write Cache Periodic 
Flush = 5 seconds" and "Write Cache Flush Ratio = 45 Percent".
My kernelversion is 2.6.16 (SLES10), so the default should be nobarrier. 
But i read in the official SGI xfs Training documentation that write 
Barrier are enabled by default on SLES10.
How can i check if barrier is on or off?. I don't find something in the log.

greets

Steffen

> On Fri, Jan 30, 2009 at 10:53:19PM +0100, Steffen Knauf wrote:
>   
>> Hello,
>>
>> after a raid crash (Raid Controller problem, 3 Disks of the Disk Group  
>> were kicked out oft the diskgroup), 2 of 3 partitions (XFS FS) were  
>> shutdown immediately.
>> Perhaps somebody has a idea, what's the best solution (xfs_repair?).
>>     
>
> This looks like you were running with a write back cache enabled on the
> controller / disks but without barriers.  xfs_repair should be able
> to repair the filesystem.  If you're lucky only the freespace-btrees
> are corrupted (as in the trace below) as xfs_repair can rebuild them
> from scratch. 
>
>
>   

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
