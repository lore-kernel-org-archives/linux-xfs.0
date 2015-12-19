Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B70D27F50
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:55:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A88C68F8039
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:55:15 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id MbnxTuw1Ca4oZjRT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:55:13 -0800 (PST)
Subject: [RFCv4 0/9] vfs: hoist reflink/dedupe ioctls to the VFS
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:55:05 -0800
Message-ID: <20151219085505.12478.71157.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, xfs@oss.sgi.com

Hi all,

This patch set goes along with the fourth revision of an RFC adding to
XFS kernel support for tracking reverse-mappings of physical blocks to
file and metadata; and support for mapping multiple file logical
blocks to the same physical block, more commonly known as reflinking.

The first four patches are taken verbatim from Anna Schumaker's
patches adding a physical copy call to the kernel.  The next two
patches are from Christoph Hellwig, and hoist the clone and
clone_range ioctls into the VFS.  These patches are a bit old at
this point; they're in here solely to demonstrate how this (long)
patchset diverges from upstream.

The third patch fixes some bugs in the first four patches, and the
fourth patch hoists the extent_same ioctl into the VFS as the dedupe
ioctl.

The patch set is based on the current (4.4-rc5) upstream kernel.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
See also the xfs-docs[4] and manpage[5] updates.

This is an extraordinary way to eat your data.  Enjoy!

Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/for-dave
[2] https://github.com/djwong/xfsprogs/tree/for-dave
[3] https://github.com/djwong/xfstests/tree/for-dave
[4] https://github.com/djwong/xfs-documentation/tree/for-dave
[5] https://github.com/djwong/man-pages/commits/for-mtk

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
