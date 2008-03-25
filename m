Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 23:04:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2P64bnA006224
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 23:04:41 -0700
Message-ID: <47E8960D.1000801@sgi.com>
Date: Tue, 25 Mar 2008 17:05:01 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsqa: call _notrun in common.dump if dump utils not
 found
References: <47E5CFBA.7060405@sandeen.net> <47E8703C.30603@sgi.com> <op.t8jyw8i63jf8g2@pc-bnaujok.melbourne.sgi.com> <47E87D97.9050900@sandeen.net> <47E88676.7080006@sgi.com>
In-Reply-To: <47E88676.7080006@sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Barry Naujok <bnaujok@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Timothy Shimmin wrote:
 > Eric Sandeen wrote:
 >> Barry Naujok wrote:
 >>> On Tue, 25 Mar 2008 14:23:40 +1100, Timothy Shimmin <tes@sgi.com> wrote:
 >>>
 >>>> Thanks, Eric.
 >>>>
 >>>> On IRIX:
 >>>>  > where xfsdump xfsrestore xfsinvutil
 >>>> /sbin/xfsdump
 >>>> /usr/sbin/xfsdump
 >>>> /sbin/xfsrestore
 >>>> /usr/sbin/xfsinvutil
 >>>>  > ls -l /sbin/xfsdump
 >>>> lrwxr-xr-x    ... /sbin/xfsdump -> ../usr/sbin/xfsdump*
 >>>>
 >>>> I'll add the IRIX xfsrestore path and wait for Russell or
 >>>> whoever to complain about BSD :)
 >>> common.config sets up environment variables for the various
 >>> tools used and can handle these paths. It has them for the
 >>> xfsprogs tools (XFS_REPAIR_PROG, XFS_DB_PROG, etc) but
 >>> nothing for the xfsdump tools.
 >>
 >> yeah, that may be better...
 >>
 > Okay. Fair point.
 > I'll change common.dump to use the XFSDUMP_PROG etc....
 > and common.config to set the PROG vars.
 >
 > --Tim
 >
 >

Okay, something like below then.
Note, I only test for failure in common.dump and I need
to filter out the fullpaths for the commands now as
they output their full path.
Oh and I changed a bit for the DEBUGDUMP which can
use binaries in xfstests for debugging.
Ughhh.

--Tim


===========================================================================
Index: xfstests/common.config
===========================================================================

--- a/xfstests/common.config	2008-03-25 17:02:57.000000000 +1100
+++ b/xfstests/common.config	2008-03-25 18:21:37.964000000 +1100
@@ -114,6 +114,9 @@ export AWK_PROG="`set_prog_path awk`"
  export SED_PROG="`set_prog_path sed`"
  [ "$SED_PROG" = "" ] && _fatal "sed not found"

+export BC_PROG="`set_prog_path bc`"
+[ "$BC_PROG" = "" ] && _fatal "bc not found"
+
  export PS_ALL_FLAGS="-ef"

  export DF_PROG="`set_prog_path df`"
@@ -128,6 +131,9 @@ export XFS_GROWFS_PROG=`set_prog_path xf
  export XFS_IO_PROG="`set_prog_path xfs_io`"
  export XFS_PARALLEL_REPAIR_PROG="`set_prog_path xfs_prepair`"
  export XFS_PARALLEL_REPAIR64_PROG="`set_prog_path xfs_prepair64`"
+export XFSDUMP_PROG="`set_prog_path xfsdump`"
+export XFSRESTORE_PROG="`set_prog_path xfsrestore`"
+export XFSINVUTIL_PROG="`set_prog_path xfsinvutil`"

  # Generate a comparable xfsprogs version number in the form of
  # major * 10000 + minor * 100 + release

===========================================================================
Index: xfstests/common.dump
===========================================================================

--- a/xfstests/common.dump	2008-03-25 17:02:57.000000000 +1100
+++ b/xfstests/common.dump	2008-03-25 18:38:43.792000000 +1100
@@ -9,17 +9,23 @@
  rm -f $here/$seq.full

  if [ -n "$DEBUGDUMP" ]; then
-  _dump_debug=-v4
-  _restore_debug=-v4
-  _invutil_debug=-d
+	_dump_debug=-v4
+	_restore_debug=-v4
+	_invutil_debug=-d
+
+	# Use dump/restore in qa directory (copy them here) for debugging
+	export PATH="$here:$PATH"
+	export XFSDUMP_PROG="`set_prog_path xfsdump`"
+	export XFSRESTORE_PROG="`set_prog_path xfsrestore`"
+	export XFSINVUTIL_PROG="`set_prog_path xfsinvutil`"
+	[ -x $here/xfsdump ]    && echo "Using xfstests' xfsdump for debug"
+	[ -x $here/xfsrestore ] && echo "Using xfstests' xfsrestore for debug"
+	[ -x $here/xfsinvutil ] && echo "Using xfstests' xfsinvutil for debug"
  fi

-# Use dump/restore in qa directory for debugging
-PATH="$here:$PATH"
-export PATH
-#which xfsdump
-#which xfsrestore
-#which xfsinvutil
+[ "$XFSDUMP_PROG" = "" ]    && _fatal "xfsdump not found"
+[ "$XFSRESTORE_PROG" = "" ] && _fatal "xfsrestore not found"
+[ "$XFSINVUTIL_PROG" = "" ] && _fatal "xfsinvutil not found"

  # status returned for not run tests
  NOTRUNSTS=2
@@ -761,6 +767,9 @@ _dump_filter_main()
  {
    _filter_devchar |\
    sed \
+      -e "s#$XFSDUMP_PROG#xfsdump#"			\
+      -e "s#$XFSRESTORE_PROG#xfsrestore#"		\
+      -e "s#$XFSINVUTIL_PROG#xfsinvutil#"		\
        -e "s/`hostname`/HOSTNAME/"			\
        -e "s#$SCRATCH_DEV#SCRATCH_DEV#"			\
        -e "s#$SCRATCH_RAWDEV#SCRATCH_DEV#"		\
@@ -906,7 +915,7 @@ _do_dump_sub()
      echo "Dumping to tape..."
      opts="$_dump_debug$dump_args -s $dump_sdir -f $dumptape -M $media_label -L $session_label $SCRATCH_MNT"
      echo "xfsdump $opts" | _dir_filter
-    xfsdump $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSDUMP_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
  }

  #
@@ -919,7 +928,7 @@ _do_dump()
      echo "Dumping to tape..."
      opts="$_dump_debug$dump_args -f $dumptape -M $media_label -L $session_label $SCRATCH_MNT"
      echo "xfsdump $opts" | _dir_filter
-    xfsdump $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSDUMP_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
  }


@@ -934,7 +943,7 @@ _do_dump_min()
      onemeg=1048576
      opts="$_dump_debug$dump_args -m -b $onemeg -l0 -f $dumptape -M $media_label -L $session_label $SCRATCH_MNT"
      echo "xfsdump $opts" | _dir_filter
-    xfsdump $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSDUMP_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
  }


@@ -948,7 +957,7 @@ _do_dump_file()
      echo "Dumping to file..."
      opts="$_dump_debug$dump_args -f $dump_file -M $media_label -L $session_label $SCRATCH_MNT"
      echo "xfsdump $opts" | _dir_filter
-    xfsdump $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSDUMP_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
  }

  #
@@ -970,7 +979,7 @@ _do_dump_multi_file()
      echo "Dumping to files..."
      opts="$_dump_debug$dump_args $multi_args -L $session_label $SCRATCH_MNT"
      echo "xfsdump $opts" | _dir_filter
-    xfsdump $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSDUMP_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
  }


@@ -1004,7 +1013,7 @@ _do_restore()
      echo "Restoring from tape..."
      opts="$_restore_debug -f $dumptape  -L $session_label $restore_dir"
      echo "xfsrestore $opts" | _dir_filter
-    xfsrestore $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSRESTORE_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
  }

  #
@@ -1019,7 +1028,7 @@ _do_restore_min()
      onemeg=1048576
      opts="$_restore_debug -m -b $onemeg -f $dumptape  -L $session_label $restore_dir"
      echo "xfsrestore $opts" | _dir_filter
-    xfsrestore $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSRESTORE_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
  }

  #
@@ -1033,7 +1042,7 @@ _do_restore_file()
      echo "Restoring from file..."
      opts="$_restore_debug -f $dump_file  -L $session_label $restore_dir"
      echo "xfsrestore $opts" | _dir_filter
-    xfsrestore $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSRESTORE_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
  }

  #
@@ -1050,7 +1059,7 @@ _do_restore_file_cum()
      echo "Restoring cumumlative from file..."
      opts="$_restore_debug -f $dump_file -r $restore_dir"
      echo "xfsrestore $opts" | _dir_filter
-    xfsrestore $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSRESTORE_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
  }

  _do_restore_toc()
@@ -1059,7 +1068,7 @@ _do_restore_toc()
      opts="$_restore_debug -f $dump_file -t"
      echo "xfsrestore $opts" | _dir_filter
      cd $SCRATCH_MNT # for IRIX which needs xfs cwd
-    xfsrestore $opts 2>&1 | tee -a $here/$seq.full | _dump_filter_main |\
+    $XFSRESTORE_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter_main |\
      _check_quota_file |\
      _check_quota_entries |\
      $AWK_PROG 'NF != 1 { print; next }
@@ -1090,7 +1099,7 @@ _do_restore_multi_file()
      echo "Restoring from file..."
      opts="$_restore_debug $multi_args -L $session_label $restore_dir"
      echo "xfsrestore $opts" | _dir_filter
-    xfsrestore $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSRESTORE_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
  }

  #
@@ -1106,7 +1115,7 @@ _do_dump_restore()
      restore_opts="$_restore_debug - $restore_dir"
      dump_opts="$_dump_debug$dump_args -s $dump_sdir - $SCRATCH_MNT"
      echo "xfsdump $dump_opts | xfsrestore $restore_opts" | _dir_filter
-    xfsdump $dump_opts 2>$tmp.dump.mlog | xfsrestore $restore_opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSDUMP_PROG $dump_opts 2>$tmp.dump.mlog | $XFSRESTORE_PROG $restore_opts 2>&1 | tee -a $here/$seq.full | _dump_filter
      _dump_filter <$tmp.dump.mlog
  }

@@ -1244,7 +1253,7 @@ _diff_compare()
  #
  _dump_inventory()
  {
-    xfsdump $_dump_debug -I | tee -a $here/$seq.full | _dump_filter_main
+    $XFSDUMP_PROG $_dump_debug -I | tee -a $here/$seq.full | _dump_filter_main
  }

  #
@@ -1255,7 +1264,7 @@ _do_invutil()
  {
      host=`hostname`
      echo "xfsinvutil $_invutil_debug -M $host:$SCRATCH_MNT \"$middate\" $*" >$here/$seq.full
-    xfsinvutil $_invutil_debug $* -M $host:$SCRATCH_MNT "$middate" \
+    $XFSINVUTIL_PROG $_invutil_debug $* -M $host:$SCRATCH_MNT "$middate" \
      | tee -a $here/$seq.full | _invutil_filter
  }
