Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 175D17CA2
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 13:58:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D00DC8F8037
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 11:58:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ggFLzHMEDPidGPBD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2016 11:58:23 -0700 (PDT)
Subject: Re: [PATCH 41/42] block: do not use REQ_FLUSH for tracking flush
	support
References: <1460716802-2294-1-git-send-email-mchristi@redhat.com>
	<1460716802-2294-42-git-send-email-mchristi@redhat.com>
	<5710C77F.2000405@pfupf.net>
From: Mike Christie <mchristi@redhat.com>
Message-ID: <571139C9.8060405@redhat.com>
Date: Fri, 15 Apr 2016 13:58:17 -0500
MIME-Version: 1.0
In-Reply-To: <5710C77F.2000405@pfupf.net>
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
To: Juergen Gross <kernel@pfupf.net>, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On 04/15/2016 05:50 AM, Juergen Gross wrote:
> On 15/04/16 12:40, mchristi@redhat.com wrote:
>> From: Mike Christie <mchristi@redhat.com>
>>
>> The last patch added a REQ_OP_FLUSH for request_fn drivers
>> and the next patch renames REQ_FLUSH to REQ_PREFLUSH which
>> will be used by file systems and make_request_fn drivers so
>> they can send a write/flush combo.
>>
>> This patch drops xen's use of REQ_FLUSH to track if it supports
>> REQ_OP_FLUSH requests, so REQ_FLUSH can be deleted.
>>
>> v6:
>> - Dropped parts of patch handled by Jens's QUEUE_FLAG_WC/FUA
>> patches and modified patch to check feature_flush/fua bits.
>>
>> Signed-off-by: Mike Christie <mchristi@redhat.com>
>> Reviewed-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/block/xen-blkfront.c | 47 ++++++++++++++++++++++----------------------
>>  1 file changed, 24 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
>> index f01691a..d6429e7 100644
>> --- a/drivers/block/xen-blkfront.c
>> +++ b/drivers/block/xen-blkfront.c
> 
> ...
> 
>> @@ -985,24 +981,22 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
>>  	return 0;
>>  }
>>  
>> -static const char *flush_info(unsigned int feature_flush)
>> +static const char *flush_info(struct blkfront_info *info)
>>  {
>> -	switch (feature_flush & ((REQ_FLUSH | REQ_FUA))) {
>> -	case REQ_FLUSH|REQ_FUA:
>> +	if (info->feature_flush && info->feature_fua)
>>  		return "barrier: enabled;";
>> -	case REQ_FLUSH:
>> +	else if (info->feature_fua)
> 
> Shouldn't this test feature_flush?
> 
>>  		return "flush diskcache: enabled;";
>> -	default:
>> +	else
>>  		return "barrier or flush: disabled;";
>> -	}
>>  }
>>  
>>  static void xlvbd_flush(struct blkfront_info *info)
>>  {
>> -	blk_queue_write_cache(info->rq, info->feature_flush & REQ_FLUSH,
>> -				info->feature_flush & REQ_FUA);
>> +	blk_queue_write_cache(info->rq, info->feature_flush ? true : false,
>> +			      info->feature_flush ? true : false);
> 
> And here the second test should be feature_fua?
> 

You are right. Will fix up and resend.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
