Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8F08B7F7D
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 18:39:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3B4F7304043
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 16:39:16 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 5gxAFPD89tmqbZqh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 16:39:14 -0700 (PDT)
Subject: [RFC(RAP) 00/14] xfs: add reflink and dedupe support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jun 2015 16:39:10 -0700
Message-ID: <20150625233909.4992.68314.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Hi all,

This is a RFC-quality pass at kernel support for mapping multiple file
logical blocks to the same physical block, more commonly known as
reflinking.  It is a single [block, refcount] tree to track the
reference counts of extents of physical blocks.  There's also a bunch
of support code that provides the desired copy-on-write behavior,
userland interfaces to reflink, query the status of, and un-reflink
files.

The patch set is based on the current (4.2) for-next branch plus
Dave's rmap RFC patches.  There are still a lot of bugs in this code;
I'm not sure that I've gotten the locking and the transaction
handling correct.  Deadlocks and hangs due to the log being full are
unfortunately common, but light exercise shows that it works well
enough as a proof of concept.

The ioctl interface to XFS reflink looks surprisingly like the btrfs
ioctl interface <cough> -- you can reflink a file, reflink subranges
of a file, or dedupe subranges of files.  (Dedupe also checks file
blocks, though I have a feeling it's racy.)  To un-reflink a file,
simply chattr +C it to mark it no-cow.  xfs_fsr can be better at
that, though. :)

If you're going to start using this mess, you're going to want to pull
my xfsprogs dev tree[1], which itself is also based on xfsprogs
for-next and the userland rmap support bits.  I've not had time to get
reflink and rmap to work together.

I've also prepared a bunch of xfstests[2] to exercise the userland
interfaces.

This is an extraordinary way to eat your data.  Enjoy!

Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/xfsprogs/commits/for-next
[2] https://github.com/djwong/xfstests/commits/master

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
