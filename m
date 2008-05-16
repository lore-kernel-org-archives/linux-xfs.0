Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 May 2008 11:04:20 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4GI4FVZ028591
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 11:04:17 -0700
Received: from mail.ukfsn.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 89F6A16D991A
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 11:05:03 -0700 (PDT)
Received: from mail.ukfsn.org (mx1.ukfsn.org [77.75.108.10]) by cuda.sgi.com with ESMTP id lT856gfLUUb7eioC for <xfs@oss.sgi.com>; Fri, 16 May 2008 11:05:03 -0700 (PDT)
Message-ID: <482DCCCD.8020503@dgreaves.com>
Date: Fri, 16 May 2008 19:05:01 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: Regression- XFS won't mount on partitioned md array
References: <482DC043.5000307@dgreaves.com> <alpine.DEB.1.10.0805161316100.3118@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0805161316100.3118@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: David Chinner <dgc@sgi.com>, LinuxRaid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>

> Ouch, still on 2.6.25.1 here, didn't reboot yet, but I do not use
> mdraid'ed partitions, just regular mdraid, if you boot back to 2.6.20.7
> does it work again?
Yes, no probs.

It came in prior to 2.6.25-rc1
The machine has a root xfs filesystem with an internal log on a sata disk and a
data filesystem on a partitioned array with an external log (also on the
partitioned array).
Only the partitioned array/external-log filesystem is affected.

David
