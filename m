Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7KFw1Cc105207 for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 10:58:11 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96BC514F8AE1
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 08:58:44 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 8kKOmTEgcduWvF2I for
	<xfs@oss.sgi.com>; Thu, 20 Aug 2009 08:58:44 -0700 (PDT)
Message-ID: <4A8D7292.70806@sandeen.net>
Date: Thu, 20 Aug 2009 10:58:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS Best Practices
References: <a0531a500908200800m3f5ea065v818c97e845042221@mail.gmail.com>	
	<4A8D6A6D.405@sandeen.net>
	<a0531a500908200845m5dbc4356o278cb6c90d2925f9@mail.gmail.com>
In-Reply-To: <a0531a500908200845m5dbc4356o278cb6c90d2925f9@mail.gmail.com>
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
> On Thu, Aug 20, 2009 at 11:23 AM, Eric Sandeen<sandeen@sandeen.net> wrote:
>> Jeff Flowers wrote:
>>> I am going to use XFS on a Arch Linux box and I am looking for ways to
>>> maximize XFS performance. According to an article I have read [1],
>>> best XFS performance was reached with a file system formatted with a
>>> 64MB log and mounted with 8 log buffers and atime disabled. But I am
>>> curious, from the prespective of the XFS experts of this list, if this
>>> is still good advice and if it is still relevant, as this article was
>>> published in 2003.
>> Based on the information you've provided about the performance issues
>> you're seeing with your particular workload (i.e., nothing), the
>> existing defaults are perfect for you.  :)
> 
> For me, it is not about dissatisfaction with XFS performance but
> simply wanting to know if there are optimizations I am missing and
> could be taking advantage of. Many forums have people talking about
> options to improve or optimize Ext3 and Ext4 performance but XFS seems
> to be dismissed (which I don't understand, as XFS is a very mature and
> proven filesystem).

Sure, but the point is, if there is some all-encompassing "tweak" or
optimization to be made, it is already a default in xfs.

Tuning beyond defaults is usually about tradeoffs, and making those
tradeoffs depends on what you actually want to do with the filesystem.

It's not meant to be snarky, but by and large the defaults for xfs
really do match most normal usage scenarios, and looking for tips &
tweaks isn't usually necessary IMHO.

>>> Also, I have seen a few people recommend turning off the internal
>>> buffers of hard drives (via hdparm) when using a file system like XFS.
>>> Good advice?
>> When drive write caches lose power it may lead to inconsistencies in a
>> journaling filesystem like xfs, which relies on data hitting the disk in
>> a certain order, more or less.  By default xfs issues barriers to
>> enforce this ordering; this has the effect of flushing the write cache
>> to make it safe.  In some cases disabling barriers and also disabling
>> write cache may be a good choice.
>>
>> If you "never" lose power (good ups?) then write caching is safe even
>> w/o barriers.
>>
>> -Eric
> 
> Thanks for the information. Your explaination of write barries is one
> of the better ones I have read.
> 

You're welcome :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
