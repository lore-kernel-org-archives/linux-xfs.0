Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAUHqqE4210540 for <xfs@oss.sgi.com>; Fri, 30 Nov 2012 11:52:52 -0600
Message-ID: <50B8F2FC.6060501@sgi.com>
Date: Fri, 30 Nov 2012 11:55:08 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/3] xfs: use b_maps[] for discontiguous buffers
References: <20121128222309.109033307@.sgi.com>
	<20121128222622.688093599@sgi.com>
	<20121130160920.GA9873@infradead.org>
In-Reply-To: <20121130160920.GA9873@infradead.org>
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
Cc: xfs@oss.sgi.com

On 11/30/12 10:09, Christoph Hellwig wrote:
>>   use_alloc_page:
>> -	start = BBTOB(bp->b_map.bm_bn)>>  PAGE_SHIFT;
>> -	end = (BBTOB(bp->b_map.bm_bn + bp->b_length) + PAGE_SIZE - 1)
>> +	start = BBTOB(bp->b_maps[0].bm_bn)>>  PAGE_SHIFT;
>> +	end = (BBTOB(bp->b_maps[0].bm_bn + bp->b_length) + PAGE_SIZE - 1)
>
> Btw, how is this logic supposed to work for discontiguous buffers?
>
> Each of them might straddle boundaries individually, so doing the
> start/end calculation for the number of pages isn't going to be correct.
>

eeek. yep, I will loop through and count the pages needed in each
segment.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
