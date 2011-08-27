Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7R5vaoS179097 for <xfs@oss.sgi.com>; Sat, 27 Aug 2011 00:57:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D59FF11E25A
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2011 22:57:32 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	U5XZlwxWi6v8Yzuw for <xfs@oss.sgi.com>;
	Fri, 26 Aug 2011 22:57:32 -0700 (PDT)
Date: Sat, 27 Aug 2011 01:57:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/2] make sure to always update the inode size on umount
Message-ID: <20110827055731.GA24159@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This series addresses an issue where XFS might not actually flush the
inode size if we wrote out the inode data during umount, which was
recently reported on #xfs on irc.  (If the reported is active on the
list please chime in so that I can add your reported-by tag!).

The first patch is the guts of the fix, and the second fixes various
issues with ->write_inode that I found during the audit.  To me patch
1 is a clear Linux 3.1 candidate, and I would tend to nominate patch 2
as well.

I think we also have some issue with the VFS writeback code not handling
inode redirtying from the I/O completion handler nicely, but I'll send
another patch for that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
