Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3OHqREm094219 for <xfs@oss.sgi.com>; Fri, 24 Apr 2009 12:52:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 391251CE636F
	for <xfs@oss.sgi.com>; Fri, 24 Apr 2009 10:52:25 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nUsJWjHJOx1kp0bu for
	<xfs@oss.sgi.com>; Fri, 24 Apr 2009 10:52:25 -0700 (PDT)
Date: Fri, 24 Apr 2009 13:52:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_file_last_byte() needs to acquire ilock
Message-ID: <20090424175224.GB32198@infradead.org>
References: <1624785772.3251240539480564.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1624785772.3251240539480564.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
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
To: Lachlan McIlroy <lmcilroy@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 23, 2009 at 10:18:00PM -0400, Lachlan McIlroy wrote:
> We had some systems crash with this stack:
> 
> [<a00000010000cb20>] ia64_leave_kernel+0x0/0x280
> [<a00000021291ca00>] xfs_bmbt_get_startoff+0x0/0x20 [xfs]
> [<a0000002129080b0>] xfs_bmap_last_offset+0x210/0x280 [xfs]
> [<a00000021295b010>] xfs_file_last_byte+0x70/0x1a0 [xfs]
> [<a00000021295b200>] xfs_itruncate_start+0xc0/0x1a0 [xfs]
> [<a0000002129935f0>] xfs_inactive_free_eofblocks+0x290/0x460 [xfs]
> [<a000000212998fb0>] xfs_release+0x1b0/0x240 [xfs]
> [<a0000002129ad930>] xfs_file_release+0x70/0xa0 [xfs]
> [<a000000100162ea0>] __fput+0x1a0/0x420
> [<a000000100163160>] fput+0x40/0x60
> 
> The problem here is that xfs_file_last_byte() does not acquire the
> inode lock and can therefore race with another thread that is modifying
> the extext list.  While xfs_bmap_last_offset() is trying to lookup
> what was the last extent some extents were merged and the extent list
> shrunk so the index we lookup is now beyond the end of the extent list
> and potentially in a freed buffer.

Looks good.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
