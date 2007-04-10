Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Apr 2007 23:49:17 -0700 (PDT)
Received: from ilsmtp.nds.com ([192.118.32.12])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3A6n8fB016419
	for <xfs@oss.sgi.com>; Mon, 9 Apr 2007 23:49:14 -0700
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: XFS Resiliency to the disk errors.
Date: Tue, 10 Apr 2007 09:49:06 +0300
Message-ID: <A63C579E7F04E74588517328EF5A385E02076C7B@ILEX5.IL.NDS.COM>
In-Reply-To: <46151E86.2080704@sandeen.net>
From: "Zak, Semion" <SZak@nds.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Thank you very much.

I have other question, about data lose on crash/power cut.
Is it possible to make it not more then in other file systems, if open
the important file with O_SYNC flag, or use fsync and sync functions?

Thanks,

Semion. 

-----Original Message-----
From: Eric Sandeen [mailto:sandeen@sandeen.net] 
Sent: Thursday, April 05, 2007 7:07 PM
To: Zak, Semion
Cc: xfs@oss.sgi.com
Subject: Re: XFS Resiliency to the disk errors.

Zak, Semion wrote:
> Hi,
>  
> We are studying possibility to use XFS with cheap (not too reliable) 
> discs, so we have some questions:
>  
> What in XFS is done to survive the disk errors (bad sectors)?
> I know about superblock duplication in every AG. What else?
>  
> What is XFS behavior in case of the disk errors  (panic/no 
> mount/partial data access)?

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
disk and re-image the appliance" was  acceptable, but that's just me.
:)

-Eric
***********************************************************************************
This email message and any attachments thereto are intended only for use by the addressee(s) named above, and may contain legally privileged and/or confidential information. If the reader of this message is not the intended recipient, or the employee or agent responsible to deliver it to the intended recipient, you are hereby notified that any dissemination, distribution or copying of this communication is strictly prohibited. If you have received this communication in error, please immediately notify the postmaster@nds.com and destroy the original message.
***********************************************************************************
