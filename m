Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Aug 2008 21:29:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7C4SfhN017801
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2008 21:28:42 -0700
Message-ID: <48A1134B.9010606@sgi.com>
Date: Tue, 12 Aug 2008 14:36:27 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: Ooops in Kernel 2.6.26.2
References: <20080808180938.GA3760@diesel.geggus.net> <489FECCD.6050703@sgi.com> <489FF0EE.5040607@sgi.com> <20080812015508.GM6119@disturbed>
In-Reply-To: <20080812015508.GM6119@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, Sven Geggus <lists@fuchsschwanzdomain.de>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Mon, Aug 11, 2008 at 05:57:34PM +1000, Lachlan McIlroy wrote:
>> The ticket allocation code got reworked in 2.6.26 and we now free
>> tickets whereas before we used to cache them so the use-after-free
>> went undetected.
>>
>> This patch should do the trick.
>>
>> --- a/fs/xfs/xfs_log.c	2008-08-11 17:47:18.000000000 +1000
>> +++ b/fs/xfs/xfs_log.c	2008-08-11 17:53:24.000000000 +1000
>> @@ -336,15 +364,12 @@ xfs_log_done(xfs_mount_t	*mp,
>> 	} else {
>> 		xlog_trace_loggrant(log, ticket, "xfs_log_done: (permanent)");
>> 		xlog_regrant_reserve_log_space(log, ticket);
>> -	}
>> -
>> -	/* If this ticket was a permanent reservation and we aren't
>> -	 * trying to release it, reset the inited flags; so next time
>> -	 * we write, a start record will be written out.
>> -	 */
>> -	if ((ticket->t_flags & XLOG_TIC_PERM_RESERV) &&
>> -	    (flags & XFS_LOG_REL_PERM_RESERV) == 0)
>> +		/* If this ticket was a permanent reservation and we aren't
>> +		 * trying to release it, reset the inited flags; so next time
>> +		 * we write, a start record will be written out.
>> +		 */
>> 		ticket->t_flags |= XLOG_TIC_INITED;
>> +	}
>>
>> 	return lsn;
>> }	/* xfs_log_done */
> 
> Looks sane, Lachlan. Good catch, though it makes me wonder how we
> didn't hit it in debug builds with memory poisoning turned on.
> Compiler optimisation, perhaps?

Memory poisoning will only trigger a panic if we use the contents
of the freed structure as an address and dereference it.  For the
code above the compiler will take the contents of 'ticket' (which
is still an address) and add the offset of t_flags and then modify
the contents at that address (ie modify the poison pattern).

I think this panic was caused by the page that contained the freed
ticket being unmapped from the kernel - that just comes down to
getting the timing right.
