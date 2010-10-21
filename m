Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9LK6HbW066466 for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 15:06:17 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B329118EBF
	for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 13:07:31 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IqpEtEgDPPg4DauC for
	<xfs@oss.sgi.com>; Thu, 21 Oct 2010 13:07:31 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1P91QB-0007us-JK
	for xfs@oss.sgi.com; Thu, 21 Oct 2010 20:07:31 +0000
Date: Thu, 21 Oct 2010 16:07:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: do not call attr/getfattr/setfattr direcly
Message-ID: <20101021200731.GB30128@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com


always use the full path set up in common.attr.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Index: xfstests-dev/021
===================================================================
--- xfstests-dev.orig/021	2010-10-21 05:02:35.000000000 +0000
+++ xfstests-dev/021	2010-10-21 05:03:15.000000000 +0000
@@ -45,7 +45,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 1
 
 _attr()
 {
-	attr $* 2>$tmp.err >$tmp.out
+	${ATTR_PROG} $* 2>$tmp.err >$tmp.out
 	exit=$?
 	sed \
 	    -e "s#$SCRATCH_MNT[^ .:]*#<TESTFILE>#g" \
@@ -60,7 +60,7 @@ _attr()
 
 _getfattr()
 {
-	getfattr $* 2>$tmp.err >$tmp.out
+	${GETFATTR_PROG} $* 2>$tmp.err >$tmp.out
 	exit=$?
 	sed \
 	    -e "s#$SCRATCH_MNT[^ .:]*#<TESTFILE>#g" \
Index: xfstests-dev/093
===================================================================
--- xfstests-dev.orig/093	2010-10-21 05:05:20.000000000 +0000
+++ xfstests-dev/093	2010-10-21 05:05:35.000000000 +0000
@@ -138,16 +138,16 @@ echo "restore perms on file"
 chmod 777 $file
 
 echo "set a root EA on file"
-attr -R -s test -V testval $file | _filefilter
+${ATTR_PROG} -R -s test -V testval $file | _filefilter
 
 echo "list EA on file"
-attr -R -l $file | _filefilter
+${ATTR_PROG} -R -l $file | _filefilter
 
 echo "as non-root try to append to file"
 $runas -u $uid $tmp.append 2>&1 | _filefilter
 
 echo "list EA on file"
-attr -R -l $file | _filefilter
+${ATTR_PROG} -R -l $file | _filefilter
 
 chown $uid $file
 chmod ugo+w $testdir
Index: xfstests-dev/097
===================================================================
--- xfstests-dev.orig/097	2010-10-21 05:05:39.000000000 +0000
+++ xfstests-dev/097	2010-10-21 05:06:24.000000000 +0000
@@ -76,6 +76,8 @@ _supported_fs generic
 _supported_os IRIX
 
 _require_scratch
+_require_attrs
+
 _setup_testdir 
 
 TARGET_DIR=$SCRATCH_MNT
@@ -87,131 +89,131 @@ rm -f foo
 touch foo
 
 echo "should be no EAs for foo:"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "set EA <noise,woof>:"
-attr -s noise -V woof foo
+${ATTR_PROG} -s noise -V woof foo
 
 echo "set EA <colour,blue>:"
-attr -s colour -V blue foo
+${ATTR_PROG} -s colour -V blue foo
 
 echo "set EA <size,small>:"
-attr -s size -V small foo
+${ATTR_PROG} -s size -V small foo
 
 echo "list the EAs for foo: noise, colour, size" 
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "check the list again for foo"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "unmount the FS and see if EAs are persistent"
 _umount_and_mount
 
 echo "check the list again for foo after umount/mount"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "get the value of the noise EA"
-attr -g noise foo
+${ATTR_PROG} -g noise foo
 
 echo "get the value of the colour EA which was removed earlier"
-attr -g colour foo
+${ATTR_PROG} -g colour foo
 
 echo "get the value of the size EA"
-attr -g size foo
+${ATTR_PROG} -g size foo
 
 echo "remove the colour EA on foo"
-attr -r colour foo
+${ATTR_PROG} -r colour foo
 
 echo "list EAs for foo: noise, size"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "get the value of the noise EA"
-attr -g noise foo
+${ATTR_PROG} -g noise foo
 
 echo "get the value of the colour EA which was removed earlier"
-attr -g colour foo
+${ATTR_PROG} -g colour foo
 
 echo "get the value of the size EA"
-attr -g size foo
+${ATTR_PROG} -g size foo
 
 echo "list all the EAs again: noise, size"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "change the value of the size EA from small to huge"
-attr -s size -V huge foo
+${ATTR_PROG} -s size -V huge foo
 
 echo "get the size EA which should now have value huge"
-attr -g size foo
+${ATTR_PROG} -g size foo
 
 echo "list EAs: noise, size"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "remove the size EA from foo"
-attr -r size foo
+${ATTR_PROG} -r size foo
 
 echo "list EAs: noise (size EA has been removed)"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "get the noise EA: woof"
-attr -g noise foo
+${ATTR_PROG} -g noise foo
 
 echo "try removing non-existent EA named woof"
-attr -r woof foo
+${ATTR_PROG} -r woof foo
 
 echo "try removing already removed EA size"
-attr -r size foo
+${ATTR_PROG} -r size foo
 
 echo "list EAs: noise"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "try removing already removed EA colour"
-attr -r colour foo
+${ATTR_PROG} -r colour foo
 
 echo "list EAs: noise"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "remove remaining EA noise"
-attr -r noise foo
+${ATTR_PROG} -r noise foo
 
 echo "list EAs: should be no EAs left now"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "unmount the FS and see if EAs are persistent"
 _umount_and_mount
 
 echo "list EAs: should still be no EAs left"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo ""
 echo "*** Test out the root namespace ***"
 echo ""
 
 echo "set EA <root:colour,marone>:"
-attr -R -s colour -V marone foo
+${ATTR_PROG} -R -s colour -V marone foo
 
 echo "set EA <user:colour,beige>:"
-attr -s colour -V beige foo
+${ATTR_PROG} -s colour -V beige foo
 
 echo "set EA <user:vomit,pizza>:"
-attr -s vomit -V pizza foo
+${ATTR_PROG} -s vomit -V pizza foo
 
 echo "set EA <root:noise,whack>:"
-attr -R -s noise -V whack foo
+${ATTR_PROG} -R -s noise -V whack foo
 
 echo "list root EAs: <root:colour,noise>:"
-attr -R -l foo
+${ATTR_PROG} -R -l foo
 
 echo "list user EAs: <user:colour,vomit>:"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "get root EA colour: marone"
-attr -R -g colour foo
+${ATTR_PROG} -R -g colour foo
 
 echo "get root EA noise: whack"
-attr -R -g noise foo
+${ATTR_PROG} -R -g noise foo
 
 echo "get root EA vomit which is a user EA => find nothing"
-attr -R -g vomit foo
+${ATTR_PROG} -R -g vomit foo
 
 echo ""
 echo "unmount the FS and see if EAs are persistent"
@@ -219,28 +221,28 @@ echo ""
 _umount_and_mount
 
 echo "get root EA colour: marone"
-attr -R -g colour foo
+${ATTR_PROG} -R -g colour foo
 
 echo "get root EA noise: whack"
-attr -R -g noise foo
+${ATTR_PROG} -R -g noise foo
 
 echo "get user EA vomit: pizza" 
-attr -g vomit foo
+${ATTR_PROG} -g vomit foo
 
 echo "remove the root colour EA"
-attr -R -r colour foo
+${ATTR_PROG} -R -r colour foo
 
 echo "list root EAs: <root:noise>:"
-attr -R -l foo
+${ATTR_PROG} -R -l foo
 
 echo "list user EAs: <user:colour,vomit>:"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "remove the final root EA noise"
-attr -R -r noise foo
+${ATTR_PROG} -R -r noise foo
 
 echo "list root EAs: none"
-attr -R -l foo
+${ATTR_PROG} -R -l foo
 
 cd /
 _cleanup_testdir
Index: xfstests-dev/098
===================================================================
--- xfstests-dev.orig/098	2010-10-21 05:06:26.000000000 +0000
+++ xfstests-dev/098	2010-10-21 05:07:52.000000000 +0000
@@ -80,6 +80,8 @@ _supported_fs udf
 _supported_os IRIX
 
 _require_scratch
+_require_attrs
+
 _setup_testdir
 
 cd $SCRATCH_MNT
@@ -89,131 +91,131 @@ echo "file_contents" >foo
 cat foo
 
 echo "should be no EAs for foo:"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "set EA <noise,woof>:"
-attr -s noise -V woof foo
+${ATTR_PROG} -s noise -V woof foo
 
 echo "set EA <colour,blue>:"
-attr -s colour -V blue foo
+${ATTR_PROG} -s colour -V blue foo
 
 echo "set EA <size,small>:"
-attr -s size -V small foo
+${ATTR_PROG} -s size -V small foo
 
 echo "list the EAs for foo: noise, colour, size" 
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "check the list again for foo"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "unmount the FS and see if EAs are persistent"
 _umount_check_mount
 
 echo "check the list again for foo after umount/mount"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "get the value of the noise EA"
-attr -g noise foo
+${ATTR_PROG} -g noise foo
 
 echo "get the value of the colour EA which was removed earlier"
-attr -g colour foo
+${ATTR_PROG} -g colour foo
 
 echo "get the value of the size EA"
-attr -g size foo
+${ATTR_PROG} -g size foo
 
 echo "remove the colour EA on foo"
-attr -r colour foo
+${ATTR_PROG} -r colour foo
 
 echo "list EAs for foo: noise, size"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "get the value of the noise EA"
-attr -g noise foo
+${ATTR_PROG} -g noise foo
 
 echo "get the value of the colour EA which was removed earlier"
-attr -g colour foo
+${ATTR_PROG} -g colour foo
 
 echo "get the value of the size EA"
-attr -g size foo
+${ATTR_PROG} -g size foo
 
 echo "list all the EAs again: noise, size"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "change the value of the size EA from small to huge"
-attr -s size -V huge foo
+${ATTR_PROG} -s size -V huge foo
 
 echo "get the size EA which should now have value huge"
-attr -g size foo
+${ATTR_PROG} -g size foo
 
 echo "list EAs: noise, size"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "remove the size EA from foo"
-attr -r size foo
+${ATTR_PROG} -r size foo
 
 echo "list EAs: noise (size EA has been removed)"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "get the noise EA: woof"
-attr -g noise foo
+${ATTR_PROG} -g noise foo
 
 echo "try removing non-existent EA named woof"
-attr -r woof foo
+${ATTR_PROG} -r woof foo
 
 echo "try removing already removed EA size"
-attr -r size foo
+${ATTR_PROG} -r size foo
 
 echo "list EAs: noise"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "try removing already removed EA colour"
-attr -r colour foo
+${ATTR_PROG} -r colour foo
 
 echo "list EAs: noise"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "remove remaining EA noise"
-attr -r noise foo
+${ATTR_PROG} -r noise foo
 
 echo "list EAs: should be no EAs left now"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "unmount the FS and see if EAs are persistent"
 _umount_check_mount
 
 echo "list EAs: should still be no EAs left"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo ""
 echo "*** Test out the root namespace ***"
 echo ""
 
 echo "set EA <root:colour,marone>:"
-attr -R -s colour -V marone foo
+${ATTR_PROG} -R -s colour -V marone foo
 
 echo "set EA <user:colour,beige>:"
-attr -s colour -V beige foo
+${ATTR_PROG} -s colour -V beige foo
 
 echo "set EA <user:vomit,pizza>:"
-attr -s vomit -V pizza foo
+${ATTR_PROG} -s vomit -V pizza foo
 
 echo "set EA <root:noise,whack>:"
-attr -R -s noise -V whack foo
+${ATTR_PROG} -R -s noise -V whack foo
 
 echo "list root EAs: <root:colour,noise>:"
-attr -R -l foo
+${ATTR_PROG} -R -l foo
 
 echo "list user EAs: <user:colour,vomit>:"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "get root EA colour: marone"
-attr -R -g colour foo
+${ATTR_PROG} -R -g colour foo
 
 echo "get root EA noise: whack"
-attr -R -g noise foo
+${ATTR_PROG} -R -g noise foo
 
 echo "get root EA vomit which is a user EA => find nothing"
-attr -R -g vomit foo
+${ATTR_PROG} -R -g vomit foo
 
 echo ""
 echo "unmount the FS and see if EAs are persistent"
@@ -221,28 +223,28 @@ echo ""
 _umount_check_mount
 
 echo "get root EA colour: marone"
-attr -R -g colour foo
+${ATTR_PROG} -R -g colour foo
 
 echo "get root EA noise: whack"
-attr -R -g noise foo
+${ATTR_PROG} -R -g noise foo
 
 echo "get user EA vomit: pizza" 
-attr -g vomit foo
+${ATTR_PROG} -g vomit foo
 
 echo "remove the root colour EA"
-attr -R -r colour foo
+${ATTR_PROG} -R -r colour foo
 
 echo "list root EAs: <root:noise>:"
-attr -R -l foo
+${ATTR_PROG} -R -l foo
 
 echo "list user EAs: <user:colour,vomit>:"
-attr -l foo
+${ATTR_PROG} -l foo
 
 echo "remove the final root EA noise"
-attr -R -r noise foo
+${ATTR_PROG} -R -r noise foo
 
 echo "list root EAs: none"
-attr -R -l foo
+${ATTR_PROG} -R -l foo
 
 cd /
 umount $SCRATCH_MNT
Index: xfstests-dev/115
===================================================================
--- xfstests-dev.orig/115	2010-10-21 05:07:56.000000000 +0000
+++ xfstests-dev/115	2010-10-21 05:08:48.000000000 +0000
@@ -152,67 +152,67 @@ _do_test()
 	echo ""
 	echo "1. remove the EA"
 	echo ""
-	attr -Fl dir2/file2
+	${ATTR_PROG} -Fl dir2/file2
 	stat_ino=`stat -iq dir2`
 	attrname=`printf "%.16x %.16x" $stat_ino $cnt`
 	#echo "attrname = $attrname"
-	attr -Fr "$attrname" dir2/file2
-	attr -Fl dir2/file2
+	${ATTR_PROG} -Fr "$attrname" dir2/file2
+	${ATTR_PROG} -Fl dir2/file2
 
 	echo ""
 	echo "2. change the EA name"
 	echo ""
-	attr -Fl dir2/dir3/file3
+	${ATTR_PROG} -Fl dir2/dir3/file3
 	stat_ino=100
 	attrname=`printf "%.16x %.16x" $stat_ino $cnt`
 	attrvalue=file3
-	attr -Fs "$attrname" -V $attrvalue dir2/dir3/file3
-	attr -Fl dir2/dir3/file3
+	${ATTR_PROG} -Fs "$attrname" -V $attrvalue dir2/dir3/file3
+	${ATTR_PROG} -Fl dir2/dir3/file3
 
 	echo ""
 	echo "3. change the EA value"
 	echo ""
-	attr -Fl $d/file4
+	${ATTR_PROG} -Fl $d/file4
 	stat_ino=`stat -iq $d`
 	attrname=`printf "%.16x %.16x" $stat_ino $cnt`
 	attrvalue=woopdydoo
-	attr -Fs "$attrname" -V "$attrvalue" $d/file4
-	attr -Fl $d/file4
-	attr -Fg "$attrname" $d/file4
+	${ATTR_PROG} -Fs "$attrname" -V "$attrvalue" $d/file4
+	${ATTR_PROG} -Fl $d/file4
+	${ATTR_PROG} -Fg "$attrname" $d/file4
 
 	echo ""
 	echo "4. add an extra EA - diff name, same value"
 	echo ""
-	attr -Fl $d/file5
+	${ATTR_PROG} -Fl $d/file5
 	stat_ino=100
 	attrname=`printf "%.16x %.16x" $stat_ino $cnt`
 	attrvalue=file5
-	attr -Fs "$attrname" -V $attrvalue $d/file5
-	attr -Fl $d/file5
-	attr -Fg "$attrname" $d/file5
+	${ATTR_PROG} -Fs "$attrname" -V $attrvalue $d/file5
+	${ATTR_PROG} -Fl $d/file5
+	${ATTR_PROG} -Fg "$attrname" $d/file5
 
 	echo ""
 	echo "5. add an extra EA - diff name, diff value"
 	echo ""
-	attr -Fl $d/file6
+	${ATTR_PROG} -Fl $d/file6
 	stat_ino=100
 	attrname=`printf "%.16x %.16x" $stat_ino $cnt`
 	attrvalue=file600
-	attr -Fs "$attrname" -V $attrvalue $d/file6
-	attr -Fl $d/file6
-	attr -Fg "$attrname" $d/file6
+	${ATTR_PROG} -Fs "$attrname" -V $attrvalue $d/file6
+	${ATTR_PROG} -Fl $d/file6
+	${ATTR_PROG} -Fg "$attrname" $d/file6
 
 	echo ""
 	echo "6. give bad fmt'ed EA name and get rid of existing name"
 	echo ""
 	attrname=woof
 	attrvalue=file7
-	attr -Fs "$attrname" -V $attrvalue $d/file7
+	${ATTR_PROG} -Fs "$attrname" -V $attrvalue $d/file7
 	# remove old attrname
 	cnt=1
 	stat_ino=`stat -iq $d`
 	attrname=`printf "%.16x %.16x" $stat_ino $cnt`
-	attr -Fr "$attrname" $d/file7
+	${ATTR_PROG} -Fr "$attrname" $d/file7
 
 	echo ""
 	echo "--- now check it ---"
Index: xfstests-dev/136
===================================================================
--- xfstests-dev.orig/136	2010-10-21 05:08:54.000000000 +0000
+++ xfstests-dev/136	2010-10-21 05:09:10.000000000 +0000
@@ -77,7 +77,7 @@ add_eas()
     echo ""; echo "** add $start..$end EAs **"
     i=$start
     while [ $i -le $end ]; do 
-	attr -s name.$i -V value $file >/dev/null
+	${ATTR_PROG} -s name.$i -V value $file >/dev/null
 	let i=$i+1
     done
 }
@@ -89,7 +89,7 @@ rm_eas()
     echo ""; echo "** rm $start..$end EAs **"
     i=$start
     while [ $i -le $end ]; do 
-	attr -r name.$i $file >/dev/null
+	${ATTR_PROG} -r name.$i $file >/dev/null
 	let i=$i+1
     done
 }
@@ -343,7 +343,7 @@ _test_initial_sf_ea()
 	touch $file
 	vlen=402
 	vlen=300
-	dd if=/dev/zero bs=1 count=$vlen | attr -s name $file
+	dd if=/dev/zero bs=1 count=$vlen | ${ATTR_PROG} -s name $file
 	_print_inode
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
