Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Dec 2006 16:26:45 -0800 (PST)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB20QaaG013055
	for <xfs@oss.sgi.com>; Fri, 1 Dec 2006 16:26:37 -0800
Date: Sat, 2 Dec 2006 00:25:54 +0000 (GMT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: Issues with XFS on Sles9 sp2.
In-Reply-To: <45704570.7020209@atipa.com>
Message-ID: <Pine.LNX.4.64.0612020007490.3735@sheep.housecafe.de>
References: <45704570.7020209@atipa.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Roger Heflin <rheflin@atipa.com>
Cc: xfs@oss.sgi.com

On Fri, 1 Dec 2006, Roger Heflin wrote:
> converting the machines to ext3 eliminates the issues.  Under load
> they were seeing 1-2 events per 24 hours on 100 machines.

just to be sure: 1-2 machines out of 100 had a hanging XFS in 24h, 
right? (as opposed to "each of the 100 machines had 1-2 incidents in 
24h" ;))

> They are using Sles9SP2, currently we cannot go to SP3 as there
> are some other bad driver issues unrelated to XFS (the issue
> preventing us from upgrading also appears to be in 2.6.16.x
> kernel.org kernels so that is a more than just a SLES issue).

So, you can't upgrade to a more current SuSE kernel, but you've already 
tried vanilla kernels? OK, you won't be able to upgrade to a kernel.org 
kernel because of the driver issues - but do the XFS hangs go away?
Did it happen with earlier SuSE kernels too?

> anywhere.  The first type of machine to have the issue
> and where the issue is alot more common has only 4GB
> of ram, the second type of machine that has recently
> starting also having the error has 32GB of ram.

Shot in the dark: did you try to boot with the "mem=" option?
You could try to boot with e.g. "mem=512M" and see if the problem has 
something to do with memory...

Christian.
-- 
BOFH excuse #228:

That function is not currently supported, but Bill Gates assures us it will be featured in the next upgrade.
