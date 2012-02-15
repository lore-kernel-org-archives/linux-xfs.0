Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1F2Wp4n142612 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 20:32:51 -0600
Date: Tue, 14 Feb 2012 21:32:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH -v2 2/3] xfs: make inode quota check more general
Message-ID: <20120215023249.GB17149@infradead.org>
References: <20120206124951.12624.88233.stgit@ltc219.sdl.hitachi.co.jp>
	<20120206125030.12624.95365.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120206125030.12624.95365.stgit@ltc219.sdl.hitachi.co.jp>
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

On Mon, Feb 06, 2012 at 09:50:30PM +0900, Mitsuo Hayasaka wrote:
> The xfs checks quota when reserving disk blocks and inodes. In the block
> reservation, it checks if the total number of blocks including current
> usage and new reservation exceed quota. In the inode reservation,
> it checks using the total number of inodes including only current usage
> without new reservation. However, this inode quota check works well
> since the caller of xfs_trans_dquot() always sets the argument of the
> number of new inode reservation to 1 or 0 and inode is reserved one by
> one in current xfs.
> 
> To make it more general, this patch changes it to the same way as the
> block quota check.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
