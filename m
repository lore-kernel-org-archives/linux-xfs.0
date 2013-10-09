Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 976257FED
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 21:15:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5ABFC8F8054
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 19:15:46 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 5oMH2PRj4ptUOeFe for
	<xfs@oss.sgi.com>; Tue, 08 Oct 2013 19:15:44 -0700 (PDT)
Message-ID: <1381284836.3969.8.camel@localhost.localdomain>
Subject: Re: [PATCH] xfstest: an regression test for btrfs balance
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Date: Wed, 09 Oct 2013 10:13:56 +0800
In-Reply-To: <20131008172157.GD16461@localhost.localdomain>
References: <1381195275-9471-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	<20131008172157.GD16461@localhost.localdomain>
Mime-Version: 1.0
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: miaox@cn.fujitsu.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, 2013-10-08 at 13:21 -0400, Josef Bacik wrote:
> On Tue, Oct 08, 2013 at 09:21:15AM +0800, Gui Hecheng wrote:
> > Originally, when executing "btrfs balance" right after
> > "btrfs subvolume snaphot" & "btrfs subvolume delete",
> > a kernel BUG arises.
> > 
> > This problem is caused by the patch:
> > [PATCH 1/2] Btrfs: fix for patch "cleanup: don't check
> > the same thing twice"
> > The commit id: 48475471728f060bfd2e686f592ef208d3ba8b7d
> > (in kernel/git/torvalds/linux.git)
> > 
> > handled by the patch:
> > [PATCH 2/3] Btrfs: fix oops caused by the space balance
> > and dead roots
> > 
> > Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> > ---
> >  tests/btrfs/319     | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/319.out |  2 ++
> >  tests/btrfs/group   |  1 +
> >  3 files changed, 74 insertions(+)
> >  create mode 100755 tests/btrfs/319
> >  create mode 100644 tests/btrfs/319.out
> > 
> > diff --git a/tests/btrfs/319 b/tests/btrfs/319
> > new file mode 100755
> > index 0000000..b49e760
> > --- /dev/null
> > +++ b/tests/btrfs/319
> > @@ -0,0 +1,71 @@
> > +#! /bin/bash
> > +# FS QA Test No. btrfs/319
> > +#
> 
> Just pick the next available number, so 012, no reason to jack up the numbers
> like this.

Test number has been changed 319 -> 012 in V2.

> > +# Btrfs balance tests
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2013 Fujitsu.  All Rights Reserved.
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
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here="`pwd`"
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +
> > +_create_snapshot()
> > +{
> > +	for i in $(seq 20)
> > +	do
> > +		btrfs sub snapshot $SCRATCH_MNT $SCRATCH_MNT/snapshot0 >/dev/null
> > +		btrfs sub delete $SCRATCH_MNT/snapshot0 >/dev/null
> > +	done
> > +}
> > +
> > +_balance()
> > +{
> > +	for i in $(seq 20)
> > +	do
> > +		btrfs balance start $SCRATCH_MNT >/dev/null
> > +	done
> > +}
> > +
> > +#get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_fs btrfs
> > +_supported_os Linux
> > +
> > +_setup_testdir
> > +_require_scratch
> > +_scratch_mkfs >/dev/null 2>&1
> > +_scratch_mount
> > +
> > +echo "Tip: Run dmesg to see the error on failure"
> > +
> > +_create_snapshot &
> > +
> > +_balance &
> > +
> > +wait
> > +
> > +status=0
> > +exit
> > diff --git a/tests/btrfs/319.out b/tests/btrfs/319.out
> > new file mode 100644
> > index 0000000..1d21523
> > --- /dev/null
> > +++ b/tests/btrfs/319.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 319
> > +Tip: Run dmesg to see the error on failure
> > diff --git a/tests/btrfs/group b/tests/btrfs/group
> > index d2fe030..201a475 100644
> > --- a/tests/btrfs/group
> > +++ b/tests/btrfs/group
> > @@ -14,3 +14,4 @@
> >  009 auto quick
> >  010 auto quick
> >  011 auto
> > +319 auto
> > -- 
> > 1.8.0.1
> 
> Otherwise this looks nice and straightforward, did you verify that it made the
> box panic without Miao's fixes?  If you did just fixup the test number and you
> can add
> 
> Reviewed-by: Josef Bacik <jbacik@fusionio.com>
> 
> Thanks,
> 
> Josef
> --

I have verify that it did make the box panic without Miao's fixes.
Thank you for your comments.

Gui

> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
