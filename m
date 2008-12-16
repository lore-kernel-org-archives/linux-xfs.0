Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBG51Crm006207 for <xfs@oss.sgi.com>; Mon, 15 Dec 2008 23:01:12 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7BD951739AF4
	for <xfs@oss.sgi.com>; Mon, 15 Dec 2008 21:01:11 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id xuOHbYTbw3WASDhU for <xfs@oss.sgi.com>;
	Mon, 15 Dec 2008 21:01:11 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id BFC08AAC743
	for <xfs@oss.sgi.com>; Mon, 15 Dec 2008 23:01:10 -0600 (CST)
Message-ID: <49473616.1020307@sandeen.net>
Date: Mon, 15 Dec 2008 23:01:10 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: xfstests tests not in the auto group; do we know why?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs-oss <xfs@oss.sgi.com>

Of the tests that are not in the auto group, do we know why they are not?

022: # Test out a level 0 dump/restore to a tape of a subdir
023: # To test xfsdump/restore to tape using a directory with
024: # Test out incremental dumps
025: # Test dump/restore using -m option (min strategy)
036: # Test xfsdump/restore minrmt to a remote IRIX tape
037: # Test xfsdump/restore minrmt to a remote linux tape
038: # Test xfsdump/restore to a remote linux tape
039: # Test xfsdump/restore to a remote IRIX tape
043: # Test out xfsdump/restore but rmv inventory prior to restore.
055: # Test xfsdump/restore to a remote IRIX tape using RMT user
059: # place holder for IRIX 059 test for xfsdump/xfsrestore multi streams
060: # place holder for IRIX 060 test for xfsdump/xfsrestore multi streams
064: # test multilevel dump and restores with hardlinks
071: # Exercise IO at large file offsets.
080: # rwtest (iogen|doio)
085: # To test log replay by shutdown of file system
086: # To test log replay with version 2 logs
087: # like 086 but want to create more/different kinds of metadata
098: # simple attr tests for EAs:
101: # This tests mkfs_udf with -s [SIZE] option.
102: # This tests mkfs_udf/mkudffs and the device detection code
104: # XFS online growfs-while-allocating tests (data subvol variant)
106: # Exercise basic xfs_quota functionality (user/group/project quota)
107: # Project quota.
108: # Simple quota accounting test for direct/buffered/mmap IO.
109: # ENOSPC deadlock case from Asano Masahiro.
110: # Incorrect dir2 freetab warning case from Masanori Tsuda.
111: # Infinite xfs_bulkstat bad-inode loop case from Roger Willcocks.
113: # aio-stress
114: # Test some parent ptr stuff
115: # Test out xfs_repair_ipaths
116: # Test out resetting of sb_qflags when mounting with no quotas
after having mounted with quotas.
118: # To test out pv#940675 crash in xfs_trans_brelse + quotas
119: # Leaking reservation space in the GRH
133: # Concurrent I/O to same file to ensure no deadlocks
136: # Test the attr2 code


udf tests are probably not auto out of principle? :)
071 fails/hangs on some platforms IIRC
104 hangs ...
"parent" requires code not committed(?)
"tape" group requires... tape so not auto?

# auto - tests to be run as part of nightly qa

I'm not sure what that means; is this group always supposed to pass?  If
so there are filestreams tests that don't, for example.  Maybe "tests
that don't hang?"

I wonder if it'd be worth documenting this a bit, and have a group which
should always run & pass on the core architectures.  (and for those that
don't pass, do a bit of documentation on why they don't?)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
