Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q95IUJD0088047 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 13:30:19 -0500
Message-ID: <506F278C.6070306@sgi.com>
Date: Fri, 05 Oct 2012 13:31:40 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch v4 04/13] [PATCH 04/13] xfs: sync work is now only periodic
	log work
References: <20121005171853.985930109@sgi.com>
	<20121005171945.888412779@sgi.com>
	<20121005181645.GB1056@infradead.org>
In-Reply-To: <20121005181645.GB1056@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On 10/05/12 13:16, Christoph Hellwig wrote:
> On Fri, Oct 05, 2012 at 12:18:57PM -0500, Ben Myers wrote:
>>   		ASSERT(mp->m_flags&  XFS_MOUNT_RDONLY);
>>   	}
>>
>> +	xfs_log_work_queue(mp);
>> +
>>   	return error;
>
> I still think queueing the work item here if we return a failure is
> the wrong thing to do.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

You are correct. I did not see that it was not moved when mentioned in 
the first series.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
