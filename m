Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6B2EF29DF8
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 22:03:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 57C668F8037
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 20:03:39 -0700 (PDT)
Received: from mail-vc0-f175.google.com (mail-vc0-f175.google.com
	[209.85.220.175]) by cuda.sgi.com with ESMTP id
	kqBxkAb56agyzrMR (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 May 2013 20:03:37 -0700 (PDT)
Received: by mail-vc0-f175.google.com with SMTP id lf10so3329536vcb.34
	for <xfs@oss.sgi.com>; Thu, 09 May 2013 20:03:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <518C1D08.4080309@redhat.com>
References: <518C1D08.4080309@redhat.com>
From: Eryu Guan <guaneryu@gmail.com>
Date: Fri, 10 May 2013 11:03:17 +0800
Message-ID: <CA+dCu8_DtrqMy97u9NfHwCC8_-z9uSrF1oR3B=ej15gL6C=W+Q@mail.gmail.com>
Subject: Re: [PATCH] xfstests: regression test for ext4 resize with non-extent
	files
Reply-To: guaneryu@gmail.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7530362613810048636=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

--===============7530362613810048636==
Content-Type: multipart/alternative; boundary=bcaec547c9efcdbb5204dc546979

--bcaec547c9efcdbb5204dc546979
Content-Type: text/plain; charset=ISO-8859-1

On Fri, May 10, 2013 at 6:02 AM, Eric Sandeen <sandeen@redhat.com> wrote:

> Regression test for:
>
> c5c72d8 ext4: fix online resizing for ext3-compat file systems
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> diff --git a/tests/ext4/306 b/tests/ext4/306
> new file mode 100755
> index 0000000..6a961ee
> --- /dev/null
> +++ b/tests/ext4/306
> @@ -0,0 +1,83 @@
> +#! /bin/bash
> +# FS QA Test No. ext4/306
> +#
> +# Test that blocks are available to non-extent files after a resize2fs
> +# Regression test for commit:
> +# c5c72d8 ext4: fix online resizing for ext3-compat file systems
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +PIDS=""
> +status=1       # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    _scratch_unmount
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs ext4
> +_supported_os Linux
> +
> +_require_scratch
> +
> +# This needs to mount ext3; might require ext3 driver, or ext4
> +# might handle it itself.  Find out if we have it one way or another.
> +modprobe ext3 > /dev/null 2>&1
> +grep -q ext3 /proc/filesystems || _notrun "This test requires ext3
> support"
> +
> +rm -f $seqres.full
> +echo "Silence is golden"
>

The test has verbose output log, so "Silence is golden" is not true here,
remove this line or redirect other echo to $seqres.full ?

> +
> +# Make a small ext3 fs, (extents disabled) & mount it
> +yes | mkfs.ext3 $SCRATCH_DEV 512m >> $seqres.full 2>&1
> +_scratch_mount -t ext3 || _fail "couldn't mount fs as ext3"
> +# Create a small non-extent-based file
> +echo "Create 1m testfile1"
> +$XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c "pwrite 0 1m" | _filter_xfs_io
> +echo "Create testfile2 to fill the fs"
> +# A large non-extent-based file filling the fs; this will run out & fail
> +$XFS_IO_PROG -f $SCRATCH_MNT/testfile2 -c "pwrite 0 512m" | _filter_xfs_io
> +
> +# Remount as ext4
> +_scratch_unmount
> +_scratch_mount -t ext4 || _fail "couldn't remount fs as ext4"
> +df -h $SCRATCH_MNT >> $seqres.full
> +
> +# Grow it by 512m
> +echo "Resize to 1g"
> +resize2fs $SCRATCH_DEV 1g >> $seqres.full 2>&1 || _fail "Could not resize
> to 1g"
> +df -h $SCRATCH_MNT >> $seqres.full
> +
> +# See if we can add more blocks to the files
> +echo "append 2m to testfile1"
> +$XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c "pwrite 1m 2m" | _filter_xfs_io
> +echo "append 2m to testfile2"
> +$XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c "pwrite 512m 2m" |
> _filter_xfs_io
> +
> +status=0
> +exit
> diff --git a/tests/ext4/306.out b/tests/ext4/306.out
> new file mode 100644
> index 0000000..654637d
> --- /dev/null
> +++ b/tests/ext4/306.out
> @@ -0,0 +1,14 @@
> +QA output created by 306
> +Silence is golden
> +Create 1m testfile1
> +wrote 1048576/1048576 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +Create testfile2 to fill the fs
> +pwrite64: No space left on device
> +Resize to 1g
> +append 2m to testfile1
> +wrote 2097152/2097152 bytes at offset 1048576
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +append 2m to testfile2
> +wrote 2097152/2097152 bytes at offset 536870912
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> diff --git a/tests/ext4/group b/tests/ext4/group
> index 53af708..4c3e2f4 100644
> --- a/tests/ext4/group
> +++ b/tests/ext4/group
> @@ -9,3 +9,4 @@
>  303 aio dangerous ioctl rw stress
>  304 aio dangerous ioctl rw stress
>  305 auto
> +306 dangerous rw resize quick
>

I'm wondering why it's not in auto group :)

Otherwise patch looks good to me.

Eryu Guan

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--bcaec547c9efcdbb5204dc546979
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra">On Fri, May 10, 2013 at 6:02 AM=
, Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@redhat.com" =
target=3D"_blank">sandeen@redhat.com</a>&gt;</span> wrote:<br><div class=3D=
"gmail_quote">

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Regression test for:<br>
<br>
c5c72d8 ext4: fix online resizing for ext3-compat file systems<br>
<br>
Signed-off-by: Eric Sandeen &lt;<a href=3D"mailto:sandeen@redhat.com">sande=
en@redhat.com</a>&gt;<br>
---<br>
<br>
diff --git a/tests/ext4/306 b/tests/ext4/306<br>
new file mode 100755<br>
index 0000000..6a961ee<br>
--- /dev/null<br>
+++ b/tests/ext4/306<br>
@@ -0,0 +1,83 @@<br>
+#! /bin/bash<br>
+# FS QA Test No. ext4/306<br>
+#<br>
+# Test that blocks are available to non-extent files after a resize2fs<br>
+# Regression test for commit:<br>
+# c5c72d8 ext4: fix online resizing for ext3-compat file systems<br>
+#<br>
+#-----------------------------------------------------------------------<b=
r>
+# Copyright (c) 2013 Red Hat, Inc. =A0All Rights Reserved.<br>
+#<br>
+# This program is free software; you can redistribute it and/or<br>
+# modify it under the terms of the GNU General Public License as<br>
+# published by the Free Software Foundation.<br>
+#<br>
+# This program is distributed in the hope that it would be useful,<br>
+# but WITHOUT ANY WARRANTY; without even the implied warranty of<br>
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =A0See the<br>
+# GNU General Public License for more details.<br>
+#<br>
+# You should have received a copy of the GNU General Public License<br>
+# along with this program; if not, write the Free Software Foundation,<br>
+# Inc., =A051 Franklin St, Fifth Floor, Boston, MA =A002110-1301 =A0USA<br=
>
+#-----------------------------------------------------------------------<b=
r>
+<br>
+seq=3D`basename $0`<br>
+seqres=3D$RESULT_DIR/$seq<br>
+echo &quot;QA output created by $seq&quot;<br>
+<br>
+PIDS=3D&quot;&quot;<br>
+status=3D1 =A0 =A0 =A0 # failure is the default!<br>
+trap &quot;_cleanup; exit \$status&quot; 0 1 2 3 15<br>
+<br>
+_cleanup()<br>
+{<br>
+ =A0 =A0_scratch_unmount<br>
+}<br>
+<br>
+# get standard environment, filters and checks<br>
+. ./common/rc<br>
+. ./common/filter<br>
+<br>
+# real QA test starts here<br>
+_supported_fs ext4<br>
+_supported_os Linux<br>
+<br>
+_require_scratch<br>
+<br>
+# This needs to mount ext3; might require ext3 driver, or ext4<br>
+# might handle it itself. =A0Find out if we have it one way or another.<br=
>
+modprobe ext3 &gt; /dev/null 2&gt;&amp;1<br>
+grep -q ext3 /proc/filesystems || _notrun &quot;This test requires ext3 su=
pport&quot;<br>
+<br>
+rm -f $seqres.full<br>
+echo &quot;Silence is golden&quot;<br></blockquote><div><br>The test has v=
erbose output log, so &quot;Silence is golden&quot; is not true here, remov=
e this line or redirect other echo to $seqres.full ? <br></div><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">


+<br>
+# Make a small ext3 fs, (extents disabled) &amp; mount it<br>
+yes | mkfs.ext3 $SCRATCH_DEV 512m &gt;&gt; $seqres.full 2&gt;&amp;1<br>
+_scratch_mount -t ext3 || _fail &quot;couldn&#39;t mount fs as ext3&quot;<=
br>
+# Create a small non-extent-based file<br>
+echo &quot;Create 1m testfile1&quot;<br>
+$XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c &quot;pwrite 0 1m&quot; | _filte=
r_xfs_io<br>
+echo &quot;Create testfile2 to fill the fs&quot;<br>
+# A large non-extent-based file filling the fs; this will run out &amp; fa=
il<br>
+$XFS_IO_PROG -f $SCRATCH_MNT/testfile2 -c &quot;pwrite 0 512m&quot; | _fil=
ter_xfs_io<br>
+<br>
+# Remount as ext4<br>
+_scratch_unmount<br>
+_scratch_mount -t ext4 || _fail &quot;couldn&#39;t remount fs as ext4&quot=
;<br>
+df -h $SCRATCH_MNT &gt;&gt; $seqres.full<br>
+<br>
+# Grow it by 512m<br>
+echo &quot;Resize to 1g&quot;<br>
+resize2fs $SCRATCH_DEV 1g &gt;&gt; $seqres.full 2&gt;&amp;1 || _fail &quot=
;Could not resize to 1g&quot;<br>
+df -h $SCRATCH_MNT &gt;&gt; $seqres.full<br>
+<br>
+# See if we can add more blocks to the files<br>
+echo &quot;append 2m to testfile1&quot;<br>
+$XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c &quot;pwrite 1m 2m&quot; | _filt=
er_xfs_io<br>
+echo &quot;append 2m to testfile2&quot;<br>
+$XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c &quot;pwrite 512m 2m&quot; | _fi=
lter_xfs_io<br>
+<br>
+status=3D0<br>
+exit<br>
diff --git a/tests/ext4/306.out b/tests/ext4/306.out<br>
new file mode 100644<br>
index 0000000..654637d<br>
--- /dev/null<br>
+++ b/tests/ext4/306.out<br>
@@ -0,0 +1,14 @@<br>
+QA output created by 306<br>
+Silence is golden<br>
+Create 1m testfile1<br>
+wrote 1048576/1048576 bytes at offset 0<br>
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)<br>
+Create testfile2 to fill the fs<br>
+pwrite64: No space left on device<br>
+Resize to 1g<br>
+append 2m to testfile1<br>
+wrote 2097152/2097152 bytes at offset 1048576<br>
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)<br>
+append 2m to testfile2<br>
+wrote 2097152/2097152 bytes at offset 536870912<br>
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)<br>
diff --git a/tests/ext4/group b/tests/ext4/group<br>
index 53af708..4c3e2f4 100644<br>
--- a/tests/ext4/group<br>
+++ b/tests/ext4/group<br>
@@ -9,3 +9,4 @@<br>
=A0303 aio dangerous ioctl rw stress<br>
=A0304 aio dangerous ioctl rw stress<br>
=A0305 auto<br>
+306 dangerous rw resize quick<br></blockquote><div><br>I&#39;m wondering w=
hy it&#39;s not in auto group :)<br><br></div><div>Otherwise patch looks go=
od to me.<br><br>Eryu Guan <br></div><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">


<br>
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe linux-ext4&q=
uot; in<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org">major=
domo@vger.kernel.org</a><br>
More majordomo info at =A0<a href=3D"http://vger.kernel.org/majordomo-info.=
html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a><br>
</blockquote></div><br></div></div>

--bcaec547c9efcdbb5204dc546979--


--===============7530362613810048636==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7530362613810048636==--
