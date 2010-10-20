Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9KBnkGB060786 for <xfs@OSS.SGI.com>; Wed, 20 Oct 2010 06:49:46 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E9FA194F209
	for <xfs@OSS.SGI.com>; Wed, 20 Oct 2010 04:50:58 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id kpHtBeztP4ALEl12
	for <xfs@OSS.SGI.com>; Wed, 20 Oct 2010 04:50:58 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1P8XBz-000789-7E
	for <xfs@OSS.SGI.com>; Wed, 20 Oct 2010 12:50:51 +0100
MIME-Version: 1.0
Message-ID: <19646.55189.843933.481529@tree.ty.sabi.co.uk>
Date: Wed, 20 Oct 2010 12:50:45 +0100
Subject: Re: avoid mbox file fragmentation
In-Reply-To: <20101019234217.GD12506@dastard>
References: <4CBE2403.8070108@hardwarefreak.com>
	<20101019234217.GD12506@dastard>
From: pg@xfs2.to.sabi.co.UK (Peter Grandi)
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

[ ...  multiple slowly growing streams case ... ]

> What you want is _physical_ preallocation, not speculative
> preallocation.

Not even that. What he wants really is applications based on a
mail database layer that handles these issues, like real DBMSes do
(or *should* do), with tablespaces and the like, including where
necessary reservations and the like as you say:

> i.e. look up XFS_IOC_RESVSP or FIEMAP so your application does
> _permanent_ preallocate past EOF. Alteratively, the filesystem
> will avoid the truncation on close() is the file has the APPEND
> attribute set and the application is writing via O_APPEND...

Because these issues are common to essentially all multiple slow
growing files. I have seen slowly downloading ISO images with
hundreds of thousands of extents, never mind log files.

> The filesystem cannot do everything for you. Sometimes the
> application has to help....

That's only because file system authors are lazy and haven't
implemented 'O_PONIES' yet. :-)


However, I am a fan of having *default* physical preallocation,
because as a rule one can trade off space for speed nowadays, and
padding files with "future growth" tails is fairly cheap, and one
could modify the filesystem code or 'fsck' to reclaim unused space
in "future grown" tails.

Ideally applications would advise the filesystem with the expected
allocation patterns (e.g. "immutable", or "loglike", or "rewritable")
but the 'O_PONIES' discussions shows that it is unrealistic.
Userspace sucks.

Even if I think that a lot of good could be done by autoadvising in
the 'stdio' library, as 'stdio' flags often give a pretty huge hint.
Uhm I just remembered that I wriote in my blog something fairly
related, with a nice if sadly still true quote from a crucial paper
on all this userspace (and sometimes kernel) suckage:

  http://www.sabi.co.uk/blog/anno05-4th.html#051011
  http://www.sabi.co.uk/blog/anno05-4th.html#051011b
  http://www.sabi.co.uk/blog/anno05-4th.html#051012
  http://www.sabi.co.uk/blog/anno05-4th.html#051012d

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
