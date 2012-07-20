Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6KDM1xb118787 for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 08:22:01 -0500
Message-ID: <50095B77.7090203@sgi.com>
Date: Fri, 20 Jul 2012 08:21:59 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC] xfs: wait for the write of the superblock on unmount
References: <20120717215957.855744999@tinguelysgi.com>
	<20120718220003.396849822@tinguelysgi.com>
	<20120719015809.GC23387@dastard>
In-Reply-To: <20120719015809.GC23387@dastard>
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

On 07/18/12 20:58, Dave Chinner wrote:
> On Wed, Jul 18, 2012 at 12:33:58PM -0500, tinguely@sgi.com wrote:
>> Sorry, I have been distracted away from this regression. This was previously
>> titled "xfs: synchronously write the superblock on unmount".
>>
>> xfs_wait_buftarg() does not wait for the completion of the write of the
>> uncached superblock. This write can race with the shutdown of the log and
>> causes a panic if the write does not win the race.
>>
>> The log write of the superblock is important for possible recovery, but a
>> second syncronous write of the same superblock seems redundant. Would just
>> waiting for the iodone() of the log write before tearing down the log be
>> enough?
>
> Yes. i.e. something like:
>
> 	/*
> 	 * The superblock buffer is uncached, so xfs_wait_buftarg()
> 	 * will not wait for it. Hence we need to explicitly wait
> 	 * for IO completion on the superblock to occur here.
> 	 */
> 	error = xfs_buf_iowait(mp->m_sb_bp);
> 	if (error)
> 		AAAAIEEEE!
>
> This fix is also needed in xfs_quiesce_attr() for the freeze and
> ro,remount cases as well.
>
> Cheers,
>
> Dave.
>

Thanks for the feedback.

I chose the ugly lock to block on the superblock buffer because it has 
XBF_ASYNC set at that point and won't go through the complete() patch. I 
will look at turning the XBF_ASYNC flag off and wait on a xfs_buf_iowait().

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
