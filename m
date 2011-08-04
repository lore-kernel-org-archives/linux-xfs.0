Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p74EE6b6071766 for <xfs@oss.sgi.com>; Thu, 4 Aug 2011 09:14:06 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26FDD168E094
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2011 07:14:59 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id qFrmsSXpQZo2IPeG for <xfs@oss.sgi.com>;
	Thu, 04 Aug 2011 07:14:59 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] Removal of xfs_flush_pages()
Date: Thu,  4 Aug 2011 16:13:54 +0200
Message-Id: <1312467236-31341-1-git-send-email-jack@suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


  Hello,

  here are two patches which remove xfs_flush_pages().  I've split it in two
patches because the first patch contains a slight semantical change (two
XBF_ASYNC callers now call filemap_flush() while they previously ended up
calling filemap_fdatawrite()). Christoph, is this what you had in mind?

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
