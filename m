Return-Path: <SRS0=b7mv=XQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD7CC3A5A2
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Sep 2019 01:04:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41BA4217F9
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Sep 2019 01:04:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OCkm5fXX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394032AbfIUBEE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 21:04:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59716 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393953AbfIUBEE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Sep 2019 21:04:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8L1086N141974;
        Sat, 21 Sep 2019 01:03:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=jq1tHJql8kUvTbfLI03P5E1PMzVQLJBxWtfLQroydTY=;
 b=OCkm5fXXZF+jZa8CcmUlhJOuUxLIl26n3w/ru43IHliSDzWZy2O1/tjN5CIMhylJ4x+X
 AeNIrpoqOlgzNlzy+mEvb3dNW8jqhmhCOb6azIx96XDINwd5QawKa/58HOTIqPKjWKix
 AHNb+o6jnLVm9Ry2e5MJVTiD6HUDq9HPJcXDVycjVbs/KcJX5GFvwdIthOSvM/Vw/9ka
 hyUfeZ+595ocKniRDSE1qfaF4OH/AhSgSt+zTD4eSB31juMocEig9i8WWIZJ5QPgEwdX
 HI90E40AGHa0tVVbIM+Rwcms/447E9AOdEcWupqcltkB8G4BO2LPupFbfXb5CVRw6pa6 pQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2v3vb5586e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Sep 2019 01:03:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8L13igk029726;
        Sat, 21 Sep 2019 01:03:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2v590dtkx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Sep 2019 01:03:46 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8L1399Z030552;
        Sat, 21 Sep 2019 01:03:09 GMT
Received: from [192.168.1.9] (/67.1.21.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 20 Sep 2019 18:03:09 -0700
Subject: Re: [PATCH v3 10/19] xfs: Add xfs_attr3_leaf helper functions
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-11-allison.henderson@oracle.com>
 <20190920135058.GH40150@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <0054b43d-c03e-7ca4-8790-c831fa4cd916@oracle.com>
Date:   Fri, 20 Sep 2019 18:03:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920135058.GH40150@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909210010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909210009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/20/19 6:50 AM, Brian Foster wrote:
> On Thu, Sep 05, 2019 at 03:18:28PM -0700, Allison Collins wrote:
>> And new helper functions xfs_attr3_leaf_flag_is_set and
>> xfs_attr3_leaf_flagsflipped.  These routines check to see
>> if xfs_attr3_leaf_setflag or xfs_attr3_leaf_flipflags have
>> already been run.  We will need this later for delayed
>> attributes since routines may be recalled several times
>> when -EAGAIN is returned.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr_leaf.c | 84 +++++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_leaf.h |  2 ++
>>   2 files changed, 86 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index bcd86c3..79650c9 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -2757,6 +2757,36 @@ xfs_attr3_leaf_clearflag(
>>   }
>>   
>>   /*
>> + * Check if the INCOMPLETE flag on an entry in a leaf block is set.
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
>> +	trace_xfs_attr_leaf_setflag(args);
>> +
> 
> Tracepoint seems misplaced.. This is just a flag checking helper, right?
>
Yes, I likely scooped it up with the rest to consolidate code, but it 
probably should have stayed in setflag

>> +	/*
>> +	 * Set up the operation.
>> +	 */
> 
> Not sure what the comment means. The code seems self-explanatory here
> anyways, so you could probably just drop it.
Alrighty then, will clean out

> 
>> +	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno, -1, &bp);
> 
> Didn't you create a #define for this -1 earlier in the series?
Yes, I missed applying it here.  Will fix

> 
>> +	if (error)
>> +		return error;
>> +
>> +	leaf = bp->b_addr;
>> +	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
>> +
>> +	*isset = ((entry->flags & XFS_ATTR_INCOMPLETE) != 0);
>> +	return 0;
> 
> What about bp? Should we release it before returning? If not, the
> comment above the function should elaborate.
I think you're probably right.  It's only used in the delayed code path 
and I think the logging routines may have done the release so I didn't 
notice

> 
>> +}
>> +
>> +/*
>>    * Set the INCOMPLETE flag on an entry in a leaf block.
>>    */
>>   int
>> @@ -2918,3 +2948,57 @@ xfs_attr3_leaf_flipflags(
>>   
>>   	return error;
>>   }
>> +
>> +/*
>> + * On a leaf entry, check to see if the INCOMPLETE flag is cleared
>> + * in args->blkno/index and set in args->blkno2/index2.
>> + * Note that they could be in different blocks, or in the same block.
>> + *
> 
> A sentence or two on what this check is for would be helpful. Relocation
> of an xattr or something..?
It's just a check to see if the two flags mentioned above have been 
swapped before proceeding to swap them with xfs_attr3_leaf_flipflags.  I 
believe it's used in attr renames.  I will add in some extra commentary 
to reference the other routine, that might help make a little more sense.

> 
>> + * isflipped is set to true if flags are flipped or false otherwise
>> + */
>> +int
>> +xfs_attr3_leaf_flagsflipped(
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
>> +	trace_xfs_attr_leaf_flipflags(args);
>> +
>> +	/*
>> +	 * Read the block containing the "old" attr
>> +	 */
>> +	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno, -1, &bp1);
>> +	if (error)
>> +		return error;
>> +
> 
> Similar comments about the tracepoint, -1 usage and buffers.
Sure, will fix.  Thanks!

Allison
> 
> Brian
> 
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
>> +	*isflipped = (((entry1->flags & XFS_ATTR_INCOMPLETE) == 0) &&
>> +		      (entry2->flags & XFS_ATTR_INCOMPLETE));
>> +
>> +	return 0;
>> +}
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
>> index 58e9327..d82229b 100644
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
