Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Nov 2007 17:21:07 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAG1KuFE012192
	for <xfs@oss.sgi.com>; Thu, 15 Nov 2007 17:20:58 -0800
Message-ID: <473CF018.6050806@sgi.com>
Date: Fri, 16 Nov 2007 12:19:20 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] Move AIL pushing into a separate thread
References: <20071105050706.GW66820511@sgi.com> <473BBDC1.2020107@sgi.com> <20071116004310.GL66820511@sgi.com>
In-Reply-To: <20071116004310.GL66820511@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

David Chinner wrote:
> On Thu, Nov 15, 2007 at 02:32:17PM +1100, Lachlan McIlroy wrote:
>> Overall it looks good Dave, just a few comments below.
> .....
>>> +int
>>> +xfsaild(
>>> +	void	*data)
>>> +{
>>> +	xfs_mount_t	*mp = (xfs_mount_t *)data;
>>> +	xfs_lsn_t	last_pushed_lsn = 0;
>>> +	long		tout = 0;
>>> +
>>> +	while (!kthread_should_stop()) {
>>> +		if (tout)
>>> +		 schedule_timeout_interruptible(msecs_to_jiffies(tout));
>>> +
>>> +		/* swsusp */
>>> +		try_to_freeze();
>>> +
>>> +		/* we're either starting or stopping if there is no log */
>>> +		if (!mp->m_log)
>>> +			continue;
>> It's looks like the log should never be NULL while the xfsaild
>> thread is running.  Could we ASSERT(mp->m_log)?
> 
> Already done.
> 
>>> @@ -100,57 +97,105 @@ xfs_trans_push_ail(
>>> 		spin_unlock(&mp->m_ail_lock);
>>> 		return (xfs_lsn_t)0;
>>> 	}
>>> +	if (XFS_LSN_CMP(threshold_lsn, mp->m_ail.xa_target) > 0)
>> Is this conditional necessary?  Can we just call xfsaild_wakeup()
>> and let it do the same thing?
> 
> Already done.
> 
>>> +long
>>> +xfsaild_push(
>>> +	xfs_mount_t	*mp,
>>> +	xfs_lsn_t	*last_lsn)
>>> +{
>>> +	long		tout = 100; /* milliseconds */
>>> +	xfs_lsn_t	last_pushed_lsn = *last_lsn;
>>> +	xfs_lsn_t	target =  mp->m_ail.xa_target;
>>> +	xfs_lsn_t	lsn;
>>> +	xfs_log_item_t	*lip;
>>> +	int		lock_result;
>>> +	int		gen;
>>> +	int		restarts;
>> restarts needs to be initialised
> 
> Already done.
> 
>>> +		spin_lock(&mp->m_ail_lock);
>>> +		count++;
>>> +		/* Too many items we can't do anything with? */
>>> +		if (stuck > 100)
>> 100?  Arbitrary magic number or was there reason for this?
> 
> Arbitrary magic number based on observation. basically, if
> we are skipping too many items because we can't flush them or
> they are already being flushed we back off and given them time
> to complete whatever operation is being done. i.e. remove pressure
> from the AIL while we can't make progress so traversals don't
> slow down further inserts and removæls to/from the AIL.
> 
>>> +			break;
>>> +		/* we're either starting or stopping if there is no log */
>>> +		if (!mp->m_log)
>> Again, can we ASSERT(mp->m_log)?
> 
> Already done.
> 
>>> +	if ((XFS_LSN_CMP(lsn, target) >= 0)) {
>>> +		tout += 20;
>>> +		last_pushed_lsn = 0;
>>> +	} else if ((restarts > XFS_TRANS_PUSH_AIL_RESTARTS) ||
>>> +		   (count && (count < (stuck + 10)))) {
>> If 0 < count < 10 and stuck == 0 then we'll think we couldn't flush 
>> something
>> - not sure if that is what you intended here.
> 
> If we've got to this situation it generally means we've
> got an empty AIL. Hence backing off a bit more won't hurt at
> all because the log is pretty much clean and we are not likely
> to be in a tail-pushing situation in the next few milliseconds.
Ah, yes, good point.

> 
>> Maybe ((count - stuck) < stuck) ?  ie the number of items we successfully 
>> flushed
>> is less than the number of items we couldn't flush then back off.
> 
> Sort of, but that's a 50% rule - what I'm checking is more like a
> 90% stuck threshold when we break out of the loop at stuck == 100.
> If you can think of a better way of expressing that....

something like ((stuck * 100)/count > 90) ?
or adding a bias to the 50% rule, ((count - stuck) * 10 < stuck)
