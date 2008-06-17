Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jun 2008 00:42:17 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5H7gFee029377
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 00:42:16 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EFB4917D846B
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 00:43:11 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id JxDgt09AUHLegEWZ for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 00:43:11 -0700 (PDT)
Date: Tue, 17 Jun 2008 17:41:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS mkfs/mount options
Message-ID: <20080617074158.GQ3700@disturbed>
References: <881489.19090.qm@web34506.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <881489.19090.qm@web34506.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark <musicman529@yahoo.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 17, 2008 at 12:33:57AM -0700, Mark wrote:
> I have been doing some experiments with XFS on my "hot new desktop
> system," and I have turned up an interesting bit of info. (Note:
> My system is an AMD64 X2 2.5GHz running Linux.)
> 
> When I mount an XFS volume (thus loading the xfs kernel module),
> the kernel spawns two CPU-bound threads for "xfslogd" and
> "xfsdatad". However, it appears that only one of each of these
> kernel processes is getting any load, as indicated by "ps ax":
> 
>  3700 ?        S<     0:00 [xfslogd/0]
>  3701 ?        S<     0:19 [xfslogd/1]
>  3702 ?        S<     0:00 [xfsdatad/0]
>  3703 ?        D<     0:05 [xfsdatad/1]
> 
> For each of these kernel threads, only those on CPU #2 are actually pulling notable load. Why is this?

Because your disk interrupts are delivered to that CPU only.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
