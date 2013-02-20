Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0A04D7F4E
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 07:15:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 80E35AC008
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 05:15:04 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AhsbbdaJfdpp13YF for
	<xfs@oss.sgi.com>; Wed, 20 Feb 2013 05:15:03 -0800 (PST)
Message-ID: <5124CCED.6090308@redhat.com>
Date: Wed, 20 Feb 2013 08:17:33 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 5/7] xfs: xfs_dquot prealloc throttling watermarks
	and low free space
References: <1361291851-24714-1-git-send-email-bfoster@redhat.com>
	<1361291851-24714-6-git-send-email-bfoster@redhat.com>
	<20130219230857.GH10731@dastard>
In-Reply-To: <20130219230857.GH10731@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 02/19/2013 06:08 PM, Dave Chinner wrote:
> On Tue, Feb 19, 2013 at 11:37:29AM -0500, Brian Foster wrote:
>> Enable tracking of high and low watermarks for preallocation
>> throttling of files under quota restrictions. These values are
>> calculated when the quota limit is read from disk or modified and
>> cached for later use by the throttling algorithm.
>>
>> The high watermark specifies when preallocation is disabled, the
>> low watermark specifies when throttling is enabled and the low free
>> space data structure contains precalculated low free space limits
>> to serve as input to determine the level of throttling required.
>>
>> Note that the low free space data structure is based on the
>> existing global low free space data structure with the exception of
>> using three stages (5%, 3% and 1%) rather than five to reduce the
>> impact of xfs_dquot memory overhead.
>>
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>> ---
>>  fs/xfs/xfs_dquot.c       |   43 +++++++++++++++++++++++++++++++++++++++++--
>>  fs/xfs/xfs_dquot.h       |   13 +++++++++++++
>>  fs/xfs/xfs_qm_syscalls.c |    1 +
>>  3 files changed, 55 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
>> index e1833b9..bd25be3 100644
>> --- a/fs/xfs/xfs_dquot.c
>> +++ b/fs/xfs/xfs_dquot.c
...
>> +
>> +	if (prealloc)
>> +		xfs_dquot_init_prealloc(dq);
> 
> 		xfs_dquot_set_prealloc_limits(dq);
> 
> Because it is used to overwrite existing limits here, not just
> initialise them...
> 

Ok.

>>  }
>>  
>>  /*
>> @@ -249,6 +257,34 @@ xfs_qm_init_dquot_blk(
>>  	xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
>>  }
>>  
>> +/*
>> + * Initialize the preallocation throttling watermarks and low free space table.
> 
> "Initialise the dynamic speculative preallocation thresholds." 
> 

Sounds good.

...
>> +	for (i = 0; i < XFS_QLOWSP_MAX; i++) {
>> +		__uint64_t space = dqp->q_prealloc_hi_wmark;
>> +
>> +		do_div(space, 100);
>> +		dqp->q_low_space[i] = space * pct;
>> +		pct += XFS_QLOWSP_PCNT_INCR;
>> +	}
> 
> This seems kind of obscure. It's just a simple assignment of 3
> values, so why not just unroll the loop like so:
> 
> 	__uint64_t space = dqp->q_prealloc_hi_wmark;
> 
> 	do_div(space, 100);
> 	dqp->q_low_space[XFS_QLOWSP_1_PCNT] = space;
> 	dqp->q_low_space[XFS_QLOWSP_3_PCNT] = space * 3
> 	dqp->q_low_space[XFS_QLOWSP_5_PCNT] = space * 5;
> 
> And it effectively documents itself.
> 
> I know the mount lowspace array is initialised in a loop, but it has
> a fairly obvious per-iteration increment of 1 percent....
> 

Yeah, I agree that is cleaner.

>> --- a/fs/xfs/xfs_dquot.h
>> +++ b/fs/xfs/xfs_dquot.h
>> @@ -32,6 +32,14 @@
>>  struct xfs_mount;
>>  struct xfs_trans;
>>  
>> +enum {
>> +	XFS_QLOWSP_1_PCNT = 0,
>> +	XFS_QLOWSP_3_PCNT,
>> +	XFS_QLOWSP_5_PCNT,
>> +	XFS_QLOWSP_MAX
>> +};
>> +#define XFS_QLOWSP_PCNT_INCR 2
> 
> And gets rid of this strange vowel-challenged XFS_QLOWSP_PCNT_INCR
> thingy....
> 

Snds gd. ;)

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
