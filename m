Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Feb 2008 21:04:54 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1F54lDF032401
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 21:04:49 -0800
Message-ID: <47B51D82.1060509@sgi.com>
Date: Fri, 15 Feb 2008 16:05:06 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch] Use atomics for iclog reference counting
References: <20080121053021.GH155259@sgi.com> <4796CCF5.8010509@sgi.com> <20080214234758.GP155259@sgi.com> <20080215002429.GT155259@sgi.com> <47B5085D.30409@sgi.com> <20080215042712.GY155259@sgi.com>
In-Reply-To: <20080215042712.GY155259@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> On Fri, Feb 15, 2008 at 02:34:53PM +1100, Timothy Shimmin wrote:
>> In the 1st 2 cases of the patch:
>>> @@ -675,7 +675,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>>>
>>>  		spin_lock(&log->l_icloglock);
>>>  		iclog = log->l_iclog;
>>> -		iclog->ic_refcnt++;
>>> +		atomic_inc(&iclog->ic_refcnt);
>>>  		spin_unlock(&log->l_icloglock);
>>>  		xlog_state_want_sync(log, iclog);
>>>  		(void) xlog_state_release_iclog(log, iclog);
>>> @@ -713,7 +713,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>>>  		 */
>>>  		spin_lock(&log->l_icloglock);
>>>  		iclog = log->l_iclog;
>>> -		iclog->ic_refcnt++;
>>> +		atomic_inc(&iclog->ic_refcnt);
>>>  		spin_unlock(&log->l_icloglock);
>> Do we still really need to take the lock etc?
> 
> log->iclog is protected by the l_icloglock as well, 

Ah, yep :)

> so the lock
> needs to be retained to prevent races when reading and taking a
> reference to it. IOWs, the l_icloglock still synchronises increments
> and the final decrement on an iclog; we only need the atomic counter
> to enable unlocked refcount decrements when the refcount is > 1.
>  
Yep.

--Tim
