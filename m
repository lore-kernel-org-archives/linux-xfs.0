Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45538 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750921AbeEBO7o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 10:59:44 -0400
Date: Wed, 2 May 2018 07:59:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 8/9] xfs: checkbashisms in all script files
Message-ID: <20180502145937.GT4127@magnolia>
References: <152518916007.23023.4793255395982876953.stgit@magnolia>
 <152518921090.23023.14958881774088486712.stgit@magnolia>
 <20180502085503.GE29084@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180502085503.GE29084@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net, fstests@vger.kernel.org

On Wed, May 02, 2018 at 04:55:03PM +0800, Eryu Guan wrote:
> On Tue, May 01, 2018 at 08:40:10AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Find all the /bin/sh scripts in xfsprogs and check for bashisms.
> > 
> > Cc: sandeen@sandeen.net
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Looks fine to me, but I'd like a review from Eric too, as it's a
> "maintainer script" :)
> 
> > ---
> >  tests/xfs/711     |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/711.out |    1 +
> >  tests/xfs/group   |    1 +
> >  3 files changed, 53 insertions(+)
> >  create mode 100755 tests/xfs/711
> >  create mode 100644 tests/xfs/711.out
> > 
> > 
> > diff --git a/tests/xfs/711 b/tests/xfs/711
> > new file mode 100755
> > index 00000000..d3dc3cd4
> > --- /dev/null
> > +++ b/tests/xfs/711
> > @@ -0,0 +1,51 @@
> > +#! /bin/bash
> > +# FS QA Test No. 711
> > +#
> > +# checkbashisms on all /bin/sh scripts.  This is a maintainer script.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2018 Oracle, Inc.
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
> > +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> > +
> > +# get standard environment
> > +. ./common/rc
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_supported_os Linux
> > +export CHECKBASHISMS_PROG="`set_prog_path checkbashisms`"
> > +_require_command "$CHECKBASHISMS_PROG" checkbashisms
> > +
> > +test -z "$WORKAREA" && _notrun "Can't find xfsprogs source"
> > +
> > +rm -f $seqres.full
> > +
> > +find $WORKAREA -name 'xfs*.sh' -print0 | xargs -0 grep '^#!/bin/sh' | sed -e 's/:.*$//g' | while read f; do
> 
> Do we care about spaces between "#!" and "/bin/sh"? i.e. "#! /bin/sh",
> sometimes there can be space(s).

Yes, I suppose we do care and should look for '^#!.*/bin/bash'.  I'll
also fix it to look only for files since that's all we care about.

--D

> Thanks,
> Eryu
> 
> > +	$CHECKBASHISMS_PROG $f
> > +done
> > +
> > +status=0
> > diff --git a/tests/xfs/711.out b/tests/xfs/711.out
> > new file mode 100644
> > index 00000000..52ff4745
> > --- /dev/null
> > +++ b/tests/xfs/711.out
> > @@ -0,0 +1 @@
> > +QA output created by 711
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 39e259e8..b7da3fba 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -443,3 +443,4 @@
> >  443 auto quick ioctl fsr
> >  444 auto quick
> >  445 auto quick filestreams
> > +711 auto quick
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
