Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7NKgAfq066065 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 15:42:10 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	k2xY7eHcnEGuzHdF (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Aug 2012 13:42:56 -0700 (PDT)
Received: by obbup19 with SMTP id up19so3073761obb.26
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 13:42:56 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 23 Aug 2012 22:42:56 +0200
Message-ID: <CAFZPdfipr3FkLJ3B7zDPXRA5Nw3Qerpri05gsnJopyMQwQfGUw@mail.gmail.com>
Subject: [RFE] xfstests: Add support for tmpfs filesystem
From: Boris Ranto <ranto.boris@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5715424960031614819=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5715424960031614819==
Content-Type: multipart/alternative; boundary=e89a8f6434ec76a9a804c7f4e768

--e89a8f6434ec76a9a804c7f4e768
Content-Type: text/plain; charset=ISO-8859-1

This is resent with the improved subject line.
This is just a simple patch to get the tmpfs working. I've made the full
xfstests run with the tmpfs as the target filesystem and it works quite
well. Some tests passed properly, some tests failed (and some of them due
to the nature of tmpfs).

I didn't change the xfstests logic to recognize a proper SCRATCH_DEV so the
SCRATCH_DEV for tmpfs should be in the nfs form (with the : in it) for this
to work properly.

diff --git a/common b/common
index 0723224..5853602 100644
--- a/common
+++ b/common
@@ -126,6 +126,7 @@ check options
     -xfs                test XFS (default)
     -udf                test UDF
     -nfs                test NFS
+    -tmpfs              test TMPFS
     -l            line mode diff
     -xdiff        graphical mode diff
     -udiff        show unified diff (default)
@@ -158,6 +159,11 @@ testlist options
         xpand=false
         ;;

+    -tmpfs)    # -tmpfs ... set FSTYP to tmpfs
+        FSTYP=tmpfs
+        xpand=false
+        ;;
+
     -g)    # -g group ... pick from group file
         group=true
         xpand=false
diff --git a/common.rc b/common.rc
index 602513a..a1351c9 100644
--- a/common.rc
+++ b/common.rc
@@ -97,6 +97,10 @@ _mount_opts()
     # acls aren't turned on by default on gfs2
     export MOUNT_OPTIONS="-o acl $GFS2_MOUNT_OPTIONS"
     ;;
+    tmpfs)
+    # We need to specify the size at mount, use 512 MB by default
+    export MOUNT_OPTIONS="-o size=512M $TMPFS_MOUNT_OPTIONS"
+    ;;
     *)
     ;;
     esac
@@ -116,6 +120,9 @@ _mkfs_opts()
     nfs)
     export MKFS_OPTIONS=$NFS_MKFS_OPTIONS
     ;;
+    tmpfs)
+    export MKFS_OPTIONS=$TMPFS_MKFS_OPTIONS
+    ;;
     reiserfs)
     export MKFS_OPTIONS="$REISERFS_MKFS_OPTIONS -q"
     ;;
@@ -327,6 +334,9 @@ _scratch_mkfs()
     nfs*)
     # do nothing for nfs
     ;;
+    tmpfs)
+    # do nothing for tmpfs
+    ;;
     udf)
         $MKFS_UDF_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
     ;;
@@ -736,6 +746,12 @@ _require_scratch()
              _notrun "this test requires a valid \$SCRATCH_DEV"
          fi
          ;;
+    tmpfs)
+        if [ -z "$SCRATCH_DEV" -o ! -d "$SCRATCH_MNT" ];
+        then
+            _notrun "this test requires a valid \$SCRATCH_MNT and unique
$SCRATCH_DEV"
+        fi
+        ;;
     *)
          if [ -z "$SCRATCH_DEV" -o "`_is_block_dev $SCRATCH_DEV`" = "" ]
          then
@@ -1394,6 +1410,9 @@ _check_test_fs()
     nfs)
     # no way to check consistency for nfs
     ;;
+    tmpfs)
+        # no way to check the consistency for tmpfs
+    ;;
     udf)
     # do nothing for now
     ;;
@@ -1426,6 +1445,9 @@ _check_scratch_fs()
     nfs*)
     # Don't know how to check an NFS filesystem, yet.
     ;;
+    tmpfs)
+    # No way to check the consistency of tmpfs
+    ;;
     btrfs)
     _check_btrfs_filesystem $SCRATCH_DEV
     ;;
@@ -1517,6 +1539,33 @@ _setup_nfs_scratchdir()
     testdir=$SCRATCH_MNT
 }

+_setup_tmpfs_scratchdir()
+{
+    [ "$FSTYP" != "tmpfs" ] \
+        && _fail "setup_tmpfs_testdir: \$FSTYP is not tmpfs"
+    [ -z "$SCRATCH_DEV" ] \
+    && _notrun "this test requires a valid host fs for \$SCRATCH_DEV"
+    [ -z "$SCRATCH_MNT" ] \
+    && _notrun "this test requires a valid \$SCRATCH_MNT"
+
+    # mounted?
+    if _mount | grep -q $SCRATCH_DEV
+    then
+        # if it's mounted, make sure its on $SCRATCH_MNT
+        if ! _mount | grep $SCRATCH_DEV | grep -q $SCRATCH_MNT
+        then
+            _fail "\$SCRATCH_DEV is mounted but not on \$SCRATCH_MNT -
aborting"
+        fi
+        $UMOUNT_PROG $SCRATCH_DEV
+    fi
+
+    _scratch_mkfs
+    _scratch_mount
+
+    testdir=$SCRATCH_MNT
+}
+
+
 #
 # Warning for UDF and NFS:
 # this function calls _setup_udf_scratchdir and _setup_udf_scratchdir
@@ -1535,6 +1584,9 @@ _setup_testdir()
     nfs*)
     _setup_nfs_scratchdir
     ;;
+    tmpfs)
+    _setup_tmpfs_scratchdir
+    ;;
     *)
     testdir=$TEST_DIR
     ;;
@@ -1552,6 +1604,10 @@ _cleanup_testdir()
     # umount testdir as it is $SCRATCH_MNT which could be used by xfs next
     [ -n "$testdir" ] && $UMOUNT_PROG $testdir
     ;;
+    tmpfs)
+    # umount testdir since it is actually a scrath mount
+    [ -n "$testdir" ] && $UMOUNT_PROG $testdir
+    ;;
     *)
     # do nothing, testdir is $TEST_DIR
     :

Signed-off-by: Boris Ranto <ranto.boris@gmail.com>

--e89a8f6434ec76a9a804c7f4e768
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

This is resent with the improved subject line.<br>This is just a simple pat=
ch to get the tmpfs working. I&#39;ve made the full xfstests run with the t=
mpfs as the target filesystem and it works quite well. Some tests passed pr=
operly, some tests failed (and some of them due to the nature of tmpfs).<br=
>
<br>I didn&#39;t change the xfstests logic to recognize a proper SCRATCH_DE=
V so the SCRATCH_DEV for tmpfs should be in the nfs form (with the : in it)=
 for this to work properly.<br><br>diff --git a/common b/common<br>index 07=
23224..5853602 100644<br>
--- a/common<br>+++ b/common<br>@@ -126,6 +126,7 @@ check options<br>=A0=A0=
=A0=A0 -xfs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 test XFS (default)=
<br>=A0=A0=A0=A0 -udf=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 test UDF=
<br>=A0=A0=A0=A0 -nfs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 test NFS=
<br>+=A0=A0=A0 -tmpfs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 test TMPFS<br>
=A0=A0=A0=A0 -l=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 line mode diff<br>=A0=A0=A0=A0=
 -xdiff=A0=A0=A0 =A0=A0=A0 graphical mode diff<br>=A0=A0=A0=A0 -udiff=A0=A0=
=A0 =A0=A0=A0 show unified diff (default)<br>@@ -158,6 +159,11 @@ testlist =
options<br>=A0=A0=A0=A0 =A0=A0=A0 xpand=3Dfalse<br>=A0=A0=A0=A0 =A0=A0=A0 ;=
;<br>=A0<br>+=A0=A0=A0 -tmpfs)=A0=A0=A0 # -tmpfs ... set FSTYP to tmpfs<br>
+=A0=A0=A0 =A0=A0=A0 FSTYP=3Dtmpfs<br>+=A0=A0=A0 =A0=A0=A0 xpand=3Dfalse<br=
>+=A0=A0=A0 =A0=A0=A0 ;;<br>+<br>=A0=A0=A0=A0 -g)=A0=A0=A0 # -g group ... p=
ick from group file<br>=A0=A0=A0=A0 =A0=A0=A0 group=3Dtrue<br>=A0=A0=A0=A0 =
=A0=A0=A0 xpand=3Dfalse<br>diff --git a/common.rc b/common.rc<br>index 6025=
13a..a1351c9 100644<br>
--- a/common.rc<br>+++ b/common.rc<br>@@ -97,6 +97,10 @@ _mount_opts()<br>=
=A0=A0=A0=A0 # acls aren&#39;t turned on by default on gfs2<br>=A0=A0=A0=A0=
 export MOUNT_OPTIONS=3D&quot;-o acl $GFS2_MOUNT_OPTIONS&quot;<br>=A0=A0=A0=
=A0 ;;<br>+=A0=A0=A0 tmpfs)<br>
+=A0=A0=A0 # We need to specify the size at mount, use 512 MB by default<br=
>+=A0=A0=A0 export MOUNT_OPTIONS=3D&quot;-o size=3D512M $TMPFS_MOUNT_OPTION=
S&quot;<br>+=A0=A0=A0 ;;<br>=A0=A0=A0=A0 *)<br>=A0=A0=A0=A0 ;;<br>=A0=A0=A0=
=A0 esac<br>@@ -116,6 +120,9 @@ _mkfs_opts()<br>
=A0=A0=A0=A0 nfs)<br>=A0=A0=A0=A0 export MKFS_OPTIONS=3D$NFS_MKFS_OPTIONS<b=
r>=A0=A0=A0=A0 ;;<br>+=A0=A0=A0 tmpfs)<br>+=A0=A0=A0 export MKFS_OPTIONS=3D=
$TMPFS_MKFS_OPTIONS<br>+=A0=A0=A0 ;;<br>=A0=A0=A0=A0 reiserfs)<br>=A0=A0=A0=
=A0 export MKFS_OPTIONS=3D&quot;$REISERFS_MKFS_OPTIONS -q&quot;<br>
=A0=A0=A0=A0 ;;<br>@@ -327,6 +334,9 @@ _scratch_mkfs()<br>=A0=A0=A0=A0 nfs*=
)<br>=A0=A0=A0=A0 # do nothing for nfs<br>=A0=A0=A0=A0 ;;<br>+=A0=A0=A0 tmp=
fs)<br>+=A0=A0=A0 # do nothing for tmpfs<br>+=A0=A0=A0 ;;<br>=A0=A0=A0=A0 u=
df)<br>=A0=A0=A0=A0=A0=A0=A0=A0 $MKFS_UDF_PROG $MKFS_OPTIONS $* $SCRATCH_DE=
V &gt; /dev/null<br>
=A0=A0=A0=A0 ;;<br>@@ -736,6 +746,12 @@ _require_scratch()<br>=A0=A0=A0=A0 =
=A0=A0=A0 =A0=A0=A0=A0 _notrun &quot;this test requires a valid \$SCRATCH_D=
EV&quot;<br>=A0=A0=A0=A0 =A0=A0=A0 =A0fi<br>=A0=A0=A0=A0 =A0=A0=A0 =A0;;<br=
>+=A0=A0=A0 tmpfs)<br>+=A0=A0=A0 =A0=A0=A0 if [ -z &quot;$SCRATCH_DEV&quot;=
 -o ! -d &quot;$SCRATCH_MNT&quot; ];<br>
+=A0=A0=A0 =A0=A0=A0 then<br>+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 _notrun &quot;t=
his test requires a valid \$SCRATCH_MNT and unique $SCRATCH_DEV&quot;<br>+=
=A0=A0=A0 =A0=A0=A0 fi<br>+=A0=A0=A0 =A0=A0=A0 ;;<br>=A0=A0=A0=A0 *)<br>=A0=
=A0=A0=A0 =A0=A0=A0 =A0if [ -z &quot;$SCRATCH_DEV&quot; -o &quot;`_is_block=
_dev $SCRATCH_DEV`&quot; =3D &quot;&quot; ]<br>
=A0=A0=A0=A0 =A0=A0=A0 =A0then<br>@@ -1394,6 +1410,9 @@ _check_test_fs()<br=
>=A0=A0=A0=A0 nfs)<br>=A0=A0=A0=A0 # no way to check consistency for nfs<br=
>=A0=A0=A0=A0 ;;<br>+=A0=A0=A0 tmpfs)<br>+=A0=A0=A0=A0=A0=A0=A0 # no way to=
 check the consistency for tmpfs<br>+=A0=A0=A0 ;;<br>=A0=A0=A0=A0 udf)<br>
=A0=A0=A0=A0 # do nothing for now<br>=A0=A0=A0=A0 ;;<br>@@ -1426,6 +1445,9 =
@@ _check_scratch_fs()<br>=A0=A0=A0=A0 nfs*)<br>=A0=A0=A0=A0 # Don&#39;t kn=
ow how to check an NFS filesystem, yet.<br>=A0=A0=A0=A0 ;;<br>+=A0=A0=A0 tm=
pfs)<br>+=A0=A0=A0 # No way to check the consistency of tmpfs<br>
+=A0=A0=A0 ;;<br>=A0=A0=A0=A0 btrfs)<br>=A0=A0=A0=A0 _check_btrfs_filesyste=
m $SCRATCH_DEV<br>=A0=A0=A0=A0 ;;<br>@@ -1517,6 +1539,33 @@ _setup_nfs_scra=
tchdir()<br>=A0=A0=A0=A0 testdir=3D$SCRATCH_MNT<br>=A0}<br>=A0<br>+_setup_t=
mpfs_scratchdir()<br>+{<br>+=A0=A0=A0 [ &quot;$FSTYP&quot; !=3D &quot;tmpfs=
&quot; ] \<br>
+=A0=A0=A0=A0=A0=A0=A0 &amp;&amp; _fail &quot;setup_tmpfs_testdir: \$FSTYP =
is not tmpfs&quot;<br>+=A0=A0=A0 [ -z &quot;$SCRATCH_DEV&quot; ] \<br>+=A0=
=A0=A0 &amp;&amp; _notrun &quot;this test requires a valid host fs for \$SC=
RATCH_DEV&quot;<br>+=A0=A0=A0 [ -z &quot;$SCRATCH_MNT&quot; ] \<br>
+=A0=A0=A0 &amp;&amp; _notrun &quot;this test requires a valid \$SCRATCH_MN=
T&quot;<br>+<br>+=A0=A0=A0 # mounted?<br>+=A0=A0=A0 if _mount | grep -q $SC=
RATCH_DEV<br>+=A0=A0=A0 then<br>+=A0=A0=A0=A0=A0=A0=A0 # if it&#39;s mounte=
d, make sure its on $SCRATCH_MNT<br>
+=A0=A0=A0=A0=A0=A0=A0 if ! _mount | grep $SCRATCH_DEV | grep -q $SCRATCH_M=
NT<br>+=A0=A0=A0=A0=A0=A0=A0 then<br>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 _fa=
il &quot;\$SCRATCH_DEV is mounted but not on \$SCRATCH_MNT - aborting&quot;=
<br>+=A0=A0=A0=A0=A0=A0=A0 fi<br>+=A0=A0=A0=A0=A0=A0=A0 $UMOUNT_PROG $SCRAT=
CH_DEV<br>
+=A0=A0=A0 fi<br>+<br>+=A0=A0=A0 _scratch_mkfs<br>+=A0=A0=A0 _scratch_mount=
<br>+<br>+=A0=A0=A0 testdir=3D$SCRATCH_MNT<br>+}<br>+<br>+<br>=A0#<br>=A0# =
Warning for UDF and NFS:<br>=A0# this function calls _setup_udf_scratchdir =
and _setup_udf_scratchdir<br>
@@ -1535,6 +1584,9 @@ _setup_testdir()<br>=A0=A0=A0=A0 nfs*)<br>=A0=A0=A0=
=A0 _setup_nfs_scratchdir<br>=A0=A0=A0=A0 ;;<br>+=A0=A0=A0 tmpfs)<br>+=A0=
=A0=A0 _setup_tmpfs_scratchdir<br>+=A0=A0=A0 ;;<br>=A0=A0=A0=A0 *)<br>=A0=
=A0=A0=A0 testdir=3D$TEST_DIR<br>=A0=A0=A0=A0 ;;<br>@@ -1552,6 +1604,10 @@ =
_cleanup_testdir()<br>
=A0=A0=A0=A0 # umount testdir as it is $SCRATCH_MNT which could be used by =
xfs next<br>=A0=A0=A0=A0 [ -n &quot;$testdir&quot; ] &amp;&amp; $UMOUNT_PRO=
G $testdir<br>=A0=A0=A0=A0 ;;<br>+=A0=A0=A0 tmpfs)<br>+=A0=A0=A0 # umount t=
estdir since it is actually a scrath mount<br>
+=A0=A0=A0 [ -n &quot;$testdir&quot; ] &amp;&amp; $UMOUNT_PROG $testdir<br>=
+=A0=A0=A0 ;;<br>=A0=A0=A0=A0 *)<br>=A0=A0=A0=A0 # do nothing, testdir is $=
TEST_DIR<br>=A0=A0=A0=A0 :<br><br>Signed-off-by: Boris Ranto &lt;ranto.bori=
s<span class=3D"Object" id=3D"OBJ_PREFIX_DWT1718_com_zimbra_email"><span cl=
ass=3D"Object" id=3D"OBJ_PREFIX_DWT1719_com_zimbra_email">@<a href=3D"http:=
//gmail.com">gmail.com</a></span></span>&gt;

--e89a8f6434ec76a9a804c7f4e768--


--===============5715424960031614819==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5715424960031614819==--
