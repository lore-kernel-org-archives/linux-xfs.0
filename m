Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 85B237F66
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 22:56:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0C597AC001
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 20:56:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AImpZRoLQ2tBRI8D for
	<xfs@oss.sgi.com>; Mon, 21 Oct 2013 20:56:26 -0700 (PDT)
Date: Tue, 22 Oct 2013 11:56:20 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfstests generic/320: heavy rm workload test
Message-ID: <20131022035620.GC2675@dhcp-13-216.nay.redhat.com>
References: <1382360484-6570-1-git-send-email-eguan@redhat.com>
	<20131021222955.GD16161@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131021222955.GD16161@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 22, 2013 at 09:29:55AM +1100, Dave Chinner wrote:
> On Mon, Oct 21, 2013 at 09:01:24PM +0800, Eryu Guan wrote:
> > This test is based on generic/273, a regression test for commit
> > 
> > 9a3a5da xfs: check for stale inode before acquiring iflock on push
> > 
> > On unpatched kernel, rm processes would hang.
> > 
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > ---
> >  tests/generic/320     | 139 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/320.out |   2 +
> >  tests/generic/group   |   2 +-
> >  3 files changed, 142 insertions(+), 1 deletion(-)
> >  create mode 100755 tests/generic/320
> >  create mode 100644 tests/generic/320.out
> > 
> > diff --git a/tests/generic/320 b/tests/generic/320
> > new file mode 100755
> > index 0000000..afe35a3
> > --- /dev/null
> > +++ b/tests/generic/320
> > @@ -0,0 +1,139 @@
> > +#! /bin/bash
> > +# FS QA Test No. generic/320
> > +#
> > +# heavy rm workload
> > +#
> > +# Regression test for commit:
> > +# 9a3a5da xfs: check for stale inode before acquiring iflock on push
> > +#
> > +# Based on generic/273
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2011-2012 Fujitsu, Inc.  All Rights Reserved.
> > +# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#
> > +#-----------------------------------------------------------------------
> > +#
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -rf $tmp.*
> > +}
> > +
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +threads=50
> > +count=2
> > +
> > +_threads_set()
> > +{
> > +	_cpu_num=`grep -c processor /proc/cpuinfo`
> > +	threads=$(($_cpu_num * 50))
> > +	if [ $threads -gt 200 ]
> > +	then
> > +		threads=200
> > +	fi
> > +}
> > +
> > +_file_create()
> > +{
> > +	_i=0
> > +
> > +	if ! mkdir $SCRATCH_MNT/origin
> > +	then
> > +		echo "mkdir origin err"
> > +		status=1
> > +		exit
> > +	fi
> 
> mkdir on a scratch device you just created shouldn't ever fail. We
> don't ibother adding noise to tests for such basic functionality
> unless we are specifically testing basic functionality.

I copy from most of code from generic/273 and did minor modifications
& cleanups, I should have done major cleanups :)

Thanks for the detailed review, I'll address them all in next version.

Thanks!

Eryu Guan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
