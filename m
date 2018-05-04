Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54598 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751611AbeEDWgT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 May 2018 18:36:19 -0400
Subject: Re: [PATCH 6/5] xfs: make several functions void
References: <f5d059e3-28de-e365-acd4-d82aa9d17db7@redhat.com>
 <9d126a83-c4ef-00a2-dbb6-510e2c41de73@sandeen.net>
 <df47c5e1-0e77-55d6-eb52-8e694946c9cb@sandeen.net>
 <20180504222949.GV26569@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <db24915d-ed96-8fe5-602b-1567762cf3f9@sandeen.net>
Date: Fri, 4 May 2018 17:36:17 -0500
MIME-Version: 1.0
In-Reply-To: <20180504222949.GV26569@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 5/4/18 5:29 PM, Darrick J. Wong wrote:
>> Subject: [PATCH 6/5] xfs: make several functions void
> 
> Usual patch cramming practice is to make this a reply to the cover
> letter, not 5/5.

Yup I noticed that when it hit my inbox, my bad.

> Also, "make several functions return void"?

sure.  "making them void" could be interpreted as vulgar.  ;)

...

>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index 2135b8e67dcc..73f2c1ae2dcf 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -59,7 +59,7 @@
>>   */
>>  STATIC int xfs_attr3_leaf_create(struct xfs_da_args *args,
>>  				 xfs_dablk_t which_block, struct xfs_buf **bpp);
>> -STATIC int xfs_attr3_leaf_add_work(struct xfs_buf *leaf_buffer,
>> +STATIC void xfs_attr3_leaf_add_work(struct xfs_buf *leaf_buffer,
> 
> /me hates to be a PITA, but some of these functions ASSERT on on-disk
> metadata checks that fail.  Sometimes the checks are for things that are
> already caught by the verifiers & so therefore ensure we haven't
> corrupted in-core state, but others could very well be things that
> should be turned into -EFSCORRUPTED return.
> 
> How about splitting these up and only do a few functions (or a single
> file) at a time?  (And ideally after I land the series that starts the
> conversion of ASSERT-on-disk-corruption to EFSCORRUPTED-return that's
> also out for review...)

Sure, fine by me, or maybe I'll just hit all the bog-simple ones and leave
the rest, for now.

Thanks,
-Eric
