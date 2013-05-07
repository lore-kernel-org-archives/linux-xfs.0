Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8018B29E19
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 03:05:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 76948304071
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 01:05:06 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	yBcx7HmfAoZepjbk for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 01:05:04 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UZctH-0006Z7-G6
	for xfs@oss.sgi.com; Tue, 07 May 2013 18:04:51 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UZctH-0007rB-49
	for xfs@oss.sgi.com; Tue, 07 May 2013 18:04:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC, PATCH 0/7] xfs: new icreate transaction
Date: Tue,  7 May 2013 18:04:29 +1000
Message-Id: <1367913876-30086-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

As ben and I discussed during the review of the initial CRC series,
inode allocation needs to log the entire inode to ensure the
replayed create transaction results in an inode with the correct
CRC. This means that the logging overhead of inode create doubled
for 256 byte inodes, and is close to 5x higher for 512 byte inodes.

Ben suggested that having a transaction to initialise buffers to
zero without needing to log them physically might be a way to solve
the problem. It would solve the problem, but I already have a
patchset from a few years back that introduces a new inode create
transaction that doesn't require any physical logging on inodes at
all.

This patch series is a forward port of my original work from 2009
(hence the SOBs being from david@fromorbit.com) with a couple of
more recent patches that will also help reduce inode buffer lookups
and hence improve performance.

The first two patches are for reducing he number of inode buffer
lookups. When we are allocating a new inode, the only reason we look
up the inode buffer is to read the generation number so we can
increment it. This patch replaces the inode buffer read with radomly
calculating a new generation number, resulting in an inode
allocation being a purely in-memory operation requiring no IO. There
is a caveat to that - for people using noikeep, we still need to
ensure the generation number increments monotonically so we only
take the new path if that mount option is not set. This reduces
buffer lookups under create heavy workloads by roughly 10%.

The second patch removes a buffer lookup and modification on unlink
that was added for coherency with bulkstat back when bulkstat did
non-cohernet inode lookups. bulkstat is using coherent lookups
again, so the code in unlink is not necessary any more.

The remaining 5 patches are the new icreate transaction series. The
first patch introduced ordered buffers. These are buffers that are
modified in transactions but are not logged by the transaction. They
have an identical lifecycle to a normal buffer, and so pin the tail
ofthe log until they are written back. This enables us to do log a
logical change and have all the physical changes behave as though
physical logging had been performed. This is used for the inode
buffers by the new icreate transaction.

The rest of the patches are simply mechanical - introducing the
inode create log item, the changes to transaction reservations (uses
less space in the log), converting the code to selectively use the
new logging method and adding recovery support to it.

Right now the code will use this transaction if the filesystem is
CRC enabled. Given that CRC enabled filesystems are experimental at
this point, adding a new log item type should not be a major problem
for anyone using them - just make sure the log is clean before
downgrading to an older kernel...

The patchset passes xfstests on non-CRC filesystems without new
regressions and the initial two patches are resulting in a ~10%
improvement in 8-way create speed and a ~15% improvement in 8-way
unlink speed. I don't have any numbers on CRC enabled filesystems as
I've been working on the userspace CRC patchset and getting that
into shape rather than tesing and benchmarking kernel CRC code...

Comments, thoughts, flames?

-Dave.

PS. I'm working on an equivalent patchset for unlink that logs the
the unlinked list as part of the inode core for CRC enabled
filesystems. That's a little bit away from working yet, though...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
