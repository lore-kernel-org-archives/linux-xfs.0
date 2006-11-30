Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Nov 2006 23:43:58 -0800 (PST)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAU7hoaG032381
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 23:43:51 -0800
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kAU7h0BK025892
	for <xfs@oss.sgi.com>; Thu, 30 Nov 2006 16:43:00 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.195])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kAU7bgG3018743
	for <xfs@oss.sgi.com>; Thu, 30 Nov 2006 16:37:42 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id kAU7bgZ18148 for xfs@oss.sgi.com; Thu, 30 Nov 2006 16:37:42 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv4.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id kAU7bgr02578 for <xfs@oss.sgi.com>; Thu, 30 Nov 2006 16:37:42 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20061130.164305.42102236 for <xfs@oss.sgi.com>
	; Thu, 30 Nov 2006 16:43:05 +0900
Received: from rifu.bsd.tnes.nec.co.jp (rifu.bsd.tnes.nec.co.jp [10.1.104.1])
	by tnessv1.tnes.nec.co.jp (Postfix) with ESMTP id 3946CAE4B0
	for <xfs@oss.sgi.com>; Thu, 30 Nov 2006 16:31:45 +0900 (JST)
Received: from TNESG9305.tnes.nec.co.jp (TNESG9305.bsd.tnes.nec.co.jp [10.1.104.199])
	by rifu.bsd.tnes.nec.co.jp (8.12.11/3.7W/BSD-TNES-MX01) with SMTP id kAU7bfEe010053
	for <xfs@oss.sgi.com>; Thu, 30 Nov 2006 16:37:41 +0900
Message-Id: <200611300737.AA04758@TNESG9305.tnes.nec.co.jp>
Date: Thu, 30 Nov 2006 16:37:39 +0900
Subject: Re: [PATCH 1/2]segmentation fault in xfs_io mread/mwrite command
From: Utako Kusaka <utako@tnes.nec.co.jp>
In-Reply-To: <1164838961.4992.29.camel@edge>
References: <1164838961.4992.29.camel@edge>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Thanks for your response.
This is my test case.

$ ./xfs_io -f mmap -c "pwrite 0 16384" -c "mmap 4096 4096" -c "mread -r"
wrote 16384/16384 bytes at offset 0
16 KiB, 4 ops; 0.0000 sec (625 MiB/sec and 160000.0000 ops/sec)
Segmentation fault

$ cat /etc/SuSE-release
SUSE LINUX 10.0 (X86-64)
VERSION = 10.0

Thu, 30 Nov 2006 09:22:41 +1100 Nathan Scott wrote：
>On Wed, 2006-11-29 at 09:26 +0900, Utako Kusaka wrote:
>> Hi,
>> 
>> I found the following issues in xfs_io.
>>  mread command:
>>   a) Causes a segmentation fault.
>>      Because "length"+1 bytes data is copied to buffer in read_mapping(),
>>      but buffer size is "length".
>>   b) Reads from wrong offset.
>>   c) The first byte of dump data is incorrect when length > page size.
>>  mwrite command:
>>   d) Data placement is incorrect when -r option is specified
>>      because of wrong for-loop counter.
>> 
>> This patch fixes them.
>> 
>
>Looks OK - could you send explicit test cases that demonstrate each
>problem please?  (i.e. actual xfs_io invocations).  Particularly the
>segfault should be easy to show, something like:
>xfs_io -f -c 'mmap ...' -c 'mread ...' /tmp/foo)
>
>That way they can be added to the regression test suite to ensure these
>things don't spontaneously break themselves in the future.
>
>thanks!
>
>-- 
>Nathan
