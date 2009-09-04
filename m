Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n842Nfws156062 for <xfs@oss.sgi.com>; Thu, 3 Sep 2009 21:23:52 -0500
Message-Id: <200909040224.n842OHYo023675@mail04.syd.optusnet.com.au>
Content-Disposition: inline
Mime-Version: 1.0
From: Barry Naujok <bnaujok@optusnet.com.au>
Date: Fri, 04 Sep 2009 12:24:17 +1000
Subject: Re: Re: [PATCH 00/14] repair memory usage reductions
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
To: Geoffrey Wehrman <gwehrman@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Geoffrey Wehrman <gwehrman@sgi.com> wrote:
> 
> On Wed, Sep 02, 2009 at 01:55:31PM -0400, Christoph Hellwig wrote:
> | This is a respin of the patches Barry Naujok wrote at SGI for reducing
> | the memory usage in repair.  I've split it up, fixed a few small bugs
> | and added two preparatory cleanups - but all the real work is Barry's.
> | There has been lots of heavy testing on large filesystems by Barry
> | on the original patches, and quite a lot of testing on slightly 
> smaller
> | filesystems by me.  These were all ad-hoc tests as XFSQA coverage is
> | rather low on repair.  My plan is to add various additional testcase
> | for XFSQA both for intentional corruptions as well as reproducing past
> | reported bugs before we'll release these patches in xfsprogs.  But I 
> think
> | it would be good if we could get them into the development git tree to
> | get wider coverage already.
> 
> How do these changes affect xfs_repair I/O performance?  Barry changes
> were previously withheld within SGI due to a regression in performance.

They were withheld? First I've heard about that. I spent a lot of time on those
changes to minimize the performance impact, and with increasing xfs_repair's
cache size, can actually be faster now depending on the system's RAM
and filesystem size. And it's certainly faster than xfs_repair before my 
performance optimisation changes.

Barry.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
