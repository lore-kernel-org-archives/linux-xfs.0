Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9KBJv7r057867 for <xfs@OSS.SGI.com>; Wed, 20 Oct 2010 06:19:58 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 79BDAF362D2
	for <xfs@OSS.SGI.com>; Wed, 20 Oct 2010 04:36:08 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id emAaf6TEUl6Y13tH
	for <xfs@OSS.SGI.com>; Wed, 20 Oct 2010 04:36:08 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1P8WjA-00076s-Rf
	for <xfs@OSS.SGI.com>; Wed, 20 Oct 2010 12:21:04 +0100
MIME-Version: 1.0
Message-ID: <19646.53405.367424.255946@tree.ty.sabi.co.uk>
Date: Wed, 20 Oct 2010 12:21:01 +0100
Subject: Re: avoid mbox file fragmentation
In-Reply-To: <4CBE2403.8070108@hardwarefreak.com>
References: <4CBE2403.8070108@hardwarefreak.com>
From: pgh@xfs2.to.sabi.co.UK (Peter Grandi)
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

[ ... ]

> I added allocsize=1m as my read of the man page suggests this
> will preallocate an additional 1MB of extent space at the end
> of each mbox file each time it is written, which I would think
> should eliminate fragmentation of these files. [ ... ] I've
> probably totally misread what allocsize= actually does. [
> ... ]

That is not really the point. The point is that it is extremely
difficult if not pointless to ensure contiguous allocation for N
slowly growing streams (see below) on a 1-dimensional storage
device in the general case. One does not need to read any file
system introductory tutorial to figure that out, just a bit of
thinking it through will do.

> If allocsize= doesn't help prevent fragmentation of mbox
> files, what can I do to mitigate this, other than regularly
> running xfs_fsr?

'xfs_fsr' is not really a defragmenter, it just fixes some of
the worst cases, if there is a lot of free space.

> I've recently run xfs_fsr thus the low 7% figure.  Every
> couple of weeks the fragmentation reaches ~30%.  I save a lot
> of list mail, dozens to hundreds per day for each of about 7
> foss mailing lists.

That is the case where one has a number of slowly growing
"stream" files, such as multiple parallel downloads, or log
files.

> As I say, in just a couple of weeks, these mbox files become
> fragmented, on the order of a dozen to a few dozen extents per
> mbox file.

That's not a lot and not necessarily something to worry about.
What matters is fragment size and their distance in terms of arm
positioning times.

Anyhow in general file system allocators are designed to give
decent average performance, not to give perfect allocations in
edge cases (especially not those requiring predictive instead of
adaptive algorithms), unlike so many newbies posting to this
list seem to assume.

If you want perfect allocation strategies for edge cases, please
write your own abstract storage system. DBMS authors do that for
example.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
