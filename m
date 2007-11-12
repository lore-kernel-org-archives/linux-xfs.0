Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 Nov 2007 16:08:37 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAC08Ro0029596
	for <xfs@oss.sgi.com>; Sun, 11 Nov 2007 16:08:31 -0800
Message-ID: <473799A9.9000200@sgi.com>
Date: Mon, 12 Nov 2007 11:09:13 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [xfs-masters] [PATCH] fs/xfs: remove duplicated defines
References: <20071111134351.106efb98@lucky.kitzblitz> <473796EF.6050104@sandeen.net>
In-Reply-To: <473796EF.6050104@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, kernel-janitors@vger.kernel.org

Eric Sandeen wrote:
> Nicolas Kaiser wrote:
>> Remove duplicated defines.
>>
>> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
>> ---
> 
> Heh, each defined twice, but used 0 times in the kernel.  Could probably
> just remove them altogether (though I guess btoc is used in
> xfstests/ltp/doio.c in userspace/xfstests, but that's the *only* place)
> 
Yes, that's what I was just noticing - how they are not used anyway.

 > grep -Ir btoc . | egrep -v 'tag|anot'
./linux-2.6/xfs_linux.h:#define btoc(x)         (((__psunsigned_t)(x)+(NBPC-1))>>BPCSHIFT)
./linux-2.6/xfs_linux.h:#define btoct(x)        ((__psunsigned_t)(x)>>BPCSHIFT)
./linux-2.6/xfs_linux.h:#define btoc64(x)       (((__uint64_t)(x)+(NBPC-1))>>BPCSHIFT)
./linux-2.6/xfs_linux.h:#define btoct64(x)      ((__uint64_t)(x)>>BPCSHIFT)
./linux-2.6/xfs_linux.h:#define btoct(x)        ((__psunsigned_t)(x)>>BPCSHIFT)
./linux-2.6/xfs_linux.h:#define btoc(x)         (((__psunsigned_t)(x)+(NBPC-1))>>BPCSHIFT)
./linux-2.6/xfs_buf.c:  page_count = xfs_buf_btoc(end) - xfs_buf_btoct(bp->b_file_offset);
./linux-2.6/xfs_buf.c:          page = bp->b_pages[xfs_buf_btoct(boff + bp->b_offset)];
./linux-2.6/xfs_buf.h:#define xfs_buf_btoc(dd)  (((dd) + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT)
./linux-2.6/xfs_buf.h:#define xfs_buf_btoct(dd) ((dd) >> PAGE_CACHE_SHIFT)

--Tim

> -Eric
> 
>>  fs/xfs/linux-2.6/xfs_linux.h |    4 ----
>>  1 file changed, 4 deletions(-)
>>
>> --- a/fs/xfs/linux-2.6/xfs_linux.h	2007-11-07 11:26:20.000000000 +0100
>> +++ b/fs/xfs/linux-2.6/xfs_linux.h	2007-11-11 13:07:11.000000000 +0100
>> @@ -167,12 +167,8 @@
>>  
>>  /* clicks to bytes */
>>  #define	ctob(x)		((__psunsigned_t)(x)<<BPCSHIFT)
>> -#define btoct(x)        ((__psunsigned_t)(x)>>BPCSHIFT)
>>  #define	ctob64(x)	((__uint64_t)(x)<<BPCSHIFT)
>>  
>> -/* bytes to clicks */
>> -#define btoc(x)         (((__psunsigned_t)(x)+(NBPC-1))>>BPCSHIFT)
>> -
>>  #define ENOATTR		ENODATA		/* Attribute not found */
>>  #define EWRONGFS	EINVAL		/* Mount with wrong filesystem type */
>>  #define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
>>
>>
> 
