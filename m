Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Apr 2007 09:06:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l35G6WfB013207
	for <xfs@oss.sgi.com>; Thu, 5 Apr 2007 09:06:33 -0700
Message-ID: <46151E86.2080704@sandeen.net>
Date: Thu, 05 Apr 2007 11:06:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS Resiliency to the disk errors.
References: <A63C579E7F04E74588517328EF5A385E02076A9A@ILEX5.IL.NDS.COM>
In-Reply-To: <A63C579E7F04E74588517328EF5A385E02076A9A@ILEX5.IL.NDS.COM>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Zak, Semion" <SZak@nds.com>
Cc: xfs@oss.sgi.com

Zak, Semion wrote:
> Hi,
>  
> We are studying possibility to use XFS with cheap (not too reliable)
> discs, so we have some questions:
>  
> What in XFS is done to survive the disk errors (bad sectors)?
> I know about superblock duplication in every AG. What else?
>  
> What is XFS behavior in case of the disk errors  (panic/no mount/partial
> data access)?

generally metadata IO errors or bad magic found in metadata will shut 
down the filesystem gracefully if it can.

IO errors on data will just be IO errors.

> What could be done to restore?

xfsdump/xfsrestore I suppose

> If  zero bad sector/dump to other device/format/restore will help? 

Well, you can't make data out of nothing.

you could dd off the junk drive, zeroing out unreadable sectors, point 
xfs_repair at it and hope for the best.  Which, depending on the 
problem, could wind up not being very good.

If you want to know how to recover from disaster, it sounds like perhaps 
your data is important enough that you should not plan for failure, but 
rather find a way to avoid it?

Seems to me the only way I'd want to put drives which are expected to 
fail regularly into a product is if the recovery method of "replace the 
disk and re-image the appliance" was  acceptable, but that's just me.  :)

-Eric
