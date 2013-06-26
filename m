Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 792117F4E
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 14:16:38 -0500 (CDT)
Date: Wed, 26 Jun 2013 14:16:35 -0500
From: Ben Myers <bpm@sgi.com>
Subject: XFS status update for May 2013
Message-ID: <20130626191635.GT32736@sgi.com>
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
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

May saw the merge of the XFS development tree for Linux 3.10 into
mainline as well as a number of fixes after the initial merge.

Linux 3.10 will be an exciting release for XFS as this release includes
an experimental feature, CRC protection for on-disk metadata structures.
In order to create a CRC enabled filesystem, build the crc-dev branch of
xfsprogs located at git://oss.sgi.com/xfs/cmds/xfsprogs.git and mkfs.

We also saw the release of xfsprogs-3.1.11 and xfsdump-3.1.3.  xfsprogs
includes a numerous fixes for xfs_repair, xfs_metadump, mkfs, and
xfs_db.  xfsdump has fixes for a backward compatability problem with
dumps created with 3.1.2, and a fix for a segfault in xfsrestore.

Other work that was posted in May includes a series of fixes for log
space validation, a revision of a patchset to allow project and group
quotas to be used simultaneously, and a number of new tests for
xfstests.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
