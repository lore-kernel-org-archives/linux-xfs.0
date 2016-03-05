Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D93AB7CA3
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 18:37:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 90245304039
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 16:37:26 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id TX1x5ArcxvQOpGHp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 16:37:25 -0800 (PST)
Subject: [PATCH v5 00/12] xfstests: minor fixes for the reflink/dedupe tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Mar 2016 16:37:18 -0800
Message-ID: <20160305003717.28738.98818.stgit@birch.djwong.org>
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
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

This is a patch set for xfstests, associated with the fifth revision
to a patch series adding reverse mapping and reflink to XFS.  Patches
1, 3-9, and 11 are bug fixes to existing reflink tests.

Patches 2 and 10 add a few more XFS-specific reflink tests to ensure
that we get the CoW and metadata reservation accounting correct.

Patch 12 adds tests for the new block device fallocate call; don't
bother merging it unless the corresponding kernel patches aren't
shouted down after a reasonable amount of time.

Comments and questions are, as always, welcome.  The fixes are
available on github[1].

--D

[1] https://github.com/djwong/xfstests/tree/reflink-devel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
