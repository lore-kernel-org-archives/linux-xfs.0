Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 88D807F3F
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 02:38:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5FD008F806F
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 00:38:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id g1TbPGgzYj9Gl0rS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Nov 2013 00:38:02 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VmJaL-0008TZ-K4
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 08:38:01 +0000
Message-Id: <20131129083658.401196724@bombadil.infradead.org>
Date: Fri, 29 Nov 2013 00:36:58 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/0] decouple the in-memory from the on-disk log format V2
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

Since the introduction of the CIL we already have a layer of indirection
between the physical log format and the data structure tracking the
changes in memory.  But due to the way iop_format works we are still
forced to keep a copy of everything that goes out to the log in memory
even before copying it into the CIL.

The first patch in this series changes iop_format so that the log items
are free to store their in-memory data however they want before formatting
them into the CIL, and the other patches take advantage of that by not
keeping most log formats in memory all the time.  Especially the EFI and
EFD related ones at the end start to show the benefit.

What's missing from this series are larger changes to the in-core inode
layout.  No needing the full struct icdinode at all times will be the
biggest benefit of this change, but it will be large enough series of it's
own.

Changes from V1:
 - split into more patches
 - added the xlog_copy_iovec helper

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
