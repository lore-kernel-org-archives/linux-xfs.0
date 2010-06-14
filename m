Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5E8vEBE033923 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 03:57:14 -0500
Received: from mga14.intel.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2979712ACC45
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 02:03:16 -0700 (PDT)
Received: from mga14.intel.com (mga14.intel.com [143.182.124.37]) by
	cuda.sgi.com with ESMTP id 0zJLO5PRmX5ncWVH for
	<xfs@oss.sgi.com>; Mon, 14 Jun 2010 02:03:16 -0700 (PDT)
Message-ID: <4C15EF75.5080909@linux.intel.com>
Date: Mon, 14 Jun 2010 10:59:33 +0200
From: Andi Kleen <ak@linux.intel.com>
MIME-Version: 1.0
Subject: Re: [PATCH] XFS: Fix gcc 4.6 set but not read and unused statement
	warnings v2
References: <20100614081356.GA27499@basil.fritz.box>
	<20100614083021.GA29354@lst.de>
In-Reply-To: <20100614083021.GA29354@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Andi Kleen <andi@firstfloor.org>, dgc@fromorbit.com, xfs@oss.sgi.com

, Christoph Hellwig wrote:
> On Mon, Jun 14, 2010 at 10:13:56AM +0200, Andi Kleen wrote:
>> -	/* REFERENCED */
>> -	xfs_da_blkinfo_t *blkinfo;
>>   	xfs_da_args_t *args;
>>   	xfs_dablk_t child;
>>   	xfs_dabuf_t *bp;
>> @@ -742,15 +738,14 @@ xfs_da_root_join(xfs_da_state_t *state,
>>   	if (error)
>>   		return(error);
>>   	ASSERT(bp != NULL);
>> -	blkinfo = bp->data;
>>   	if (be16_to_cpu(oldroot->hdr.level) == 1) {
>> -		ASSERT(be16_to_cpu(blkinfo->magic) == XFS_DIR2_LEAFN_MAGIC ||
>> -		       be16_to_cpu(blkinfo->magic) == XFS_ATTR_LEAF_MAGIC);
>> +		ASSERT(be16_to_cpu(bp->data->magic) == XFS_DIR2_LEAFN_MAGIC ||
>> +		       be16_to_cpu(bp->data->magic) == XFS_ATTR_LEAF_MAGIC);
>>   	} else {
>> -		ASSERT(be16_to_cpu(blkinfo->magic) == XFS_DA_NODE_MAGIC);
>> +		ASSERT(be16_to_cpu(bp->data->magic) == XFS_DA_NODE_MAGIC);
>
> How can this work?  bp->data is a void pointer.

It compiled with CONFIG_XFS_DEBUG enabled. Do I need to set some other
option to test this?

Anyways I don't plan to do any more heavy lifting on this patch,
so if you need any other complicated changes someone else
will have to do it.

-Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
