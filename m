Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o457s3aJ022593 for <xfs@oss.sgi.com>; Wed, 5 May 2010 02:54:03 -0500
Received: from e32.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0B4F30FBAD
	for <xfs@oss.sgi.com>; Wed,  5 May 2010 00:56:11 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id cdV4c9hhaTvR9QVZ for
	<xfs@oss.sgi.com>; Wed, 05 May 2010 00:56:11 -0700 (PDT)
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by e32.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o457n8uo007082
	for <xfs@oss.sgi.com>; Wed, 5 May 2010 01:49:08 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	o457u8XO148940 for <xfs@oss.sgi.com>; Wed, 5 May 2010 01:56:08 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP
	id o457u6Ep031774
	for <xfs@oss.sgi.com>; Wed, 5 May 2010 01:56:08 -0600
Date: Wed, 5 May 2010 13:25:56 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH v2] New testcase to check if fallocate respects
	RLIMIT_FSIZE or not
Message-ID: <20100505075556.GA5142@amitarora.in.ibm.com>
References: <201004281854.49730.knikanth@suse.de> <4BD85F1F.7030100@suse.de>
	<201004291014.07194.knikanth@suse.de>
	<20100430143319.d51d6d77.akpm@linux-foundation.org>
	<20100501070426.GA9562@amitarora.in.ibm.com>
	<20100501101846.GA3769@infradead.org>
	<20100503083135.GC13756@amitarora.in.ibm.com>
	<4BE08718.5040608@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BE08718.5040608@redhat.com>
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
Cc: Nick Piggin <npiggin@suse.de>, Andreas Dilger <adilger@sun.com>, Eelis <opensuse.org@contacts.eelis.net>, Theodore Ts'o <tytso@mit.edu>, Nikanth Karthikesan <knikanth@suse.de>, coly.li@suse.de, Amit Arora <aarora@in.ibm.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org

On Tue, May 04, 2010 at 03:44:08PM -0500, Eric Sandeen wrote:
> Amit K. Arora wrote:
> > Here is the new testcase.
> Thanks!  A few comments...
Thanks for the review!
 
> 228.out is missing from the patch
Ok, added it in the new patch.
 
> Also on my fedora box I don't get a coredump by default; can
> you either make that explicit, or filter out the core message?
Hmm.. for some strange reason I am no longer seeing this message. Tried
on the same system as last time and couple of others also.
 
> > 
> > Here is the test:
> > ----------------
> > Add a new testcase to the xfstests suite to check if fallocate respects
> > the limit imposed by RLIMIT_FSIZE (can be set by "ulimit -f XXX") or
> > not, on a particular filesystem.
> 
> ...
> 
> > +# get standard environment, filters and checks
> > +. ./common.rc
> > +. ./common.filter
> 
> Nitpick, I don't think you need common.filter, doesn't look like you are 
> using it.
Right. Removed it..
 
> > +# FSIZE limit is now set to 100 MB.
> > +# Lets try to preallocate 101 MB. This should fail.
> > +$XFS_IO_PROG -F -f -c 'falloc 0 101m' $TEST_DIR/ouch
> > +rm -f $TEST_DIR/ouch
> > +
> > +# Lets now try to preallocate 50 MB. This should succeed.
> > +$XFS_IO_PROG -F -f -c 'falloc 0 50m' $TEST_DIR/ouch
> > +rm -f $TEST_DIR/ouch
> 
> Even more nitpicky, but sometimes I think it's nice to have the .out 
> file be a bit more descriptive in and of itself so when you see a 
> failing diff you have a better idea what's gone wrong.
Agreed. Done.

Here is the new patch with the changes:

Add a new testcase to the xfstests suite to check if fallocate respects
the limit imposed by RLIMIT_FSIZE (can be set by "ulimit -f XXX") or
not, on a particular filesystem.

Signed-off-by: Amit Arora <aarora@in.ibm.com>

diff -Nuarp xfstests-dev.org/228 xfstests-dev/228
--- xfstests-dev.org/228	1969-12-31 19:00:00.000000000 -0500
+++ xfstests-dev/228	2010-05-05 02:37:48.000000000 -0400
@@ -0,0 +1,79 @@
+#! /bin/bash
+# FS QA Test No. 228
+#
+# Check if fallocate respects RLIMIT_FSIZE 
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 IBM Corporation. All Rights Reserved.
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
+owner=aarora@in.ibm.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+here=`pwd`
+tmp=$TEST_DIR/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15 25
+
+# get standard environment, filters and checks
+. ./common.rc
+
+# real QA test starts here
+# generic, but xfs_io's fallocate must work
+_supported_fs generic
+# only Linux supports fallocate
+_supported_os Linux
+
+[ -n "$XFS_IO_PROG" ] || _notrun "xfs_io executable not found"
+
+rm -f $seq.full
+
+# Sanity check to see if fallocate works
+_require_xfs_io_falloc
+
+# Check if we have good enough space available
+avail=`df -P $TEST_DIR | awk 'END {print $4}'`
+[ "$avail" -ge 104000 ] || _notrun "Test device is too small ($avail KiB)"
+
+# Set the FSIZE ulimit to 100MB and check
+ulimit -f 102400
+flim=`ulimit -f`
+[ "$flim" != "unlimited" ] || _notrun "Unable to set FSIZE ulimit"
+[ "$flim" -eq 102400 ] || _notrun "FSIZE ulimit is not correct (100 MB)"
+
+echo "File size limit is now set to 100 MB."
+echo "Let us try to preallocate 101 MB. This should fail."
+$XFS_IO_PROG -F -f -c 'falloc 0 101m' $TEST_DIR/ouch
+rm -f $TEST_DIR/ouch
+
+echo "Let us now try to preallocate 50 MB. This should succeed."
+$XFS_IO_PROG -F -f -c 'falloc 0 50m' $TEST_DIR/ouch
+rm -f $TEST_DIR/ouch
+
+echo "Test over."
+# success, all done
+status=0
+exit
diff -Nuarp xfstests-dev.org/228.out xfstests-dev/228.out
--- xfstests-dev.org/228.out	1969-12-31 19:00:00.000000000 -0500
+++ xfstests-dev/228.out	2010-05-05 02:38:30.000000000 -0400
@@ -0,0 +1,6 @@
+QA output created by 228
+File size limit is now set to 100 MB.
+Let us try to preallocate 101 MB. This should fail.
+File size limit exceeded
+Let us now try to preallocate 50 MB. This should succeed.
+Test over.
diff -Nuarp xfstests-dev.org/group xfstests-dev/group
--- xfstests-dev.org/group	2010-05-03 02:35:09.000000000 -0400
+++ xfstests-dev/group	2010-05-05 02:38:00.000000000 -0400
@@ -341,3 +341,4 @@ deprecated
 225 auto quick
 226 auto enospc
 227 auto fsr
+228 rw auto prealloc quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
