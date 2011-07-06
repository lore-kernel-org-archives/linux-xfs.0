Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6685Axc091427 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 03:05:11 -0500
Date: Wed, 6 Jul 2011 04:05:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS internal error (memory corruption)
Message-ID: <20110706080505.GA2354@infradead.org>
References: <4E12A927.9020102@gmail.com> <20110705130932.GF1026@dastard>
	<4E1313C1.6020309@gmail.com> <20110706040403.GW1026@dastard>
	<20110706070756.GA25800@infradead.org>
	<20110706072221.GZ1026@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110706072221.GZ1026@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, T?r?k Edwin <edwintorok@gmail.com>

On Wed, Jul 06, 2011 at 05:22:21PM +1000, Dave Chinner wrote:
> Unless you have a good sized chunk of BBWC in front of your disks,
> in which case internal logs are just as fast. In fact, internal logs
> can are often faster in this case because an internal log on a 12
> disk RAID6 array can sink a whole log more bandwidth than an external
> log on a 2-disk RAID0 mirror.....
> 
> At least, that's what my hardware tells me. ;)

Sure, a nice BBWC setup will give you good results.  But it's generally
much more expensive than a simple setup with a raid5 or 6 and a mirror for
the log device.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
