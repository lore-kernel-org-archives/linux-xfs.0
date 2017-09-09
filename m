Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:38354 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757173AbdIIBPX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2017 21:15:23 -0400
Received: by mail-pf0-f195.google.com with SMTP id q76so2164382pfq.5
        for <linux-xfs@vger.kernel.org>; Fri, 08 Sep 2017 18:15:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7c353810-d8be-51c4-d2a8-9e0833eaf01c@sandeen.net>
References: <20170908233616.26051-1-raj.khem@gmail.com> <7c353810-d8be-51c4-d2a8-9e0833eaf01c@sandeen.net>
From: Khem Raj <raj.khem@gmail.com>
Date: Fri, 8 Sep 2017 18:14:51 -0700
Message-ID: <CAMKF1spJSfBKvuC+agA8j1tDO4nb7d+d0Dq1wNZctUVEZPOTgA@mail.gmail.com>
Subject: Re: [PATCH] define __ prefixed version of intXY_t types
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Fri, Sep 8, 2017 at 5:50 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 9/8/17 6:36 PM, Khem Raj wrote:
>> This is required since musl does not define them
>> unlike glibc
>>
>> Signed-off-by: Khem Raj <raj.khem@gmail.com>
>> ---
>>  include/linux.h | 29 +++++++++++++++++++++++++++++
>>  1 file changed, 29 insertions(+)
>>
>> diff --git a/include/linux.h b/include/linux.h
>> index 9611a37f..1f6319c6 100644
>> --- a/include/linux.h
>> +++ b/include/linux.h
>> @@ -40,6 +40,35 @@
>>  # undef fsxattr
>>  #endif
>>
>> +#ifndef loff_t
>> +#define loff_t off_t
>
> I think you should just switch to off64_t in io/copy_file_range.c,
> the only user of loff_t.

OK. I was just following the darwin.h lead but I will make this change in v2

>
> None of the following double-underscore types are present in
> xfsprogs since this commit:

I think it was not a complete commit. I still see issues. I will see if
I can fix them

>
> commit 14f8b6810bd240cc58131483790a099fcf56c073
> Author: Darrick J. Wong <darrick.wong@oracle.com>
> Date:   Fri Aug 4 16:33:51 2017 -0500
>
>     xfsprogs: remove double-underscore integer types
>
>     This is a purely mechanical patch that removes the private
>     __{u,}int{8,16,32,64}_t typedefs in favor of using the system
>     {u,}int{8,16,32,64}_t typedefs.  This is the sed script used to perform
>     the transformation and fix the resulting whitespace and indentation
>     errors:
>
>     s/typedef\t__uint8_t/typedef __uint8_t\t/g
>     s/typedef\t__uint/typedef __uint/g
>     s/typedef\t__int\([0-9]*\)_t/typedef int\1_t\t/g
>     s/__uint8_t\t/__uint8_t\t\t/g
>     s/__uint/uint/g
>     s/__int\([0-9]*\)_t\t/__int\1_t\t\t/g
>     s/__int/int/g
>     /^typedef.*int[0-9]*_t;$/d
>
>     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>     Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
>     [sandeen: fix whitespace incidentals]
>     Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>     Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>
> currently on the for-next branch of xfsprogs.  You might want to
> carry that patch until 4.13 is released.
>
> (and 4a492e7 xfs: remove double-underscore integer types as well)
>
> -Eric
>
>> +#endif
>> +#ifndef __uint8_t
>> +#define __uint8_t uint8_t
>> +#endif
>> +#ifndef __uint16_t
>> +#define __uint16_t uint16_t
>> +#endif
>> +#ifndef __uint32_t
>> +#define __uint32_t uint32_t
>> +#endif
>> +#ifndef __uint64_t
>> +#define __uint64_t uint64_t
>> +#endif
>> +
>> +#ifndef __int8_t
>> +#define __int8_t int8_t
>> +#endif
>> +#ifndef __int16_t
>> +#define __int16_t int16_t
>> +#endif
>> +#ifndef __int32_t
>> +#define __int32_t int32_t
>> +#endif
>> +#ifndef __int64_t
>> +#define __int64_t int64_t
>> +#endif
>> +
>>  static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
>>  {
>>       return ioctl(fd, cmd, p);
>>
