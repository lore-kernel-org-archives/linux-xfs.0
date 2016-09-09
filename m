Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CB0907CA1
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2016 18:14:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 80D9E8F8039
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2016 16:14:46 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	B7n9FieMwu96vATK for <xfs@oss.sgi.com>;
	Fri, 09 Sep 2016 16:14:43 -0700 (PDT)
Date: Sat, 10 Sep 2016 09:13:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [BUG REPORT] missing memory counter introduced by xfs
Message-ID: <20160909231320.GG30056@dastard>
References: <57CFEDA3.9000005@chinanetcenter.com>
	<20160907212206.GP30056@dastard>
	<57D13871.9070603@chinanetcenter.com>
	<20160908204413.GW30056@dastard>
	<57D25772.3070304@chinanetcenter.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <57D25772.3070304@chinanetcenter.com>
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
To: Lin Feng <linf@chinanetcenter.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 09, 2016 at 02:32:18PM +0800, Lin Feng wrote:
> Hi Dave,
> 
> A final not-clear concept about XFS, look beblow please.
> 
> On 09/09/2016 04:44 AM, Dave Chinner wrote:
> >On Thu, Sep 08, 2016 at 06:07:45PM +0800, Lin Feng wrote:
....
> >>>So, you have *5.4 million* active metadata buffers. Each buffer will
> >>>hold  1 or 2 4k pages on your kernel, so simple math says 4M * 4k +
> >>>1.4M * 8k = 26G. There's no missing counter here....
> >>
> >>Does xattr contribute to such metadata buffers or there is something else?
> >
> >xattrs are metadata, so if they don't fit in line in the inode
> >(typical for ceph because it uses xattrs larger than 256 bytes) then
> >they are held in external blocks which are cached in the buffer
> >cache.
> >
> 
> So the 'buffer cache' here you mean is the pages handled by xfs_buf
> struct,

Yes.

> used to hold the xattrs if the inode inline data space
> overflows,

And all other cached metadata that is accessed via struct xfs_buf.

> not the 'beffer/cache' seen via free command, they won't
> reflect in cache field by free command, right?

Correct. From the "free" man page:

	buffers
	     Memory used by kernel buffers (Buffers in /proc/meminfo)

	cache
	     Memory used by the page cache and slabs (Cached and
	     Slab in /proc/meminfo)

	buff/cache
	     Sum of buffers and cache


So, "Buffers" is the amount of cached block device pages - this is
always zero for XFS filesystems as we don't use the block device
page cache at all (IIRC, that's where ext4 caches it's metadata).
"cache" is obvious, but it does not include memory attached to slab
objects. Hence it will account for struct xfs_buf memory usage, but
not the pages attached to each xfs_buf....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
