Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBEMDC8f232972 for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 16:13:12 -0600
Date: Wed, 14 Dec 2011 16:13:36 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 11/19] xfs: implement lazy removal for the dquot freelist
Message-ID: <20111214221336.GD29840@sgi.com>
References: <20111206215806.844405397@bombadil.infradead.org>
	<20111206215854.567573800@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206215854.567573800@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Dec 06, 2011 at 04:58:17PM -0500, Christoph Hellwig wrote:
> Do not remove dquots from the freelist when we grab a reference to them in
> xfs_qm_dqlookup, but leave them on the freelist util scanning notices that
> they have a reference.  This speeds up the lookup fastpath, and greatly
> simplifies the lock ordering constraints.  Note that the same scheme is
> used by the VFS inode and dentry caches.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
