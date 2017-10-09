Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42596 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755039AbdJIVLV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Oct 2017 17:11:21 -0400
Subject: Re: [PATCH v2 2/3] xfs_io: Add RWF_NOWAIT to pwritev2()
References: <20170929130035.24760-1-rgoldwyn@suse.de>
 <20170929130035.24760-2-rgoldwyn@suse.de> <20171009171953.GR7122@magnolia>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <4e15ed18-b30c-1fb1-56ee-9bf5b0c6a73f@suse.de>
Date: Mon, 9 Oct 2017 16:11:17 -0500
MIME-Version: 1.0
In-Reply-To: <20171009171953.GR7122@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, Goldwyn Rodrigues <rgoldwyn@suse.com>



On 10/09/2017 12:19 PM, Darrick J. Wong wrote:
> On Fri, Sep 29, 2017 at 08:00:34AM -0500, Goldwyn Rodrigues wrote:
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> This allows to make pwritev2() calls with RWF_NOWAIT,
>> which would fail in case the call blocks.
>>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> ---
>>  io/pwrite.c       | 8 +++++++-
>>  man/man8/xfs_io.8 | 6 ++++++
>>  2 files changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/io/pwrite.c b/io/pwrite.c
>> index e7d411bb..2b85a528 100644
>> --- a/io/pwrite.c
>> +++ b/io/pwrite.c
>> @@ -52,6 +52,9 @@ pwrite_help(void)
>>  "         (heh, zorry, the -s/-S arguments were already in use in pwrite)\n"
>>  #ifdef HAVE_PWRITEV
>>  " -V N -- use vectored IO with N iovecs of blocksize each (pwritev)\n"
>> +#ifdef HAVE_PWRITEV2
>> +" -N   -- Perform the pwritev2() with RWF_NOWAIT\n"
>> +#endif
> 
> Separate these two? i.e.
> 
> #ifdef HAVE_PWRITEV
> " -V N..."
> #endif
> #ifdef HAVE_PWRITEV2
> " -N ..."
> #endif
> 
> They're tested separately in configure, so the ifdefs needn't be nested.
> 
>>  #endif
>>  "\n"));
>>  }
>> @@ -276,7 +279,7 @@ pwrite_f(
>>  	init_cvtnum(&fsblocksize, &fssectsize);
>>  	bsize = fsblocksize;
>>  
>> -	while ((c = getopt(argc, argv, "b:BCdf:Fi:qRs:S:uV:wWZ:")) != EOF) {
>> +	while ((c = getopt(argc, argv, "b:BCdf:Fi:NqRs:S:uV:wWZ:")) != EOF) {
>>  		switch (c) {
>>  		case 'b':
>>  			tmp = cvtnum(fsblocksize, fssectsize, optarg);
>> @@ -305,6 +308,9 @@ pwrite_f(
>>  		case 'i':
>>  			infile = optarg;
>>  			break;
>> +		case 'N':
>> +			pwritev2_flags |= RWF_NOWAIT;
>> +			break;
> 
> Needs #ifdef HAVE_PWRITEV2.
> 
> If you feel the need to be extra cautious, you could also put:
> 
> #ifndef HAVE_PWRITEV2
> 	assert(pwritev2_flags == 0);
> #endif
> 
> ...just after the getopt parsing to make sure that we never silently
> drop RWF_* flags due to code bugs.
> 

Instead I am planning to put an #else to #ifdef in the case 'N' to make
sure that people who do not have pwritev2() get the proper message
instead of the command failing without reason.

+               case 'N':
+#ifdef HAVE_PWRITEV2
+                       pwritev2_flags |= RWF_NOWAIT;
+                       break;
+#else
+                       printf(_("-N: Kernel does not support
pwritev2()\n"));
+                       return 0;
+#endif



> --D
> 
>>  		case 's':
>>  			skip = cvtnum(fsblocksize, fssectsize, optarg);
>>  			if (skip < 0) {
>> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
>> index 0fd9b951..9c58914f 100644
>> --- a/man/man8/xfs_io.8
>> +++ b/man/man8/xfs_io.8
>> @@ -282,6 +282,12 @@ Use the vectored IO write syscall
>>  with a number of blocksize length iovecs. The number of iovecs is set by the
>>  .I vectors
>>  parameter.
>> +.TP
>> +.B \-N
>> +Perform the
>> +.BR pwritev2 (2)
>> +call with
>> +.I RWF_NOWAIT.
>>  .RE
>>  .PD
>>  .TP
>> -- 
>> 2.14.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Goldwyn
