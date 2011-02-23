Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1N1pYxU011452 for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 19:51:34 -0600
Subject: Re: [PATCH 1/2] xfs: stop using xfs_trans_iget in the RT allocator
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110213132531.GA18279@infradead.org>
References: <20110213132531.GA18279@infradead.org>
Date: Tue, 22 Feb 2011 19:52:38 -0600
Message-ID: <1298425958.1960.115.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Sun, 2011-02-13 at 08:25 -0500, Christoph Hellwig wrote:
> During mount we establish references to the RT inodes, which we keep for
> the lifetime of the filesystem.  Instead of using xfs_trans_iget to grab
> additional references when adding RT inodes to transactions use the
> combination of xfs_ilock and xfs_trans_ijoin_ref, which archives the same
> end result with less overhead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
