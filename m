Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 23:52:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6B6qh1f004546
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 23:52:44 -0700
Message-ID: <48770375.1060308@sgi.com>
Date: Fri, 11 Jul 2008 16:53:41 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Fix reference counting race on log buffers
References: <1215752481-6862-1-git-send-email-david@fromorbit.com> <4876FD7E.3080207@sandeen.net>
In-Reply-To: <4876FD7E.3080207@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com



Eric Sandeen wrote:
> Dave Chinner wrote:
>> When we release the iclog, we do an atomic_dec_and_lock to determine
>> if we are the last reference to enable update of log headers and
>> writeout. however, in xlog_state_get_iclog_space() we need to check
>> if we have the last reference count there.  if we do, we release the
>> log buffer, otherwise we decrement the reference count.
>>
>> The issue is that the compare and decrement in
>> xlog_state_get_iclog_space() is not atomic, so both places can see a
>> reference count of 2 and neither will release the iclog. That leads
>> to a filesystem hang.
>>
>> Close the hole replacing the compare and decrement with
>> atomic_add_unless() to ensure that they are executed atomically.
>>
>> Signed-off-by: Dave Chinner <david@fromorbit.com>
> 
> Tested-by: Eric Sandeen <sandeen@sandeen.net>
> 
> Passes the fs_mark testcase I hit this on, 18 million inodes & counting.

Thanks Eric & Dave. Given the short time available, could one of you
please push this directly to Linus? I don't have anyone here to do that
until Monday, which is probably too late.

Cheers
-- Mark


> 
> Thanks,
> -Eric
> 
>> ---
>>  fs/xfs/xfs_log.c |   15 +++++++++++----
>>  1 files changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index 760d543..0816c5d 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -2425,13 +2425,20 @@ restart:
>>  	if (iclog->ic_size - iclog->ic_offset < 2*sizeof(xlog_op_header_t)) {
>>  		xlog_state_switch_iclogs(log, iclog, iclog->ic_size);
>>  
>> -		/* If I'm the only one writing to this iclog, sync it to disk */
>> -		if (atomic_read(&iclog->ic_refcnt) == 1) {
>> +		/*
>> +		 * If I'm the only one writing to this iclog, sync it to disk.
>> +		 * We need to do an atomic compare and decrement here to avoid
>> +		 * racing with concurrent atomic_dec_and_lock() calls in
>> +		 * xlog_state_release_iclog() when there is more than one
>> +		 * reference to the iclog.
>> +		 */
>> +		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1)) {
>> +			/* we are the only one */
>>  			spin_unlock(&log->l_icloglock);
>> -			if ((error = xlog_state_release_iclog(log, iclog)))
>> +			error = xlog_state_release_iclog(log, iclog);
>> +			if (error)
>>  				return error;
>>  		} else {
>> -			atomic_dec(&iclog->ic_refcnt);
>>  			spin_unlock(&log->l_icloglock);
>>  		}
>>  		goto restart;
> 
> 

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
