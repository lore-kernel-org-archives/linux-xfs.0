Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.148.204]:23407 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726640AbfDLCpa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Apr 2019 22:45:30 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 00228615D3
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 20:57:19 -0500 (CDT)
Subject: Re: [PATCH] xfs: use struct_size() helper
References: <20190411233758.GA19031@embeddedor>
 <20190412001941.GV15524@magnolia>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <51407603-d144-ece9-6cd5-edea72374527@embeddedor.com>
Date: Thu, 11 Apr 2019 20:57:14 -0500
MIME-Version: 1.0
In-Reply-To: <20190412001941.GV15524@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org



On 4/11/19 7:19 PM, Darrick J. Wong wrote:
> [fixing linux-xfs cc]
> 

Thanks for this.

> On Thu, Apr 11, 2019 at 06:37:58PM -0500, Gustavo A. R. Silva wrote:
>> Make use of the struct_size() helper instead of an open-coded  version
>> in order to avoid any potential type mistakes, in particular in the
>> context in which this code is being used.
>>
>> So, replace code of the following form:
>>
>> sizeof(*alist) + context->count * sizeof(alist->al_offset[0]
>>
>> with:
>>
>> struct_size(alist, al_offset, context->count)
>>
>> and remove unnecessary variable arraytop.
>>
>> This code was detected with the help of Coccinelle.
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> 
> Has this been run through xfstests?
> 

No.  Is this a requirement?

Thanks
--
Gustavo

> --D
> 
>>  fs/xfs/xfs_attr_list.c | 5 +----
>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
>> index 3d213a7394c5..05e03348553e 100644
>> --- a/fs/xfs/xfs_attr_list.c
>> +++ b/fs/xfs/xfs_attr_list.c
>> @@ -553,7 +553,6 @@ xfs_attr_put_listent(
>>  {
>>  	struct attrlist *alist = (struct attrlist *)context->alist;
>>  	attrlist_ent_t *aep;
>> -	int arraytop;
>>  
>>  	ASSERT(!context->seen_enough);
>>  	ASSERT(!(context->flags & ATTR_KERNOVAL));
>> @@ -572,10 +571,8 @@ xfs_attr_put_listent(
>>  	    ((flags & XFS_ATTR_ROOT) == 0))
>>  		return;
>>  
>> -	arraytop = sizeof(*alist) +
>> -			context->count * sizeof(alist->al_offset[0]);
>>  	context->firstu -= ATTR_ENTSIZE(namelen);
>> -	if (context->firstu < arraytop) {
>> +	if (context->firstu < struct_size(alist, al_offset, context->count)) {
>>  		trace_xfs_attr_list_full(context);
>>  		alist->al_more = 1;
>>  		context->seen_enough = 1;
>> -- 
>> 2.21.0
>>
