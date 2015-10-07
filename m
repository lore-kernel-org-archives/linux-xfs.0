Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B5AFD7F37
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 16:31:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A68228F8049
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 14:31:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UrkWeyfeSDL0rEkQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2015 14:31:37 -0700 (PDT)
Subject: Re: [PATCH] xfs: avoid null *src in memcpy call in xlog_write
References: <56154967.70100@redhat.com> <20151007212422.GS27164@dastard>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <56158F37.9030108@redhat.com>
Date: Wed, 7 Oct 2015 16:31:35 -0500
MIME-Version: 1.0
In-Reply-To: <20151007212422.GS27164@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10/7/15 4:24 PM, Dave Chinner wrote:
> On Wed, Oct 07, 2015 at 11:33:43AM -0500, Eric Sandeen wrote:
>> The gcc undefined behavior sanitizer caught this; surely
>> any sane memcpy implementation will no-op if size == 0,
>> but behavior with a *src of NULL is technically undefined
>> (declared nonnull), so avoid it here.
>>
>> We are actually in this situation frequently via
>> xlog_commit_record(), because:
>>
>>         struct xfs_log_iovec reg = {
>>                 .i_addr = NULL,
>>                 .i_len = 0,
>>                 .i_type = XLOG_REG_TYPE_COMMIT,
>>         };
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index 4012523..8897fd1 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -2424,7 +2424,10 @@ xlog_write(
>>  
>>  			/* copy region */
>>  			ASSERT(copy_len >= 0);
>> -			memcpy(ptr, reg->i_addr + copy_off, copy_len);
>> +			ASSERT(reg->i_addr + copy_off > 0 || copy_len == 0);
>> +			/* size == 0 is ok, but *src == NULL is undefined */
>> +			if (reg->i_addr + copy_off)
>> +				memcpy(ptr, reg->i_addr + copy_off, copy_len);
>>  			xlog_write_adv_cnt(&ptr, &len, &log_offset, copy_len);
> 
> The comment doesn't explain anything about why copylen might be zero
> or reg->i_addr might be null.  If copylen is zero, we should really
> skip the copy, not rely on some magic pointer arithmetic to tell us
> it's ok to copy...
> 
> 			/*
> 			 * Copy region.
> 			 *
> 			 * Unmount records just log an opheader, so can have
> 			 * empty payloads with no data region to copy. Hence we only
> 			 * copy the payload if the vector says it has data to copy.
> 			 */
> 			ASSERT(copy_len >= 0);
> 			if (copy_len > 0) {
> 				memcpy(ptr, reg->i_addr + copy_off, copy_len);
> 				xlog_write_adv_cnt(&ptr, &len, &log_offset, copy_len);
> 			}

Yeah, I thought about that, why didn't I do it that way?  Maybe I was thinking
about *src still being NULL, but I guess in that case we'd find out that there's
a problem very quickly.

You may as well just commit that version w/ your S-O-B and my Reported-by.

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
