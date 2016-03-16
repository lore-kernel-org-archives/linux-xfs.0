Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DF17E7CEB
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 06:44:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4B079AC008
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 04:44:47 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id qOsFciwhiMQB8Slb (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 04:44:44 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: further writeback updates V2
Date: Wed, 16 Mar 2016 12:44:38 +0100
Message-Id: <1458128681-10869-1-git-send-email-hch@lst.de>
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
Cc: bfoster@redhat.com

This series contains two patches from Dave (with a rebase and minor updates
from me) which he posted as RFC earlier to reduce the buffer_head dependency
in the writeback path, and one patch from me to make use of bios embedded
into the ioend and bio chaining to further simplify and optimize the writeback
path.

They pass xfstests on 4k and 1k file systems.

Changes since V1:
 - various minor refactoring based on the comments from Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
