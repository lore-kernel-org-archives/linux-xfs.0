Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 21:44:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6B4hw4Z019576
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 21:44:00 -0700
Message-ID: <4876E54A.7040506@sgi.com>
Date: Fri, 11 Jul 2008 14:44:58 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: deadlocked xfs
References: <4876C667.608@sandeen.net> <4876C9EB.7060601@sgi.com> <4876D1C3.4000006@sgi.com> <20080711040447.GC11558@disturbed>
In-Reply-To: <20080711040447.GC11558@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, markgw@sgi.com, xfs-oss <xfs@oss.sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>

Dave Chinner wrote:
> On Fri, Jul 11, 2008 at 01:21:39PM +1000, Timothy Shimmin wrote:
>>> It made this change which moved the refcount 'decrement and test' operation
>>> outside the l_icloglock spinlock and therefore can race. 
> 
> Just FYI, this is not a 'decrement and test' operation - it's
> an 'decrement and return locked if zero' operation. Best to
>  explain it is this comment in lib/dec_and_lock.c:
> 
Fine, although I didn't write the above :)

> /*
>  * This is an implementation of the notion of "decrement a
>  * reference count, and return locked if it decremented to zero".
>  *
>  * NOTE NOTE NOTE! This is _not_ equivalent to
>  *
>  *      if (atomic_dec_and_test(&atomic)) {
>  *              spin_lock(&lock);
>  *              return 1;
>  *      }
>  *      return 0;
>  *
>  * because the spin-lock and the decrement must be
>  * "atomic".
>  */
> 
> 
>>> 	spin_lock(&log->l_icloglock);
>>> 	atomic_inc(&iclog->ic_refcnt);	/* prevents sync */
>>>
>>> 	...
>>>
>>> 	if (iclog->ic_size - iclog->ic_offset < 2*sizeof(xlog_op_header_t)) {
>>> 		xlog_state_switch_iclogs(log, iclog, iclog->ic_size);
>>>
>>> 		/* If I'm the only one writing to this iclog, sync it to disk */
>>> 		if (atomic_read(&iclog->ic_refcnt) == 1) {
>>> 			spin_unlock(&log->l_icloglock);
>>> 			if ((error = xlog_state_release_iclog(log, iclog)))
>>> 				return error;
>>> 		} else {
>>> 			atomic_dec(&iclog->ic_refcnt);
>>> 			spin_unlock(&log->l_icloglock);
>>> 		}
>>> 		goto restart;
>>> 	}
> 
> Ok, so all the increments of ic_refcnt are done under l_icloglock.
> That means through this section of code we can not ever have teh reference
> count increase. It can decrease, but never to zero because that
> requires holding the l_icloglock.
> 
>>> Previously xlog_state_release_iclog() would wait for the spinlock to be
>>> released above but will now do the atomic_dec_and_lock() while the above
>>> code is executing.  The above atomic_read() will return 2, the
>>> atomic_dec_and_lock() in xlog_state_release_iclog() will return false and
>>> return without syncing the iclog and then the above code will decrement the
>>> atomic counter.  The iclog never gets out of WANT_SYNC state and everything
>>> gets stuck behind it.
> 
> So what that means is that need the semantics here to be an
> atomic 'decrement unless the count is 1' i.e.:
> 
> 	if (atomic_add_unless(&iclog->ic_refcnt, -1, 1)) {
> 		spin_unlock(&log->l_icloglock);
> 		if ((error = xlog_state_release_iclog(log, iclog)))
> 			return error;
> 	} else {
> 			spin_unlock(&log->l_icloglock);
> 	}
> 
Gee, they have an atomic_ almost everything :-)
When I was talking to Lachlan he was saying it would need to make the
atomic_read and the dec somehow atomic (close the window)
- didn't realise such a func existed. 
(And yeah, I hear you saying well one needs to look...
he must have gotten on to one of the corruption fixes..dunno...)

Just saw email, yeah didn't pick up on the reverse logic there -
atomic decrement unless equal to one, yep (reverse if/else logic).

> This means that the compare + decrement becomes atomic, thereby
> closing the race condition where another unlocked thread can
> decrement the reference count in between the compare and decrement
> here.
> 
Yep.

--Tim
