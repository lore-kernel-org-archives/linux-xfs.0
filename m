Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3P9fnQc251901 for <xfs@OSS.SGI.com>; Sun, 25 Apr 2010 04:41:50 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BEEA8CA695
	for <xfs@OSS.SGI.com>; Sun, 25 Apr 2010 02:43:50 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id ZvUrJpV9Y2nKS0tl
	for <xfs@OSS.SGI.com>; Sun, 25 Apr 2010 02:43:50 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1O5yNF-000441-HC
	for <xfs@OSS.SGI.com>; Sun, 25 Apr 2010 10:43:37 +0100
MIME-Version: 1.0
Message-ID: <19412.3777.475058.533813@tree.ty.sabi.co.uk>
Date: Sun, 25 Apr 2010 10:43:29 +0100
Subject: Re: power failure causes files loss
In-Reply-To: <201004241905.44282.hpj@urpla.net>
References: <28340118.post@talk.nabble.com> <4BD21E65.80203@hardwarefreak.com>
	<201004241905.44282.hpj@urpla.net>
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
To: Linux XFS <xfs@oss.sgi.com>

[ ... usual call for 'O_PONIES' ... ]

> While you're right for the general case of course, there are
> many other failure conditions, that an UPS will not prevent,
> eg. kernel crashes.

> Therefore there is an vivid interest, that any storage based
> filesystems should stay consistent _any_ time (and usually
> filesystem developers spend an considerable amount of their
> time on fixing such problems, if they arise).

That's strictly speaking impossible, almost always undesirable,
and at the same time easy to achieve: if you want something like
that just mount with '-o sync' :-).

If you want that *and* excellent performance, just mount with
'-o ponies' instead :-).

If you want that *and* excellent performance *and* scalable
performance with small IO just mount with '-o unicorns' :-).

This topic has been already discussed a few times over in this
mailing list, and in the kernel mailing etc.; those who can get
it have gotten it, those who don't continue to whine.

The real problem is not so much the '-o ponies' (or '-o unicorns')
attitude, it is that even those who get it still have a hard time
with doing the right things because of limited or broken behaviour,
at all levels (from the POSIX semantics of 'fsync' to the Linux
page cache to the firmware of many drives).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
