Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AD0237F63
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 19:30:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F1D4AC001
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 17:30:51 -0800 (PST)
Received: from mail-la0-f47.google.com (mail-la0-f47.google.com
	[209.85.215.47]) by cuda.sgi.com with ESMTP id tCSH82PqUktUOjpT
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 01 Mar 2013 17:30:49 -0800 (PST)
Received: by mail-la0-f47.google.com with SMTP id fj20so3470606lab.20
	for <xfs@oss.sgi.com>; Fri, 01 Mar 2013 17:30:47 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 09/10] xfstest: add defragmentation stress tests for ext4
In-Reply-To: <51310046.5090306@sgi.com>
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
	<1361356935-29153-10-git-send-email-dmonakhov@openvz.org>
	<51310046.5090306@sgi.com>
Date: Sat, 02 Mar 2013 05:30:43 +0400
Message-ID: <878v66h9ks.fsf@openvz.org>
MIME-Version: 1.0
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, dchinner@redhat.com, xfs@oss.sgi.com

On Fri, 1 Mar 2013 13:23:50 -0600, Rich Johnston <rjohnston@sgi.com> wrote:
> On 02/20/2013 04:42 AM, Dmitry Monakhov wrote:
> > Perform various regression tests for ext4defrag  subsystem
> >
> >   299'th Test1: Defragment file while other task does direct AIO
> >   300'th Test2: Perform defragmentation on file under buffered AIO
> >   	while third task does direct AIO to donor file
> >   301'th Test3: Two defrag tasks use common donor file.
> >   302'th Test4: Stress defragmentation. Several threads pefrorm
> typo 	                                                  perform
> 
> >   	fragmentation at random position use inplace=1 will
> > 	allocate and free blocks inside defrag event improve
> > 	load pressure.
> >
> > This tests are considered dengerous because 300'th and 301'th are known
> typo                        dangerous
> 
> > to trigger OOPS on recent kernels see:https://gist.github.com/dmonakhov/4770294
> >
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> >   299           |  126 +++++++++++++++++++++++++++++++++++++++++++++++
> >   299.out       |    4 ++
> >   300           |  143 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >   300.out       |    4 ++
> >   301           |  153 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >   301.out       |    4 ++
> >   302           |  130 ++++++++++++++++++++++++++++++++++++++++++++++++
> >   302.out       |    4 ++
> >   common.defrag |    4 +-
> >   group         |    6 ++-
> >   10 files changed, 575 insertions(+), 3 deletions(-)
> >   create mode 100755 299
> >   create mode 100644 299.out
> >   create mode 100755 300
> >   create mode 100644 300.out
> >   create mode 100755 301
> >   create mode 100644 301.out
> >   create mode 100755 302
> >   create mode 100644 302.out
> >
> > diff --git a/299 b/299
> > new file mode 100755
> > index 0000000..4a7a98c
> > --- /dev/null
> > +++ b/299
> > @@ -0,0 +1,126 @@
> > +#! /bin/bash
> > +# FSQA Test No. 299
> > +#
> > +# Ext4 defragmentation stress test
> > +# Defragment file while other task does direct io
> > +#-----------------------------------------------------------------------
> > +# (c) 2013 Dmitry Monakhov
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
> > +# creator
> > +owner=dmonakhov@openvz.org
> > +
> > +seq=`basename $0`
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> > +
> > +# get standard environment, filters and checks
> > +. ./common.rc
> > +. ./common.filter
> > +. ./common.defrag
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_supported_fs ext4
> > +_need_to_be_root
> > +_require_scratch
> > +_require_defrag
> > +
> I think you meant to set NUM_JOBS here like you did in [Patch 08/10], 
> something like:
> 
> +NUM_JOBS=$((4*LOAD_FACTOR))
Indeed. I've forget to update patch.
> 
> otherwise you get
> 
> ###	 [not run] /usr/local/bin/fio too old
> 
> > +BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> > +# We need space for 2 files (test file, and donor one)
> > +# reserve 30% in order to avoid ENOSPC
> > +FILE_SIZE=$((BLK_DEV_SIZE * (512 / (2 + 1))))
> > +
> > +cat >$tmp-$seq.fio <<EOF
> > +# Common e4defrag regression tests
> > +[global]
> > +ioengine=ioe_e4defrag
> > +iodepth=1
> > +directory=${SCRATCH_MNT}
> > +filesize=${FILE_SIZE}
> > +size=999G
> > +buffered=0
> > +fadvise_hint=0
> > +group_reporting
> > +
> > +#################################
> > +# Test1
> > +# Defragment file while other task does direct io
> > +
> > +# Continious sequential defrag activity
> > +[defrag-4k]
> > +ioengine=e4defrag
> > +iodepth=1
> > +bs=128k
> > +donorname=test1.def
> > +filename=test1
> > +inplace=0
> > +rw=write
> > +numjobs=${NUM_JOBS}
> > +runtime=30*${TIME_FACTOR}
> > +time_based
> > +
> > +# Verifier
> > +[aio-dio-verifier]
> > +ioengine=libaio
> > +iodepth=128*${LOAD_FACTOR}
> > +numjobs=1
> > +verify=crc32c-intel
> > +verify_fatal=1
> > +verify_dump=1
> > +verify_backlog=1024
> > +verify_async=1
> > +verifysort=1
> > +direct=1
> > +bs=64k
> > +rw=randwrite
> > +filename=test1
> > +runtime=30*${TIME_FACTOR}
> > +time_based
> > +EOF
> > +
> > +_workout()
> > +{
> > +	echo ""
> > +	echo " Start defragment activity "
> git does not like trailing whitespace   ^
> (same for the other 3 tests)
> > +	echo ""
> > +	cat $tmp-$seq.fio >>  $seq.full
> > +	run_check $FIO_PROG $tmp-$seq.fio
> > +}
> > +
> > +_require_fio $tmp-$seq.fio
> > +
> > +_scratch_mkfs  >> $seq.full 2>&1
> > +_scratch_mount
> > +
> > +if ! _workout; then
> > +	umount $SCRATCH_DEV 2>/dev/null
> > +	exit
> > +fi
> > +
> > +if ! _scratch_unmount; then
> > +	echo "failed to umount"
> > +	status=1
> > +	exit
> > +fi
> > +_check_scratch_fs
> > +status=$?
> > +exit diff --git a/299.out b/299.out new file mode 100644 index 0000000..b215a3f
> > diff --git a/299.out b/299.out
> > new file mode 100644
> > index 0000000..c2b0b4c
> > --- /dev/null
> > +++ b/299.out
> > @@ -0,0 +1,4 @@
> > +QA output created by 299
> > +
> > + Start defragment activity
> remove trailing whitespace   ^
> (same for the other 3 tests)
> 
> Let me know if you agree with these changes and I will make them at 
> commit time.
Yes, please do.
> 
> Thanks
> --Rich
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
