Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Feb 2008 22:11:05 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1T6Aqi1003811
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 22:10:54 -0800
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD2AC62E24E
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 22:11:20 -0800 (PST)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id rry4yDBfx3HrPR4Q for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 22:11:20 -0800 (PST)
Date: Fri, 29 Feb 2008 01:11:18 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [REVIEW #3] bad_features2 support in user-space
Message-ID: <20080229061118.GA22067@josefsipek.net>
References: <op.t69rt3bp3jf8g2@pc-bnaujok.melbourne.sgi.com> <47C79BB8.4010005@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C79BB8.4010005@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Feb 28, 2008 at 11:44:24PM -0600, Eric Sandeen wrote:
> Barry Naujok wrote:
> > Ok, xfs_repair will leave bad_features2 in place just in case it is
> > being run with an older kernel that expects features2 in the bad
> > location. But, it will make sure the correct and bad features2 are
> > consistent if bad_features2 in non-zero.
> > 
> > If bad_features2 is zero, it is left alone (eg. new mkfs or new
> > kernel with fixes it during mount time).
> > 
> > This seems to be the best solution to the problem.
> 
> Will look at details later, but I agree w/ the general direction... I
> think maybe the kernel should go this way too?  (i.e. kernel maybe
> shouldn't be zeroing features2 either...

I think so.

> but this is probably more important for userspace than kernelspace; how
> often do you revert to an older kernel...)

All you need is another subsystem in Linux to be broken (*cough*ACPI*cough*)
and you'll want to go back to your previous kernel.

Josef 'Jeff' Sipek.

-- 
A computer without Microsoft is like chocolate cake without mustard.
