Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 353C07F5D
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 09:15:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F2009304051
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 07:15:34 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ZUh6gY8HX6V6OxM0 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 23 Nov 2013 07:15:34 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VkEvl-0001Nf-MM
	for xfs@oss.sgi.com; Sat, 23 Nov 2013 15:15:33 +0000
Message-Id: <20131123151151.716201348@bombadil.infradead.org>
Date: Sat, 23 Nov 2013 07:11:51 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/7] decouple the in-memory from the on-disk log format
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
