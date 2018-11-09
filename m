Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50410 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727210AbeKJJ2O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 10 Nov 2018 04:28:14 -0500
Subject: Re: [PATCH] Fix misspelling issue in fs/xfs/kmem.c
References: <20181109232301.19977-1-weizhefix@gmail.com>
 <20181109234056.GH15721@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <69b1d0d9-5a5b-e11d-4ebe-eb49b9ba2ef3@sandeen.net>
Date: Fri, 9 Nov 2018 17:45:21 -0600
MIME-Version: 1.0
In-Reply-To: <20181109234056.GH15721@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, hmsjwzb <weizhefix@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org



On 11/9/18 5:40 PM, Darrick J. Wong wrote:
> On Sat, Nov 10, 2018 at 07:23:01AM +0800, hmsjwzb wrote:
> 
> Sorry, but all submissions must have a Signed-off-by: to be reviewed.
> 
> Also, there's no To: header on this message??

Also, it's not the only misspelling, and not even the only instance of
"auxillary" in the xfs codebase ... generally we only fix up such things
when we're touching surrounding code for a more substantive change.

-Eric

> NAK.
> 
> --D
> 
>> ---
>>  fs/xfs/kmem.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
>> index fdd9d6ede25c..73ec1f84e591 100644
>> --- a/fs/xfs/kmem.c
>> +++ b/fs/xfs/kmem.c
>> @@ -45,7 +45,7 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
>>  		return ptr;
>>  
>>  	/*
>> -	 * __vmalloc() will allocate data pages and auxillary structures (e.g.
>> +	 * __vmalloc() will allocate data pages and auxiliary structures (e.g.
>>  	 * pagetables) with GFP_KERNEL, yet we may be under GFP_NOFS context
>>  	 * here. Hence we need to tell memory reclaim that we are in such a
>>  	 * context via PF_MEMALLOC_NOFS to prevent memory reclaim re-entering
>> -- 
>> 2.17.1
>>
> 
