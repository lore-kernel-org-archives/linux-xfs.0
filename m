Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46266 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751556AbdCTEeP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Mar 2017 00:34:15 -0400
Subject: Re: [PATCH][PROGS] xfs_io: Allow setting multiple mode flags for
 fallocate()
References: <c2fdfcbb1f4ac9a71633dfbe192ed1145b12b8ac.1489799604.git.calvinowens@fb.com>
 <20170318065554.GX17542@dastard>
From: Calvin Owens <calvinowens@fb.com>
Message-ID: <8dc5334b-a7b9-d455-25b5-5d651a3b918d@fb.com>
Date: Sun, 19 Mar 2017 21:33:50 -0700
MIME-Version: 1.0
In-Reply-To: <20170318065554.GX17542@dastard>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, kernel-team@fb.com, calvinowens <calvinowens@fb.com>

On 03/17/2017 11:55 PM, Dave Chinner wrote:
> On Fri, Mar 17, 2017 at 06:26:09PM -0700, Calvin Owens wrote:
>> This allows testing FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE.
>
> Which is normally done through the "fpunch" command, which explains
> why nobody has noticed this.

Ah okay, I was assuming parity with syscalls in the commands and picked
the first one I saw ;)

>> Signed-off-by: Calvin Owens <calvinowens@fb.com>
>> ---
>>  io/prealloc.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/io/prealloc.c b/io/prealloc.c
>> index a9d66cc..2a4bcdc 100644
>> --- a/io/prealloc.c
>> +++ b/io/prealloc.c
>> @@ -201,19 +201,19 @@ fallocate_f(
>>  	while ((c = getopt(argc, argv, "cikpu")) != EOF) {
>>  		switch (c) {
>>  		case 'c':
>> -			mode = FALLOC_FL_COLLAPSE_RANGE;
>> +			mode |= FALLOC_FL_COLLAPSE_RANGE;
>>  			break;
>>  		case 'i':
>> -			mode = FALLOC_FL_INSERT_RANGE;
>> +			mode |= FALLOC_FL_INSERT_RANGE;
>>  			break;
>>  		case 'k':
>> -			mode = FALLOC_FL_KEEP_SIZE;
>> +			mode |= FALLOC_FL_KEEP_SIZE;
>>  			break;
>>  		case 'p':
>> -			mode = FALLOC_FL_PUNCH_HOLE;
>> +			mode |= FALLOC_FL_PUNCH_HOLE;
>>  			break;
>>  		case 'u':
>> -			mode = FALLOC_FL_UNSHARE_RANGE;
>> +			mode |= FALLOC_FL_UNSHARE_RANGE;
>>  			break;
>
> NACK. We should not allow users to set invalid combinations
> of commands such as 'falloc -cipu ...' - this would set the flags
> (FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE |
> FALLOC_FL_PUNCH_HOLE | FALLOC_FL_UNSHARE_RANGE) and will always
> error out.

Isn't it potentially useful to test invalid behavior?

> The use of FALLOC_FL_KEEP_SIZE for the FALLOC_FL_PUNCH_HOLE command
> is essentially for documentation purposes - it does not do
> truncation, hence the FALLOC_FL_KEEP_SIZE flag was added to it to
> ensure developers understand that it does not truncate the file and
> change EOF.
>
> IOWs, the fix needed to make the 'falloc -p' command work is really
> just this:
>
> -			mode = FALLOC_FL_PUNCH_HOLE;
> +			mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;

My thinking was just "allow full exercising of the syscall", fpunch works
for my testcase so if you'd prefer not to do that we can just drop this :)

It might be worth cleaning up 'falloc' though: '-k' doesn't really make
sense on its own right? Maybe remove "-k" and make "-p" OR in KEEP_SIZE
like you suggest?

Thanks,
Calvin

> Cheers,
>
> Dave.
>

