Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 01 Oct 2008 13:12:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m91KC0P4004910
	for <xfs@oss.sgi.com>; Wed, 1 Oct 2008 13:12:00 -0700
Received: from smtpout.eastlink.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0265A134E220
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2008 13:13:37 -0700 (PDT)
Received: from smtpout.eastlink.ca (smtpout.eastlink.ca [24.222.0.30]) by cuda.sgi.com with ESMTP id 6EB6VkjEu037avgb for <xfs@oss.sgi.com>; Wed, 01 Oct 2008 13:13:37 -0700 (PDT)
Received: from ip02.eastlink.ca ([24.222.39.20])
 by mta01.eastlink.ca (Sun Java System Messaging Server 6.2-4.03 (built Sep 22
 2005)) with ESMTP id <0K82004T7TIK5031@mta01.eastlink.ca> for xfs@oss.sgi.com;
 Wed, 01 Oct 2008 17:13:32 -0300 (ADT)
Date: Wed, 01 Oct 2008 17:13:31 -0300
From: Peter Cordes <peter@cordes.ca>
Subject: Re: RAID5/6 writes
In-reply-to: <87k5csp0pe.fsf@basil.nowhere.org>
Message-id: <20081001201331.GL32037@cordes.ca>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <20081001175237.GJ32037@cordes.ca>
 <87k5csp0pe.fsf@basil.nowhere.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: xfs@oss.sgi.com

On Wed, Oct 01, 2008 at 09:36:13PM +0200, Andi Kleen wrote:
> Peter Cordes <peter@cordes.ca> writes:
> >
> >  XFS knows (or should have been told by the admin with mkfs!) what the
> > stripe geometry is: block size and stripe width.  So it could apply
> > this optimization only if it would make a write cover more whole
> > blocks or whole stripes.
> 
> It's a nice idea, but I don't think XFS knows the actual RAID level,
> only the stripes. And for 0/1 it wouldn't be a good idea.

 Yeah, this would have to be a mount option, like stripewrite=1.
There are already a few other essential mount options people need to
learn about for big RAIDs, e.g. inode64.

 AFAIK, XFS only knows the stripe geometry (sunit, swidth), not how
many parity blocks are part of each stripe, so it can't tell the
difference between RAID0 and RAID4,5,6.  (let alone RAID60...).  XFS
on RAID1 will have swidth=0, though.  Probably the only sane default
is 0, even when swidth!=0, to make sure it doesn't cause problems for
anyone or slow down RAID0.

 Thanks for the CC, since I'm not subscribe to the xfs list.

-- 
#define X(x,y) x##y
Peter Cordes ;  e-mail: X(peter@cor , des.ca)

"The gods confound the man who first found out how to distinguish the hours!
 Confound him, too, who in this place set up a sundial, to cut and hack
 my day so wretchedly into small pieces!" -- Plautus, 200 BC
