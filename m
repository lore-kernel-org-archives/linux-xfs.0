Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Feb 2007 11:34:39 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1KJYWm7008598
	for <linux-xfs@oss.sgi.com>; Tue, 20 Feb 2007 11:34:34 -0800
Message-ID: <45DB4CE1.3040302@sandeen.net>
Date: Tue, 20 Feb 2007 13:32:49 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mkfs.xfs, lvm, multi-terrabyte hardware array and luks
References: <9068053.post@talk.nabble.com>
In-Reply-To: <9068053.post@talk.nabble.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: pgf111000 <junkmail@petergfrazier.com>
Cc: linux-xfs@oss.sgi.com

pgf111000 wrote:
> When I try to format partitions above 2-3gb my opteron experiences heavy io
> wait; the mkfs.xfs fails, and I receive the following....
> 
>  "mkfs.xfs: libxfs_device_zero write failed: Input/output error"
> 
> When I format partions below 2-3gb, there is no problem whatsoever.  I can
> mkfs.xfs on a +2-3GB non-luks formated partition without a problem... any
> thoughts?

Sounds like a LUKS problem, maybe it can't do those large offsets?  xfs
certainly can...

I bet you'll find that the 2GB size is the threshold... xfs is just
trying a write():

        if ((bytes = write(fd, z, bytes)) < 0) {
                fprintf(stderr, _("%s: %s write failed: %s\n"),
                        progname, __FUNCTION__, strerror(errno));

maybe try a simple dd write at the end of your large luks device, see
how that goes.

-Eric
