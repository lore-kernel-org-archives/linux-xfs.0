Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59292 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfCGPwC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Mar 2019 10:52:02 -0500
Date: Thu, 7 Mar 2019 07:51:53 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/5] generic: test statx attribute_mask setting
Message-ID: <20190307155153.GA4676@magnolia>
References: <155173434205.767.15128498725168844621.stgit@magnolia>
 <155173437536.767.4083133841860983852.stgit@magnolia>
 <20190307061418.GL2824@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190307061418.GL2824@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Mar 07, 2019 at 02:14:18PM +0800, Eryu Guan wrote:
> On Mon, Mar 04, 2019 at 01:19:35PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make sure the filesystem reports attribute_mask for the attributes it
> > supports.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> A few minor issues, and I can fix them all on commit (I'm sure I do test
> the changes this time :)).
> 
> > ---
> >  tests/generic/713     |   67 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/713.out |    1 +
> >  tests/generic/group   |    1 +
> >  3 files changed, 69 insertions(+)
> >  create mode 100755 tests/generic/713
> >  create mode 100644 tests/generic/713.out
> > 
> > 
> > diff --git a/tests/generic/713 b/tests/generic/713
> > new file mode 100755
> > index 00000000..cd128d9c
> > --- /dev/null
> > +++ b/tests/generic/713
> > @@ -0,0 +1,67 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0+
> > +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 713
> > +#
> > +# Regression test for a bug where XFS fails to set statx attributes_mask but
> > +# sets attribute flags anyway.
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.* $testfile
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_test
> > +
> > +get_attributes() {
> > +	$XFS_IO_PROG -r -c "statx -r" $1 | grep 'stat.attributes =' | cut -d ' ' -f 3
> > +}
> > +
> > +get_attributes_mask() {
> > +	$XFS_IO_PROG -r -c "statx -r" $1 | grep 'stat.attributes_mask =' | cut -d ' ' -f 3
> > +}
> > +
> > +check_statx_attributes()
> > +{
> > +	attrs=$(get_attributes $testfile)
> > +	mask=$(get_attributes_mask $testfile)
> 
> Declare them as 'local'.
> 
> > +
> > +	echo "MASK:$mask:ATTRS:$attrs:" >> $seqres.full
> > +
> > +	test -z "$mask" && _notrun "xfs_io statx command does not support attributes_mask"
> > +	test $(( mask )) -eq 0 && echo "attributes mask is zero"
> > +	test $(( attrs & ~(mask) )) -ne 0 && echo "attributes $attrs do not appear in mask $mask"
> > +}
> > +
> 
> Added the below here:
> 
> rm -f $seqres.full
> echo "Silence is golden"
> 
> > +# Create file, check for incorrect mask
> > +testfile=$TEST_DIR/$$.test
> > +touch $testfile
> > +check_statx_attributes
> > +
> > +# Do it again, but this time try to turn on one of the attributes.
> > +if chattr +i $testfile > /dev/null 2>&1; then
> > +	check_statx_attributes
> > +	chattr -i $testfile
> > +fi
> > +if chattr +a $testfile > /dev/null 2>&1; then
> > +	check_statx_attributes
> > +	chattr -a $testfile
> 
> Change 'chattr' to '$CHATTR_PROG'.

Sounds good, thank you for fixing those!

--D

> Thanks,
> Eryu
> 
> > +fi
> > +
> > +status=0
> > +exit
> > diff --git a/tests/generic/713.out b/tests/generic/713.out
> > new file mode 100644
> > index 00000000..066598d3
> > --- /dev/null
> > +++ b/tests/generic/713.out
> > @@ -0,0 +1 @@
> > +QA output created by 713
> > diff --git a/tests/generic/group b/tests/generic/group
> > index 15227b67..d04bf39f 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -534,3 +534,4 @@
> >  529 auto quick attr
> >  530 auto quick unlink
> >  531 auto quick unlink
> > +713 auto quick
> > 
