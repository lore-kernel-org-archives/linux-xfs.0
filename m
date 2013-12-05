Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 26E107F66
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 14:11:59 -0600 (CST)
Date: Thu, 5 Dec 2013 14:11:55 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 5/5] xfs: assert that we hold the ilock for extent map
	access
Message-ID: <20131205201155.GL1935@sgi.com>
References: <20131205155830.620826868@bombadil.infradead.org>
	<20131205155951.874279041@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131205155951.874279041@bombadil.infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Dec 05, 2013 at 07:58:35AM -0800, Christoph Hellwig wrote:
> Make sure that xfs_bmapi_read has the ilock held in some way, and that
> xfs_bmapi_write, xfs_bmapi_delay and xfs_iread_extents are called with
> the ilock held exclusively.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
