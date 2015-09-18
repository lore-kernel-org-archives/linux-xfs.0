Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2F03A7F3F
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2015 18:00:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CBA69AC002
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2015 16:00:29 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	H2x8riZRzLEOWrJT for <xfs@oss.sgi.com>;
	Fri, 18 Sep 2015 16:00:27 -0700 (PDT)
Date: Sat, 19 Sep 2015 08:44:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests, bad generic tests 009 and 308
Message-ID: <20150918224412.GE26895@dastard>
References: <55FC3E0E.9060506@nomovok.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55FC3E0E.9060506@nomovok.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Angelo Dureghello <angelo.dureghello@nomovok.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 18, 2015 at 06:38:38PM +0200, Angelo Dureghello wrote:
> Hi all,
> 
> working on arm (32bit arch), kernel 4.1.6.

Is this a new platform?

Also, we need to know what compiler you are using, because we know
that certain versions of gcc miscompile XFS kernel code on arm
(4.6, 4.7 and certain versions of 4.8 are suspect) due to a
combination of compiler mis-optimisations and kernel bugs in the
arm 64 bit division asm implementation.

As such, it would be worthwhile trying gcc-4.9 and a 4.3-rc1 kernel
to see if the problems still occur.

> Looking to find the reason of some bad results on xfstests,
> 
> -tests/generic/009
> ------------------
> i get several "all holes" messages
> 
> generic/009    [  842.949643] run fstests generic/009 at 2015-09-18
> 15:29:36
>  - output mismatch (see
> /home/angelo/xfstests/results//generic/009.out.bad)
>     --- tests/generic/009.out    2015-09-17 10:54:06.689071257 +0000
>     +++ /home/angelo/xfstests/results//generic/009.out.bad
> 2015-09-18 15:29:41.412784177 +0000
>     @@ -1,79 +1,45 @@
>      QA output created by 009
>          1. into a hole
>     -0: [0..7]: hole
>     -1: [8..23]: unwritten
>     -2: [24..39]: hole
>     +0: [0..39]: hole
>      daa100df6e6711906b61c9ab5aa16032
> 
> also some other tests are giving the same bad notices.

Can you attach the entire
/home/angelo/xfstests/results//generic/009.out.bad file? I'm not
sure which of the tests this output comes from, so I need to
confirm which specific operations are resulting in errors.

> -tests/generic/308
> ------------------
> 
> I have now: CONFIG_LBDAF=y
> 
> In my target device this test creates a 16 Terabytes file 308.tempfile
> 
> -rw------- 1 root root  17592186044415 Sep 18 09:40 testfile.308
> 
> While "df" is not complaining about:
> 
> /dev/mmcblk0p5   8378368   45252   8333116   1% /media/p5
> 
> and next rm -f on it hands the cpu to 95%, forever.
> 
> This issue seems known from a long time, as it has been discussed in
> the thread:
> 
> http://oss.sgi.com/archives/xfs/2013-04/msg00273.html
> 
> I was wondering if there was any special reason why the Jeff patch has
> never been finally applied.

MAX_LFS_FILESIZE on 32 bits is 8TB, whereas xfs supports 16TB file
size on 32 bit systems. The specific issue this test fixed was
committed in commit 8695d27 ("xfs: fix infinite loop at
xfs_vm_writepage on 32bit system")

http://oss.sgi.com/archives/xfs/2014-05/msg00447.html

And, as you may notice now, generic/308 is the test case for the
exact problem the above commit fixed. 

Can you find out exactly where the CPU is looping? sysrq-l will
help, as will running 'perf top -U -g' to show you the hot code
paths, and so on.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
