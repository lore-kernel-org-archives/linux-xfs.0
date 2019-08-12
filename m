Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48494 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbfHLWjD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 18:39:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CMYddu062135
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:02 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u9nbtagmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CMcdQ0062182
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2u9k1vrfjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:01 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CMd0cq026101
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:01 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v2 11/18] xfs: Add xfs_attr3_leaf helper functions
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-12-allison.henderson@oracle.com>
 <20190812162216.GZ7138@magnolia>
Message-ID: <4adda31d-de39-5665-6d64-6ffb2edf04d4@oracle.com>
Date: Mon, 12 Aug 2019 15:38:58 -0700
MIME-Version: 1.0
In-Reply-To: <20190812162216.GZ7138@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 8/12/19 9:22 AM, Darrick J. Wong wrote:
> On Fri, Aug 09, 2019 at 02:37:19PM -0700, Allison Collins wrote:
>> And new helper functions xfs_attr3_leaf_flag_is_set and
>> xfs_attr3_leaf_flagsflipped.  These routines check to see
>> if xfs_attr3_leaf_setflag or xfs_attr3_leaf_flipflags have
>> already been run.  We will need this later for delayed
>> attributes since routines may be recalled several times
>> when -EAGAIN is returned.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr_leaf.c | 78 +++++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_leaf.h |  2 ++
>>   2 files changed, 80 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index 4a22ced..b2d5f62 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -2729,6 +2729,34 @@ xfs_attr3_leaf_clearflag(
>>   }
>>   
>>   /*
>> + * Check if the INCOMPLETE flag on an entry in a leaf block is set.
>> + */
>> +int
>> +xfs_attr3_leaf_flag_is_set(
>> +	struct xfs_da_args		*args)
> 
> <urk> Please don't conflate error codes and a boolean predicate.  It
> would be way too easy to do:
> 
> if (xfs_attr3_leaf_flag_is_set(&args)) {
> 	/* launch the nuculur missiles */
> }
> 
> because there was a disk error and xfs_attr3_leaf_read fed us -EIO.
> Either make the callers do the _read and pass the bp to this predicate,
> or add a "bool *isset" outparam.
> 
> Second potential failure case:
> 
> error = xfs_attr3_leaf_flag_is_set(&args);
> if (error) {
> 	/* bury all the whatever */
> }
> 
> Wherein everything was actually fine, but instead someone incorrectly
> freaked out and that's why my neighbors were running chainsaws at 11pm
> last night.

Lol, I see.  Sure, I'll add in an isset param here.

> 
>> +{
>> +	struct xfs_attr_leafblock	*leaf;
>> +	struct xfs_attr_leaf_entry	*entry;
>> +	struct xfs_buf			*bp;
>> +	struct xfs_inode		*dp = args->dp;
>> +	int				error = 0;
>> +
>> +	trace_xfs_attr_leaf_setflag(args);
>> +
>> +	/*
>> +	 * Set up the operation.
>> +	 */
>> +	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno, -1, &bp);
>> +	if (error)
>> +		return error;
>> +
>> +	leaf = bp->b_addr;
>> +	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
>> +
>> +	return ((entry->flags & XFS_ATTR_INCOMPLETE) != 0);
>> +}
>> +
>> +/*
>>    * Set the INCOMPLETE flag on an entry in a leaf block.
>>    */
>>   int
>> @@ -2890,3 +2918,53 @@ xfs_attr3_leaf_flipflags(
>>   
>>   	return error;
>>   }
>> +
>> +/*
>> + * On a leaf entry, check to see if the INCOMPLETE flag is cleared
>> + * in args->blkno/index and set in args->blkno2/index2.
>> + *
>> + * Note that they could be in different blocks, or in the same block.
>> + */
>> +int
>> +xfs_attr3_leaf_flagsflipped(
>> +	struct xfs_da_args		*args)
>> +{
>> +	struct xfs_attr_leafblock	*leaf1;
>> +	struct xfs_attr_leafblock	*leaf2;
>> +	struct xfs_attr_leaf_entry	*entry1;
>> +	struct xfs_attr_leaf_entry	*entry2;
>> +	struct xfs_buf			*bp1;
>> +	struct xfs_buf			*bp2;
>> +	struct xfs_inode		*dp = args->dp;
>> +	int				error = 0;
>> +
>> +	trace_xfs_attr_leaf_flipflags(args);
>> +
>> +	/*
>> +	 * Read the block containing the "old" attr
>> +	 */
>> +	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno, -1, &bp1);
>> +	if (error)
>> +		return error;
>> +
>> +	/*
>> +	 * Read the block containing the "new" attr, if it is different
>> +	 */
>> +	if (args->blkno2 != args->blkno) {
>> +		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno2,
>> +					   -1, &bp2);
>> +		if (error)
>> +			return error;
>> +	} else {
>> +		bp2 = bp1;
>> +	}
>> +
>> +	leaf1 = bp1->b_addr;
>> +	entry1 = &xfs_attr3_leaf_entryp(leaf1)[args->index];
>> +
>> +	leaf2 = bp2->b_addr;
>> +	entry2 = &xfs_attr3_leaf_entryp(leaf2)[args->index2];
>> +
>> +	return (((entry1->flags & XFS_ATTR_INCOMPLETE) == 0) &&
>> +		 (entry2->flags & XFS_ATTR_INCOMPLETE));
> 
> Same complaint here.

Ok, will fix.  Thx!

Allison

> 
> --D
> 
>> +}
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
>> index be1f636..d6afe23 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
>> @@ -54,7 +54,9 @@ int	xfs_attr3_leaf_to_shortform(struct xfs_buf *bp,
>>   				   struct xfs_da_args *args, int forkoff);
>>   int	xfs_attr3_leaf_clearflag(struct xfs_da_args *args);
>>   int	xfs_attr3_leaf_setflag(struct xfs_da_args *args);
>> +int	xfs_attr3_leaf_flag_is_set(struct xfs_da_args *args);
>>   int	xfs_attr3_leaf_flipflags(struct xfs_da_args *args);
>> +int	xfs_attr3_leaf_flagsflipped(struct xfs_da_args *args);
>>   
>>   /*
>>    * Routines used for growing the Btree.
>> -- 
>> 2.7.4
>>
