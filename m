Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 61B037F51
	for <xfs@oss.sgi.com>; Tue, 16 Apr 2013 00:55:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F3513AC001
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 22:55:52 -0700 (PDT)
Received: from mail-gg0-f177.google.com (mail-gg0-f177.google.com
	[209.85.161.177]) by cuda.sgi.com with ESMTP id
	O7Pa4WuztvUMIBbD (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Apr 2013 22:55:51 -0700 (PDT)
Received: by mail-gg0-f177.google.com with SMTP id q1so13490gge.22
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 22:55:51 -0700 (PDT)
Message-ID: <516CE7E0.6010307@gmail.com>
Date: Tue, 16 Apr 2013 01:55:44 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix s_max_bytes to MAX_LFS_FILESIZE if needed
References: <5167E160.3020800@oracle.com> <5169CC34.9080902@gmail.com>
	<516CE451.5010203@oracle.com>
In-Reply-To: <516CE451.5010203@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

You're welcome.  Thanks for the explanation.  Now everything makes 
logical sense.

I'll re-run the tests with different block sizes.  The tests have been 
run already with a) default mkfs options and b) with an external journal 
and realtime device.

Your related patch, "xfs: don't return 0 if generic_segment_checks() 
find nothing to write," has also been applied.  The suggested test case 
hasn't been tried, but the patch hasn't caused any additional problems, 
either.

Anyway, I hope you had/have a good stay here in the US.

Michael

On 04/16/2013 01:40 AM, Jeff Liu wrote:
> Hi Michael,
>
> Thanks a lot for help verifying this fix and sorry for my too late
> response since I have traveled to US two days ago.
>
> On 04/14/2013 05:20 AM, Michael L. Semon wrote:
>> Update:  My tests on my original hardware go exactly as they did in my
>> Pentium 4 test.  xfstests shared/[0-9][0-9][0-9] and xfs/003 through
>> xfs/136 were run against it.  No problems.  Good job.  I'm keeping the
>> patch.
>>
>> My final version of the bug summary goes like this:
>>
>> On a 32-bit x86 PC, with a Linux kernel that has CONFIG_LBDAF=y...
>>
>> xfstests generic/308, by writing to a file at an address just before
>> 2**32, causes the following conditions on an XFS filesystem:
>>
>> 1) CPU usage becomes very high,
>>
>> 2) The xfs_io process cannot be killed,
>>
>> 3) The best way to shut down the PC is through use of the magic SysRq keys.
>>
>> 4) Afterwards, attempts to mount the filesystem result in a soft oops.
>>
>> 5) After an `xfs_repair -L` on the filesystem, all is OK, other than for
>> what was lost by zeroing the log.
>>
>> J. Liu wrote a patch that solves this problem, but he found the answers
>> with CONFIG_LBDAF=n, which is a condition for which xfstests generic/308
>> passes on the two test PCs used.
> Ooops! it's wrong.  My answer is misleading, you can think that I drink
> too much at that time.:(  Actually, it quite the reverse, i.e. this
> issue can be reproduced against 32-bit kernel with CONFIG_LBADF=y, this
> is the default configuration of mine.
> In this case, I observed that the s_maxbytes is larger than the
> MAX_LFS_FILESIZE.  Hence, the current patch is written to make sure that
> the s_maxbytes should not beyond this limits.
>
> For 32-bit kernel with CONFIG_LBADF=n, the s_maxbytes is just equal to
> MAX_LFS_FILESIZE, so the test is works to me.  BTW, I only verified this
> fix upon the default mkfs options. i.e, 4k blocksize, that is, mkfs.xfs
> /dev/sdX.
>>
>> Tests were conducted on a Pentium III (kernel 3.9-rc4 with numerous SGI
>> patches) and on a Pentium 4 (kernel 3.9-rc6 with numerous SGI patches).
>>
>> Could you verify these things by memory (no need to retest)?
> As I mentioned above.
>> a) With CONFIG_LBDAF=y, generic/308 caused filesystem corruption, and
> In this case, the operation should be denied with -EFBIG error returned
> if trying to create a huge file.
>>
>> b) With CONFIG_LBDAF=n, generic/308 passed the test.
> Even don't applying this patch, the test run passed for the default mkfs
> setup.
>>
>> c) Having CONFIG_LBDAF=n helped you to find the answers and write this
>> fine patch.
> CONFIG_LBADF=y instead.
>
> Thanks again!
> -Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
