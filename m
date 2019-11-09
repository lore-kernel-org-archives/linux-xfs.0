Return-Path: <SRS0=uP9V=ZB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94707C17441
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Nov 2019 00:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AA9C215EA
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Nov 2019 00:09:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hZiHHBeT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfKIAJe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 19:09:34 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53274 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfKIAJe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 19:09:34 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA909LG6104674
        for <linux-xfs@vger.kernel.org>; Sat, 9 Nov 2019 00:09:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=vRMC3g9b8SoUXJqXS3MYsbfR5xSm8A4J98E7DLJ/Ncc=;
 b=hZiHHBeTITzHNDlixgXF1svlWOVZtpPpL8OcIhWR1z9Y2T7nKQfyqkxPRb+Sz8kG+mvb
 79or0ecEGD6iY18U9svf0XTgQsTn0ipu1poq13Dc2xLEDHOL3JoT47Xa76XQB8YAbwMd
 WHghKc4XiRqZkpaKiA+vLg8DIc+Xoy5RlYGPNy61OOWJv4WYxLgx9tzVhh9y0HUJWWhU
 TTsJfDdF/y8vY1QXosBacLZW8ey4KgzFMnFrnvVbSAcZMGEJo1npLuU9VqvVbhwSEXAQ
 LbI5espkBoGGCsKaHAQNjxqkDeFuiG2+RW7stQ0LAm6XTsqgHw5w+jdXNpUFw6sfLzMb Dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w5hgwr5n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 09 Nov 2019 00:09:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA909JcZ057217
        for <linux-xfs@vger.kernel.org>; Sat, 9 Nov 2019 00:09:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2w5hgxvpu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 09 Nov 2019 00:09:32 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA909VsZ020695
        for <linux-xfs@vger.kernel.org>; Sat, 9 Nov 2019 00:09:31 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 16:09:31 -0800
Subject: Re: [PATCH v4 11/17] xfs: Add xfs_attr3_leaf helper functions
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-12-allison.henderson@oracle.com>
 <20191108211721.GB6219@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <0e0c4bc7-5da6-ffd0-97ca-836777504e29@oracle.com>
Date:   Fri, 8 Nov 2019 17:09:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108211721.GB6219@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911090000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911090000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/8/19 2:17 PM, Darrick J. Wong wrote:
> On Wed, Nov 06, 2019 at 06:27:55PM -0700, Allison Collins wrote:
>> And new helper functions xfs_attr3_leaf_flag_is_set and
>> xfs_attr3_leaf_flagsflipped.  These routines check to see
>> if xfs_attr3_leaf_setflag or xfs_attr3_leaf_flipflags have
>> already been run.  We will need this later for delayed
>> attributes since routines may be recalled several times
>> when -EAGAIN is returned.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr_leaf.c | 94 +++++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_leaf.h |  2 +
>>   2 files changed, 96 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index 42c037e..023c616 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -2809,6 +2809,40 @@ xfs_attr3_leaf_clearflag(
>>   }
>>   
>>   /*
>> + * Check if the INCOMPLETE flag on an entry in a leaf block is set.  This
>> + * function can be used to check if xfs_attr3_leaf_setflag has already been
>> + * called.  The INCOMPLETE flag is used during attr rename operations to mark
>> + * entries that are being renamed. Since renames should be atomic, only one of
> 
> It's also used when creating an xattr with a value stored in a remote
> block so that we can commit the name entry to the log (with INCOMPLETE
> set), allocate/write the remote value with ordered buffers, and then
> commit a second transaction clearing the INCOMPLETE flag.
> 
> Now that I think about it ... this predicate is for non-rename setting
> of attrs with remote values, and the "flagsflipped" predicate is for
> rename operations, aren't they?\

Yes, but I'm realizing now, that we may not need these helpers if we 
continue to move forward with the state machine.  With the state 
machine, we can simply flip the flag, set the next state, and move on 
since that region of code will not execute again.  The state switch will 
jump us forward to where we were without having to check if we already 
did it.

> 
>> + * them should appear as a completed attribute.
>> + *
>> + * isset is set to true if the flag is set or false otherwise
>> + */
>> +int
>> +xfs_attr3_leaf_flag_is_set(
>> +	struct xfs_da_args		*args,
>> +	bool				*isset)
>> +{
>> +	struct xfs_attr_leafblock	*leaf;
>> +	struct xfs_attr_leaf_entry	*entry;
>> +	struct xfs_buf			*bp;
>> +	struct xfs_inode		*dp = args->dp;
>> +	int				error = 0;
>> +
>> +	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno,
>> +				    XFS_DABUF_MAP_NOMAPPING, &bp);
>> +	if (error)
>> +		return error;
>> +
>> +	leaf = bp->b_addr;
>> +	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
>> +
>> +	*isset = ((entry->flags & XFS_ATTR_INCOMPLETE) != 0);
>> +	xfs_trans_brelse(args->trans, bp);
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>>    * Set the INCOMPLETE flag on an entry in a leaf block.
>>    */
>>   int
>> @@ -2972,3 +3006,63 @@ xfs_attr3_leaf_flipflags(
>>   
>>   	return error;
>>   }
>> +
>> +/*
>> + * On a leaf entry, check to see if the INCOMPLETE flag is cleared
>> + * in args->blkno/index and set in args->blkno2/index2.
> 
> Might be worth mentioning here that args->blkno is the old entry and
> args->blkno2 is the new entry.  This predicate will be used (by the
> deferred attr item recovery code) to decide if we have to finish that
> part of a rename operation, right?
No, it was used in the previous series xfs_attr_set_later where I was 
aiming to rely more on the state of the fork rather than the state 
machine.  But with the new state machine in this series, I may be able 
to just drop this patch.

> 
>>   Note that they could be
>> + * in different blocks, or in the same block.  This function can be used to
>> + * check if xfs_attr3_leaf_flipflags has already been called.  The INCOMPLETE
>> + * flag is used during attr rename operations to mark entries that are being
>> + * renamed. Since renames should be atomic, only one of them should appear as a
>> + * completed attribute.
>> + *
>> + * isflipped is set to true if flags are flipped or false otherwise
>> + */
>> +int
>> +xfs_attr3_leaf_flagsflipped(
> 
> I don't like "flagsflipped" because it's not clear to me what "flipped"
> means.
> 
> xfs_attr3_leaf_rename_is_incomplete() ?
> 
Sure, if I keep this patch in the set I will update it.  Things are 
still pretty wiggly, so i may still find a use for it, but hopefully I 
can let it go.

>> +	struct xfs_da_args		*args,
>> +	bool				*isflipped)
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
>> +	/*
>> +	 * Read the block containing the "old" attr
>> +	 */
>> +	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno,
>> +				    XFS_DABUF_MAP_NOMAPPING, &bp1);
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
> 
> bp1 leaks here, I think.
ok, will make a note.

> 
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
>> +	*isflipped = (((entry1->flags & XFS_ATTR_INCOMPLETE) == 0) &&
> 
> Nit: ((entry1->flags & XFS_ATTR_INCOMPLETE) == 0) could be written as
> !(entry1->flags & XFS_ATTR_INCOMPLETE)
> 
>> +		      (entry2->flags & XFS_ATTR_INCOMPLETE));
>> +
>> +	xfs_trans_brelse(args->trans, bp1);
>> +	xfs_trans_brelse(args->trans, bp2);
> 
> This double-frees bp2 if bp1 == bp2.
Ok, will fix if needed.  Thanks for the review!  Sorry for the stray patch!

Allison
> 
> --D
> 
> 
>> +
>> +	return 0;
>> +}
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
>> index e108b37..12283cf 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
>> @@ -57,7 +57,9 @@ int	xfs_attr3_leaf_to_shortform(struct xfs_buf *bp,
>>   				   struct xfs_da_args *args, int forkoff);
>>   int	xfs_attr3_leaf_clearflag(struct xfs_da_args *args);
>>   int	xfs_attr3_leaf_setflag(struct xfs_da_args *args);
>> +int	xfs_attr3_leaf_flag_is_set(struct xfs_da_args *args, bool *isset);
>>   int	xfs_attr3_leaf_flipflags(struct xfs_da_args *args);
>> +int	xfs_attr3_leaf_flagsflipped(struct xfs_da_args *args, bool *isflipped);
>>   
>>   /*
>>    * Routines used for growing the Btree.
>> -- 
>> 2.7.4
>>
