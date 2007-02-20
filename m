Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Feb 2007 13:00:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1KL02m7025858
	for <linux-xfs@oss.sgi.com>; Tue, 20 Feb 2007 13:00:03 -0800
Message-ID: <45DB60E9.5040809@sandeen.net>
Date: Tue, 20 Feb 2007 14:58:17 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs.xfs, lvm, multi-terrabyte hardware array and luks
References: <9068053.post@talk.nabble.com> <45DB4CE1.3040302@sandeen.net> <9069238.post@talk.nabble.com>
In-Reply-To: <9069238.post@talk.nabble.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: pgf111000 <junkmail@petergfrazier.com>
Cc: linux-xfs@oss.sgi.com

pgf111000 wrote:
> Thank you for the quick response.  I have posted on a few luks forums to try
> to delve into this issue a little deeper; if they are aware of a resolution
> I'll make sure to post it.  The interesting thing is that when I mkfs.ext3
> on luks partitions above 2-3gb all is fine; I wish xfs and luks would play
> nice.....

mkfs.xfs actually does writes out at the end of the device and verifies
them; I'm not sure ext3 is doing the same.  You may find yourself in
trouble on ext3 post-mkfs (or you may not...)  I seem to recall that xfs
has shaken out similar problems on other block devices for this reason.

I'd do some simple device-level read/write tests around 2GB just for
fun, see how it goes.

-Eric
