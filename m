Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C67D57F37
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 17:52:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B26248F804C
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 15:52:49 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	w0N5aSTZnIRWzgzv for <xfs@oss.sgi.com>;
	Mon, 21 Sep 2015 15:52:46 -0700 (PDT)
Date: Tue, 22 Sep 2015 08:52:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests, bad generic tests 009 and 308
Message-ID: <20150921225244.GD19114@dastard>
References: <55FC3E0E.9060506@nomovok.com> <20150918224412.GE26895@dastard>
	<55FFE665.7040004@nomovok.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55FFE665.7040004@nomovok.com>
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

On Mon, Sep 21, 2015 at 01:13:41PM +0200, Angelo Dureghello wrote:
> Hi Dave,
> 
> many thanks for the support. Sorry for the double mail, after
> first registering mails was not accepted, so i re-registered
> with a company mail.
> 
> 
> On 19/09/2015 00:44, Dave Chinner wrote:
> >On Fri, Sep 18, 2015 at 06:38:38PM +0200, Angelo Dureghello wrote:
> >>Hi all,
> >>
> >>working on arm (32bit arch), kernel 4.1.6.
> >Is this a new platform?
> >
> >Also, we need to know what compiler you are using, because we know
> >that certain versions of gcc miscompile XFS kernel code on arm
> >(4.6, 4.7 and certain versions of 4.8 are suspect) due to a
> >combination of compiler mis-optimisations and kernel bugs in the
> >arm 64 bit division asm implementation.
> >
> >As such, it would be worthwhile trying gcc-4.9 and a 4.3-rc1 kernel
> >to see if the problems still occur.
> 
> I am using actually gcc-linaro-4.9-2015.05-x86_64_arm-linux-gnueabihf

So gcc-4.9 patched with a bunch of stuff from linaro and built as a
cross compiler from x86-64 to 32 bit arm? ISTR we had a bunch of
different compiler problems at one point that only showed up in
kernels build with a x86-64 to arm cross-compiler.  In case you
haven't guessed, XFS has a history of being bitten by ARM compiler
problems. There's been a lot more problems in the past couple of
years than the historical trend, though.

As it is, I highly recommend that you try a current 4.3 kernel, as
there are several code fixes in the XFS kernel code that work around
compiler issues we know about. AFAIA, the do_div() asm bug that
trips recent gcc optimisations isn't in the upstream kernel yet, but
that can be worked around by setting CONFIG_CC_OPTIMIZE_FOR_SIZE=y
in your build.

> >>generic/009    [  842.949643] run fstests generic/009 at 2015-09-18
> >>15:29:36
> >>  - output mismatch (see
> >>/home/angelo/xfstests/results//generic/009.out.bad)
> >>     --- tests/generic/009.out    2015-09-17 10:54:06.689071257 +0000
> >>     +++ /home/angelo/xfstests/results//generic/009.out.bad
> >>2015-09-18 15:29:41.412784177 +0000
> >>     @@ -1,79 +1,45 @@
> >>      QA output created by 009
> >>          1. into a hole
> >>     -0: [0..7]: hole
> >>     -1: [8..23]: unwritten
> >>     -2: [24..39]: hole
> >>     +0: [0..39]: hole
> >>      daa100df6e6711906b61c9ab5aa16032
> >>
> >>also some other tests are giving the same bad notices.
> >Can you attach the entire
> >/home/angelo/xfstests/results//generic/009.out.bad file? I'm not
> >sure which of the tests this output comes from, so I need to
> >confirm which specific operations are resulting in errors.
> Sure, i completed the whole generic + shared + xfs tests.
> In total i have 38 errors. And trying now one by one to understand
> the reason.
> I attached the 009 output.
> 
> >>-tests/generic/308
> >>------------------
....
> I have recent git version of xfstests, but generic/308 shows
> 
> #! /bin/bash
> # FS QA Test No. 308
> #
> # Regression test for commit:
> # f17722f ext4: Fix max file size and logical block counting of
> extent format file

More that one filesystem had problems with maximum file sizes on 32
bit systems. Compare the contents of the test; don't stop reading
because the summary of the test makes you think the rest of the test
is unrelated to the problem at hand.

> I have a 16MB partition, and wondering why xfs allows from test 308
> to create a 16TB file.
> 
> -rw------- 1 root root  17592186044415 Sep 18 09:40 testfile.308

https://en.wikipedia.org/wiki/Sparse_file

> QA output created by 009
> 	1. into a hole
> 0: [0..39]: hole
> daa100df6e6711906b61c9ab5aa16032
> 	2. into allocated space
> cc58a7417c2d7763adc45b6fcd3fa024
> 	3. into unwritten space
> daa100df6e6711906b61c9ab5aa16032

I don't need to look any further to see that something is badly
wrong here. This is telling me that no extents are being allocated
at all, which indicates either fiemap is broken, awk/sed is
broken or misbehaving (and hence mangling the output) or something
deep in the filesystem code is fundamentally broken in some
strange, silent way.

Can you create an xfs filesystem on your scratch device, and
manually run this command and post the output:

# mkfs.xfs -V
# mkfs.xfs <dev>
# mount <dev> /mnt/xfs
# xfs_io -f -c "pwrite 0 64k" -c sync \
	    -c "bmap -vp" -c "fiemap -v" \
	    -c "falloc 1024k 256k" -c sync \
	    -c "pwrite 1088k 64k" -c sync \
	    -c "bmap -vp" -c "fiemap -v" \
	    /mnt/xfs/testfile

and attach the entire output?

It would also be good if you can run this command under trace-cmd
and capture all the XFS events that occur during the test. See

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

for details, and attach the (compressed) report file.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
