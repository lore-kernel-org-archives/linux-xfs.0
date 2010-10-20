Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9KBnlWP060794 for <xfs@OSS.SGI.com>; Wed, 20 Oct 2010 06:49:47 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E5F8A1070AC
	for <xfs@OSS.SGI.com>; Wed, 20 Oct 2010 04:51:00 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id 5p7VaRExWgDEGx4E
	for <xfs@OSS.SGI.com>; Wed, 20 Oct 2010 04:51:00 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1P8WtG-000773-Qb
	for <xfs@OSS.SGI.com>; Wed, 20 Oct 2010 12:31:30 +0100
MIME-Version: 1.0
Message-ID: <19646.54031.427786.109841@tree.ty.sabi.co.uk>
Date: Wed, 20 Oct 2010 12:31:27 +0100
Subject: Re: avoid mbox file fragmentation
In-Reply-To: <4CBE55B3.5010405@hardwarefreak.com>
References: <4CBE2403.8070108@hardwarefreak.com>
	<20101019234217.GD12506@dastard>
	<4CBE55B3.5010405@hardwarefreak.com>
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

[ ... ]

> Odds are long as I believe mbox has a very small user base
> today compared to maildir [ ... ]

Why? It is a good format and lots and lots of programs default
to it. Maildir is the result of the usual "file systems are the
optimal DBMS for databases with many small records" attitude.

Actually it was designed to avoid locking issues on filesystem
with poor locking implementations, for things like spool files
with high update rates, not for archiving emails, for which 'mbox'
is usually a lot better.

> I just thought there may be a tweak in XFS to lessen the
> fragmentation effects.

The simplest tweak would be write a predictive custom allocator
with advising (which is sort of what DaveC said), as nothing else
would do.

> Maybe it's simply time for me to move to maildir format which
> pretty much eliminates fragmentation altogether.

HAHAHAHAHAHAHA! Good one. Genius level insight. Just par for the
course for many posts to this (and others) mailing list.

As a curiosity, how do you square this amazing insight with
writing later that:

> The main reason I like mbox is the fast full body searching of
> mail folders. Doing so with maildir crawls, relatively speaking,
> especially for folders with 15k+ emails.

This reminds me of the other recent post where some other genius
thought that they were sorting the contents of files by changing
the order of directory entries and wondered why the result was so
slow.

[ ... ]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
