Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 Mar 2007 06:09:19 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2PD996p031553
	for <linux-xfs@OSS.SGI.com>; Sun, 25 Mar 2007 06:09:11 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.62 #1)
	id 1HVReN-0008Mo-FG
	for <linux-xfs@OSS.SGI.com>; Sun, 25 Mar 2007 13:16:43 +0100
Resent-Message-ID: <17926.26665.807869.199983@base.ty.sabi.co.UK>
Resent-To: linux-xfs@oss.sgi.com
Subject: Re: xfs_repair on Debian testing 64bits
Date: Sun, 25 Mar 2007 13:10:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Message-ID: <17926.26297.892974.270267@base.ty.sabi.co.UK>
References: <1174655443.5441.37.camel@localhost.localdomain>
In-Reply-To: <1174655443.5441.37.camel@localhost.localdomain>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

>>> On Fri, 23 Mar 2007 14:10:42 +0100, Patrick Noël
>>> <patrick.noel@argus-presse.fr> said:

patrick.noel> Hi, i have a device with 5,3To under a debian
patrick.noel> (sarge) 32bits server.  When i try a xfs_repair
patrick.noel> (2.8.20) on 5,3To i have a message : xfs_repair:
patrick.noel> libxfs_initbuf can't memalign 4096 bytes: Cannot
patrick.noel> allocate memory

  http://OSS.SGI.com/archives/linux-xfs/2005-08/msg00045.html

    «From some quick tests I just ran, for 32bit binaries
     xfs_check needs around 1GiB RAM per TiB of filesystem plus
     about 100MiB RAM per 1million inodes in the filesystem (more
     if you have lots of fragmented files). Double this for 64bit
     binaries.  e.g. it took 1.5GiB RAM for 32bit xfs_check and
     2.7GiB RAM for a 64bit xfs_check on a 1.1TiB filesystem with
     3million inodes in it.»

And from a message that is missing from the list archive:

   «To successfully check or run repair on a multi-terabyte
    filesystem, you need:

	- a 64bit machine
	- a 64bit xfs_repair/xfs_check binary
	- ~2GB RAM per terabyte of filesystem
	- 100-200MB of RAM per million inodes in the filesystem.

    xfs_repair will usually use less memory than this, but these
    numbers give you a ballpark figure for what a large
    filesystem that is > 80% full can require to repair.

    FWIW, last time this came up internally, the 29TB filesystem
    in question took ~75GB of RAM+swap to repair.»

patrick.noel> [ ... ] i tried mounting the device on a 64 bits
patrick.noel> (Debian testing) and with xfs_repair 2.8.20 there
patrick.noel> is no problem with memory but is very long (12
patrick.noel> hours between phase 1 and phase 6) [ ... ]

That seems to me quite fast, like 500GB per hour; you don't say
how many files, but assuming say 50KB/file that's 10M files/hour.

For comparison sometimes it takes more than two months to 'fsck' a
1.5TB filesystem with 'ext3':

  http://UKAI.org/b/log/debian/snapshot/1_month_fsck-2005-07-22-00-00.html
  http://UKAI.org/b/log/debian/snapshot/fsck_completed_but-2005-09-04-15-00.html

A rarely appreciated aspect of 'fsck' is that check and repair of
an error-free filesystem is usually *much* faster than for one
with errors. From some small scale tests I did some time ago:

  http://WWW.sabi.co.UK/blog/anno06-2nd.html#060424b

   «If one extrapolates linearly from the larger filesystem, which
    has an 800KiB average file size, a filesystem with 6.5TiB of
    data in 8.5M inodes will take at least 50 minutes to check,
    and one with 65TiB of data in around 85M inodes at least 11
    hours. If one extrapolates from the smaller filesystem, which
    has a 16KiB average file size, those times must be at least 4
    times larger.

    Again, these are optimal times, assuming that there the
    filesystem is freshly restored and there are no errors. One
    can imagine that recovery in a filesystem with damage and
    fragmentation be a lot slower.»
