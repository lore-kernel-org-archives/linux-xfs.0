Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA2LVK7j095166 for <xfs@oss.sgi.com>; Mon, 2 Nov 2009 15:31:20 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 190F25653F
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2009 13:31:33 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 7feg9qW21MG2aXPs for
	<xfs@oss.sgi.com>; Mon, 02 Nov 2009 13:31:33 -0800 (PST)
Message-ID: <4AEF4FB2.1050504@sandeen.net>
Date: Mon, 02 Nov 2009 15:31:30 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 3ware hardware raid with battery backup and the impact on barrier
	and	no write cache options.
References: <7a12b48b0911021202l126e10a1pbc281f6922380f48@mail.gmail.com>
In-Reply-To: <7a12b48b0911021202l126e10a1pbc281f6922380f48@mail.gmail.com>
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
To: William Lewis <william@netproteus.net>
Cc: xfs@oss.sgi.com

William Lewis wrote:
> Hi,
> 
> I am in the process of setting up an XFS file system on underlying 
> hardware consisting of a 3ware 9550SXU (+ battery backup module) and 4 x 
> Seagate ST31500341AS 1.5TB hard drives in Raid 5 configuration.
> 
> Reading your FAQ at http://xfs.org/index.php/XFS_FAQ I understand that 
> it is advisable to mount the file system with nobarrier to improve 
> performance. However going on to read about recommended settings for 
> write cache, the advice for 3ware hardware doesn't seem to account for 
> the fact that there are 2 levels of write cache in play, that in the 
> 3ware card itself protected by the battery and the write cache of the 
> disks themselves, which as far as I can understand is also protected by 
> the battery backup (in the correct storage modes - balanced/protection) 
> because the 3ware card uses write journaling to keep track of pending 
> write operations in the disks' cache. Therefore unless I am 
> misunderstanding something the most benefit is to be gained by mounting 
> with nobarrier and having the write cache turned on?

If the write caches won't go away - or will be fully/gracefully destaged 
before they do, then nobarrier should be safe.

> One thing I am not clear about is if nobarrier interacts with the page 
> cache at all and if the lack of barrier leaves you with a situation in 
> which pending writes can be lost from main memory on power failure?

nobarrier has no interaction with the OS page cache; all the "barrier" 
option (the default) does is enforce ordering for journal IO*, and in 
practice it does this by flushing the cache at points in time.

-Eric

*well, I think it flushes the drive cache on fsync, too, for data 
integrity (vs. the metadata integrity for the journal IO ordering)

> Thanks in advance for any clarification you can provide.
> 
> Regards
> 
> Will Lewis
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
