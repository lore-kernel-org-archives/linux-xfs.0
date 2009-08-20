Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7KFNA9W103488 for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 10:23:20 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A83103E6661
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 08:23:59 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id HebpOBl6p2Hdr3Zo for
	<xfs@oss.sgi.com>; Thu, 20 Aug 2009 08:23:59 -0700 (PDT)
Message-ID: <4A8D6A6D.405@sandeen.net>
Date: Thu, 20 Aug 2009 10:23:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS Best Practices
References: <a0531a500908200800m3f5ea065v818c97e845042221@mail.gmail.com>
In-Reply-To: <a0531a500908200800m3f5ea065v818c97e845042221@mail.gmail.com>
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
To: Jeff Flowers <ragepie@gmail.com>
Cc: xfs@oss.sgi.com

Jeff Flowers wrote:
> I am going to use XFS on a Arch Linux box and I am looking for ways to
> maximize XFS performance. According to an article I have read [1],
> best XFS performance was reached with a file system formatted with a
> 64MB log and mounted with 8 log buffers and atime disabled. But I am
> curious, from the prespective of the XFS experts of this list, if this
> is still good advice and if it is still relevant, as this article was
> published in 2003.

Based on the information you've provided about the performance issues
you're seeing with your particular workload (i.e., nothing), the
existing defaults are perfect for you.  :)

> Also, I have seen a few people recommend turning off the internal
> buffers of hard drives (via hdparm) when using a file system like XFS.
> Good advice?

When drive write caches lose power it may lead to inconsistencies in a
journaling filesystem like xfs, which relies on data hitting the disk in
a certain order, more or less.  By default xfs issues barriers to
enforce this ordering; this has the effect of flushing the write cache
to make it safe.  In some cases disabling barriers and also disabling
write cache may be a good choice.

If you "never" lose power (good ups?) then write caching is safe even
w/o barriers.

-Eric

> Thank you!
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
