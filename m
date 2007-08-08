Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Aug 2007 22:47:18 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l785lBbm009371
	for <xfs@oss.sgi.com>; Tue, 7 Aug 2007 22:47:12 -0700
Message-ID: <37268.192.168.3.1.1186552049.squirrel@mail.aconex.com>
In-Reply-To: 
     <D59801BCA402F5418C040937230AF7E00B9A8E@mtv-amer002e--3.americas.sgi.c
     om>
References: 
    <D59801BCA402F5418C040937230AF7E00B9A8E@mtv-amer002e--3.americas.sgi.com>
Date: Wed, 8 Aug 2007 15:47:29 +1000 (EST)
Subject: RE: qa 166 failure on f8 kernel
From: nscott@aconex.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alex Elder <aelder@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

>> From: xfs-bounce@oss.sgi.com
>> [mailto:xfs-bounce@oss.sgi.com]On Behalf Of
>> David Chinner
>> Sent: Tuesday, August 07, 2007 9:56 PM
>> To: Eric Sandeen
>> Cc: xfs-oss
>> Subject: Re: qa 166 failure on f8 kernel
> ...
>> mmap dirties entire pages. page size differs between platforms -
>> ia64 = 16k, x86 = 4k - so the size of the extent allocated is
>> different. Guess what platform I wrote the test on and use as my
>> primary platform?
>>
>> The output needs better filtering, methinks.
>
> Could the test be changed so the output is pagesize independent
> rather than filtering the output?  Or maybe the test should
> use a buffer size that's the LCM of all supported page sizes.
>

FWIW, xfs-cmds/xfstests/src/feature.c will tell you the page size (-s);
with that you can accurately filter the output and not lose any info.

cheers.

--
Nathan
