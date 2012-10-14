Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9HLd0S0104284 for <xfs@OSS.SGI.com>; Wed, 17 Oct 2012 16:39:00 -0500
Received: from ukmrpl004.it.hutchison3g.net (ukmrpl004.threembb.net
	[217.171.128.38]) by cuda.sgi.com with SMTP id BkWmT9bnO75yiJwT
	for <xfs@OSS.SGI.com>; Wed, 17 Oct 2012 14:40:37 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.76 #1) id 1TNTuA-000078-Tj
	for <xfs@OSS.SGI.com>; Sun, 14 Oct 2012 20:31:18 +0100
MIME-Version: 1.0
Message-ID: <20603.4866.547834.929799@tree.ty.sabi.co.UK>
Date: Sun, 14 Oct 2012 20:31:14 +0100
Subject: Re: Performance degradation over time
In-Reply-To: <20121011111509.0a57372a@booking.com>
References: <20121010105142.148519ca@booking.com>
	<50757583.9000901@hardwarefreak.com> <507586B4.6010201@sandeen.net>
	<20121011103352.4ed8bbf5@booking.com>
	<20121011111509.0a57372a@booking.com>
From: pg@xf2.for.sabi.co.UK (Peter Grandi)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@oss.sgi.com>

>>> [ ... ] open() syscalls (open for writing) were taking
>>> significantly more time than they should eg. 15-20ms vs
>>> 100-150us. [ ... ] That means that we create lots of files in
>>> /mountpoint/some/path/.tmp directory, but directory is empty
>>> as they are moved (rename() syscall) shortly after file
>>> creation to a different directory on the same filesystem.

>>> The workaround which I found so far is to remove that
>>> directory (/mountpoint/some/path/.tmp in our case) with its
>>> content and re-create it. After this operation open() syscall
>>> goes down to 100-150us again.

>>> Is this a known problem ?

Indeed, two known (for several decades) problems: using
filesystems as DBMSes and directories as spool queues.

[ ... ]

> After mounting XFS with inode64 I see performance improvement
> (open() now takes ~3ms vs ~15ms previous) although it's still
> not something I would expect (~150us.)

It would be amusing to know why ever to expect a random metadata
access operation to take 150=B5s on *average* on a storage system
that seems to have rotating disk with 10-15ms *average* access
time.

The metadata operations may have locality, but unsurprisingly
that decreases with time...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
