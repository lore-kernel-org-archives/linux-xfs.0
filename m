Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1F2X8ni142676 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 20:33:08 -0600
Date: Tue, 14 Feb 2012 21:33:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH -v2 3/3] xfs: cleanup quota check on disk blocks and
	inodes reservations
Message-ID: <20120215023306.GC17149@infradead.org>
References: <20120206124951.12624.88233.stgit@ltc219.sdl.hitachi.co.jp>
	<20120206125105.12624.93123.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120206125105.12624.93123.stgit@ltc219.sdl.hitachi.co.jp>
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

On Mon, Feb 06, 2012 at 09:51:05PM +0900, Mitsuo Hayasaka wrote:
> This patch is a cleanup of quota check on disk blocks and inodes
> reservations, and changes it as follows.
> 
> (1) add a total_count variable to store the total number of
>     current usages and new reservations for disk blocks and inodes,
>     respectively.
> 
> (2) make it more readable to check if the local variables softlimit
>     and hardlimit are positive. It has been changed as follows.
> 	    if (softlimit > 0ULL) -> if (softlimit)
> 	    if (hardlimit > 0ULL) -> if (hardlimit)
>     This is because they are defined as xfs_qcnt_t which is unsigned.
> 
> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> Cc: Ben Myers <bpm@sgi.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
