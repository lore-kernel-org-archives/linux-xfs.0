Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2F5EF7CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 08:02:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AE26BAC005
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 06:02:15 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id GySFWJLHzOWZCDpl (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 06:02:13 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: oh the joy of swap files
Date: Thu, 26 May 2016 15:02:03 +0200
Message-Id: <1464267724-31423-1-git-send-email-hch@lst.de>
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
To: darrick.wong@oracle.com
Cc: linux-mm@kvack.org, xfs@oss.sgi.com

Quirk out of ->bmap for reflink inodes because the swap code still
believes it's a good idea to blindly bypass the fs if it exists.

This is a bit of a crude hack, but without redesigning how swapfiles
work we can't really do very much better.  Except for a real error
code from ->bmap, but that's a bit like putting lipstick on a pig..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
