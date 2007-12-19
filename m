Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 17:06:12 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBJ162rl008295
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 17:06:07 -0800
Date: Wed, 19 Dec 2007 12:06:07 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs mknod regression
Message-ID: <20071219010607.GT4396912@sgi.com>
References: <dda83e780712172048n4d40cfcbw4a4d3106fc99f02e@mail.gmail.com> <20071218173642.GA7338@infradead.org> <20071219003745.GR4396912@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219003745.GR4396912@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Bret Towe <magnade@gmail.com>, xfs@oss.sgi.com

On Wed, Dec 19, 2007 at 11:37:45AM +1100, David Chinner wrote:
> On Tue, Dec 18, 2007 at 05:36:42PM +0000, Christoph Hellwig wrote:
> > 
> > This was broken by my '[XFS] simplify xfs_create/mknod/symlink prototype',
> > which assigned the re-shuffled ondisk dev_t back to the rdev variable in
> > xfs_vn_mknod.  Because of that i_rdev is set to the ondisk dev_t instead
> > of the linux dev_t later down the function.
> > 
> > Fortunately the fix for it is trivial:  we can just remove the
> > assignment because xfs_revalidate_inode has done the proper job before
> > unlocking the inode.
> > 
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
> > ===================================================================
> > --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-12-18 18:23:32.000000000 +0100
> > +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2007-12-18 18:23:43.000000000 +0100
> > @@ -345,9 +345,7 @@ xfs_vn_mknod(
> >  		ASSERT(vp);
> >  		ip = vn_to_inode(vp);
> >  
> > -		if (S_ISCHR(mode) || S_ISBLK(mode))
> > -			ip->i_rdev = rdev;
> > -		else if (S_ISDIR(mode))
> > +		if (S_ISDIR(mode))
> >  			xfs_validate_fields(ip);
> >  		d_instantiate(dentry, ip);
> >  		xfs_validate_fields(dir);
> 
> Thanks for this, Christoph - I'll run some tests on it and check it in.

Can I get an eyeball or two on the qa test below so i can check it in at the
same time?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 xfstests/184     |   43 +++++++++++++++++++++++++++++++++++++++++++
 xfstests/184.out |    1 +
 xfstests/group   |    1 +
 3 files changed, 45 insertions(+)

Index: xfs-cmds/xfstests/group
===================================================================
--- xfs-cmds.orig/xfstests/group	2007-12-19 12:01:13.000000000 +1100
+++ xfs-cmds/xfstests/group	2007-12-19 12:02:25.141919445 +1100
@@ -271,3 +271,4 @@ filestreams	dgc@sgi.com
 181 log auto
 182 metadata rw auto
 183 rw other auto
+184 metadata auto
Index: xfs-cmds/xfstests/184
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfs-cmds/xfstests/184	2007-12-19 12:05:39.756887566 +1100
@@ -0,0 +1,43 @@
+#! /bin/sh
+# FS QA Test No. 184
+#
+# check mknod makes working nodes.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2007 Silicon Graphics, Inc.  All Rights Reserved.
+#-----------------------------------------------------------------------
+#
+# creator
+owner=dgc@sgi.com
+
+seq=`basename $0`
+echo "QA output created by $seq - silence is golden"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+    _cleanup_testdir
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs xfs udf nfs
+_supported_os IRIX Linux
+
+_setup_testdir
+
+mknod $testdir/null c 1 3
+chmod 666 $testdir/null
+echo fred > $testdir/null
+
+status=$?
+exit
Index: xfs-cmds/xfstests/184.out
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfs-cmds/xfstests/184.out	2007-12-19 12:03:13.835636262 +1100
@@ -0,0 +1 @@
+QA output created by 184 - silence is golden
