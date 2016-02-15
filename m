Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A70067CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 14:46:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 39331AC002
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 12:46:16 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 8ZmKervsCjxJvezd (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 15 Feb 2016 12:46:14 -0800 (PST)
Subject: [PATCH v4.3 0/3] xfstests: minor fixes for the reflink/dedupe tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 15 Feb 2016 12:46:08 -0800
Message-ID: <20160215204608.7977.2802.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

This is a patch set against the reflink/dedupe test cases in xfstests.
All three patches fix some minor problems in the giant testcase merge
last weekend.

The zeroth patch ought to be Filipe Manana's patch ("fstests:
generic/158, test dedupe with destination offset past EOF") but as he
just resent that this morning, I won't repost it here.

The first patch, then, corrects the error output in the high offset
dedupe test (generic/304).

The second patch changes punch-alternating.c to use the filesystem
accounting block size to determine where to punch holes in the file
because that value is the internal filesystem block size.  This makes
the program behave as expected when testing with non-page-size block
sizes on XFS.

The third patch adds to _require_xfs_io_command the ability to check
that a subcommand supports a particular command line argument and adds
to xfs/24[356] the ability to check for the -c switch to the xfs_io
bmap command.

Comments and questions are, as always, welcome.  The fixes are
available on github[1].

--D

[1] https://github.com/djwong/xfstests/tree/for-dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
