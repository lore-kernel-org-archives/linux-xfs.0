Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47473 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753536AbdGNQ6D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2017 12:58:03 -0400
Date: Fri, 14 Jul 2017 09:57:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] generic: test negative SEEK_HOLE/SEEK_DATA offsets
Message-ID: <20170714165757.GA4211@magnolia>
References: <20170713190641.GA4150@magnolia>
 <20170714034119.GI2478@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170714034119.GI2478@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Fri, Jul 14, 2017 at 11:41:19AM +0800, Eryu Guan wrote:
> On Thu, Jul 13, 2017 at 12:06:41PM -0700, Darrick J. Wong wrote:
> > Check that we get -ENXIO if the user calls SEEK_HOLE/SEEK_DATA with
> > a negative file offset.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: use helpers as suggested by Eryu.
> > ---
> [snip]
> > +
> > +seq=`basename "$0"`
> > +seqres="$RESULT_DIR/$seq"
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +    cd /
> > +    rm -rf "$tmp".* $testdir/file1
> > +}
> 
> Just noticed there're two _cleanup()s, I'll remove this one and move the
> one below here.

Oops.  Thanks for catching that!

--D

> 
> Thanks,
> Eryu
> 
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +_supported_fs generic
> > +_supported_os Linux
> > +
> > +_require_test
> > +_require_seek_data_hole
> > +
> > +BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
> > +
> > +_require_test_program "seek_sanity_test"
> > +
> > +# Disable extent zeroing for ext4 as that change where holes are created
> > +if [ "$FSTYP" = "ext4" ]; then
> > +	DEV=`_short_dev $TEST_DEV`
> > +	echo 0 >/sys/fs/ext4/$DEV/extent_max_zeroout_kb
> > +fi
> > +
> > +_cleanup()
> > +{
> > +	rm -f $tmp.* $BASE_TEST_FILE.*
> > +}
> > +
> > +$here/src/seek_sanity_test -s 18 -e 18 $BASE_TEST_FILE > $seqres.full 2>&1 ||
> > +	_fail "seek sanity check failed!"
> > +
> > +_check_dmesg
> > +# success, all done
> > +echo "Silence is golden"
> > +status=0
> > +exit
> > diff --git a/tests/generic/702.out b/tests/generic/702.out
> > new file mode 100644
> > index 0000000..608d593
> > --- /dev/null
> > +++ b/tests/generic/702.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 702
> > +Silence is golden
> > diff --git a/tests/generic/group b/tests/generic/group
> > index 3c5a19c..6afd402 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -449,4 +449,5 @@
> >  444 auto quick acl
> >  445 auto quick rw
> >  446 auto quick rw dangerous
> > +702 auto quick rw
> >  931 auto quick clone
