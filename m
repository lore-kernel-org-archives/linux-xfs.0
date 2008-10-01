Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 01 Oct 2008 14:00:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m91L00iI008806
	for <xfs@oss.sgi.com>; Wed, 1 Oct 2008 14:00:00 -0700
Received: from smtpout.eastlink.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 105C6130792D
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2008 14:01:37 -0700 (PDT)
Received: from smtpout.eastlink.ca (smtpout.eastlink.ca [24.222.0.30]) by cuda.sgi.com with ESMTP id QxcghxPoAkLXznEX for <xfs@oss.sgi.com>; Wed, 01 Oct 2008 14:01:37 -0700 (PDT)
Received: from ip04.eastlink.ca ([24.222.39.52])
 by mta02.eastlink.ca (Sun Java System Messaging Server 6.2-4.03 (built Sep 22
 2005)) with ESMTP id <0K8200ACIVQPAT31@mta02.eastlink.ca> for xfs@oss.sgi.com;
 Wed, 01 Oct 2008 18:01:37 -0300 (ADT)
Date: Wed, 01 Oct 2008 18:01:36 -0300
From: Peter Cordes <peter@cordes.ca>
Subject: Re: RAID5/6 writes
In-reply-to: <20081001204450.GA25711@one.firstfloor.org>
Message-id: <20081001210136.GM32037@cordes.ca>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <20081001175237.GJ32037@cordes.ca>
 <87k5csp0pe.fsf@basil.nowhere.org> <20081001201331.GL32037@cordes.ca>
 <20081001204450.GA25711@one.firstfloor.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: xfs@oss.sgi.com

On Wed, Oct 01, 2008 at 10:44:50PM +0200, Andi Kleen wrote:
> The other problem I can think of is that determing if something is 
> free data might need more read IO if the free extent tree is not completely
> cached.

 Yeah, I think I mentioned that in my original suggestion.  Unless
there are repeated writes with the same hole, it's probably not worth
it to read from disk to figure out if a sector is free.  XFS could just
see what it could do with what it already has in memory.  This is just
an optimization, so it doesn't have to succeed every time it's possible.

-- 
#define X(x,y) x##y
Peter Cordes ;  e-mail: X(peter@cor , des.ca)

"The gods confound the man who first found out how to distinguish the hours!
 Confound him, too, who in this place set up a sundial, to cut and hack
 my day so wretchedly into small pieces!" -- Plautus, 200 BC
