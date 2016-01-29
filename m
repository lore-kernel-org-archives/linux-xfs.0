Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 035907CA2
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 13:21:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D163E8F804B
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 11:21:49 -0800 (PST)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	rC8xxCl0rDx5n3Or for <xfs@oss.sgi.com>;
	Fri, 29 Jan 2016 11:21:48 -0800 (PST)
Date: Fri, 29 Jan 2016 12:21:45 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: xfstests xfs/293 failure with current xfstests
Message-ID: <20160129192145.GC5224@linux.intel.com>
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
To: xfs@oss.sgi.com

It looks like the current version of xfsprogs (v4.3.0) has an inconsistency
between its documentation and implementation that is making the xfstest
xfs/293 fail:

./check xfs/293
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 lorwyn 4.5.0-rc1
MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem0p2
MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem0p2 /mnt/xfstests_scratch

xfs/293	 - output mismatch (see /root/xfstests/results//xfs/293.out.bad)
    --- tests/xfs/293.out	2015-10-02 10:19:36.836796097 -0600
    +++ /root/xfstests/results//xfs/293.out.bad	2016-01-29 10:41:25.530512911 -0700
    @@ -1,2 +1,4 @@
     QA output created by 293
     Silence is golden
    +help not documented in the xfs_io manpage
    +zero not documented in the xfs_io manpage
    ...
    (Run 'diff -u tests/xfs/293.out /root/xfstests/results//xfs/293.out.bad'  to see the entire diff)
Ran: xfs/293
Failures: xfs/293
Failed 1 of 1 tests

"help" and "zero" are indeed options in xfs_io, but aren't listed in the man
page.

Thanks,
- Ross

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
