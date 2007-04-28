Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 28 Apr 2007 09:48:02 -0700 (PDT)
Received: from mx1.suse.de (mx1.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3SGlvfB010655
	for <xfs@oss.sgi.com>; Sat, 28 Apr 2007 09:47:58 -0700
Subject: Re: XFS on x86_64 Linux Question
References: <Pine.LNX.4.64.0704280633510.7998@p34.internal.lan>
From: Andi Kleen <andi@firstfloor.org>
Date: 28 Apr 2007 19:32:11 +0200
In-Reply-To: <Pine.LNX.4.64.0704280633510.7998@p34.internal.lan>
Message-ID: <p73lkgc1k2s.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com, linux-raid@linux-kernel.vger.kernel.org

Justin Piszcz <jpiszcz@lucidpixels.com> writes:

> Had a quick question, if I re-provision a host with an Intel Core Duo
> CPU with x86_64 Linux; I create a software raid array and use the XFS
> filesystem-- all in 64bit space...
> 
> If I boot a recovery image such as Knoppix, it will not be able to
> work on the filesystem correct?  I would need a 64bit live CD?

There used to be a XFS bug that 32bit journals couldn't 
be replayed on 64bit and vice versa. This means you couldn't mount
a dirty file system on the other architecture. But this bug has been 
long fixed and mounting clean file systems always worked.

-Andi
