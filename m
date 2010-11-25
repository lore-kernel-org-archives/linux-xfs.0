Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAPMtM2A079840 for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 16:55:23 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC97913ED0FE
	for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 14:57:01 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id HAP0XypheJ14WNKf
	for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 14:57:01 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 0679E6C15D
	for <xfs@oss.sgi.com>; Thu, 25 Nov 2010 16:57:00 -0600 (CST)
Message-ID: <4CEEE9BC.2030401@hardwarefreak.com>
Date: Thu, 25 Nov 2010 16:57:00 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Verify filesystem is aligned to stripes
References: <4CED5BFC.8000906@shiftmail.org>
	<20101125054607.GM13830@dastard>	<4CEE0995.9030900@hardwarefreak.com>
	<20101125101537.GD12187@dastard>
In-Reply-To: <20101125101537.GD12187@dastard>
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

Dave Chinner put forth on 11/25/2010 4:15 AM:
> On Thu, Nov 25, 2010 at 01:00:37AM -0600, Stan Hoeppner wrote:

>> RAID1 traditionally has equal read performance to a
>> single device, and half the write performance of a single device.
> 
> A good RAID1 implementation typically has the read performance of
> two devices (i.e. it can read from both legs simultaneously) and the
> write performance of a single device.

I've done no formal testing myself, but the last article I read that
tested md RAID1 performance showed marginally faster read performance
for a two disk mirror.  IIRC, one test of 10 showed a 50% improvement.
The rest showed less than 10% improvement, and some showed lower
performance than a single drive.  The performance would probably still
be greater than the parity scenario you described with heavy RMW ops.

> Parity based RAID is only fast for large write IOs or small IOs that
> are close enough together that a stripe cache can coalesce them into
> large writes. If this can't be acheived, parity based raid will be
> no faster than a _single drive_ for writes because all drives will
> be involved in RMW cycles. Indeed, I've seen RAID5 luns be saturated
> at only 50 iops because every IO required a RMW cycle, while an
> equivalent number of drives using RAID1 of RAID0 stripes did 1,000
> iops...

This point brings up a question I've had for some time for which I've
never found a thorough technical answer (maybe for lack of looking hard
enough).  And I'm painfully showing my lack of knowledge of how striping
actually works, so please don't beat me up too much here. :)

Lets use an IMAP mail server in our example, configured to use maildir
storage format.  Most email messages are less than 4KB is size, and many
are less than 512B--not even a full sector.  Thus, the real size of each
maildir file is going to be less than 4KB or 512B.

Let's say our array, either software or hardware based, contains
14x300GB SAS drives in RAID10.  Let's say we've created the array with a
(7x32KB) 224KB stripe size (though most hardware controllers would
probably force us to choose between 128 or 256).

Looking at the stripe size, which is equal to 64 sectors per array
member drive (448 sectors total), how exactly is a sub 4KB mail file (8
sectors) going to be split up into equal chunks across a 224KB RAID
stripe?  Does 220KB of the stripe merely get wasted?  Will XFS pack this
tiny file into the same extent with other small files, and then the
extent gets written into the 128KB stripe?

So, for an array+filesystem that is going to overwhelming be storing
lots of tiny files (mail), what array stripe size should one use, and
what XFS parameters should the filesystem be created and mounted with to
yield maximum random IOPs and minimum latency?  Obviously these
parameters may be different depending on RAID level chosen, so let's
stick with this 14 disk RAID10 for our discussion.

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
