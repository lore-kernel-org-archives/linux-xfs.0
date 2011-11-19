Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAJDuY6R044228 for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 07:56:35 -0600
Received: from mail-ww0-f51.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A965F1D1E50A
	for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 05:56:32 -0800 (PST)
Received: from mail-ww0-f51.google.com (mail-ww0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id kAiAG26QHiKfjYBa
	for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 05:56:32 -0800 (PST)
Received: by wwe6 with SMTP id 6so5129877wwe.32
	for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 05:56:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321691055-1927-1-git-send-email-eguan@redhat.com>
References: <1321691055-1927-1-git-send-email-eguan@redhat.com>
From: Eryu Guan <guaneryu@gmail.com>
Date: Sat, 19 Nov 2011 21:56:10 +0800
Message-ID: <CA+dCu89-P1+4zr5KNn2s08Z3__ZYNgpy3NYNeNGYhnQ1eDQzDw@mail.gmail.com>
Subject: Re: [PATCH] xfstests: 276 test time before epoch is correct when
	re-read in from disk
Reply-To: guaneryu@gmail.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eryu Guan <eguan@redhat.com>
Cc: Christoph Hellwig <chellwig@redhat.com>, xfs@oss.sgi.com

On Sat, Nov 19, 2011 at 4:24 PM, Eryu Guan <eguan@redhat.com> wrote:
> This is a regression test case for commit
>
> 4d7bf11d649c72621ca31b8ea12b9c94af380e63
> ext2/3/4: fix file date underflow on ext2 3 filesystems on 64 bit systems

xfstests 258 tests exactly the same, sorry for the noise.

Eryu Guan
>
> On 64bit systems, unpatched extX doesn't sign-extend time values read
> in from disk. This results in times which should be before the epoch
> jumping forward in time. =A0For example:
>
> At creation, inode information still in memory.
> [root@cluster1 ~]# touch -t 196001010101 test.txt
> [root@cluster1 ~]# ls -l test.txt
> -rw-r--r-- 1 root root 0 Jan =A01 =A01960 test.txt
>
> After remount/reboot to force the values to be read in from disk:
> [root@cluster1 ~]# ls -l test.txt
> -rw-r--r-- 1 root root 0 Feb =A06 =A02096 test.txt
>
> When the time value was read in from disk, it wasn't sign extended so
> became a large, positive time value. =A0This doesn't occur on 32bit
> systems since the time is stored as 32bits on disk and thus doesn't
> need to be extended in size.
>
> Cc: Christoph Hellwig <chellwig@redhat.com>
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
> =A0276 =A0 =A0 | =A0 74 +++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++++++++
> =A0276.out | =A0 =A05 ++++
> =A0group =A0 | =A0 =A01 +
> =A03 files changed, 80 insertions(+), 0 deletions(-)
> =A0create mode 100755 276
> =A0create mode 100644 276.out
>
> diff --git a/276 b/276
> new file mode 100755
> index 0000000..7570977
> --- /dev/null
> +++ b/276
> @@ -0,0 +1,74 @@
> +#! /bin/bash
> +# FS QA Test No. 276
> +#
> +# Test time before epoch is correct when re-read in from disk.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2011 Red Hat, Inc. =A0All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =A0See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc., =A051 Franklin St, Fifth Floor, Boston, MA =A002110-1301 =A0USA
> +#-----------------------------------------------------------------------
> +#
> +# creator
> +owner=3Deguan@redhat.com
> +
> +seq=3D`basename $0`
> +echo "QA output created by $seq"
> +
> +status=3D1 =A0 =A0 =A0 # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> + =A0 =A0 =A0 cd /
> + =A0 =A0 =A0 rm -f $testfile
> + =A0 =A0 =A0 _scratch_unmount
> +}
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +
> +_require_scratch
> +_scratch_mkfs &>/dev/null
> +_scratch_mount
> +
> +testfile=3D$SCRATCH_MNT/testfile
> +
> +# set timestamp 1 second before epoch
> +touch -d @-1 $testfile
> +atime_1=3D`stat --format=3D%X $testfile`
> +mtime_1=3D`stat --format=3D%Y $testfile`
> +echo "atime after touch $atime_1"
> +echo "mtime after touch $mtime_1"
> +
> +# remount fs to force re-read in timestamp from disk
> +_scratch_remount
> +
> +atime_2=3D`stat --format=3D%X $testfile`
> +mtime_2=3D`stat --format=3D%Y $testfile`
> +echo "atime after remount $atime_2"
> +echo "mtime after remount $mtime_2"
> +
> +if [ "$atime_1" =3D "$atime_2" -a "$mtime_1" =3D "$mtime_2" ];then
> + =A0 =A0 =A0 status=3D0
> +fi
> +
> +exit
> diff --git a/276.out b/276.out
> new file mode 100644
> index 0000000..6e544ee
> --- /dev/null
> +++ b/276.out
> @@ -0,0 +1,5 @@
> +QA output created by 276
> +atime after touch -1
> +mtime after touch -1
> +atime after remount -1
> +mtime after remount -1
> diff --git a/group b/group
> index 08d999a..be4bd9b 100644
> --- a/group
> +++ b/group
> @@ -389,3 +389,4 @@ deprecated
> =A0273 auto rw
> =A0274 auto rw
> =A0275 auto rw
> +276 auto quick
> --
> 1.7.7.1
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
