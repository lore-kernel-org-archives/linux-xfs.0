Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1F2WQ69142546 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 20:32:26 -0600
Date: Tue, 14 Feb 2012 21:32:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH -v2 1/3] xfs: change available ranges of softlimit and
	hardlimit in quota check
Message-ID: <20120215023219.GA17149@infradead.org>
References: <20120206124951.12624.88233.stgit@ltc219.sdl.hitachi.co.jp>
	<20120206125007.12624.58454.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120206125007.12624.58454.stgit@ltc219.sdl.hitachi.co.jp>
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
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Alex Elder <elder@kernel.org>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>

On Mon, Feb 06, 2012 at 09:50:07PM +0900, Mitsuo Hayasaka wrote:
> In general, quota allows us to use disk blocks and inodes up to each
> limit, that is, they are available if they don't exceed their limitations.
> Current xfs sets their available ranges to lower than them except disk
> inode quota check. So, this patch changes the ranges to not beyond them.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
