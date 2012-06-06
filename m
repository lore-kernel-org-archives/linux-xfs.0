Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q56Dd2Y8222086 for <xfs@oss.sgi.com>; Wed, 6 Jun 2012 08:39:02 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Ubpa0YtjEf0c1lIP for <xfs@oss.sgi.com>;
	Wed, 06 Jun 2012 06:39:01 -0700 (PDT)
Date: Wed, 6 Jun 2012 23:38:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Segmentation fault in xfs_db frag, xfsprogs-3.1.8
Message-ID: <20120606133859.GM22848@dastard>
References: <4FCC77E1.4030600@cape-horn-eng.com>
	<20120605234528.GD22848@dastard>
	<4FCF2BAC.6050100@cape-horn-eng.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FCF2BAC.6050100@cape-horn-eng.com>
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
To: Richard Ems <richard.ems@cape-horn-eng.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 06, 2012 at 12:06:36PM +0200, Richard Ems wrote:
> On 06/06/2012 01:45 AM, Dave Chinner wrote:
> > No surprise if you have a large filesystem and the filesystem is
> > changing while xfs_db is running. xfs_db is not coherent with
> > mounted filesytems, and it is not recommended that you use it that
> > way.s xfs-db is a debugging tool, not a filesystem state reporting
> > tool.
> 
> Ok, thanks, didn't know that.
> I would like to monitor the fragmentation value for all my mounted XFS.
> I think I read in previous list messages that also other people are
> using xfs_db this way. Or is there another way to get the fragmentation
> value?

No, and what xfs_db reports is mostly useless. You don't have a
fragmentation problem unless you are noticing performance problems,
and no fragmentation number will ever tell you that....

> I found this segmentation fault error very strange, since I have been
> using "echo frag | xfs_db -r" for months already on other big
> filesystems - 2 x 17 TB, 1 x 25 TB, 1 x 20 TB - and NEVER got a
> segmentation fault. All 4 filessystems are mounted read-write and are in
> heavy IO use, nevertheless "echo frag | xfs_db -r" runs as expected (by
> me), no one xfs_db run crashed with a segmentation fault at all for
> months, running every weekend.
> It also ran several times without giving any errors on this 80 TB XFS,
> but then started to throw segmentation faults some weeks ago.

It's entirely possible it is running out of memory, failing to
capture the failure and dereferencing a null pointer....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
