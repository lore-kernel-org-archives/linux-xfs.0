Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3TJmRRZ078904 for <xfs@OSS.SGI.com>; Fri, 29 Apr 2011 14:48:28 -0500
Received: from honeysuckle.london.02.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B423C421107
	for <xfs@OSS.SGI.com>; Fri, 29 Apr 2011 12:52:01 -0700 (PDT)
Received: from honeysuckle.london.02.net (honeysuckle.london.02.net
	[87.194.255.144]) by cuda.sgi.com with ESMTP id
	cF0qpzlQUb3sopOP for <xfs@OSS.SGI.com>;
	Fri, 29 Apr 2011 12:52:01 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by honeysuckle.london.02.net
	(8.5.133)
	id 4DA2FC0B00621BDB for xfs@OSS.SGI.com; Fri, 29 Apr 2011 20:52:00 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1QFtjE-0002IO-6J
	for <xfs@OSS.SGI.com>; Fri, 29 Apr 2011 20:51:52 +0100
MIME-Version: 1.0
Message-ID: <19899.5845.648007.218858@tree.ty.sabi.co.UK>
Date: Fri, 29 Apr 2011 20:51:49 +0100
Subject: Re: xfs performance problem
In-Reply-To: <201104291828.46420.Martin@lichtvoll.de>
References: <201104291828.46420.Martin@lichtvoll.de>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>


>> [ ... ] more than likely your problem is that barriers have
>> been enabled for MD/DM devices on the new kernel, and they
>> aren't on the old kernel. [ ... ]

> But didn't 2.6.38 replace barriers by explicit flushes the
> filesystem has to wait for - mitigating most of the
> performance problems with barriers?

That's an example of the 'O_PONIES' attitude: because there are
no performance problems with barriers as such.

There is something completely different: a tradeoff between
levels of safety (whether you want committed transactions or not
and how finely grained) and time to completion.

Barriers would have performance problems if given the safety
semantics they offer they could be reimplemented to give better
speed, but that does not seem to be the case.

But when one sees comical "performance" comparisons without even
cache flushing, explaining the difference between a performance
problem and different safety/speed tradeoffs seems a bit wasted.

Again, the fundamental problem is how many committed IOPS the
storage system can do given a metadata (and thus journal)
intensive load (the answer is "not many" per spinning medium).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
