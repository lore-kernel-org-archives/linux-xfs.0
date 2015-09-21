Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1BCD97F47
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 06:18:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D35E18F8035
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 04:18:06 -0700 (PDT)
Received: from mail.nomovok.com (mail.nomovok.com [83.150.122.238]) by
	cuda.sgi.com with ESMTP id DIblsqjWoYgxXPZU (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Sep 2015 04:18:04 -0700 (PDT)
Received: from [192.168.0.111]
	(host22-235-dynamic.248-95-r.retail.telecomitalia.it [95.248.235.22])
	by mail.nomovok.com (Postfix) with ESMTPSA id C4664AE031
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 14:18:02 +0300 (EEST)
Message-ID: <55FFE769.7090802@nomovok.com>
Date: Mon, 21 Sep 2015 13:18:01 +0200
From: Angelo Dureghello <angelo.dureghello@nomovok.com>
MIME-Version: 1.0
Subject: Re: xfstests, bad generic tests 009 and 308
References: <55FC3E0E.9060506@nomovok.com> <20150918224412.GE26895@dastard>
	<55FFE665.7040004@nomovok.com>
In-Reply-To: <55FFE665.7040004@nomovok.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Sry, in my previous mail please s/16M/16G.  Was a typo.

I am using an SD card with test partitions 8G and 16G.

Best regards
Angelo

On 21/09/2015 13:13, Angelo Dureghello wrote:
> Hi Dave,
>
> many thanks for the support. Sorry for the double mail, after
> first registering mails was not accepted, so i re-registered
> with a company mail.
>
>
> On 19/09/2015 00:44, Dave Chinner wrote:
>> On Fri, Sep 18, 2015 at 06:38:38PM +0200, Angelo Dureghello wrote:
>>> Hi all,
>>>
>>> working on arm (32bit arch), kernel 4.1.6.
>> Is this a new platform?
>>
>> Also, we need to know what compiler you are using, because we know
>> that certain versions of gcc miscompile XFS kernel code on arm
>> (4.6, 4.7 and certain versions of 4.8 are suspect) due to a
>> combination of compiler mis-optimisations and kernel bugs in the
>> arm 64 bit division asm implementation.
>>
>> As such, it would be worthwhile trying gcc-4.9 and a 4.3-rc1 kernel
>> to see if the problems still occur.
>
> I am using actually gcc-linaro-4.9-2015.05-x86_64_arm-linux-gnueabihf
>
>>> Looking to find the reason of some bad results on xfstests,
>>>
>>> -tests/generic/009
>>> ------------------
>>> i get several "all holes" messages
>>>
>>> generic/009    [  842.949643] run fstests generic/009 at 2015-09-18
>>> 15:29:36
>>>   - output mismatch (see
>>> /home/angelo/xfstests/results//generic/009.out.bad)
>>>      --- tests/generic/009.out    2015-09-17 10:54:06.689071257 +0000
>>>      +++ /home/angelo/xfstests/results//generic/009.out.bad
>>> 2015-09-18 15:29:41.412784177 +0000
>>>      @@ -1,79 +1,45 @@
>>>       QA output created by 009
>>>           1. into a hole
>>>      -0: [0..7]: hole
>>>      -1: [8..23]: unwritten
>>>      -2: [24..39]: hole
>>>      +0: [0..39]: hole
>>>       daa100df6e6711906b61c9ab5aa16032
>>>
>>> also some other tests are giving the same bad notices.
>> Can you attach the entire
>> /home/angelo/xfstests/results//generic/009.out.bad file? I'm not
>> sure which of the tests this output comes from, so I need to
>> confirm which specific operations are resulting in errors.
> Sure, i completed the whole generic + shared + xfs tests.
> In total i have 38 errors. And trying now one by one to understand the 
> reason.
> I attached the 009 output.
>
>>> -tests/generic/308
>>> ------------------
>>>
>>> I have now: CONFIG_LBDAF=y
>>>
>>> In my target device this test creates a 16 Terabytes file 308.tempfile
>>>
>>> -rw------- 1 root root  17592186044415 Sep 18 09:40 testfile.308
>>>
>>> While "df" is not complaining about:
>>>
>>> /dev/mmcblk0p5   8378368   45252   8333116   1% /media/p5
>>>
>>> and next rm -f on it hands the cpu to 95%, forever.
>>>
>>> This issue seems known from a long time, as it has been discussed in
>>> the thread:
>>>
>>> http://oss.sgi.com/archives/xfs/2013-04/msg00273.html
>>>
>>> I was wondering if there was any special reason why the Jeff patch has
>>> never been finally applied.
>> MAX_LFS_FILESIZE on 32 bits is 8TB, whereas xfs supports 16TB file
>> size on 32 bit systems. The specific issue this test fixed was
>> committed in commit 8695d27 ("xfs: fix infinite loop at
>> xfs_vm_writepage on 32bit system")
>>
>> http://oss.sgi.com/archives/xfs/2014-05/msg00447.html
>>
>> And, as you may notice now, generic/308 is the test case for the
>> exact problem the above commit fixed.
>
> I have recent git version of xfstests, but generic/308 shows
>
> #! /bin/bash
> # FS QA Test No. 308
> #
> # Regression test for commit:
> # f17722f ext4: Fix max file size and logical block counting of extent 
> format file
>
>> Can you find out exactly where the CPU is looping? sysrq-l will
>> help, as will running 'perf top -U -g' to show you the hot code
>> paths, and so on.
>
> Strangely, the patch 
> http://oss.sgi.com/archives/xfs/2014-05/msg00447.html is already included
> in the xfs that comes with this 4.1.6 kernel, while only applying 
> previous
>
> http://oss.sgi.com/archives/xfs/2013-04/msg00273.html patch from Jeff 
> fix the issue and
> test 308 get passed.
>
>
> I have a 16MB partition, and wondering why xfs allows from test 308 to 
> create a 16TB file.
>
> -rw------- 1 root root  17592186044415 Sep 18 09:40 testfile.308
>
>
> When at 308 test exit, rm is invoked, system get blocked in infinite 
> loop.
>
> root      5445  0.7  0.2   3760  3180 ttyS0    S+   10:53   0:00 
> /bin/bash /home/angelo/xfstests/tests/generic/308
> root      5674  100  0.0   1388   848 ttyS0    R+   10:53   0:27 rm -f 
> /media/p5/testfile.308
>
> Can't install actually perf-tools for some debian repos issue, but let 
> me know, i will enable sysrq
> if needed.
>
> Best regards
> Angelo
>
>
>>
>> Cheers,
>>
>> Dave.
>
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Best regards,
Angelo Dureghello

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
