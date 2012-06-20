Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5KFxJu0100872 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 10:59:20 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6FjaN8e7AeCTuoik for
	<xfs@oss.sgi.com>; Wed, 20 Jun 2012 08:59:19 -0700 (PDT)
Message-ID: <4FE1F37E.6090706@redhat.com>
Date: Wed, 20 Jun 2012 11:59:58 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfs: re-enable xfsaild idle mode and fix associated
	races
References: <1339087793-45731-1-git-send-email-bfoster@redhat.com>
	<20120620080523.GA26167@infradead.org>
In-Reply-To: <20120620080523.GA26167@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 06/20/2012 04:05 AM, Christoph Hellwig wrote:
> On Thu, Jun 07, 2012 at 12:49:53PM -0400, Brian Foster wrote:
[snip]
>>  	spin_lock(&ailp->xa_lock);
>> +
>> +	/* barrier matches the xa_target update in xfs_ail_push() */
>> +	smp_rmb();
>> +	target = ailp->xa_target;
>> +	ailp->xa_target_prev = target;
>> +
>>  	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->xa_last_pushed_lsn);
>>  	if (!lip) {
>>  		/*
>> +
>> +		spin_lock(&ailp->xa_lock);
>> +
>> +		/*
>> +		 * Idle if the AIL is empty and we are not racing with a target
>> +		 * update. The barrier matches the xa_target update in
>> +		 * xfs_ail_push().
>> +		 */
>> +		smp_rmb();
> 
> Given that both sides are under xa_lock I can't see any need for
> barriers here.
> 

Actually now that I look at it, it appears xfs_trans_ail_copy_lsn() does
not necessarily acquire the xa_lock...

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
