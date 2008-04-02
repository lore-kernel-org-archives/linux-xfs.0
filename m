Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Apr 2008 22:20:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m325KgLQ028745
	for <xfs@oss.sgi.com>; Tue, 1 Apr 2008 22:20:45 -0700
Message-ID: <47F32557.2030300@sgi.com>
Date: Wed, 02 Apr 2008 16:19:03 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [Patch] Per iclog callback chain lock
References: <20080401231348.GT103491721@sgi.com> <47F3150B.6000106@sgi.com> <20080402043941.GC103491721@sgi.com>
In-Reply-To: <20080402043941.GC103491721@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> On Wed, Apr 02, 2008 at 03:09:31PM +1000, Lachlan McIlroy wrote:
>> Looks fine to me - just one small comment.
> .....
>>> @@ -1257,6 +1255,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
>>> 		iclog->ic_size = XFS_BUF_SIZE(bp) - log->l_iclog_hsize;
>>> 		iclog->ic_state = XLOG_STATE_ACTIVE;
>>> 		iclog->ic_log = log;
>>> +		atomic_set(&iclog->ic_refcnt, 0);
>> Not related to this change but looks like we need it anyway.
>> Did you mean to include it in this change?
> 
> I added it just to be explicit. It's not actually needed as we
> kmem_zalloc() the log structure....
Ahh, it is zeroed.  I was wondering why it hadn't caused any problems.

> 
>>> +			spin_lock(&iclog->ic_callback_lock);
>>> +			cb = iclog->ic_callback;
> ....
>>> +			spin_lock(&log->l_icloglock);
>>> 			ASSERT(iclog->ic_callback == NULL);
>>> +			spin_unlock(&iclog->ic_callback_lock);
>> Okay so we can acquire the l_icloglock while holding ic_callback_lock.
> 
> Yup - it's a new lock, so we can make whatever rules we like ;)
> 
> Cheers,
> 
> Dave.
