Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 25A8C7F37
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 17:58:28 -0500 (CDT)
Message-ID: <55DE4492.90105@sgi.com>
Date: Wed, 26 Aug 2015 17:58:26 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V3] xfsdump: prevent segfault in cb_add_inogrp
References: <20150924193241.975348815@gulag1.americas.sgi.com>
	<77EDF3BA.60409@sgi.com> <20150826225601.GG3902@dastard>
In-Reply-To: <20150826225601.GG3902@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/26/2015 05:56 PM, Dave Chinner wrote:
> On Wed, Aug 26, 2015 at 05:29:55PM -0500, rjohnston@sgi.com wrote:
>>
>> The call to memset will segfault because the offset for the first
>> parameter is done twice. We are using pointer math to do the
>> calculation.
>>
>> The first time is when calculating oldsize, the size of i2gseg_t
>> is accounted for.
>> 	oldsize = (numsegs - SEGPERHNK) * sizeof(i2gseg_t);
>> Then in the call to memset, oldsize is again multiplied by the size
>> of i2gmap_t.
>> 	memset(inomap.i2gmap + oldsize, ...)
>> 	
>> i2gmap holds the used inodes in each chunk. When there are 2^31 chunk
>> entries, it could describe 2^31 (1 inode/chunk)- 2^40 (64 inodes/chunk).
>>
>> With 100s of millions of inodes there are enough entries to wrap the
>> 32 bit variable oldsize.
>>
>> Adding a bounds check (numsegs < 0) and switching to use array
>> index notation instead of calculating the pointer address twice
>> would resolve this issue. The unneeded local variable oldsize
>> can be removed as well.
>
> Can't believe I missed this first two times time through - the patch
> is missing your signed-off-by. Just reply with it, and I'll fix it
> up on commit. :)
Dooh my bad

Signed-off-by: Rich Johnston <rjohnston@sgi.com>
>
> Thanks, Rich!
>
> Cheers,
>
> Dave.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
