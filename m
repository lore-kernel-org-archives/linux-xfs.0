Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FCD0C5519F
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 01:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EE6A21D7F
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 01:27:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A7HRdJDJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgKMB1n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Nov 2020 20:27:43 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45966 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgKMB1m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Nov 2020 20:27:42 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AD1NpD0189704
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:27:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5RFPQZwP7XEYsWavZoqasrlo5i5Y2x7mdycenJ2mU/c=;
 b=A7HRdJDJD74RkrDEL/RD/M12ZjpCitbI1Vnels9OPgFEQ9U1K/OE18rsgNcGHHL44spf
 4eQB3LMZuOIKVb/m3P4ZloDGug8ZOrnfPu/7vQw43tT3FQzggcV8Cxa/REWw0Z4ZZ12z
 GccftabNGj7QX6jQk3HzRPNqCXuD2/2c9PCNTOkLKoc0fTilr46A3C17QnbFCFTEfBb2
 UleGgKiWY0t7vTooH1RD1CqjwXUEdf3NW5A95V3P0/toh6v0WM97HEh2BgxXMKcTGWqe
 tv18fXFlf/lDaK2hMysFb0fbBLEKL430V90eMYn6yKaH1cx4hXqj2HX8CcUyMU8Ty/UP gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34p72exkm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:27:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AD1PKpr139127
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:27:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34p55s6syv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:27:40 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AD1RdRu004086
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:27:39 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 17:27:39 -0800
Subject: Re: [PATCH v13 06/10] xfs: Add xfs_attr_set_deferred and
 xfs_attr_remove_deferred
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201023063435.7510-7-allison.henderson@oracle.com>
 <20201110201523.GF9695@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <2f9cc387-fca2-7978-76e5-235e095740bc@oracle.com>
Date:   Thu, 12 Nov 2020 18:27:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201110201523.GF9695@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130005
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/10/20 1:15 PM, Darrick J. Wong wrote:
> On Thu, Oct 22, 2020 at 11:34:31PM -0700, Allison Henderson wrote:
>> From: Allison Collins <allison.henderson@oracle.com>
>>
>> These routines to set up and start a new deferred attribute operations.
>> These functions are meant to be called by any routine needing to
>> initiate a deferred attribute operation as opposed to the existing
>> inline operations. New helper function xfs_attr_item_init also added.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr.h |  2 ++
>>   2 files changed, 56 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 760383c..7fe5554 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -25,6 +25,7 @@
>>   #include "xfs_trans_space.h"
>>   #include "xfs_trace.h"
>>   #include "xfs_attr_item.h"
>> +#include "xfs_attr.h"
>>   
>>   /*
>>    * xfs_attr.c
>> @@ -643,6 +644,59 @@ xfs_attr_set(
>>   	goto out_unlock;
>>   }
>>   
>> +STATIC int
>> +xfs_attr_item_init(
>> +	struct xfs_da_args	*args,
>> +	unsigned int		op_flags,	/* op flag (set or remove) */
>> +	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
>> +{
>> +
>> +	struct xfs_attr_item	*new;
>> +
>> +	new = kmem_alloc_large(sizeof(struct xfs_attr_item), KM_NOFS);
> 
> I don't think we need _large allocations for struct xfs_attr_item, right?
I will try it and see, I think it should be ok, one of the new test 
cases I'm using does try to progressively add larger and larger attrs. 
If it doesnt work, I'll make a note of it though.

> 
>> +	memset(new, 0, sizeof(struct xfs_attr_item));
> 
> Use kmem_zalloc and you won't have to memset.  Better yet, zalloc will
> get you memory that's been pre-zeroed in the background.
> 
>> +	new->xattri_op_flags = op_flags;
>> +	new->xattri_dac.da_args = args;
>> +
>> +	*attr = new;
>> +	return 0;
>> +}
>> +
>> +/* Sets an attribute for an inode as a deferred operation */
>> +int
>> +xfs_attr_set_deferred(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_attr_item	*new;
>> +	int			error = 0;
>> +
>> +	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
>> +	if (error)
>> +		return error;
>> +
>> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
>> +
>> +	return 0;
>> +}
> 
> The changes in "xfs: enable delayed attributes" should be moved to this
> patch so that these new functions immediately have callers.
Sure, will merge those patches together then

> 
> (Also see the reply I sent to the next patch, which will avoid weird
> regressions if someone's bisect lands in the middle of this series...)
> 
> --D
> 
>> +
>> +/* Removes an attribute for an inode as a deferred operation */
>> +int
>> +xfs_attr_remove_deferred(
>> +	struct xfs_da_args	*args)
>> +{
>> +
>> +	struct xfs_attr_item	*new;
>> +	int			error;
>> +
>> +	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
>> +	if (error)
>> +		return error;
>> +
>> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
>> +
>> +	return 0;
>> +}
>> +
>>   /*========================================================================
>>    * External routines when attribute list is inside the inode
>>    *========================================================================*/
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 5b4a1ca..8a08411 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -307,5 +307,7 @@ bool xfs_attr_namecheck(const void *name, size_t length);
>>   void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>>   			      struct xfs_da_args *args);
>>   int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>> +int xfs_attr_set_deferred(struct xfs_da_args *args);
>> +int xfs_attr_remove_deferred(struct xfs_da_args *args);
>>   
>>   #endif	/* __XFS_ATTR_H__ */
>> -- 
>> 2.7.4
>>
