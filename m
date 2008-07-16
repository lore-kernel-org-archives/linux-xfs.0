Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Jul 2008 14:57:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6GLvstZ017541
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2008 14:57:55 -0700
Received: from elf.torek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B1852FB719
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2008 14:59:01 -0700 (PDT)
Received: from elf.torek.net (mail.torek.net [67.40.109.61]) by cuda.sgi.com with ESMTP id uev6Ddo3eSMI71mL for <xfs@oss.sgi.com>; Wed, 16 Jul 2008 14:59:01 -0700 (PDT)
Message-Id: <200807162158.m6GLwtE00281@elf.torek.net>
From: Chris Torek <chris.torek@windriver.com>
Subject: Re: question about xfs_fsync on linux 
In-Reply-To: Your message of "Tue, 15 Jul 2008 12:48:30 +1000."
             <20080715024830.GZ29319@disturbed>
Date: Wed, 16 Jul 2008 15:58:55 -0600
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

>Well, you are pretty much on your own, then. Really, we cannot help
>diagnose problems on old kernels with a random set of backported
>patches in them.

Definitely understood.  I just wanted to ask that original
question, really.  I had assumed that the file system itself
had to start any dirty-page writes, having missed the top level
filemap_fdatawrite() call.

We finally got a test case and did a bunch of analysis, and it
turns out that the DB software is missing an fsync() call.  Of
course XFS won't fsync the file if you don't *ask* it to!

As long as I am sending mail, there is something else I am curious
about though.  While this is not XFS specific, I wonder if there
is any desire to have different background write frequencies on
different file systems.  By default, mm/page-writeback.c will start
writebacks after a 30-second delay.  One can tune this to any other
number (via /proc/sys/vm/dirty_{expire,writeback}_centisecs), but
this affects the entire system.  It might be useful to be able
to tune this per-FS instead.

(On the other hand, perhaps if one really wants one's data journaled,
one should just use a data-journaling file system....)

Chris
