Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p54AWt55072941 for <xfs@oss.sgi.com>; Sat, 4 Jun 2011 05:32:56 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CEF9E49DFD3
	for <xfs@oss.sgi.com>; Sat,  4 Jun 2011 03:32:52 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Z3qlS79xf6plW8lZ for <xfs@oss.sgi.com>;
	Sat, 04 Jun 2011 03:32:52 -0700 (PDT)
Date: Sat, 4 Jun 2011 20:32:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: I/O hang, possibly XFS, possibly general
Message-ID: <20110604103247.GG561@dastard>
References: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
	<20110603004247.GA28043@infradead.org>
	<20110603013948.GX561@dastard>
	<BANLkTi=FjSzSZJXGofVjtiUe2ZNvki2R-Q@mail.gmail.com>
	<4DE9E97D.30500@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DE9E97D.30500@hardwarefreak.com>
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
Cc: Paul Anderson <pha@umich.edu>, Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Sat, Jun 04, 2011 at 03:14:53AM -0500, Stan Hoeppner wrote:
> On 6/3/2011 10:59 AM, Paul Anderson wrote:
> > Not sure what I can do about the log - man page says xfs_growfs
> > doesn't implement log moving.  I can rebuild the filesystems, but for
> > the one mentioned in this theread, this will take a long time.
> 
> See the logdev mount option.  Using two mirrored drives was recommended,
> I'd go a step further and use two quality "consumer grade", i.e. MLC
> based, SSDs, such as:
> 
> http://www.cdw.com/shop/products/Corsair-Force-Series-F40-solid-state-drive-40-GB-SATA-300/2181114.aspx
> 
> Rated at 50K 4K write IOPS, about 150 times greater than a 15K SAS drive.

If you are using delayed logging, then a pair of mirrored 7200rpm
SAS or SATA drives would be sufficient for most workloads as the log
bandwidth rarely gets above 50MB/s in normal operation.

If you have fsync heavy workloads, or are not using delayed logging,
then you really need to use the RAID5/6 device behind a BBWC because
the log is -seriously- bandwidth intensive. I can drive >500MB/s of
log throughput on metadata intensive workloads on 2.6.39 when not
using delayed logging or I'm regularly forcing the log via fsync.
You sure as hell don't want to be running a sustained long term
write load like that on consumer grade SSDs.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
