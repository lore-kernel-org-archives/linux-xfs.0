Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6LEBhNe168826
	for <linux-xfs@oss.sgi.com>; Tue, 21 Jul 2009 09:11:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5EF1376C34
	for <linux-xfs@oss.sgi.com>; Tue, 21 Jul 2009 07:12:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id xvEMCZeXWZyzzgMR for
	<linux-xfs@oss.sgi.com>; Tue, 21 Jul 2009 07:12:26 -0700 (PDT)
Date: Tue, 21 Jul 2009 10:12:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.30 panic - xfs_fs_destroy_inode
Message-ID: <20090721141225.GA24330@infradead.org>
References: <4A408316.2070903@news-service.com>
	<1587994907.388291245745033392.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<20090623171305.GB23971@infradead.org>
	<4A4A7205.6010101@news-service.com>
	<20090701124441.GA12844@infradead.org>
	<4A4CEEF2.7040101@news-service.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A4CEEF2.7040101@news-service.com>
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
To: Patrick Schreurs <patrick@news-service.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@oss.sgi.com, Tommy van Leeuwen <tommy@news-service.com>, Lachlan McIlroy <lmcilroy@redhat.com>, Eric Sandeen <sandeen@sandeen.net>

On Thu, Jul 02, 2009 at 07:31:30PM +0200, Patrick Schreurs wrote:
> Hi Christoph,
>
> With this patch we see the following:
>
> kernel BUG at fs/inode.c:1288!

Okay, I think I figured out what this is.  You hit the case where
we re-use an inode that is gone from the VFS point of view, but
still in xfs reclaimable state.  We reinitialize it using
inode_init_always, but inode_init_always does not touch i_state, which
still includes I_CLEAR.  See the patch below which sets it to the
expected state.  What really worries me is that I don't seem to be
able to actually hit that case in testing.

Can you try the patch below ontop of the previous one?


Index: linux-2.6/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_iget.c	2009-07-21 16:07:41.654923213 +0200
+++ linux-2.6/fs/xfs/xfs_iget.c	2009-07-21 16:08:55.064151137 +0200
@@ -206,6 +206,7 @@ xfs_iget_cache_hit(
 			error = ENOMEM;
 			goto out_error;
 		}
+		inode->i_state = I_LOCK|I_NEW;
 	} else {
 		/* If the VFS inode is being torn down, pause and try again. */
 		if (!igrab(inode))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
