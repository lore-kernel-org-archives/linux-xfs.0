Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6UFG9xf141713 for <xfs@oss.sgi.com>; Sat, 30 Jul 2011 10:16:09 -0500
Received: from merit-proxy02.merit.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BDD511EF126B
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2011 08:16:07 -0700 (PDT)
Received: from merit-proxy02.merit.edu (merit-proxy02.merit.edu
	[207.75.116.194]) by cuda.sgi.com with ESMTP id
	DLF7UNyKkXlDAuOW for <xfs@oss.sgi.com>;
	Sat, 30 Jul 2011 08:16:07 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by merit-proxy02.merit.edu (Postfix) with ESMTP id 261B02039874
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2011 11:16:07 -0400 (EDT)
Received: from merit-proxy02.merit.edu ([127.0.0.1])
	by localhost (merit-proxy02.merit.edu [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id ru5LhIaLySjh for <xfs@oss.sgi.com>;
	Sat, 30 Jul 2011 11:16:06 -0400 (EDT)
Received: from merit.edu (74-126-0-171.static.123.net [74.126.0.171])
	by merit-proxy02.merit.edu (Postfix) with ESMTPSA id BB287203986F
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2011 11:16:05 -0400 (EDT)
Date: Sat, 30 Jul 2011 11:16:04 -0400
From: Jim Rees <rees@umich.edu>
Subject: xfstests fails on nfs4 file system
Message-ID: <20110730151604.GA26285@merit.edu>
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

xfstests fails on nfs4 file system:

rhcl1# mount -t nfs -o nfsvers=4,minorversion=1 emc-1:/pnfs2 /mnt/emc-1
rhcl1# cd /home/rees/xfstests
rhcl1# setenv TEST_DEV emc-1:/pnfs2
rhcl1# setenv TEST_DIR /mnt/emc-1/rees/xfstests
rhcl1# ./check -nfs
common.rc: Error: $TEST_DEV (emc-1:/pnfs2) is not a MOUNTED nfs filesystem
/bin/df: `emc-1:/pnfs2': No such file or directory
/bin/df: no file systems processed

Originally nfs4 was a separate file system type, and it still shows up that
way in mtab:
emc-1:/pnfs2/ on /mnt/emc-1 type nfs4 (rw,relatime,vers=4,...

I fixed this by commenting out the type check at the end of common.rc.  I
don't know enough about the innards of xfstests to know what the proper fix
is.  Maybe a substring match, or explicit check for nfs4?

rhcl1# diff -u common.rc common.rc-ok
--- common.rc   2011-07-29 12:11:34.118251109 -0400
+++ common.rc-ok        2011-07-29 12:33:58.384749553 -0400
@@ -1588,12 +1588,6 @@
         fi
     fi
 
-    if [ "`_fs_type $TEST_DEV`" != "$FSTYP" ]
-    then
-        echo "common.rc: Error: \$TEST_DEV ($TEST_DEV) is not a MOUNTED $FSTYP filesystem"
-        $DF_PROG $TEST_DEV
-        exit 1
-    fi
 fi
 
 # make sure this script returns success

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
