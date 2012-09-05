Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q85DG6DV052524 for <xfs@oss.sgi.com>; Wed, 5 Sep 2012 08:16:06 -0500
Message-ID: <504750CB.2090907@sgi.com>
Date: Wed, 05 Sep 2012 08:16:59 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 03/13] xfs: rationalise xfs_mount_wq users
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<1346328017-2795-4-git-send-email-david@fromorbit.com>
	<504622C1.20201@sgi.com> <20120905043000.GE15292@dastard>
In-Reply-To: <20120905043000.GE15292@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/04/12 23:30, Dave Chinner wrote:
> On Tue, Sep 04, 2012 at 10:48:17AM -0500, Mark Tinguely wrote:
>> On 08/30/12 07:00, Dave Chinner wrote:
>>> -	/*
>>> -	 * We shouldn't write/force the log if we are in the mount/unmount
>>> -	 * process or on a read only filesystem. The workqueue still needs to be
>>> -	 * active in both cases, however, because it is used for inode reclaim
>>> -	 * during these times.  Use the MS_ACTIVE flag to avoid doing anything
>>> -	 * during mount.  Doing work during unmount is avoided by calling
>>> -	 * cancel_delayed_work_sync on this work queue before tearing down
>>> -	 * the ail and the log in xfs_log_unmount.
>>> -	 */
>>> -	if (!(mp->m_super->s_flags&   MS_ACTIVE)&&
>>> -	    !(mp->m_flags&   XFS_MOUNT_RDONLY)) {
>>> +	if (!(mp->m_flags&   XFS_MOUNT_RDONLY)) {
>>>   		/* dgc: errors ignored here */
>>>   		if (mp->m_super->s_writers.frozen == SB_UNFROZEN&&
>>>   		xfs_log_need_covered(mp))
>>> @@ -408,8 +398,7 @@ xfs_sync_worker(
>>>   		else
>>>   			xfs_log_force(mp, 0);
>>>
>>> -		/* start pushing all the metadata that is currently
>>> -		 * dirty */
>>> +		/* start pushing all the metadata that is currently dirty */
>>>   		xfs_ail_push_all(mp->m_ail);
>>>   	}
>>>
>>
>> It appears that the removal of the MS_ACTIVE flag is causing the
>> "atomic_read(&bp->b_hold)>   0," ASSERT.
>
> I must be being slow today - I don't see why that would cause any
> problems. The worker is not started at the end of the mount process
> after everything is set up (i.e. just before MS_ACTIVE is removed),
> and the worker is stopped before anything is torn down. That should
> effectively replicate what the MS_ACTIVE flag is providing in the
> old code.
>
> Can you explain in more detail what lead you to this conclusion?
>
> Cheers,
>
> Dave.

You are correct, it does not make sense, but with the
  !(mp->m_super->s_flags &  MS_ACTIVE)
test removed, test 107 causes the above assert on
different machines/architectures. Place the test in, the
assert does not happen.

I will see if I can get it to dump on the x86_32 machine.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
