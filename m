Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jun 2008 01:48:40 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5P8matI026134
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 01:48:37 -0700
Received: from build-svl-1.agami.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37BD4181E833
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 01:49:36 -0700 (PDT)
Received: from build-svl-1.agami.com (colo-nat-pool.agami.com [216.218.227.40]) by cuda.sgi.com with ESMTP id p7pdEUrfCh11BA10 for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 01:49:36 -0700 (PDT)
Date: Wed, 25 Jun 2008 01:49:31 -0700
From: Dave Chinner <dchinner@agami.com>
Subject: Re: Xfs Access to block zero  exception and system crash
Message-ID: <20080625084931.GI16257@build-svl-1.agami.com>
References: <340C71CD25A7EB49BFA81AE8C839266701323BD8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <340C71CD25A7EB49BFA81AE8C839266701323BD8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sagar Borikar <Sagar_Borikar@pmc-sierra.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 24, 2008 at 12:03:16AM -0700, Sagar Borikar wrote:
> 
> Hello,
> 
> I hope this is the right list to address this issue. If not please divert me to the right list. 
> 
> We are facing strange issue with xfs under heavy load. It's a NAS
> box with 2.6.18 kernel,128 MB of RAM, MIPS architecture and XFS
> version 2.8.11.

[...]

> Can anyone let me know what could be the probable cause of this issue.

they are all from  corrupted extent btrees.

There are many possible causes of this that we've fixed over the
past years since 2.6.18 was released. Indeed, we are currently
discussing fixes for a bunch of problems that lead to corrupted
extent btrees and problems like this. I'd suggest that you should
probably start with a more recent kernel, make sure you have a
serial console and set the xfs_error_level to 11 so that it gives as
much information as possible on the console when the error it hit.
if that doesn't give a stack trace, then  you need to set the
xfs_panic_mask to crash the machine on block zero accesses and
report the stack ﬆraces that it outputs...

Cheers,

Dave.
-- 
Dave Chinner
dchinner@agami.com
