Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Aug 2006 07:16:57 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7HEGgDW019547
	for <linux-xfs@OSS.SGI.com>; Thu, 17 Aug 2006 07:16:43 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.62 #1)
	id 1GDh0V-0000om-Re
	for <linux-xfs@OSS.SGI.com>; Thu, 17 Aug 2006 13:29:55 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17636.24895.74010.977829@base.ty.sabi.co.UK>
Date: Thu, 17 Aug 2006 13:29:51 +0100
Subject: Re: xfsdump -s unacceptable performances
In-Reply-To: <200608170858.11697.daniele@interline.it>
References: <200608161515.00543.daniele@interline.it>
	<200608162001.10342.daniele@interline.it>
	<44E3C6D5.2080704@sgi.com>
	<200608170858.11697.daniele@interline.it>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

>>> On Thu, 17 Aug 2006 08:58:11 +0200, "Daniele P." 
>>> <daniele@interline.it> said:

[ ... ]

daniele> Hi Timothy, Yes, you are right, but there is another
daniele> problem on my side. The /small/ subtree of the
daniele> filesystem usually contains a lot of hard links (our
daniele> backup software

Given the context, I would imagine that this backup filesystem
is stored on a RAID5 device... Is it? It can be an important
part of the strategy.

daniele> uses hard links to save disk space, so expect one hard
daniele> link per file per day) and using a generic tool like
daniele> tar/star or rsync that uses "stat" to scan the
daniele> filesysem should be significant slower (no test done)
daniele> than a native tool like xfsdump, as Bill in a previous
daniele> email pointed out.

Depends a lot, for example on whether the system has enough RAM
to cache the inodes affected, and anyhow on the ratio between
inodes in the subtree and inodes in the whole filesystem.

As to this case:

    deniale> Dumping one directory with 4 file using 4KB of
    deniale> space takes hours (or days, it hasn't finished yet)
    deniale> if the underlying filesystem contains around
    deniale> 10.000.000 inodes.

probably using 'tar'/'star' may be a bit faster...

daniele> It seems that there isn't a right tool for this job.

Or perhaps it is not the right job :-).

Anyhow sequential scans of large filesystems are not an awesome
idea in general. I wonder how long and how much RAM your 10m
inode filesystem will take to 'fsck' for example :-), perhaps
you don't want to read this older entry in this mailing list:

  http://OSS.SGI.com/archives/linux-xfs/2005-08/msg00045.html

The basic problem is that the bottleneck is the ''pickup'' and
its speed has not grown as fast as disc capacity, so one has to
do RAID to work around that, but RAID delivers only for parallel,
not sequential, scans of the filesystem.

A significant issue that nobody seems in a hurry to address. As
a recent ''contributor'' to this list wrote:

  > hope i never need to run repair,

:-)
