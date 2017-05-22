Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48990 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751644AbdEVTkh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 May 2017 15:40:37 -0400
Subject: Re: [PATCH] xfs: fix unaligned access in xfs_btree_visit_blocks
References: <105ed603-971a-e7db-6040-b85e5eecd928@redhat.com>
 <20170522190710.GB17100@infradead.org>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <3a07e882-3ae8-c12c-fac6-9e31a6a96041@redhat.com>
Date: Mon, 22 May 2017 14:40:26 -0500
MIME-Version: 1.0
In-Reply-To: <20170522190710.GB17100@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 5/22/17 2:07 PM, Christoph Hellwig wrote:
> On Mon, May 22, 2017 at 10:48:14AM -0500, Eric Sandeen wrote:
>> This was throwing unaligned access warnings on sparc64:
>>
>> Kernel unaligned access at TPC[1043c088] xfs_btree_visit_blocks+0x88/0xe0 [xfs]
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
>> index 5392674..84089f8 100644
>> --- a/fs/xfs/libxfs/xfs_btree.c
>> +++ b/fs/xfs/libxfs/xfs_btree.c
>> @@ -4395,7 +4395,7 @@ struct xfs_btree_split_args {
>>  			xfs_btree_readahead_ptr(cur, ptr, 1);
>>  
>>  			/* save for the next iteration of the loop */
>> -			lptr = *ptr;
>> +			lptr = get_unaligned(ptr);
> 
> Hm..  We don't really do this for the return value of of xfs_btree_ptr_addr
> anywhere else.  So if it really returns something not suitably enough
> aligned we're in much deeper trouble. 

Yeah, I took a quick look, probably too quick.  But I think the problem
here is that it's a structure copy, which is unusual compared to most of
the other callers:


        union xfs_btree_ptr             lptr;

                        lptr = *ptr;

and is probably what's generating the warning, right?  I guess a better
comment and/or commit log would be in order.

I haven't looked at every other caller but several end up calling 
xfs_btree_copy_ptrs which does a memcpy.

Hm, ok, maybe we should just be using that helper...

xfs_btree_copy_ptrs(cur, &lptr, ptr, 1);

?

-Eric


