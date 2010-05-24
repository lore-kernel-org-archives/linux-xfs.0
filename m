Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4O6aaLl163632 for <xfs@oss.sgi.com>; Mon, 24 May 2010 01:36:37 -0500
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C79BFA255B1
	for <xfs@oss.sgi.com>; Sun, 23 May 2010 23:40:30 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id i54xfkiAgDVwGHEE for
	<xfs@oss.sgi.com>; Sun, 23 May 2010 23:40:30 -0700 (PDT)
Message-ID: <4BFA1F03.6030909@cn.fujitsu.com>
Date: Mon, 24 May 2010 14:38:59 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] btrfs: should add a permission check for setfacl
References: <4BF1E458.7060500@cn.fujitsu.com>
	<20100520083340.GC11920@infradead.org>
In-Reply-To: <20100520083340.GC11920@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "Yan, Zheng" <zheng.yan@oracle.com>, linux-btrfs@vger.kernel.org, chris.mason@oracle.com, xfs@oss.sgi.com

cc xfstests ml

at 2010-5-20 16:33, Christoph Hellwig wrote:
> On Tue, May 18, 2010 at 08:50:32AM +0800, Shi Weihua wrote:
>> On btrfs, do the following
>> ------------------
>> # su user1
>> # cd btrfs-part/
>> # touch aaa
>> # getfacl aaa
>>   # file: aaa
>>   # owner: user1
>>   # group: user1
>>   user::rw-
>>   group::rw-
>>   other::r--
>> # su user2
>> # cd btrfs-part/
>> # setfacl -m u::rwx aaa
>> # getfacl aaa
>>   # file: aaa
>>   # owner: user1
>>   # group: user1
>>   user::rwx           <- successed to setfacl
>>   group::rw-
>>   other::r--
>> ------------------
>> but we should prohibit it that user2 changing user1's acl.
>> In fact, on ext3 and other fs, a message occurs:
>>   setfacl: aaa: Operation not permitted
> 
> Can you add this as a new testcase to xfstests so that we can easiy
> check for regressions and future filesystems implementing this
> correctly?
> 

did it. maybe it should be merged into 051 or 099.

Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>
---
diff -urpN xfstests.orig.229/230 xfstests/230
--- xfstests.orig.229/230	1970-01-01 08:00:00.000000000 +0800
+++ xfstests/230	2010-05-28 14:27:02.000000000 +0800
@@ -0,0 +1,80 @@
+#! /bin/bash
+# FS QA Test No. 230
+#
+# Check user B can setfacl a file which belongs to user A
+# See also http://marc.info/?l=linux-btrfs&m=127434445620298&w=2
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 FUJITSU LIMITED. All Rights Reserved.
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
+owner=shiwh@cn.fujitsu.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+runas=$here/src/runas
+status=1        # FAILure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.attr
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	[ -n "$testdir" ] && rm -rf $testdir/$seq.dir1
+	_cleanup_testdir
+}
+
+# real QA test starts here
+_supported_fs generic
+# only Linux supports fallocate
+_supported_os Linux
+
+[ -x $runas ] || _notrun "$runas executable not found"
+
+rm -f $seq.full
+
+_setup_testdir
+
+_need_to_be_root
+_acl_setup_ids
+_require_acls
+
+# get dir
+cd $testdir
+rm -rf $seq.dir1
+mkdir $seq.dir1
+cd $seq.dir1
+
+touch file1
+chown $acl1.$acl1 file1
+
+echo "Expect to FAIL"
+$runas -u $acl2 -g $acl2 -- `which setfacl` -m u::rwx file1 2>&1
+
+echo "Test over."
+# success, all done
+status=0
+exit
diff -urpN xfstests.orig.229/230.out xfstests/230.out
--- xfstests.orig.229/230.out	1970-01-01 08:00:00.000000000 +0800
+++ xfstests/230.out	2010-05-28 14:27:05.000000000 +0800
@@ -0,0 +1,4 @@
+QA output created by 230
+Expect to FAIL
+setfacl: file1: Operation not permitted
+Test over.
diff -urpN xfstests.orig.229/group xfstests/group
--- xfstests.orig.229/group	2010-05-28 11:29:31.000000000 +0800
+++ xfstests/group	2010-05-28 14:26:48.000000000 +0800
@@ -343,3 +343,4 @@ deprecated
 227 auto fsr
 228 rw auto prealloc quick
 229 auto
+230 acl auto

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
