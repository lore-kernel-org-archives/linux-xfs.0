Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2UBEb7J034381 for <xfs@oss.sgi.com>; Wed, 30 Mar 2011 06:14:37 -0500
Received: from mx1.fusionio.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF6D015A879A
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2011 04:17:48 -0700 (PDT)
Received: from mx1.fusionio.com (mx1.fusionio.com [64.244.102.30]) by
	cuda.sgi.com with ESMTP id SefZ1ogg7DHy3mZA for
	<xfs@oss.sgi.com>; Wed, 30 Mar 2011 04:17:48 -0700 (PDT)
Message-ID: <4D93115A.4040908@fusionio.com>
Date: Wed, 30 Mar 2011 13:17:46 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: use proper interfaces for on-stack plugging
References: <20110330110509.GA9507@infradead.org>
In-Reply-To: <20110330110509.GA9507@infradead.org>
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 2011-03-30 13:05, Christoph Hellwig wrote:
> Add proper blk_start_plug/blk_finish_plug pairs for the two places where
> we issue buffer I/O, and remove the blk_flush_plug in xfs_buf_lock and
> xfs_buf_iowait, given that context switches already flush the per-process
> plugging lists.

Looks much better, thanks for doing that.

Acked-by: Jens Axboe <jaxboe@fusionio.com>


-- 
Jens Axboe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
