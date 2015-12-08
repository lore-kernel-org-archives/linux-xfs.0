Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1691F7F50
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 15:39:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 06B39304053
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 13:39:05 -0800 (PST)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	IASFt3NXSqL1lEsI for <xfs@oss.sgi.com>;
	Tue, 08 Dec 2015 13:39:04 -0800 (PST)
Date: Tue, 8 Dec 2015 14:39:02 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: v4.4-rc4 regression with direct-io
Message-ID: <20151208213902.GA4212@linux.intel.com>
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
To: Jan Kara <jack@suse.cz>
Cc: Avi Kivity <avi@scylladb.com>, stable@vger.kernel.org, xfs@oss.sgi.com, Jens Axboe <axboe@fb.com>, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, Steven Whitehouse <swhiteho@redhat.com>

Hey Jan,

In my test setup this commit:

74cedf9b6c60 ("direct-io: Fix negative return from dio read beyond eof")

causes a regression with XFS and the test generic/113.  The test used to
pass, but with the above mentioned commit it just hangs indefinitely.

This commit went in between v4.4-rc3 and v4.4-rc4, and it looks like it was
marked for stable?

I've run "echo w > /proc/sysrq-trigger", and it doesn't list any locked
processes so I don't believe that this is a deadlock.  It looks like a
livelock?

My test setup is a pair of 4GiB PMEM partitions (one as the test device and
one as the scratch) in a qemu virtual machine.  This test did not involve DAX,
and turning DAX on makes the test pass once again.

Please let me know if you need any more info or have trouble reproducing the
issue.  I'm happy to test patches.

Thanks,
- Ross

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
