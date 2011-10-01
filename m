Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p91NKxGS092886 for <xfs@OSS.SGI.com>; Sat, 1 Oct 2011 18:20:59 -0500
Received: from april.london.02.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2E831F17650
	for <xfs@OSS.SGI.com>; Sat,  1 Oct 2011 16:20:57 -0700 (PDT)
Received: from april.london.02.net (april.london.02.net [87.194.255.143]) by
	cuda.sgi.com with ESMTP id 58zvdKv4t7gZmFg8 for
	<xfs@OSS.SGI.com>; Sat, 01 Oct 2011 16:20:57 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by april.london.02.net (8.5.140)
	id 4E261E720213E969 for xfs@OSS.SGI.com; Sun, 2 Oct 2011 00:20:55 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1RA8rQ-0005Jp-0E
	for <xfs@OSS.SGI.com>; Sun, 02 Oct 2011 00:20:48 +0100
MIME-Version: 1.0
Message-ID: <20103.41038.235842.915322@tree.ty.sabi.co.UK>
Date: Sun, 2 Oct 2011 00:20:46 +0100
Subject: Re: Directory fsync
In-Reply-To: <CAF7KpS_zugTJUBnSXpHGJ8XR9N=+LZXNfPT-cuXx-LY2e=uCtA@mail.gmail.com>
References: <CAF7KpS8h2KDsLVzwAj=5ig-yuuiCwjQSVk0Nfy9UJ0qiyAqeCQ@mail.gmail.com>
	<20110923163354.GA24319@infradead.org> <201109240109.45532@zmi.at>
	<CAF7KpS_zugTJUBnSXpHGJ8XR9N=+LZXNfPT-cuXx-LY2e=uCtA@mail.gmail.com>
From: pg_xf2@xf2.for.sabi.co.uk (Peter Grandi)
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

>>> As far as standards are concerned it is.  As far as the
>>> current XFS implementation is concerned you don't need it as
>>> the file fsync will also force out all transactions that
>>> belong to the create.

>> Aren't you giving O_PONIES to the users? ;-) I understand
>> your description, but we should always tell people to use a
>> directory fsync to be sure.

Sometimes users wish unicorns, not just ponies, and sometimes
they really want winged unicorns, not just unicorns...

> I see the importance of following the standard. But I am glad
> to know the current implementation of XFS enforce more strict
> fsync semantic, just as every application developer wishes.

Stricter semantics means potetially more expensive IO and more
complicated kernel implementation with more chances for subtle
bugs.

Unless you are arguing that applications developers demand
O_PONIES and don't care about thsat much application performance
of portability or kernel bug opportunities.

It is a long time since I reminded anyone that the UNIX
filesystem semantics were designed when the whole kernel was
(well) under 64KiB, and that was an interesting constraint.

> What I worry is not much applications syncs the directory
> after new files are created, even if PostgreSQL[1] and many
> other NoSQL database.  If the current implementation forces
> more strict semantic, it makes our mind much much more
> peaceful.

Probably the developer should be a lot less peaceful, because
the safer than required semantics could and perhaps should
disappear tomorrow, and then application would be subtly buggy.

It is not a theoretical issue; there have been a lot of problems
and a huge O_PONIES discussion when the 'ext4' developers went
for an implementation closer to the safety level madnated by the
standard.

Never mind exceptionally silly application developers who tend
to forget that application files might reside on NFS or other
network file systems that are both extremely popular and they
cannot be ignored, and have semantics less safe then POSIX.

Relying on implementations that implement safer behavior than
POSIX seems to me a very bad, lazy (and common) idea.

> [ ... ] a right semantic of fsync should be "The users wants
> to assure the file is retrievable after system crash or power
> failure if fsync returned successfully".

Those would be really bad semantics, because UNIX/POSIX/Linux
filesystem semantics don't allow this silly definition to have a
useful meaning.

The definition seems to be based on ignorance of the really
important and big fact that UNIX/POSIX/Linux files have no
names, and that only directory entries have names, and that a
file can be linked to by zero or many directory entries, and
that for the kernel it can be very expensive to keep track of
all the directory entries (if any) that (hard) link to the file.

A process only needs to 'fsync' a directory if it modified the
directory (for example on entry, not necessarily file, creation
or modification) and it would be really stupid and against all
UNIX/POSIX/Linux logic to impose on the kernel the overhead of
finding and 'fsync'ing all the directories that have entries (if
any!) linking to a file being 'fsync'ed itself.

It is up the user and/or the the applications managing file and
named hard links to them to 'fsync' the file when appropriate,
and if needed (and not necessarily at the same time) any
directories containing the hard links to the file, because which
directory entries should link to a file and where they are can
only be part of the application/user data management logic.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
