Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Nov 2008 16:25:07 -0800 (PST)
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA50Oous021979
	for <xfs@oss.sgi.com>; Tue, 4 Nov 2008 16:24:50 -0800
Message-ID: <4910E7CE.1020801@sgi.com>
Date: Wed, 05 Nov 2008 11:24:46 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] XFS: handle memory allocation failures during log	initialisation
References: <1225416366-3116-1-git-send-email-david@fromorbit.com> <490A8AAD.50207@sgi.com> <20081102231023.GJ19509@disturbed>
In-Reply-To: <20081102231023.GJ19509@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> On Fri, Oct 31, 2008 at 03:33:49PM +1100, Timothy Shimmin wrote:
>>> +
>>> +out_free_iclog:
>>> +	for (iclog = log->l_iclog; iclog; iclog = prev_iclog) {
>>> +		prev_iclog = iclog->ic_next;
>>> +		if (iclog->ic_bp) {
>>> +			sv_destroy(&iclog->ic_force_wait);
>>> +			sv_destroy(&iclog->ic_write_wait);
>>> +			xfs_buf_free(iclog->ic_bp);
>>> +			xlog_trace_iclog_dealloc(iclog);
>>> +		}
>>> +		kmem_free(iclog);
>>> +	}
>>> +	spinlock_destroy(&log->l_icloglock);
>>> +	spinlock_destroy(&log->l_grant_lock);
>>> +	xlog_trace_loggrant_dealloc(log);
>>> +	xfs_buf_free(log->l_xbuf);
>>> +out_free_log:
>>> +	kmem_free(log);
>>> +	return NULL;
>>>  }	/* xlog_alloc_log */
>>>  
>>>  
>> I would have done s/prev_iclog/next_iclog/
>> as I'm not sure why you look at it as previous.
> 
> Already had a local variable of the right type - not much
> point in declaring a new variable to use as a list iterator
> when you've already got a variable that is used as a list
> iterator in another, non-overlapping part of the code ;)
> 
Oh I see your point.
And if the variable was called iclog or something more generic
then it wouldn't be so bad.
However, in this case, the name is misleading for its use - it
infers the wrong object.
But this is irrelevant considering below :)

>> However, I think it would be nicer to modify xlog_dealloc_log()
>> to handle less than l_iclog_bufs.
>> i.e put the code you have here into xlog_dealloc_log()
>> and do the deallocation in one place.
> 
> The current trend is to unwind complex initialisation errors at
> the place they occur, even if there is a destructor function for
> a completely intialised object/subsystem. I just followed that
> construct. And to be truly complete, it should also handle
> trace buffer initialisation failure, which would make the
> unwinding even more complex than it is above.
> 
> Given that this is a regression fix I didn't want to perturb the
> log destructor code by making it have to handle partially set up
> lists and objects....
> 
> If you still want me to push this into xlog_dealloc_log() I will,
> just let me know.
> 
:-)
Yeah, I'd prefer to reuse the same bit of code.
IMHO, it minimises the chance of getting it wrong by having it in one place etc.

Thanks muchly,
Tim.
