Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 571BB7F37
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 00:30:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 404878F8054
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 22:30:56 -0700 (PDT)
Received: from mail-pb0-f41.google.com (mail-pb0-f41.google.com
	[209.85.160.41]) by cuda.sgi.com with ESMTP id SFlTZmdyzxz4EisM
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 19 Mar 2013 22:30:25 -0700 (PDT)
Received: by mail-pb0-f41.google.com with SMTP id um15so1057125pbc.28
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 22:30:25 -0700 (PDT)
Date: Wed, 20 Mar 2013 13:45:56 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2] xfstests: add a new test case for ext4 indirect-based
	file
Message-ID: <20130320054555.GB4017@gmail.com>
References: <1363683183-7392-1-git-send-email-wenqing.lz@taobao.com>
	<51489267.7080202@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51489267.7080202@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On Tue, Mar 19, 2013 at 11:29:27AM -0500, Eric Sandeen wrote:
[snip]
> > +# real QA test starts here
> > +_supported_fs generic
> > +_supported_os IRIX Linux
> 
> This is not supported on IRIX, I think.

Thanks, It will be fixed.

> 
> > +
> > +_require_xfs_io_falloc_punch
> > +_require_xfs_io_fiemap
> > +
> > +testfile=$TEST_DIR/314.$$
> 
> $seq.$$
> 
> (looks like this problem snuck in on test 255, first)

Yes, I will fix it.

> 
> > +
> > +# Standard punch hole tests
> > +_test_generic_punch pwrite fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
> > +
> > +# Delayed allocation punch hole tests
> > +_test_generic_punch -d pwrite fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
> > +
> > +# Multi hole punch tests
> > +_test_generic_punch -k pwrite fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
> > +
> > +# Delayed allocation multi punch hole tests
> > +_test_generic_punch -d -k pwrite fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/314.out b/314.out
> > new file mode 100644
> > index 0000000..2eb1f27
> > --- /dev/null
> > +++ b/314.out
> > @@ -0,0 +1,307 @@
> > +QA output created by 314
> > +	1. into a hole
> > +daa100df6e6711906b61c9ab5aa16032
> > +	2. into allocated space
> > +0: [0..7]: extent
> > +1: [8..23]: hole
> > +2: [24..39]: extent
> > +cc58a7417c2d7763adc45b6fcd3fa024
> > +	3. into unwritten space
> > +0: [0..7]: extent
> > +1: [8..23]: hole
> > +2: [24..39]: extent
> > +cc58a7417c2d7763adc45b6fcd3fa024
> > +	4. hole -> data
> > +0: [0..23]: hole
> > +1: [24..31]: extent
> > +2: [32..39]: hole
> > +cc63069677939f69a6e8f68cae6a6dac
> > +	5. hole -> unwritten
> > +0: [0..23]: hole
> > +1: [24..31]: extent
> > +2: [32..39]: hole
> > +cc63069677939f69a6e8f68cae6a6dac
> > +	6. data -> hole
> > +0: [0..7]: extent
> > +1: [8..39]: hole
> > +1b3779878366498b28c702ef88c4a773
> > +	7. data -> unwritten
> > +0: [0..7]: extent
> > +1: [8..23]: hole
> > +2: [24..31]: extent
> > +3: [32..39]: hole
> > +5309cc2f1fc5a7f94cf52915caef35bd
> > +	8. unwritten -> hole
> > +0: [0..7]: extent
> > +1: [8..39]: hole
> > +1b3779878366498b28c702ef88c4a773
> > +	9. unwritten -> data
> > +0: [0..7]: extent
> > +1: [8..23]: hole
> > +2: [24..31]: extent
> > +3: [32..39]: hole
> > +5309cc2f1fc5a7f94cf52915caef35bd
> > +	10. hole -> data -> hole
> > +daa100df6e6711906b61c9ab5aa16032
> > +	11. data -> hole -> data
> > +0: [0..7]: extent
> > +1: [8..31]: hole
> > +2: [32..39]: extent
> > +f6aeca13ec49e5b266cd1c913cd726e3
> > +	12. unwritten -> data -> unwritten
> 
> It's a little odd that the output contains "unwritten" when this test
> is explicitly for testing *without* unwritten extents.  Should this be
> cleaned up a little in common.punch, maybe?

I will try to define a new function called _test_indirect_punch() to
test punching hole without unwritten extent.

[snip]
> > diff --git a/group b/group
> > index a11e832..36f63ab 100644
> > --- a/group
> > +++ b/group
> > @@ -431,3 +431,4 @@ stress
> >  305 aio dangerous enospc rw stress
> >  306 auto quick rw
> >  313 auto quick
> > +314 auto quick prealloc
> 
> I wonder if we should create a "punch" group ...
> 

Thanks for the suggestions.

Regards,
                                                - Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
