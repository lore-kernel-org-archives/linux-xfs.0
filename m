Return-Path: <SRS0=EAe2=4B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44941C352A3
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 23:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 140DE2187F
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 23:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbgBMX5U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 18:57:20 -0500
Received: from sandeen.net ([63.231.237.45]:40838 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727571AbgBMX5U (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Feb 2020 18:57:20 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id EF8E92B25;
        Thu, 13 Feb 2020 17:57:11 -0600 (CST)
Subject: Re: [PATCH, RFC] libxfs: use FALLOC_FL_ZERO_RANGE in
 libxfs_device_zero
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <4bc3be27-b09d-a708-f053-6f7240642667@sandeen.net>
 <20200213234818.GV10776@dread.disaster.area>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <15f9a679-c83e-fede-25fe-2f2cdf940d86@sandeen.net>
Date:   Thu, 13 Feb 2020 17:57:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200213234818.GV10776@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/13/20 5:48 PM, Dave Chinner wrote:
> On Thu, Feb 13, 2020 at 03:12:24PM -0600, Eric Sandeen wrote:
>> I had a request from someone who cared about mkfs speed(!)
>> over a slower network block device to look into using faster
>> zeroing methods, particularly for the log, during mkfs.xfs.
>>
>> e2fsprogs already does this, thanks to some guy named Darrick:
>>
>> /*
>>  * If we know about ZERO_RANGE, try that before we try PUNCH_HOLE because
>>  * ZERO_RANGE doesn't unmap preallocated blocks.  We prefer fallocate because
>>  * it always invalidates page cache, and libext2fs requires that reads after
>>  * ZERO_RANGE return zeroes.
>>  */
>> static int __unix_zeroout(int fd, off_t offset, off_t len)
>> {
>>         int ret = -1;
>>
>> #if defined(HAVE_FALLOCATE) && defined(FALLOC_FL_ZERO_RANGE)
>>         ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, offset, len);
>>         if (ret == 0)
>>                 return 0;
>> #endif
>> #if defined(HAVE_FALLOCATE) && defined(FALLOC_FL_PUNCH_HOLE) && defined(FALLOC_FL_KEEP_SIZE)
>>         ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
>>                         offset,  len);
>>         if (ret == 0)
>>                 return 0;
>> #endif
>>         errno = EOPNOTSUPP;
>>         return ret;
>> }
>>
>> and nobody has exploded so far, AFAIK.  :)  So, floating this idea
>> for xfsprogs.  I'm a little scared of the second #ifdef block above, but
>> if that's really ok/consistent/safe we could add it too.
> 
> If FALLOC_FL_PUNCH_HOLE is defined, then FALLOC_FL_KEEP_SIZE is
> guaranteed to be defined, so that condition check is somewhat
> redundant. See commit 79124f18b335 ("fs: add hole punching to
> fallocate")....

Style aside, is that 2nd zeroing method something we want to try?

>> The patch moves some defines around too, I could split that up and resend
>> if this isn't laughed out of the room.
>>
>> Thanks,
>> -Eric
>>
>> =====
>>
>> libxfs: use FALLOC_FL_ZERO_RANGE in libxfs_device_zero
>>
>> I had a request from someone who cared about mkfs speed(!)
>> over a slower network block device to look into using faster
>> zeroing methods, particularly for the log, during mkfs.
>>
>> Using FALLOC_FL_ZERO_RANGE is faster in this case than writing
>> a bunch of zeros across a wire.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/include/linux.h b/include/linux.h
>> index 8f3c32b0..425badb5 100644
>> --- a/include/linux.h
>> +++ b/include/linux.h
>> @@ -113,6 +113,26 @@ static __inline__ void platform_uuid_copy(uuid_t *dst, uuid_t *src)
>>  	uuid_copy(*dst, *src);
>>  }
>>  
>> +#ifndef FALLOC_FL_PUNCH_HOLE
>> +#define FALLOC_FL_PUNCH_HOLE	0x02
>> +#endif
>> +
>> +#ifndef FALLOC_FL_COLLAPSE_RANGE
>> +#define FALLOC_FL_COLLAPSE_RANGE 0x08
>> +#endif
>> +
>> +#ifndef FALLOC_FL_ZERO_RANGE
>> +#define FALLOC_FL_ZERO_RANGE 0x10
>> +#endif
>> +
>> +#ifndef FALLOC_FL_INSERT_RANGE
>> +#define FALLOC_FL_INSERT_RANGE 0x20
>> +#endif
>> +
>> +#ifndef FALLOC_FL_UNSHARE_RANGE
>> +#define FALLOC_FL_UNSHARE_RANGE 0x40
>> +#endif
> 
> These were added to allow xfs_io to test these operations before
> there was userspace support for them. I do not think we should
> propagate them outside of xfs_io - if they are not supported by the
> distro at build time, we shouldn't attempt to use them in mkfs.
> 
> i.e. xfs_io is test-enablement code for developers, mkfs.xfs is
> production code for users, so different rules kinda exist for
> them...

Fair enough.  people /could/ use newer xfsprogs on older kernels, but...
those defines are getting pretty old by now in any case.

It's probably not terrible to just fail the build on a system that doesn't
have falloc.h, by now?

>> diff --git a/libxfs/Makefile b/libxfs/Makefile
>> index fbcc963a..b4e8864b 100644
>> --- a/libxfs/Makefile
>> +++ b/libxfs/Makefile
>> @@ -105,6 +105,10 @@ CFILES = cache.c \
>>  #
>>  #LCFLAGS +=
>>  
>> +ifeq ($(HAVE_FALLOCATE),yes)
>> +LCFLAGS += -DHAVE_FALLOCATE
>> +endif
> 
> HAVE_FALLOCATE comes from an autoconf test. I suspect that this
> needs to be made more finegrained, testing for fallocate() features,
> not just just whether the syscall exists. And the above should
> probably be in include/builddefs.in so that it's available to all
> of xfsprogs, not just libxfs code...

But that's testing the kernel on the build host, right?  What's the
point of that?  Or am I misunderstanding?

>> +
>>  FCFLAGS = -I.
>>  
>>  LTLIBS = $(LIBPTHREAD) $(LIBRT)
>> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
>> index 0d9d7202..94f63bbf 100644
>> --- a/libxfs/rdwr.c
>> +++ b/libxfs/rdwr.c
>> @@ -4,6 +4,9 @@
>>   * All Rights Reserved.
>>   */
>>  
>> +#if defined(HAVE_FALLOCATE)
>> +#include <linux/falloc.h>
>> +#endif
> 
> Urk. That should be in include/linux.h, right?
> 
>>  
>>  #include "libxfs_priv.h"
>>  #include "init.h"
>> @@ -60,9 +63,21 @@ int
>>  libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
>>  {
>>  	xfs_off_t	start_offset, end_offset, offset;
>> -	ssize_t		zsize, bytes;
>> +	ssize_t		zsize, bytes, len_bytes;
>>  	char		*z;
>> -	int		fd;
>> +	int		ret, fd;
>> +
>> +	fd = libxfs_device_to_fd(btp->dev);
>> +	start_offset = LIBXFS_BBTOOFF64(start);
>> +	end_offset = LIBXFS_BBTOOFF64(start + len) - start_offset;
>> +
>> +#if defined(HAVE_FALLOCATE)
>> +	/* try to use special zeroing methods, fall back to writes if needed */
>> +	len_bytes = LIBXFS_BBTOOFF64(len);
>> +	ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start_offset, len_bytes);
>> +	if (ret == 0)
>> +		return 0;
>> +#endif
> 
> I kinda dislike the "return if success" hidden inside the ifdef -
> it's not a code pattern I'd expect to see. This is what I'd tend
> to expect in include/linux.h:
> 
> #if defined(HAVE_FALLOCATE_ZERO_RANGE)
> static inline int
> platform_zero_range(
> 	int		fd,
> 	xfs_off_t	start_offset,
> 	xfs_off_t	end_offset)
> {
> 	int		ret;
> 
> 	ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start_offset, len_bytes);
> 	if (!ret)
> 		return 0;
> 	return -errno;
> }
> #else
> #define platform_zero_range(fd, s, o)	(true)
> #endif
> 
> and then the code in libxfs_device_zero() does:
> 
> 	error = platform_zero_range(fd, start_offset, len_bytes);
> 	if (!error)
> 		return 0;
> 
> without adding nasty #defines...

Yeah that's much better.  Tho I hate adding more platform_* stuff when really
we're down to only one platform but maybe that's a project for another day.

Thanks for the review,
-Eric
