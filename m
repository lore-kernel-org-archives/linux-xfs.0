Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB479LM4031913 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 01:09:22 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F04C16904DC
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 23:09:21 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id hwIMVcvLYaq1qUXT for
	<xfs@oss.sgi.com>; Wed, 03 Dec 2008 23:09:21 -0800 (PST)
Date: Thu, 4 Dec 2008 02:08:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Remove unnecessary assertion
Message-ID: <20081204070850.GC29531@infradead.org>
References: <49377863.1070109@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49377863.1070109@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Dec 04, 2008 at 05:27:47PM +1100, Lachlan McIlroy wrote:
> Hit this assert because an inode was tagged with XFS_ICI_RECLAIM_TAG but
> not XFS_IRECLAIMABLE|XFS_IRECLAIM.  This is because xfs_iget_cache_hit()
> first clears XFS_IRECLAIMABLE and then calls __xfs_inode_clear_reclaim_tag()
> while only holding the pag_ici_lock in read mode so we can race with
> xfs_reclaim_inodes_ag().  Looks like xfs_reclaim_inodes_ag() will do the
> right thing anyway so just remove the assert.
> 
> Thanks to Christoph for pointing out where the problem was.

Yeah, given that I ran with this patch for a while you have my ACK for
it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
