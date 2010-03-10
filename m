Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2A9B709029926 for <xfs@oss.sgi.com>; Wed, 10 Mar 2010 03:11:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1522122BB45
	for <xfs@oss.sgi.com>; Wed, 10 Mar 2010 01:12:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HlaNDi9nAytgJnKx for
	<xfs@oss.sgi.com>; Wed, 10 Mar 2010 01:12:38 -0800 (PST)
Date: Wed, 10 Mar 2010 04:12:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: truncate delalloc extents when IO fails in
	writeback
Message-ID: <20100310091237.GA25227@infradead.org>
References: <1267667185-7736-1-git-send-email-david@fromorbit.com>
	<1267667185-7736-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1267667185-7736-3-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Btw, I can trigger the new warnings from this patch in xfsqa after
a few full XFSQA runs:

[39829.737139] Filesystem "vdb6": page discard on page c21d7480, inode
0x3f8, offset 0.
[39829.739488] Filesystem "vdb6": page discard failed delalloc mapping
lookup.
[39829.744005] Filesystem "vdb6": page discard on page c206ba80, inode
0x3f9, offset 0.
[39829.746496] Filesystem "vdb6": page discard failed delalloc mapping
lookup.
[39829.748655] Filesystem "vdb6": page discard on page c20e02a0, inode
0x3fa, offset 0.
[39829.751000] Filesystem "vdb6": page discard failed delalloc mapping
lookup.


going on for a few pages of kernel messages.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
