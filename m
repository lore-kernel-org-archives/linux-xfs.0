Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TLmGhE190150 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 16:48:16 -0500
Message-ID: <4F74D89B.1060008@sgi.com>
Date: Thu, 29 Mar 2012 16:48:11 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/8] xfs: check for buffer errors before waiting
References: <1333023835-12856-1-git-send-email-david@fromorbit.com>
	<1333023835-12856-2-git-send-email-david@fromorbit.com>
	<4F74B229.6030707@sgi.com> <20120329211025.GD692@dastard>
In-Reply-To: <20120329211025.GD692@dastard>
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

On 03/29/12 16:10, Dave Chinner wrote:
> On Thu, Mar 29, 2012 at 02:04:09PM -0500, Mark Tinguely wrote:
>> On 03/29/12 07:23, Dave Chinner wrote:
>>> From: Dave Chinner<dchinner@redhat.com>
>>>
>>> If we call xfs_buf_iowait() on a buffer that failed dispatch due to
>>> an IO error, it will wait forever for an Io that does not exist.
>>> This is hndled in xfs_buf_read, but there is other code that calls
>>> xfs_buf_iowait directly that doesn't.
>>>
>>> Rather than make the call sites have to handle checking for dispatch
>>> errors and then checking for completion errors, make
>>> xfs_buf_iowait() check for dispatch errors on the buffer before
>>> waiting. This means we handle both dispatch and completion errors
>>> with one set of error handling at the caller sites.
>>>
>>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>>> ---
>>
>>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>>> index 396e3bf..64ed6ff 100644
>>> --- a/fs/xfs/xfs_log_recover.c
>>> +++ b/fs/xfs/xfs_log_recover.c
>>> @@ -179,6 +179,7 @@ xlog_bread_noalign(
>>>   	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
>>>   	XFS_BUF_READ(bp);
>>>   	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
>>> +	bp->b_error = 0;
>>>
>>>   	xfsbdstrat(log->l_mp, bp);
>>>   	error = xfs_buf_iowait(bp);
>>> @@ -266,6 +267,7 @@ xlog_bwrite(
>>>   	xfs_buf_hold(bp);
>>>   	xfs_buf_lock(bp);
>>>   	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
>>> +	bp->b_error = 0;
>>>
>>>   	error = xfs_bwrite(bp);
>>>   	if (error)
>>
>> Just curious, were these needed for a particular reason?
>
> If the previous user of the buffer got an error, it is not
> guaranteed to be cleared because the buffer is not re-initialised.
> i.e. it's an uncached buffer that we control completely and reuse
> from IO to IO with just a reset of the bno and length. If b_error is
> non zero here, then the IO can fail because nothing else clears the
> error in the dispatch path....
>
> Cheers,
>
> Dave.

Thank-you for the explanation.

FYI: I am having problems with the patches applying. This patch 
complained at hunk at offset 623. Maybe I am using too new of kernel source.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
