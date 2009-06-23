Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5NH8Hq6038586 for <xfs@oss.sgi.com>; Tue, 23 Jun 2009 12:08:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 582A51D43A17
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2009 10:08:44 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 96aT8XsmXYkWPaep for
	<xfs@oss.sgi.com>; Tue, 23 Jun 2009 10:08:44 -0700 (PDT)
Date: Tue, 23 Jun 2009 13:08:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: inconsistent lock state on 2.6.30?
Message-ID: <20090623170844.GA23971@infradead.org>
References: <Pine.LNX.4.64.0906230925420.20462@cobra.newdream.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906230925420.20462@cobra.newdream.net>
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
To: Sage Weil <sage@newdream.net>
Cc: xfs@oss.sgi.com

On Tue, Jun 23, 2009 at 09:26:04AM -0700, Sage Weil wrote:
> Hi,
> 
> I have 6 machines using an XFS volume for logs, and strangely all 6 of 
> them spit out the following at roughly the same time last night.  Most are 
> around 50% full, all with a single directory full of large append-only 
> files.  They're all running similar workloads, and are all nfs exported.
> 
> Is this a known issue?  If there's any other info that'd be helpful, let 
> me know.

> [15995.063830] inconsistent {RECLAIM_FS-ON-R} -> {IN-RECLAIM_FS-W} usage.
> [15995.063830] kswapd0/290 [HC0[0]:SC0[0]:HE1:SE1] takes:
> [15995.063830]  (&(&ip->i_lock)->mr_lock){++++-?}, at: 
> [<ffffffff803af57a>] xfs_ilock+0x5b/0x79
> [15995.063830] {RECLAIM_FS-ON-R} state was registered at:

If I understand this correctly we take a rw/semaphore in the reclaim
path, and also in a memory allocation that may call back into the fs.

I don't think the actual condition is new, but I've never seen the
warning before.  The patch below should take care of it, can you give it
a try?

Index: linux-2.6/fs/xfs/xfs_da_btree.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_da_btree.c	2009-06-23 19:04:54.640929986 +0200
+++ linux-2.6/fs/xfs/xfs_da_btree.c	2009-06-23 19:05:20.615966923 +0200
@@ -2261,9 +2261,9 @@ xfs_da_buf_make(int nbuf, xfs_buf_t **bp
 	int		off;
 
 	if (nbuf == 1)
-		dabuf = kmem_zone_alloc(xfs_dabuf_zone, KM_SLEEP);
+		dabuf = kmem_zone_alloc(xfs_dabuf_zone, KM_NOFS);
 	else
-		dabuf = kmem_alloc(XFS_DA_BUF_SIZE(nbuf), KM_SLEEP);
+		dabuf = kmem_alloc(XFS_DA_BUF_SIZE(nbuf), KM_NOFS);
 	dabuf->dirty = 0;
 #ifdef XFS_DABUF_DEBUG
 	dabuf->ra = ra;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
