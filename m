Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Oct 2008 06:01:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9OD1N9r001068
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2008 06:01:24 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBD58146E407
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2008 06:01:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id Sq2ik35Je4BbKCv2 for <xfs@oss.sgi.com>; Fri, 24 Oct 2008 06:01:17 -0700 (PDT)
Message-ID: <4901C71C.9060509@sandeen.net>
Date: Fri, 24 Oct 2008 08:01:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 3/2] delalloc support for xfs fiemap
References: <49014887.6050309@sandeen.net> <20081024052930.GI18495@disturbed>
In-Reply-To: <20081024052930.GI18495@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Thu, Oct 23, 2008 at 11:01:11PM -0500, Eric Sandeen wrote:
>> Ok, got the kinks worked out of the delalloc portion of the
>> fiemap hookup I think.
>>
>> This introduces a new input flag (BMV_IF_DELALLOC) and output
>> flag (BMV_OF_DELALLOC) to request & show the delayed allocation
>> segments.
> ....
>> @@ -5827,6 +5827,7 @@ xfs_getbmap(
>>  						 * preallocated data space */
>>  	int			sh_unwritten;	/* true, if unwritten */
>>  						/* extents listed separately */
>> +	int			sh_delalloc;	/* show delayed extents */
>>  	int			iflags;		/* interface flags */
>>  	int			bmapi_flags;	/* flags for xfs_bmapi */
> 
> Do we really need this "sh_delalloc" flag? Checking for
> (iflags & BMV_IF_DELALLOC) is fine by me, same for replacing
> sh_unwritten. I've never really liked the "sh" abbreviation for
> "show"....

Sure, I'd agree with that, though some of the tests for sh_$FOO are a
bit wordy already ... I'll make the change, though.

> Otherwise it looks ok. Perhaps we should also add delalloc extent
> display to xfs_bmap....

Yep, that'd be good.

BTW thanks for the help looking through the bmap flag stuff!

I'll resend the whole series; there are some 80+ char lines etc
to fix up as well.

Thanks,
-Eric

> Cheers,
> 
> Dave.
