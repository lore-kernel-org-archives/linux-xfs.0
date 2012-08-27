Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7RA3N2n035958 for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 05:03:23 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	PLkwnEF4w2MBKb1z (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 27 Aug 2012 03:04:12 -0700 (PDT)
Received: by obbwd18 with SMTP id wd18so5269582obb.26
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 03:04:12 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 27 Aug 2012 12:04:11 +0200
Message-ID: <CAFZPdfjeDGXfhAP4hnnrdA6Fpr18pEq6vH726HpfduPp6vw3-A@mail.gmail.com>
Subject: [PATCH] xfstests: Add test case to test xfs projid32bit functionality
	a bit more extensively.
From: Boris Ranto <ranto.boris@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8226077335731392969=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

--===============8226077335731392969==
Content-Type: multipart/alternative; boundary=f46d044785818691d004c83c72cf

--f46d044785818691d004c83c72cf
Content-Type: text/plain; charset=ISO-8859-1

 The test covers several areas including enabling projid32bit functionality
dynamically by xfs_admin, dumping, restoring, quota reporting and xfs_db
projid values reporting.
 At the time of creation, the test hit two bugs: one for broken
xfsdump/xfsrestore functionality and one for enabling projid32bit
functionality with xfs_admin on a LVM device (SCRATCH_DEV must be an LVM
device to hit this).

Signed-off-by: Boris Ranto <ranto.boris@gmail.com>
---
 285     |  151
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 285.out |   27 +++++++++++
 group   |    1 +
 3 files changed, 179 insertions(+), 0 deletions(-)
 create mode 100644 285
 create mode 100644 285.out

diff --git a/285 b/285
new file mode 100644
index 0000000..c700bdf
--- /dev/null
+++ b/285
@@ -0,0 +1,151 @@
+#! /bin/bash
+# FS QA Test No. 285
+#
+# Test to verify project quota xfs_admin, xfsdump/xfsrestore and
+# xfs_db functionality
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 Boris Ranto.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+# creator
+owner=borix60@gnamil.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+tmp=/tmp/$$
+here=`pwd`
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.quota
+
+_cleanup()
+{
+    cd /
+    umount $SCRATCH_MNT 2>/dev/null
+    losetup -d $lo_dev >/dev/null 2>&1
+    rm -rf $tmp.*
+}
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_quota
+_require_scratch
+_require_projid32bit
+
+export MOUNT_OPTIONS="-opquota"
+
+# create xfs fs without projid32bit ability, will be gained by xfs_admin
+_scratch_mkfs_xfs -i projid32bit=0 -d size=200m >> $seq.full || _fail
"mkfs failed"
+_qmount
+# require project quotas
+_require_prjquota $SCRATCH_DEV
+
+dir=$SCRATCH_MNT/pquota
+
+status=1
+
+mkdir -p $dir
+touch $dir/{16,32}less
+inode16a=$(ls -i $dir/16less|cut -d ' ' -f 1)
+inode32a=$(ls -i $dir/32less|cut -d ' ' -f 1)
+$XFS_QUOTA_PROG -x -c "project -s -p $dir/16less 1234" $SCRATCH_DEV \
+        >> $seq.full
+$XFS_QUOTA_PROG -x -c "project -s -p $dir/32less 2123456789" $SCRATCH_DEV \
+        >> $seq.full 2>&1
+# These will be checked by $seq.out
+echo "No 32bit project quotas:"
+$XFS_IO_PROG -r -c "lsproj" $dir/16less
+$XFS_IO_PROG -r -c "lsproj" $dir/32less
+
+umount $SCRATCH_MNT
+
+# Now, enable projid32bit support by xfs_admin
+xfs_admin -p $SCRATCH_DEV > /dev/null 2>&1
+echo "xfs_admin returned $?"
+
+# Now mount the fs, 32bit project quotas shall be supported, now
+_qmount
+$XFS_QUOTA_PROG -x -c "project -s -p $dir/32less 2123456789" $SCRATCH_DEV \
+        >> $seq.full
+
+# These will be checked by $seq.out
+echo "With 32bit project quota support:"
+$XFS_IO_PROG -r -c "lsproj" $dir/16less
+$XFS_IO_PROG -r -c "lsproj" $dir/32less
+
+# Dump the fs to a temporary file
+rm -f $tmp.dump.img
+$XFSDUMP_PROG -f $tmp.dump -L label -M media -l 0 $SCRATCH_MNT >>
$seq.full  || _fail "dump failed"
+echo "xfsdump returned $?"
+
+# Prepare the device to restore the dumped file system
+lo_dev=$(losetup -f)
+lo_img=$tmp.img
+lo_mnt=$tmp.dir
+lo_dir=$lo_mnt/pquota
+
+rm -f $lo_img
+mkdir -p $lo_mnt
+
+# Now, create the filesystem with projid32bit feature
+$XFS_IO_PROG -f -c 'truncate 1g' $lo_img
+losetup $lo_dev $lo_img
+$MKFS_XFS_PROG $lo_dev -i projid32bit=1 >> $seq.full
+mount $lo_dev $lo_mnt -opquota
+
+# Restore
+$XFSRESTORE_PROG -f $tmp.dump $lo_mnt > /dev/null 2>&1
+echo "xfsrestore returned $?"
+
+# Check that they are the same
+diff -urpN $SCRATCH_MNT $lo_mnt
+echo "diff returned $?"
+touch $lo_dir/32lessv2
+inode16b=$(ls -i $lo_dir/16less|cut -d ' ' -f 1)
+inode32b=$(ls -i $lo_dir/32less|cut -d ' ' -f 1)
+inode32v2=$(ls -i $lo_dir/32lessv2|cut -d ' ' -f 1)
+$XFS_QUOTA_PROG -x -c "project -s -p $lo_dir/32lessv2 2123456789" $lo_mnt \
+        >> $seq.full
+echo "The restored file system + one additional file:"
+$XFS_IO_PROG -r -c "lsproj" $lo_dir/16less
+$XFS_IO_PROG -r -c "lsproj" $lo_dir/32less
+$XFS_IO_PROG -r -c "lsproj" $lo_dir/32lessv2
+
+umount $SCRATCH_MNT
+umount $lo_mnt
+
+# Now, we can examine the file systems with xfs_db
+# These two should report the same values
+echo "These two values of 16bit project quota ids shall be the same"
+$XFS_DB_PROG -c "inode $inode16a" -c "print core.projid_lo" -c "print
core.projid_hi" $SCRATCH_DEV
+$XFS_DB_PROG -c "inode $inode16b" -c "print core.projid_lo" -c "print
core.projid_hi" $lo_dev
+
+# These three should report the same values
+echo "These three values of 32bit project quota ids shall be the same"
+$XFS_DB_PROG -c "inode $inode32a" -c "print core.projid_lo" -c "print
core.projid_hi" $SCRATCH_DEV
+$XFS_DB_PROG -c "inode $inode32b" -c "print core.projid_lo" -c "print
core.projid_hi" $lo_dev
+$XFS_DB_PROG -c "inode $inode32v2" -c "print core.projid_lo" -c "print
core.projid_hi" $lo_dev
+
+losetup -d $lo_dev
+rm -f $lo_img
+
+status=0
+exit
diff --git a/285.out b/285.out
new file mode 100644
index 0000000..a601452
--- /dev/null
+++ b/285.out
@@ -0,0 +1,27 @@
+QA output created by 285
+No 32bit project quotas:
+projid = 1234
+projid = 0
+xfs_admin returned 0
+With 32bit project quota support:
+projid = 1234
+projid = 2123456789
+xfsdump returned 0
+xfsrestore returned 0
+diff returned 0
+The restored file system + one additional file:
+projid = 1234
+projid = 2123456789
+projid = 2123456789
+These two values of 16bit project quota ids shall be the same
+core.projid_lo = 1234
+core.projid_hi = 0
+core.projid_lo = 1234
+core.projid_hi = 0
+These three values of 32bit project quota ids shall be the same
+core.projid_lo = 24853
+core.projid_hi = 32401
+core.projid_lo = 24853
+core.projid_hi = 32401
+core.projid_lo = 24853
+core.projid_hi = 32401
diff --git a/group b/group
index 104ed35..bbc74fe 100644
--- a/group
+++ b/group
@@ -403,3 +403,4 @@ deprecated
 282 dump ioctl auto quick
 283 dump ioctl auto quick
 284 auto
+285 auto dump quota
-- 
1.7.1

--f46d044785818691d004c83c72cf
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

=A0The test covers several areas including enabling projid32bit functionali=
ty dynamically by xfs_admin, dumping, restoring, quota reporting and xfs_db=
 projid values reporting.<br>=A0At the time of creation, the test hit two b=
ugs: one for broken xfsdump/xfsrestore functionality and one for enabling p=
rojid32bit functionality with xfs_admin on a LVM device (SCRATCH_DEV must b=
e an LVM device to hit this).<br>
<br>Signed-off-by: Boris Ranto &lt;<a href=3D"mailto:ranto.boris@gmail.com"=
>ranto.boris@gmail.com</a>&gt;<br>---<br>=A0285=A0=A0=A0=A0 |=A0 151 ++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++<br>=A0285.out |=
=A0=A0 27 +++++++++++<br>
=A0group=A0=A0 |=A0=A0=A0 1 +<br>=A03 files changed, 179 insertions(+), 0 d=
eletions(-)<br>=A0create mode 100644 285<br>=A0create mode 100644 285.out<b=
r><br>diff --git a/285 b/285<br>new file mode 100644<br>index 0000000..c700=
bdf<br>--- /dev/null<br>
+++ b/285<br>@@ -0,0 +1,151 @@<br>+#! /bin/bash<br>+# FS QA Test No. 285<br=
>+#<br>+# Test to verify project quota xfs_admin, xfsdump/xfsrestore and<br=
>+# xfs_db functionality<br>+#<br>+#---------------------------------------=
--------------------------------<br>
+# Copyright (c) 2012 Boris Ranto.=A0 All Rights Reserved.<br>+#<br>+# This=
 program is free software; you can redistribute it and/or<br>+# modify it u=
nder the terms of the GNU General Public License as<br>+# published by the =
Free Software Foundation.<br>
+#<br>+# This program is distributed in the hope that it would be useful,<b=
r>+# but WITHOUT ANY WARRANTY; without even the implied warranty of<br>+# M=
ERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.=A0 See the<br>+# GNU Ge=
neral Public License for more details.<br>
+#<br>+# You should have received a copy of the GNU General Public License<=
br>+# along with this program; if not, write the Free Software Foundation,<=
br>+# Inc.,=A0 51 Franklin St, Fifth Floor, Boston, MA=A0 02110-1301=A0 USA=
<br>
+#<br>+#-------------------------------------------------------------------=
----<br>+#<br>+# creator<br>+owner=3D<a href=3D"mailto:borix60@gnamil.com">=
borix60@gnamil.com</a><br>+<br>+seq=3D`basename $0`<br>+echo &quot;QA outpu=
t created by $seq&quot;<br>
+tmp=3D/tmp/$$<br>+here=3D`pwd`<br>+status=3D1=A0=A0=A0 # failure is the de=
fault!<br>+trap &quot;_cleanup; exit \$status&quot; 0 1 2 3 15<br>+<br>+# g=
et standard environment, filters and checks<br>+. ./common.rc<br>+. ./commo=
n.quota<br>
+<br>+_cleanup()<br>+{<br>+=A0=A0=A0 cd /<br>+=A0=A0=A0 umount $SCRATCH_MNT=
 2&gt;/dev/null<br>+=A0=A0=A0 losetup -d $lo_dev &gt;/dev/null 2&gt;&amp;1<=
br>+=A0=A0=A0 rm -rf $tmp.*<br>+}<br>+<br>+# real QA test starts here<br>+_=
supported_fs xfs<br>
+_require_xfs_quota<br>+_require_scratch<br>+_require_projid32bit<br>+<br>+=
export MOUNT_OPTIONS=3D&quot;-opquota&quot;<br>+<br>+# create xfs fs withou=
t projid32bit ability, will be gained by xfs_admin<br>+_scratch_mkfs_xfs -i=
 projid32bit=3D0 -d size=3D200m &gt;&gt; $seq.full || _fail &quot;mkfs fail=
ed&quot;<br>
+_qmount<br>+# require project quotas<br>+_require_prjquota $SCRATCH_DEV<br=
>+<br>+dir=3D$SCRATCH_MNT/pquota<br>+<br>+status=3D1<br>+<br>+mkdir -p $dir=
<br>+touch $dir/{16,32}less<br>+inode16a=3D$(ls -i $dir/16less|cut -d &#39;=
 &#39; -f 1)<br>
+inode32a=3D$(ls -i $dir/32less|cut -d &#39; &#39; -f 1)<br>+$XFS_QUOTA_PRO=
G -x -c &quot;project -s -p $dir/16less 1234&quot; $SCRATCH_DEV \<br>+=A0=
=A0=A0 =A0=A0=A0 &gt;&gt; $seq.full<br>+$XFS_QUOTA_PROG -x -c &quot;project=
 -s -p $dir/32less 2123456789&quot; $SCRATCH_DEV \<br>
+=A0=A0=A0 =A0=A0=A0 &gt;&gt; $seq.full 2&gt;&amp;1<br>+# These will be che=
cked by $seq.out<br>+echo &quot;No 32bit project quotas:&quot;<br>+$XFS_IO_=
PROG -r -c &quot;lsproj&quot; $dir/16less<br>+$XFS_IO_PROG -r -c &quot;lspr=
oj&quot; $dir/32less<br>
+<br>+umount $SCRATCH_MNT<br>+<br>+# Now, enable projid32bit support by xfs=
_admin<br>+xfs_admin -p $SCRATCH_DEV &gt; /dev/null 2&gt;&amp;1<br>+echo &q=
uot;xfs_admin returned $?&quot;<br>+<br>+# Now mount the fs, 32bit project =
quotas shall be supported, now<br>
+_qmount<br>+$XFS_QUOTA_PROG -x -c &quot;project -s -p $dir/32less 21234567=
89&quot; $SCRATCH_DEV \<br>+=A0=A0=A0 =A0=A0=A0 &gt;&gt; $seq.full<br>+<br>=
+# These will be checked by $seq.out<br>+echo &quot;With 32bit project quot=
a support:&quot;<br>
+$XFS_IO_PROG -r -c &quot;lsproj&quot; $dir/16less<br>+$XFS_IO_PROG -r -c &=
quot;lsproj&quot; $dir/32less<br>+<br>+# Dump the fs to a temporary file<br=
>+rm -f $tmp.dump.img<br>+$XFSDUMP_PROG -f $tmp.dump -L label -M media -l 0=
 $SCRATCH_MNT &gt;&gt; $seq.full=A0 || _fail &quot;dump failed&quot;<br>
+echo &quot;xfsdump returned $?&quot;<br>+<br>+# Prepare the device to rest=
ore the dumped file system<br>+lo_dev=3D$(losetup -f)<br>+lo_img=3D$tmp.img=
<br>+lo_mnt=3D$tmp.dir<br>+lo_dir=3D$lo_mnt/pquota<br>+<br>+rm -f $lo_img<b=
r>+mkdir -p $lo_mnt<br>
+<br>+# Now, create the filesystem with projid32bit feature<br>+$XFS_IO_PRO=
G -f -c &#39;truncate 1g&#39; $lo_img<br>+losetup $lo_dev $lo_img<br>+$MKFS=
_XFS_PROG $lo_dev -i projid32bit=3D1 &gt;&gt; $seq.full<br>+mount $lo_dev $=
lo_mnt -opquota<br>
+<br>+# Restore<br>+$XFSRESTORE_PROG -f $tmp.dump $lo_mnt &gt; /dev/null 2&=
gt;&amp;1<br>+echo &quot;xfsrestore returned $?&quot;<br>+<br>+# Check that=
 they are the same<br>+diff -urpN $SCRATCH_MNT $lo_mnt<br>+echo &quot;diff =
returned $?&quot;<br>
+touch $lo_dir/32lessv2<br>+inode16b=3D$(ls -i $lo_dir/16less|cut -d &#39; =
&#39; -f 1)<br>+inode32b=3D$(ls -i $lo_dir/32less|cut -d &#39; &#39; -f 1)<=
br>+inode32v2=3D$(ls -i $lo_dir/32lessv2|cut -d &#39; &#39; -f 1)<br>+$XFS_=
QUOTA_PROG -x -c &quot;project -s -p $lo_dir/32lessv2 2123456789&quot; $lo_=
mnt \<br>
+=A0=A0=A0 =A0=A0=A0 &gt;&gt; $seq.full<br>+echo &quot;The restored file sy=
stem + one additional file:&quot;<br>+$XFS_IO_PROG -r -c &quot;lsproj&quot;=
 $lo_dir/16less<br>+$XFS_IO_PROG -r -c &quot;lsproj&quot; $lo_dir/32less<br=
>+$XFS_IO_PROG -r -c &quot;lsproj&quot; $lo_dir/32lessv2<br>
+<br>+umount $SCRATCH_MNT<br>+umount $lo_mnt<br>+<br>+# Now, we can examine=
 the file systems with xfs_db<br>+# These two should report the same values=
<br>+echo &quot;These two values of 16bit project quota ids shall be the sa=
me&quot;<br>
+$XFS_DB_PROG -c &quot;inode $inode16a&quot; -c &quot;print core.projid_lo&=
quot; -c &quot;print core.projid_hi&quot; $SCRATCH_DEV<br>+$XFS_DB_PROG -c =
&quot;inode $inode16b&quot; -c &quot;print core.projid_lo&quot; -c &quot;pr=
int core.projid_hi&quot; $lo_dev<br>
+<br>+# These three should report the same values<br>+echo &quot;These thre=
e values of 32bit project quota ids shall be the same&quot;<br>+$XFS_DB_PRO=
G -c &quot;inode $inode32a&quot; -c &quot;print core.projid_lo&quot; -c &qu=
ot;print core.projid_hi&quot; $SCRATCH_DEV<br>
+$XFS_DB_PROG -c &quot;inode $inode32b&quot; -c &quot;print core.projid_lo&=
quot; -c &quot;print core.projid_hi&quot; $lo_dev<br>+$XFS_DB_PROG -c &quot=
;inode $inode32v2&quot; -c &quot;print core.projid_lo&quot; -c &quot;print =
core.projid_hi&quot; $lo_dev<br>
+<br>+losetup -d $lo_dev<br>+rm -f $lo_img<br>+<br>+status=3D0<br>+exit<br>=
diff --git a/285.out b/285.out<br>new file mode 100644<br>index 0000000..a6=
01452<br>--- /dev/null<br>+++ b/285.out<br>@@ -0,0 +1,27 @@<br>+QA output c=
reated by 285<br>
+No 32bit project quotas:<br>+projid =3D 1234<br>+projid =3D 0<br>+xfs_admi=
n returned 0<br>+With 32bit project quota support:<br>+projid =3D 1234<br>+=
projid =3D 2123456789<br>+xfsdump returned 0<br>+xfsrestore returned 0<br>+=
diff returned 0<br>
+The restored file system + one additional file:<br>+projid =3D 1234<br>+pr=
ojid =3D 2123456789<br>+projid =3D 2123456789<br>+These two values of 16bit=
 project quota ids shall be the same<br>+core.projid_lo =3D 1234<br>+core.p=
rojid_hi =3D 0<br>
+core.projid_lo =3D 1234<br>+core.projid_hi =3D 0<br>+These three values of=
 32bit project quota ids shall be the same<br>+core.projid_lo =3D 24853<br>=
+core.projid_hi =3D 32401<br>+core.projid_lo =3D 24853<br>+core.projid_hi =
=3D 32401<br>
+core.projid_lo =3D 24853<br>+core.projid_hi =3D 32401<br>diff --git a/grou=
p b/group<br>index 104ed35..bbc74fe 100644<br>--- a/group<br>+++ b/group<br=
>@@ -403,3 +403,4 @@ deprecated<br>=A0282 dump ioctl auto quick<br>=A0283 d=
ump ioctl auto quick<br>
=A0284 auto<br>+285 auto dump quota<br>-- <br>1.7.1<br><br>

--f46d044785818691d004c83c72cf--


--===============8226077335731392969==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8226077335731392969==--
