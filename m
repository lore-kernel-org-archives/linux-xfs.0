Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jun 2008 22:42:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5H5gigk015379
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 22:42:44 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 54C2C23C906
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 22:43:41 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id FtWaaEhkJqU2EC16 for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 22:43:41 -0700 (PDT)
Date: Tue, 17 Jun 2008 15:40:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Always reset btree cursor after an insert
Message-ID: <20080617054017.GO3700@disturbed>
References: <4855CE2D.70505@sgi.com> <20080616050150.GK3700@disturbed> <48560B0B.3060204@sgi.com> <200806161014.04407.dchinner@agami.com> <48571241.20806@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48571241.20806@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Dave Chinner <dchinner@agami.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Jun 17, 2008 at 11:24:17AM +1000, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> On Sunday 15 June 2008 11:41 pm, Lachlan McIlroy wrote:
>>>> ASSERT? How about a WANT_CORRUPTED_GOTO()?
>>> I was just being consistent with the rest of the code.  If you think this
>>> ASSERT should be changed then what about all of them?
>>
>> Well, the ASSERT means silent failure on a production system.
>> Given that failure here indicates a corrupt btree, then we really
>> should be treating it as such. i.e. shut down the filesystem. This
>> might have saved us a whole heap of trouble tracking down these
>> problems as a shutdown here would have pointed us right at the
>> source of the problem...
>
> Dave, what I was asking is what about the rest of the ASSERTs in
> this file - should we change them too?  There's a lot of them.
> After this change they are all equally likely to trigger so if
> it makes sense to change one then the same argument applies to
> all of them.

In the past we've only changed the bits of the code that have been
needed for debugging problems. e.g. there's WANT_CORRUPTED
throughout the alloc code, but only some bits of the bmbt code and
almost none in the inobt. Really we should be consistent with
our catching and handling of errors.

IOWs, I'd say we probably should change them all, but it's going
to touch lots of code. For the btree code, I'd say it should be done
with the factoring (get them all in one go), but xfs_bmap.c code is
separate and could be done separately.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
