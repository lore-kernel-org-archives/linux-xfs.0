Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EFE557CA1
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 17:27:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B66268F8033
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 15:27:03 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id lPflTlzoZGFZ7IM9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 15:27:01 -0700 (PDT)
Received: from [67.51.76.21] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1aq6lv-0006AM-26
	for xfs@oss.sgi.com; Tue, 12 Apr 2016 22:27:00 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: RFC: use iomap infrastructure for all our zeroing needs
Date: Tue, 12 Apr 2016 15:26:47 -0700
Message-Id: <1460500013-28334-1-git-send-email-hch@lst.de>
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

This series uses the new iomap infrastructure to simplify all kinds
of zeroing operations.  The RFC tag is mostly because the DAX path
modified in this series hasn't been tested yet, the normal buffered
path has been tested and works fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
