Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jun 2008 18:20:06 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5H1K3SL028564
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 18:20:04 -0700
Received: from larry.melbourne.sgi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id B310417CEB76
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 18:20:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130]) by cuda.sgi.com with SMTP id 3VShDinxdeHJh20o for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 18:20:59 -0700 (PDT)
Message-ID: <48571241.20806@sgi.com>
Date: Tue, 17 Jun 2008 11:24:17 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Always reset btree cursor after an insert
References: <4855CE2D.70505@sgi.com> <20080616050150.GK3700@disturbed> <48560B0B.3060204@sgi.com> <200806161014.04407.dchinner@agami.com>
In-Reply-To: <200806161014.04407.dchinner@agami.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <dchinner@agami.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Sunday 15 June 2008 11:41 pm, Lachlan McIlroy wrote:
>> Dave Chinner wrote:
>>> On Mon, Jun 16, 2008 at 12:21:33PM +1000, Lachlan McIlroy wrote:
>>>> After a btree insert operation a cursor can be invalid due to block
>>>> splits and a maybe a new root block.  We reset the cursor in
>>>> xfs_bmbt_insert() in the cases where we think we need to but it
>>>> isn't enough as we still see assertions.  Just do what we do elsewhere
>>>> and reset the cursor unconditionally.
>>> Ok, so you should also kill the new code in the btree insert that
>>> revalidates the btree cursor. IIRC, this was the only place it was
>>> needed for....
>> That was the plan.
> 
> Cool. Please include it in the next version of the patch.
> 
>>>> +			if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
>>>> +					new->br_startblock, new->br_blockcount,
>>>> +					&i)))
>>>> 				goto done;
>>>
>>> 			error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
>>> 					br_startblock, new->br_blockcount, &i);
>>> 			if (error)
>>> 				goto done;
>>>
>>>> -			ASSERT(i == 1);
>>>> +			ASSERT(i == 0);
>>> ASSERT? How about a WANT_CORRUPTED_GOTO()?
>> I was just being consistent with the rest of the code.  If you think this
>> ASSERT should be changed then what about all of them?
> 
> Well, the ASSERT means silent failure on a production system.
> Given that failure here indicates a corrupt btree, then we really
> should be treating it as such. i.e. shut down the filesystem. This
> might have saved us a whole heap of trouble tracking down these
> problems as a shutdown here would have pointed us right at the
> source of the problem...
> 

Dave, what I was asking is what about the rest of the ASSERTs in
this file - should we change them too?  There's a lot of them.
After this change they are all equally likely to trigger so if
it makes sense to change one then the same argument applies to
all of them.
