Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 93F937FA7
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 15:03:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F1CAAC010
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 13:03:01 -0800 (PST)
Date: Tue, 10 Dec 2013 13:03:00 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: fix calculation of freed inode cluster blocks
Message-ID: <20131210210300.GA755@infradead.org>
References: <20131210205931.GD1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131210205931.GD1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 10, 2013 at 02:59:31PM -0600, Ben Myers wrote:
> rec.ir_startino is an agino rather than an ino.  Use the correct macro
> when dealing with it in xfs_difree.
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
