Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 528FD7CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 21:45:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2315D8F8033
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 19:45:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EOcj9cQWNZbz6zE7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 19:45:17 -0700 (PDT)
Date: Thu, 4 Aug 2016 10:45:14 +0800
From: Xiong Zhou <xzhou@redhat.com>
Subject: xfstests xfs fuzzers fail with DAX
Message-ID: <20160804024514.GA2906@xzhoul.usersys.redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-nvdimm@ml01.01.org, xfs@oss.sgi.com
Cc: jmoyer@redhat.com, linux-kernel@vger.kernel.org

Hi,

A few xfs fuzzers in xfstests fail with dax mount option, pass without dax.
They are xfs/086 xfs/088 xfs/089 xfs/091.

xfstests to commit 4470ad4c7e  (Jul 26)
kernel   to commit dd95069545  (Jul 24)

+ ./check xfs/091
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 rhel73 4.7.0+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem1
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/pmem1 /daxsch

xfs/091	 104s
Ran: xfs/091
Passed all 1 tests

+ echo 'MOUNT_OPTIONS="-o dax"'
+ ./check xfs/091
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 rhel73 4.7.0+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem1
MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem1 /daxsch

xfs/091 104s ...  - output mismatch (see /root/xfstests/results//xfs/091.out.bad)
    --- tests/xfs/091.out	2016-07-18 02:57:47.670000000 -0400
    +++ /root/xfstests/results//xfs/091.out.bad	2016-08-03 22:38:14.948000000 -0400
    @@ -6,6 +6,70 @@
     + corrupt image
     + mount image
     + modify files
    +pwrite64: Structure needs cleaning
    +pwrite64: Structure needs cleaning
    +pwrite64: Structure needs cleaning
    +pwrite64: Structure needs cleaning
    ...
    (Run 'diff -u tests/xfs/091.out /root/xfstests/results//xfs/091.out.bad'  to see the entire diff)
Ran: xfs/091
Failures: xfs/091
Failed 1 of 1 tests

# diff -u xfstests/tests/xfs/091.out /root/xfstests/results//xfs/091.out.bad
--- xfstests/tests/xfs/091.out	2016-07-18 02:57:47.670000000 -0400
+++ /root/xfstests/results//xfs/091.out.bad	2016-08-03 22:38:14.948000000 -0400
@@ -6,6 +6,70 @@
 + corrupt image
 + mount image
 + modify files
+pwrite64: Structure needs cleaning
<snip 62 more same lines>
+pwrite64: Structure needs cleaning
 + repair fs
 + mount image
 + chattr -R -i


Thanks,
Xiong

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
