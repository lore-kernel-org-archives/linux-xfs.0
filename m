Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 23:38:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8U6cXFd012387
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 23:38:33 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C3161339F79
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 23:40:09 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id 93oMJieFHS9VV5XF for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 23:40:09 -0700 (PDT)
Date: Tue, 30 Sep 2008 16:40:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Increase the default size of the reserved blocks pool
Message-ID: <20080930064007.GE23915@disturbed>
References: <48E097B5.3010906@sgi.com> <20080930041149.GA23915@disturbed> <48E1C50C.20604@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E1C50C.20604@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Sep 30, 2008 at 04:19:56PM +1000, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> On Mon, Sep 29, 2008 at 06:54:13PM +1000, Lachlan McIlroy wrote:
>>> The current default size of the reserved blocks pool is easy to deplete
>>> with certain workloads, in particular workloads that do lots of concurrent
>>> delayed allocation extent conversions.  If enough transactions are running
>>> in parallel and the entire pool is consumed then subsequent calls to
>>> xfs_trans_reserve() will fail with ENOSPC.  Also add a rate limited
>>> warning so we know if this starts happening again.
>>>
>>> --- a/fs/xfs/xfs_mount.c	2008-09-29 18:30:26.000000000 +1000
>>> +++ b/fs/xfs/xfs_mount.c	2008-09-29 18:27:37.000000000 +1000
>>> @@ -1194,7 +1194,7 @@ xfs_mountfs(
>>> 	 */
>>> 	resblks = mp->m_sb.sb_dblocks;
>>> 	do_div(resblks, 20);
>>> -	resblks = min_t(__uint64_t, resblks, 1024);
>>> +	resblks = min_t(__uint64_t, resblks, 16384);
>>
>> I'm still not convinced such a large increase is needed for average
>> case. This means that at a filesystem size of 5GB we are reserving
>> 256MB (5%) for a corner case workload that is unlikely to be run on a
>> 5GB filesystem. That is a substantial reduction in space for such
>> a filesystem, and quite possibly will drive systems into immediate
>> ENOSPC at mount. At that point stuff is going to fail badly during
>> boot.
> What the?  Just last week you were trying to convince me that increasing
> the pool size was a good idea.

For your customer's systems that are being run at ENOSPC - not the
default for everyone!

>> This should use the generic printk ratelimiter, and the error message
>> should use xfs_fs_cmn_err() to indicate what filesystem the error
>> is occuring on. ie.:
>>
>> 	if (printk_ratelimit())
>> 		xfs_fs_cmn_err(CE_WARN, mp,
>> 				"ENOSPC: reserved block pool empty");
>
> Okay, I didn't know about printk_ratelimit().  Hmmm, that routine is not
> entirely useful - if the system is generating lots of log messages then
> it could suppress the one key message that indicates what's really going
> on.

If the message is that critical, then it shouldn't be rate limited
at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
