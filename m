Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Mar 2008 13:37:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2LKbcgW032459
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 13:37:39 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A72B16D168D
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 13:38:10 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id FSDRi5w5FxLiF4qU for <xfs@oss.sgi.com>; Fri, 21 Mar 2008 13:38:10 -0700 (PDT)
Date: Fri, 21 Mar 2008 15:02:39 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: serious problem with XFS on nvidia IDE controller
Message-ID: <20080321190239.GF5433@josefsipek.net>
References: <1206125778.6867.14.camel@dasa-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206125778.6867.14.camel@dasa-laptop>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Massimiliano Adamo <maxadamo@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Mar 21, 2008 at 07:56:18PM +0100, Massimiliano Adamo wrote:
...
> My kernel is the one provided with Ubuntu 7.10: 2.6.22-14
> 
> At present, this controller is not managed by any driver in the linux
> kernel, and in order to boot, I have to append the string
> "all_generic_ide" into grub config file. Otherwise system doesn't boot.

I have no idea if a newer kernel does support it, but it might be worth a
try.

...
> I have installed the system at least 3 times in one day, before
> understanding that the problem was XFS filesystem.
> After each reboot there were file missing, when running ldconfig I was
> getting messages like: the file blabla_blabla.so is truncated, or is
> corrupted...

Is there anything in dmesg?

Josef 'Jeff' Sipek.


-- 
We have joy, we have fun, we have Linux on a Sun...
