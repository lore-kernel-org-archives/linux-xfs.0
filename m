Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7HLHNKB093812
	for <linux-xfs@oss.sgi.com>; Mon, 17 Aug 2009 16:17:38 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F4D114CC975
	for <linux-xfs@oss.sgi.com>; Mon, 17 Aug 2009 14:17:48 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Jnnhxlx44FqCgj9E for
	<linux-xfs@oss.sgi.com>; Mon, 17 Aug 2009 14:17:48 -0700 (PDT)
Date: Mon, 17 Aug 2009 17:14:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.30 panic - xfs_fs_destroy_inode
Message-ID: <20090817211437.GA5929@infradead.org>
References: <4A408316.2070903@news-service.com>
	<1587994907.388291245745033392.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<20090623171305.GB23971@infradead.org>
	<4A4A7205.6010101@news-service.com>
	<20090701124441.GA12844@infradead.org>
	<4A4CEEF2.7040101@news-service.com>
	<20090721141225.GA24330@infradead.org>
	<89c4f90c0907220155u5d9331dj3cbe53efcf6b51f2@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <89c4f90c0907220155u5d9331dj3cbe53efcf6b51f2@mail.gmail.com>
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
To: Tommy van Leeuwen <tommy@news-service.com>
Cc: Christoph Hellwig <hch@infradead.org>, Patrick Schreurs <patrick@news-service.com>, Lachlan McIlroy <lmcilroy@redhat.com>, linux-xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>

On Wed, Jul 22, 2009 at 10:55:54AM +0200, Tommy van Leeuwen wrote:
> Unfortunately we still get errors, with this patch on top of the
> previous one: The difference is that is now crashes within an hour
> instead of once a week, so that might be good for troubleshooting.

Hi Tommy and sorry for dropping the ball on this, I didn't remember this
mail anymore until I look for more reporters of the inode related
problems.

Current mainline (Linus' git as of today) has a lot of the fixes in this
area, any chance I could trick you into trying it?  Maybe including the
debug patch below which adds a printk to that one culprit that I thing
might remain:

Also if it still happens any chance you could send output of the dmesg
command instead of the syslog files?  For some reason syslogd usually
eats up some bits of kernel oops message..


Index: linux-2.6/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_iget.c	2009-08-17 18:08:39.563217129 -0300
+++ linux-2.6/fs/xfs/xfs_iget.c	2009-08-17 18:09:12.999316531 -0300
@@ -242,6 +242,8 @@ xfs_iget_cache_hit(
 
 		error = -inode_init_always(mp->m_super, inode);
 		if (error) {
+			printk("XFS: inode_init_always failed to re-initialize inode\n");
+
 			/*
 			 * Re-initializing the inode failed, and we are in deep
 			 * trouble.  Try to re-add it to the reclaim list.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
