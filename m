Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35942 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727180AbeK0HpY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Nov 2018 02:45:24 -0500
Date: Mon, 26 Nov 2018 12:50:00 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/12] generic: long fsx soak tests
Message-ID: <20181126205000.GG6783@magnolia>
References: <154290950237.1218.9937108728673485814.stgit@magnolia>
 <154290958406.1218.8922234236895263233.stgit@magnolia>
 <20181125162741.GN3889@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181125162741.GN3889@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Mon, Nov 26, 2018 at 12:27:41AM +0800, Eryu Guan wrote:
> On Thu, Nov 22, 2018 at 09:59:44AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a few tests to implement long soak tests of fsx.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/generic/938     |   65 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/938.out |    2 ++
> >  tests/generic/939     |   60 +++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/939.out |    2 ++
> >  tests/generic/group   |    2 ++
> >  5 files changed, 131 insertions(+)
> >  create mode 100644 tests/generic/938
> 
> The file mode should be 755.

Fixed.

> >  create mode 100644 tests/generic/938.out
> >  create mode 100644 tests/generic/939
> 
> Same here.

Fixed.

> >  create mode 100644 tests/generic/939.out
> > 
> > 
> > diff --git a/tests/generic/938 b/tests/generic/938
> > new file mode 100644
> > index 00000000..a85a6472
> > --- /dev/null
> > +++ b/tests/generic/938
> > @@ -0,0 +1,65 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2018 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 938
> > +#
> > +# Long-soak directio fsx test
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1        # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +        cd /
> > +        rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_test
> 
> _require_odirect ?

Fixed.

> > +
> > +# Run fsx for a million ops or more
> > +nr_ops=$((1000000 * TIME_FACTOR))
> > +op_sz=$((128000 * LOAD_FACTOR))
> > +file_sz=$((600000 * LOAD_FACTOR))
> > +fsx_file=$TEST_DIR/fsx.$seq
> > +min_dio_sz=$(_min_dio_alignment)
> > +
> > +fsx_args=(-q)
> > +fsx_args+=(-N $nr_ops)
> > +fsx_args+=(-p $((nr_ops / 100)))
> > +fsx_args+=(-o $op_sz)
> > +fsx_args+=(-l $file_sz)
> > +fsx_args+=(-r $min_dio_sz)
> > +fsx_args+=(-t $min_dio_sz)
> > +fsx_args+=(-w $min_dio_sz)
> > +fsx_args+=(-Z)
> > +fsx_args+=($fsx_file)
> > +
> > +echo "ltp ${fsx_args[@]} $FSX_ARGS" >> $seqres.full
> 
> FSX_ARGS is not a global variable. Perhaps you mean FSX_AVOID?
> 
> > +
> > +if ! ltp/fsx "${fsx_args[@]}" $FSX_ARGS > $tmp.fsx 2>&1; then
> > +	cat $tmp.fsx | tee -a $seqres.full
> > +fi
> 
> And maybe "run_fsx" from common/rc could do all the trick?

Good suggestion, thank you.

--D

> Thanks,
> Eryu
> 
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/generic/938.out b/tests/generic/938.out
> > new file mode 100644
> > index 00000000..11b565ee
> > --- /dev/null
> > +++ b/tests/generic/938.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 938
> > +Silence is golden
> > diff --git a/tests/generic/939 b/tests/generic/939
> > new file mode 100644
> > index 00000000..5e341e30
> > --- /dev/null
> > +++ b/tests/generic/939
> > @@ -0,0 +1,60 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2018 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 938
> > +#
> > +# Long-soak buffered fsx test
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1        # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +        cd /
> > +        rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_test
> > +
> > +# Run fsx for a million ops or more
> > +nr_ops=$((1000000 * TIME_FACTOR))
> > +op_sz=$((128000 * LOAD_FACTOR))
> > +file_sz=$((600000 * LOAD_FACTOR))
> > +fsx_file=$TEST_DIR/fsx.$seq
> > +
> > +fsx_args=(-q)
> > +fsx_args+=(-N $nr_ops)
> > +fsx_args+=(-p $((nr_ops / 100)))
> > +fsx_args+=(-o $op_sz)
> > +fsx_args+=(-l $file_sz)
> > +fsx_args+=($fsx_file)
> > +
> > +echo "ltp ${fsx_args[@]} $FSX_ARGS" >> $seqres.full
> > +
> > +if ! ltp/fsx "${fsx_args[@]}" $FSX_ARGS > $tmp.fsx 2>&1; then
> > +	cat $tmp.fsx | tee -a $seqres.full
> > +fi
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/generic/939.out b/tests/generic/939.out
> > new file mode 100644
> > index 00000000..a86e90c5
> > --- /dev/null
> > +++ b/tests/generic/939.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 939
> > +Silence is golden
> > diff --git a/tests/generic/group b/tests/generic/group
> > index 92330b52..16e5cc17 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -522,3 +522,5 @@
> >  517 auto quick dedupe clone
> >  518 auto quick clone
> >  519 auto quick
> > +938 soak long_rw
> > +939 soak long_rw
> > 
