Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B18827F91
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 01:07:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 44B49AC007
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 23:07:17 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rhtYZWaRFpQGUG5h for
	<xfs@oss.sgi.com>; Mon, 25 Feb 2013 23:07:16 -0800 (PST)
Date: Tue, 26 Feb 2013 15:07:04 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/2] xfstests 299: test write to the last block of a
	sparse file
Message-ID: <20130226070704.GE7460@eguan-t400.nay.redhat.com>
References: <1361516369-7480-1-git-send-email-eguan@redhat.com>
	<1361516369-7480-2-git-send-email-eguan@redhat.com>
	<20130223013549.GF26081@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130223013549.GF26081@dastard>
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

On Sat, Feb 23, 2013 at 12:35:49PM +1100, Dave Chinner wrote:
> On Fri, Feb 22, 2013 at 02:59:29PM +0800, Eryu Guan wrote:
> > Write to the last block of a sparse file in extent format on ext4 would
> > hit BUG_ON() on unpatched kernel.
> > 
> > Regression test for commit:
> > f17722f ext4: Fix max file size and logical block counting of extent format file
> > 
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > ---
> > 
> > Note that the second dd could triger a BUG_ON() on ext4/3.8 kernel in
> > ext4_es_remove_extent().
> > 
> > I sent a patch for this issue, please see
> > http://www.spinics.net/lists/linux-ext4/msg36784.html
> > 
> >  299     | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  299.out |  1 +
> >  group   |  1 +
> >  3 files changed, 64 insertions(+)
> >  create mode 100644 299
> >  create mode 100644 299.out
> > 
> > diff --git a/299 b/299
> > new file mode 100644
> > index 0000000..9b52243
> > --- /dev/null
> > +++ b/299
> > @@ -0,0 +1,62 @@
> > +#! /bin/bash
> > +# FS QA Test No. 299
> > +#
> > +# Write to the last block of a sparse file in extent format on ext4 would
> > +# hit BUG_ON() on unpatched kernel.
> > +#
> > +# Regression test for commit:
> > +# f17722f ext4: Fix max file size and logical block counting of extent format file
> > +#
> > +#-----------------------------------------------------------------------
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
> > +#-----------------------------------------------------------------------
> > +#
> > +# creator
> > +owner=eguan@redhat.com
> > +
> > +seq=`basename $0`
> > +echo "QA output created by $seq"
> > +
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $testfile
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common.rc
> > +. ./common.filter
> > +
> > +testfile=$TEST_DIR/testfile.$seq
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_supported_os Linux
> > +
> > +block_size=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
> 
> stat -f -c %s

This is definitely better, thanks!

> 
> > +# Create sparse file
> > +dd if=/dev/zero of=$testfile bs=$block_size count=1 seek=$((2**32 - 2)) >/dev/null 2>&1
> > +sync
> 
> > +# Write to the last block
> > +dd if=/dev/zero of=$testfile bs=$block_size count=1 seek=$((2**32 - 1)) >/dev/null 2>&1
> 
> That doesn't write to the last block - that writes one block beyond
> the EOF. And it also truncates the file first, so what is triggering
> the bug? the truncate of the previous file, or the writing of the
> file? If it is writing of the file, then what's the point of the
> first write?
> 
> Also, I'd prefer that xfs_io is used instead of dd because then the
> operations being performed are explicit. i.e, the above it this:
> 
> offset=$(((2**32 - 2) * $block_size))
> XFS_IO_PROG -f -c "pwrite $offset $block_size" \
> 		-c fsync $testfile | filter_io
> XFS_IO_PROG -f -c "truncate 0" \
> 		-c "pwrite $((offset + $block_size)) $block_size" \
> 		-c fsync $testfile | filter_io
> 
> And it's not clear from either the test of the comments which of the
> 3 operations is actaully the one that causes the bug to be
> triggered....

Thanks for your review! I'll adopt xfs_io and try to make the comments more
informative in next version.

Thanks,

Eryu
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
