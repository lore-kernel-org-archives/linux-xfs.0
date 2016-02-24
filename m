Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1DF337CA2
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 02:20:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D67F48F8033
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 00:20:32 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id UW0EnGzCScIwORxR (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 24 Feb 2016 00:20:18 -0800 (PST)
Received: from [88.128.80.14] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1aYUgC-0004RZ-Qm
	for xfs@oss.sgi.com; Wed, 24 Feb 2016 08:20:17 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: futher writeback updates
Date: Wed, 24 Feb 2016 09:20:08 +0100
Message-Id: <1456302011-18915-1-git-send-email-hch@lst.de>
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

This series contains two patches from Dave (with a rebase and minor updates
from me) which he posted as RFC earlier to reduce the buffer_head dependency
in the writeback path, and one patch from me to make use of bios embedded
into the ioend and bio chaining to further simplify and optimize the writeback
path.

They pass xfstests on 4k and 1k file systems.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
