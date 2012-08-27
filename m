Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7R9pKX3034103 for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 04:51:20 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	NcQB9h7nrAerfBbC (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 27 Aug 2012 02:52:09 -0700 (PDT)
Received: by obbwd18 with SMTP id wd18so5254685obb.26
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 02:52:09 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 27 Aug 2012 11:52:08 +0200
Message-ID: <CAFZPdfhbMU3uNDt8wWA3KbsgPg2s0g6e0LUGkHCmdn0vryB8kQ@mail.gmail.com>
Subject: Re: [PATCH] xfstests: test dump/restore of 32-bit projids
From: Boris Ranto <ranto.boris@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9221682229919272615=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Bill Kendall <wkendall@sgi.com>, xfs-oss <xfs@oss.sgi.com>

--===============9221682229919272615==
Content-Type: multipart/alternative; boundary=e89a8ff1c0d06f918e04c83c47a6

--e89a8ff1c0d06f918e04c83c47a6
Content-Type: text/plain; charset=ISO-8859-1

On Sun, 2012-08-26 at 22:27 -0500, Eric Sandeen wrote:
>Test that xfsdump/xfsrestore properly restores more than the
> bottom 16 bits of a 32-bit projid.
>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
>
> diff --git a/285 b/285
> new file mode 100755
> index 0000000..2804e5d
> --- /dev/null
> +++ b/285
> @@ -0,0 +1,81 @@
> +#! /bin/bash
> +# FS QA Test No. 285
> +#
> +# Test projid32: persist 32 bit projids thorugh dump/restore
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2012 Eric Sandeen.  All Rights Reserved.
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
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
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
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +    rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +. ./common.dump
> +. ./common.quota
> +
> +_require_scratch
> +_require_xfs_quota
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_supported_os IRIX Linux
> +
> +_scratch_mkfs_xfs -i projid32bit=1 >> $seq.full || _fail "mkfs failed"
> +
> +export MOUNT_OPTIONS="-opquota"
> +_qmount
> +_require_prjquota $SCRATCH_DEV
> +
> +# > 16 bit project ID
> +PROJID=2123456789
> +
> +# Put a project quota on a dir
> +mkdir $SCRATCH_MNT/dir
> +xfs_quota -x -c "project -s -p $SCRATCH_MNT/dir $PROJID" $SCRATCH_MNT >>
$seq.full || _fail "dir pquota failed"
> +
> +# Dump it then restore it to a fresh fs, and check the projid
> +rm -f $tmp.dumpfile
> +xfsdump -L label -M media -f $tmp.dumpfile $SCRATCH_MNT >> $seq.full ||
_fail "dump failed"
> +umount $SCRATCH_DEV
> +
> +_scratch_mkfs_xfs -i projid32bit=1 >> $seq.full || _fail "re-mkfs failed"
> +_qmount
> +xfsrestore -f $tmp.dumpfile $SCRATCH_MNT >> $seq.full || _fail "restore
failed"
> +
> +# check (-c) that we got the correct project ID back post-restore
> +xfs_quota -x -c "project -s -c -p $SCRATCH_MNT/dir $PROJID" $SCRATCH_MNT
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/285.out b/285.out
> new file mode 100644
> index 0000000..daf4e4c
> --- /dev/null
> +++ b/285.out
> @@ -0,0 +1,3 @@
> +QA output created by 285
> +Checking project 2123456790 (path /mnt/scratch/dir)...
> +Processed 1 (/etc/projects and cmdline) paths for project 2123456790
with recursion depth infinite (-1).
> diff --git a/group b/group
> index 104ed35..bbc74fe 100644
> --- a/group
> +++ b/group
> @@ -403,3 +403,4 @@ deprecated
>  282 dump ioctl auto quick
>  283 dump ioctl auto quick
>  284 auto
> +285 auto dump quota
>
>

I've been working on a xfstests projid32bit test case, too. It covers this
area + few others. I'll post that one, soon.

--e89a8ff1c0d06f918e04c83c47a6
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-08-26 at 22:27 -0500, Eric Sandeen wrote:<br>&gt;Test that xfs=
dump/xfsrestore properly restores more than the<br>&gt; bottom 16 bits of a=
 32-bit projid.<br>&gt; <br>&gt; Signed-off-by: Eric Sandeen &lt;<a href=3D=
"mailto:sandeen@sandeen.net">sandeen@sandeen.net</a>&gt;<br>
&gt; ---<br>&gt; <br>&gt; diff --git a/285 b/285<br>&gt; new file mode 1007=
55<br>&gt; index 0000000..2804e5d<br>&gt; --- /dev/null<br>&gt; +++ b/285<b=
r>&gt; @@ -0,0 +1,81 @@<br>&gt; +#! /bin/bash<br>&gt; +# FS QA Test No. 285=
<br>
&gt; +#<br>&gt; +# Test projid32: persist 32 bit projids thorugh dump/resto=
re<br>&gt; +#<br>&gt; +#---------------------------------------------------=
--------------------<br>&gt; +# Copyright (c) 2012 Eric Sandeen.=A0 All Rig=
hts Reserved.<br>
&gt; +#<br>&gt; +# This program is free software; you can redistribute it a=
nd/or<br>&gt; +# modify it under the terms of the GNU General Public Licens=
e as<br>&gt; +# published by the Free Software Foundation.<br>&gt; +#<br>
&gt; +# This program is distributed in the hope that it would be useful,<br=
>&gt; +# but WITHOUT ANY WARRANTY; without even the implied warranty of<br>=
&gt; +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.=A0 See the<br>
&gt; +# GNU General Public License for more details.<br>&gt; +#<br>&gt; +# =
You should have received a copy of the GNU General Public License<br>&gt; +=
# along with this program; if not, write the Free Software Foundation,<br>
&gt; +# Inc.,=A0 51 Franklin St, Fifth Floor, Boston, MA=A0 02110-1301=A0 U=
SA<br>&gt; +#--------------------------------------------------------------=
---------<br>&gt; +#<br>&gt; +# creator<br>&gt; +owner=3D<a href=3D"mailto:=
sandeen@sandeen.net">sandeen@sandeen.net</a><br>
&gt; +<br>&gt; +seq=3D`basename $0`<br>&gt; +echo &quot;QA output created b=
y $seq&quot;<br>&gt; +<br>&gt; +here=3D`pwd`<br>&gt; +tmp=3D/tmp/$$<br>&gt;=
 +status=3D1=A0=A0=A0 # failure is the default!<br>&gt; +trap &quot;_cleanu=
p; exit \$status&quot; 0 1 2 3 15<br>
&gt; +<br>&gt; +_cleanup()<br>&gt; +{<br>&gt; +=A0=A0=A0 cd /<br>&gt; +=A0=
=A0=A0 rm -f $tmp.*<br>&gt; +}<br>&gt; +<br>&gt; +# get standard environmen=
t, filters and checks<br>&gt; +. ./common.rc<br>&gt; +. ./common.filter<br>=
&gt; +. ./common.dump<br>
&gt; +. ./common.quota<br>&gt; +<br>&gt; +_require_scratch<br>&gt; +_requir=
e_xfs_quota<br>&gt; +<br>&gt; +# real QA test starts here<br>&gt; +<br>&gt;=
 +_supported_fs xfs<br>&gt; +_supported_os IRIX Linux<br>&gt; +<br>&gt; +_s=
cratch_mkfs_xfs -i projid32bit=3D1 &gt;&gt; $seq.full || _fail &quot;mkfs f=
ailed&quot;<br>
&gt; +<br>&gt; +export MOUNT_OPTIONS=3D&quot;-opquota&quot;<br>&gt; +_qmoun=
t<br>&gt; +_require_prjquota $SCRATCH_DEV<br>&gt; +<br>&gt; +# &gt; 16 bit =
project ID<br>&gt; +PROJID=3D2123456789<br>&gt; +<br>&gt; +# Put a project =
quota on a dir<br>
&gt; +mkdir $SCRATCH_MNT/dir<br>&gt; +xfs_quota -x -c &quot;project -s -p $=
SCRATCH_MNT/dir $PROJID&quot; $SCRATCH_MNT &gt;&gt; $seq.full || _fail &quo=
t;dir pquota failed&quot;<br>&gt; +<br>&gt; +# Dump it then restore it to a=
 fresh fs, and check the projid<br>
&gt; +rm -f $tmp.dumpfile<br>&gt; +xfsdump -L label -M media -f $tmp.dumpfi=
le $SCRATCH_MNT &gt;&gt; $seq.full || _fail &quot;dump failed&quot;<br>&gt;=
 +umount $SCRATCH_DEV<br>&gt; +<br>&gt; +_scratch_mkfs_xfs -i projid32bit=
=3D1 &gt;&gt; $seq.full || _fail &quot;re-mkfs failed&quot;<br>
&gt; +_qmount<br>&gt; +xfsrestore -f $tmp.dumpfile $SCRATCH_MNT &gt;&gt; $s=
eq.full || _fail &quot;restore failed&quot;<br>&gt; +<br>&gt; +# check (-c)=
 that we got the correct project ID back post-restore<br>&gt; +xfs_quota -x=
 -c &quot;project -s -c -p $SCRATCH_MNT/dir $PROJID&quot; $SCRATCH_MNT<br>
&gt; +<br>&gt; +# success, all done<br>&gt; +status=3D0<br>&gt; +exit<br>&g=
t; diff --git a/285.out b/285.out<br>&gt; new file mode 100644<br>&gt; inde=
x 0000000..daf4e4c<br>&gt; --- /dev/null<br>&gt; +++ b/285.out<br>&gt; @@ -=
0,0 +1,3 @@<br>
&gt; +QA output created by 285<br>&gt; +Checking project 2123456790 (path /=
mnt/scratch/dir)...<br>&gt; +Processed 1 (/etc/projects and cmdline) paths =
for project 2123456790 with recursion depth infinite (-1).<br>&gt; diff --g=
it a/group b/group<br>
&gt; index 104ed35..bbc74fe 100644<br>&gt; --- a/group<br>&gt; +++ b/group<=
br>&gt; @@ -403,3 +403,4 @@ deprecated<br>&gt;=A0 282 dump ioctl auto quick=
<br>&gt;=A0 283 dump ioctl auto quick<br>&gt;=A0 284 auto<br>&gt; +285 auto=
 dump quota<br>
&gt; <br>&gt; <br><br>I&#39;ve been working on a xfstests projid32bit test =
case, too. It covers this area + few others. I&#39;ll post that one, soon.<=
br>

--e89a8ff1c0d06f918e04c83c47a6--


--===============9221682229919272615==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9221682229919272615==--
