Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7A5Ce3s037670 for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 00:12:41 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8A9EB1E970
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2009 22:23:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id 3pf9qi4cbYPDXhwy for <xfs@oss.sgi.com>;
	Sun, 09 Aug 2009 22:23:22 -0700 (PDT)
Date: Mon, 10 Aug 2009 01:13:27 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <1871149413.1673471249881207275.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4A7C7C1C.2010202@redhat.com>
Subject: Re: [PATCH] xfstests: 220 - generic quota sanity
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

This looks good Eric.

Is this test just for quota accounting or should it be testing quota
enforcement too?

Lachlan

----- "Eric Sandeen" <sandeen@redhat.com> wrote:

> Add some very basic quota sanity tests for generic filesystems.
> 
> This is based on test 108, but uses the generic quota tools,
> not xfs_quota, and therefore cannot test project quota.
> 
> Also, the IOs are much smaller (48k) so that ext3 won't get into
> indirect blocks and throw off the accounting.  This does
> assume 4k blocks though.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/220 b/220
> new file mode 100755
> index 0000000..3b828cb
> --- /dev/null
> +++ b/220
> @@ -0,0 +1,123 @@
> +#! /bin/sh
> +# FS QA Test No. 220
> +#
> +# Simple quota accounting test for direct/buffered/mmap IO.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2009 Eric Sandeen.  All Rights Reserved.
> +#
> +# Based on test 108,
> +# Copyright (c) 2005 Silicon Graphics, Inc.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software
> Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#
> +#-----------------------------------------------------------------------
> +#
> +# creator
> +owner=sandeen@sandeen.net
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +. ./common.quota
> +
> +filter_scratch()
> +{
> +	perl -ne "
> +s,$SCRATCH_MNT,[SCR_MNT],;
> +s,$SCRATCH_DEV,[SCR_DEV],;
> +	print;"
> +}
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux #IRIX
> +_require_scratch
> +_require_quota
> +
> +test_files()
> +{
> +	echo; echo "### create files, setting up ownership (type=$type)"
> +	rm -f $SCRATCH_MNT/{buffer,direct,mmap}
> +	touch $SCRATCH_MNT/{buffer,direct,mmap}
> +	chown $uid $SCRATCH_MNT/{buffer,direct,mmap}
> +	chgrp $gid $SCRATCH_MNT/{buffer,direct,mmap}
> +	for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
> +		$here/src/lstat64 $file | head -3 | filter_scratch
> +	done
> +}
> +
> +test_accounting()
> +{
> +	echo "### some controlled buffered, direct and mmapd IO
> (type=$type)"
> +	echo "--- initiating parallel IO..." >>$seq.full
> +	# Small ios here because ext3 will account for indirect blocks too
> ...   :( 
> +	# 48k will fit w/o indirect for 4k blocks (default blocksize)
> +	$XFS_IO_PROG -F -c 'pwrite 0 48k' -c 'fsync' \
> +					$SCRATCH_MNT/buffer >>$seq.full 2>&1 &
> +	$XFS_IO_PROG -F -c 'pwrite 0 48k' -d \
> +					$SCRATCH_MNT/direct >>$seq.full 2>&1 &
> +	$XFS_IO_PROG -F -c 't 48k' -c 'mm -rw 0 48k' -c 'mw 0 48k' -c 'ms
> -s' \
> +					$SCRATCH_MNT/mmap   >>$seq.full 2>&1 &
> +	wait
> +	echo "--- completed parallel IO ($type)" >>$seq.full
> +
> +	for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
> +		$here/src/lstat64 $file | head -3 | filter_scratch
> +	done
> +
> +	repquota -$type -s -n $SCRATCH_MNT  | grep -v "^#0" |
> filter_scratch
> +}
> +
> +# real QA test starts here
> +rm -f $seq.full
> +
> +uid=1
> +gid=2
> +
> +umount $SCRATCH_DEV 2>/dev/null
> +_scratch_mkfs >> $seq.full 2>&1
> +_scratch_mount "-o usrquota,grpquota"
> +quotacheck -u -g $SCRATCH_MNT 2>/dev/null
> +quotaon $SCRATCH_MNT 2>/dev/null
> +umount $SCRATCH_DEV
> +
> +echo; echo "### test user accounting"
> +export MOUNT_OPTIONS="-o usrquota"
> +_qmount
> +quotaon $SCRATCH_MNT 2>/dev/null
> +type=u
> +test_files
> +test_accounting
> +umount $SCRATCH_DEV 2>/dev/null
> +
> +echo; echo "### test group accounting"
> +export MOUNT_OPTIONS="-o grpquota"
> +_qmount
> +quotaon $SCRATCH_MNT 2>/dev/null
> +type=g
> +test_files
> +test_accounting
> +umount $SCRATCH_DEV 2>/dev/null
> +
> +status=0
> +exit
> diff --git a/220.out b/220.out
> new file mode 100644
> index 0000000..57db113
> --- /dev/null
> +++ b/220.out
> @@ -0,0 +1,63 @@
> +QA output created by 220
> +
> +### test user accounting
> +
> +### create files, setting up ownership (type=u)
> +  File: "[SCR_MNT]/buffer"
> +  Size: 0            Filetype: Regular File
> +  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
> +  File: "[SCR_MNT]/direct"
> +  Size: 0            Filetype: Regular File
> +  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
> +  File: "[SCR_MNT]/mmap"
> +  Size: 0            Filetype: Regular File
> +  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
> +### some controlled buffered, direct and mmapd IO (type=u)
> +  File: "[SCR_MNT]/buffer"
> +  Size: 53248        Filetype: Regular File
> +  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
> +  File: "[SCR_MNT]/direct"
> +  Size: 53248        Filetype: Regular File
> +  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
> +  File: "[SCR_MNT]/mmap"
> +  Size: 53248        Filetype: Regular File
> +  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
> +*** Report for user quotas on device [SCR_DEV]
> +Block grace time: 7days; Inode grace time: 7days
> +                        Block limits                File limits
> +User            used    soft    hard  grace    used  soft  hard 
> grace
> +----------------------------------------------------------------------
> +#1        --     168       0       0              3     0     0      
> 
> +
> +
> +
> +### test group accounting
> +
> +### create files, setting up ownership (type=g)
> +  File: "[SCR_MNT]/buffer"
> +  Size: 0            Filetype: Regular File
> +  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
> +  File: "[SCR_MNT]/direct"
> +  Size: 0            Filetype: Regular File
> +  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
> +  File: "[SCR_MNT]/mmap"
> +  Size: 0            Filetype: Regular File
> +  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
> +### some controlled buffered, direct and mmapd IO (type=g)
> +  File: "[SCR_MNT]/buffer"
> +  Size: 53248        Filetype: Regular File
> +  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
> +  File: "[SCR_MNT]/direct"
> +  Size: 53248        Filetype: Regular File
> +  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
> +  File: "[SCR_MNT]/mmap"
> +  Size: 53248        Filetype: Regular File
> +  Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
> +*** Report for group quotas on device [SCR_DEV]
> +Block grace time: 7days; Inode grace time: 7days
> +                        Block limits                File limits
> +Group           used    soft    hard  grace    used  soft  hard 
> grace
> +----------------------------------------------------------------------
> +#2        --     168       0       0              3     0     0      
> 
> +
> +
> diff --git a/common.quota b/common.quota
> index a9dfb42..e2a7872 100644
> --- a/common.quota
> +++ b/common.quota
> @@ -21,14 +21,27 @@
>  #
>  
>  #
> -# checks that the XFS quota support in the kernel is enabled
> +# checks that the generic quota support in the kernel is enabled
>  # and that we have valid quota user tools installed.
>  #
>  _require_quota()
>  {
> +    [ -x /usr/bin/quota ] || _notrun "Quota user tools not
> installed"
> +    _scratch_mount "-o usrquota,grpquota"
> +    ret=$?
> +    umount $SCRATCH_MNT
> +    [ $ret -ne 0 ] && _notrun "Installed kernel does not support
> quota"
> +}
> +
> +#
> +# checks that the XFS quota support in the kernel is enabled
> +# and that we have valid quota user tools installed.
> +#
> +_require_xfs_quota()
> +{
>      src/feature -q $TEST_DEV
>      [ $? -ne 0 ] && _notrun "Installed kernel does not support XFS
> quota"
> -    [ -x /usr/sbin/xfs_quota ] || _notrun "Quota user tools not
> installed"
> +    [ -x /usr/sbin/xfs_quota ] || _notrun "XFS quota user tools not
> installed"
>  }
>  
>  #
> diff --git a/group b/group
> index e068e92..1fc280f 100644
> --- a/group
> +++ b/group
> @@ -328,3 +328,4 @@ prealloc
>  217 log metadata auto
>  218 auto fsr quick
>  219 auto
> +220 auto quota
> 
> diff --git a/050 b/050
> index abb806a..306a7b5 100755
> --- a/050
> +++ b/050
> @@ -55,7 +55,7 @@ cp /dev/null $seq.full
>  chmod a+rwx $seq.full	# arbitrary users will write here
>  
>  _require_scratch
> -_require_quota
> +_require_xfs_quota
>  
>  bsoft=100
>  bhard=500
> diff --git a/052 b/052
> index 16c78de..3d8bb9e 100755
> --- a/052
> +++ b/052
> @@ -54,7 +54,7 @@ _supported_os IRIX Linux
>  rm -f $seq.full
>  
>  _require_scratch
> -_require_quota
> +_require_xfs_quota
>  _require_nobody
>  
>  # setup a default run
> diff --git a/054 b/054
> index b495e51..b38efab 100755
> --- a/054
> +++ b/054
> @@ -52,7 +52,7 @@ cp /dev/null $seq.full
>  chmod ugo+rwx $seq.full
>  
>  _require_scratch
> -_require_quota
> +_require_xfs_quota
>  
>  _filter_stat()
>  {
> diff --git a/081 b/081
> index 3036484..c8eba80 100755
> --- a/081
> +++ b/081
> @@ -54,7 +54,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  # prelim
>  rm -f $seq.full $tmp.*
>  _require_scratch
> -_require_quota
> +_require_xfs_quota
>  _require_v2log
>   
>  echo "*** init FS"
> diff --git a/106 b/106
> index 7154979..30f740b 100755
> --- a/106
> +++ b/106
> @@ -42,7 +42,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  _supported_fs xfs
>  _supported_os Linux #IRIX
>  _require_scratch
> -_require_quota
> +_require_xfs_quota
>  _require_prjquota
>  
>  # real QA test starts here
> diff --git a/107 b/107
> index cfa8213..f36dc21 100755
> --- a/107
> +++ b/107
> @@ -54,7 +54,7 @@ s/Inode: \#\d+ \(\d+ blocks, \d+ extents\)/Inode:
> #[INO] (X blocks, Y extents)/;
>  _supported_fs xfs
>  _supported_os Linux #IRIX
>  _require_scratch
> -_require_quota
> +_require_xfs_quota
>  _require_prjquota
>  
>  # real QA test starts here
> diff --git a/108 b/108
> index 3f3e1fb..3a1fee9 100755
> --- a/108
> +++ b/108
> @@ -49,7 +49,7 @@ s,$SCRATCH_DEV,[SCR_DEV],;
>  _supported_fs xfs
>  _supported_os Linux #IRIX
>  _require_scratch
> -_require_quota
> +_require_xfs_quota
>  _require_prjquota
>  
>  test_files()
> diff --git a/116 b/116
> index 8394054..e902ce9 100755
> --- a/116
> +++ b/116
> @@ -51,7 +51,7 @@ _supported_fs xfs
>  _supported_os IRIX Linux
>  
>  _require_scratch
> -_require_quota
> +_require_xfs_quota
>  
>  mkfs.xfs -f $SCRATCH_DEV >/dev/null 2>&1
>  mount -o uquota $SCRATCH_DEV $SCRATCH_MNT
> diff --git a/118 b/118
> index 6b28055..cb0e5ee 100755
> --- a/118
> +++ b/118
> @@ -52,7 +52,7 @@ _supported_fs xfs
>  _supported_os IRIX Linux
>  
>  _require_scratch
> -_require_quota
> +_require_xfs_quota
>  
>  _chowning_file()
>  {
> diff --git a/134 b/134
> index fc2ab74..f00e1f0 100755
> --- a/134
> +++ b/134
> @@ -50,7 +50,7 @@ _cleanup()
>  _supported_fs xfs
>  _supported_os Linux IRIX
>  
> -_require_quota
> +_require_xfs_quota
>  
>  dir=$SCRATCH_MNT/project
>  
> diff --git a/196 b/196
> index 7768618..5da3659 100755
> --- a/196
> +++ b/196
> @@ -51,7 +51,7 @@ _supported_fs xfs
>  _supported_os Linux
>  
>  _require_scratch
> -_require_quota
> +_require_xfs_quota
>  
>  #
>  # Setup temporary replacements for /etc/projects and /etc/projid
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
