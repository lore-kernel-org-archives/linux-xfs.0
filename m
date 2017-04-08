Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45108 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751934AbdDHOl4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 8 Apr 2017 10:41:56 -0400
Subject: Re: [PATCH] libxfs: fix xfs_extent_busy_flush macro definition
References: <20170408025255.GP4864@birch.djwong.org>
 <585a3bce-22f8-e162-87a7-bfa6e57ffad5@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8860c7c7-4972-521c-44ec-c710136e2b49@sandeen.net>
Date: Sat, 8 Apr 2017 09:41:54 -0500
MIME-Version: 1.0
In-Reply-To: <585a3bce-22f8-e162-87a7-bfa6e57ffad5@sandeen.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 4/8/17 9:26 AM, Eric Sandeen wrote:
> On 4/7/17 9:52 PM, Darrick J. Wong wrote:
>> xfs_extent_busy_flush is a void function, so don't reduce it to zero.
>> This shuts up gcc warnings about do-nothing statements.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Whoops, thanks.  Need to test w/ newer gcc I guess, sorry!
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Oh, actually it seems that we use ((void) 0) pretty consistently
for these, i.e. -

#define xfs_extent_busy_reuse(mp,ag,bno,len,user)       ((void) 0)

and many others.  Probably best to be consistent; I may "fix" it to
that on commit, ok?

-Eric

>> ---
>>  libxfs/libxfs_priv.h |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
>> index c2d4494..167786e 100644
>> --- a/libxfs/libxfs_priv.h
>> +++ b/libxfs/libxfs_priv.h
>> @@ -419,7 +419,7 @@ roundup_64(__uint64_t x, __uint32_t y)
>>  	*(busy_gen) = __foo;					\
>>  	false;							\
>>  })
>> -#define xfs_extent_busy_flush(mp,pag,busy_gen)		(0)
>> +#define xfs_extent_busy_flush(mp,pag,busy_gen)		do { } while(0)
>>  
>>  /* avoid unused variable warning */
>>  #define xfs_alloc_busy_insert(tp,ag,b,len)	({	\
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
