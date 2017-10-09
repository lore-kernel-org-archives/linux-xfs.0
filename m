Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52527 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754246AbdJIWvw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Oct 2017 18:51:52 -0400
Subject: Re: [PATCH v2 2/3] xfs_io: Add RWF_NOWAIT to pwritev2()
References: <20170929130035.24760-1-rgoldwyn@suse.de>
 <20170929130035.24760-2-rgoldwyn@suse.de> <20171009171953.GR7122@magnolia>
 <4e15ed18-b30c-1fb1-56ee-9bf5b0c6a73f@suse.de>
 <20171009223714.GS3666@dastard>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <dd6e45df-da8c-0b8c-cca7-76f937e6cf9d@suse.de>
Date: Mon, 9 Oct 2017 17:51:48 -0500
MIME-Version: 1.0
In-Reply-To: <20171009223714.GS3666@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org



On 10/09/2017 05:37 PM, Dave Chinner wrote:
> On Mon, Oct 09, 2017 at 04:11:17PM -0500, Goldwyn Rodrigues wrote:
>>
>>
>> On 10/09/2017 12:19 PM, Darrick J. Wong wrote:
>>> On Fri, Sep 29, 2017 at 08:00:34AM -0500, Goldwyn Rodrigues wrote:
>>>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>>>
>>>> This allows to make pwritev2() calls with RWF_NOWAIT,
>>>> which would fail in case the call blocks.
>>>>
>>>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>>> ---
>>>>  io/pwrite.c       | 8 +++++++-
>>>>  man/man8/xfs_io.8 | 6 ++++++
>>>>  2 files changed, 13 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/io/pwrite.c b/io/pwrite.c
>>>> index e7d411bb..2b85a528 100644
>>>> --- a/io/pwrite.c
>>>> +++ b/io/pwrite.c
>>>> @@ -52,6 +52,9 @@ pwrite_help(void)
>>>>  "         (heh, zorry, the -s/-S arguments were already in use in pwrite)\n"
>>>>  #ifdef HAVE_PWRITEV
>>>>  " -V N -- use vectored IO with N iovecs of blocksize each (pwritev)\n"
>>>> +#ifdef HAVE_PWRITEV2
>>>> +" -N   -- Perform the pwritev2() with RWF_NOWAIT\n"
>>>> +#endif
>>>
>>> Separate these two? i.e.
>>>
>>> #ifdef HAVE_PWRITEV
>>> " -V N..."
>>> #endif
>>> #ifdef HAVE_PWRITEV2
>>> " -N ..."
>>> #endif
>>>
>>> They're tested separately in configure, so the ifdefs needn't be nested.
>>>
>>>>  #endif
>>>>  "\n"));
>>>>  }
>>>> @@ -276,7 +279,7 @@ pwrite_f(
>>>>  	init_cvtnum(&fsblocksize, &fssectsize);
>>>>  	bsize = fsblocksize;
>>>>  
>>>> -	while ((c = getopt(argc, argv, "b:BCdf:Fi:qRs:S:uV:wWZ:")) != EOF) {
>>>> +	while ((c = getopt(argc, argv, "b:BCdf:Fi:NqRs:S:uV:wWZ:")) != EOF) {
>>>>  		switch (c) {
>>>>  		case 'b':
>>>>  			tmp = cvtnum(fsblocksize, fssectsize, optarg);
>>>> @@ -305,6 +308,9 @@ pwrite_f(
>>>>  		case 'i':
>>>>  			infile = optarg;
>>>>  			break;
>>>> +		case 'N':
>>>> +			pwritev2_flags |= RWF_NOWAIT;
>>>> +			break;
>>>
>>> Needs #ifdef HAVE_PWRITEV2.
>>>
>>> If you feel the need to be extra cautious, you could also put:
>>>
>>> #ifndef HAVE_PWRITEV2
>>> 	assert(pwritev2_flags == 0);
>>> #endif
>>>
>>> ...just after the getopt parsing to make sure that we never silently
>>> drop RWF_* flags due to code bugs.
>>>
>>
>> Instead I am planning to put an #else to #ifdef in the case 'N' to make
>> sure that people who do not have pwritev2() get the proper message
>> instead of the command failing without reason.
>>
>> +               case 'N':
>> +#ifdef HAVE_PWRITEV2
>> +                       pwritev2_flags |= RWF_NOWAIT;
>> +                       break;
>> +#else
>> +                       printf(_("-N: Kernel does not support
>> pwritev2()\n"));
>> +                       return 0;
>> +#endif
> 
> Why add support for a command only to say "command not supported"?
> The error message is also incorrect - the build environment didn't
> support pwritev2, not the kernel the xfs_io binary is currently
> running on.
> 
> As it is, I really don't like this sort of ifdef pattern because it
> means over time we'll end up with an ifdef mess in the option
> parsing as more flags are added. Just make the default case say
> "command -%c not supported", and that removes the need for any of
> these else cases.
> 

In that case, it would go to "default" which will print the
command_usage. I am fine with that as long as the user understands why
-N is not working.

-- 
Goldwyn
