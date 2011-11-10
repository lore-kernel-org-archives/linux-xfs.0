Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAA7bFYY053558 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 01:37:16 -0600
Date: Thu, 10 Nov 2011 02:37:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [BUGFIX] xfs: use doalloc flag in xfs_qm_dqattach_one()
Message-ID: <20111110073707.GA5500@infradead.org>
References: <20111110013310.3408.41745.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111110013310.3408.41745.stgit@ltc219.sdl.hitachi.co.jp>
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
Cc: Alex Elder <aelder@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, yrl.pp-manager.tt@hitachi.com

On Thu, Nov 10, 2011 at 10:33:10AM +0900, Mitsuo Hayasaka wrote:
> The doalloc arg in xfs_qm_dqattach_one() is a flag that indicates
> whether a new area to handle quota information will be allocated
> if needed. Originally, it was passed to xfs_qm_dqget(), but has
> been removed by the following commit (probably by mistake):
> 
> 	commit 8e9b6e7fa4544ea8a0e030c8987b918509c8ff47
> 	Author: Christoph Hellwig <hch@lst.de>
> 	Date:   Sun Feb 8 21:51:42 2009 +0100
> 
> 	xfs: remove the unused XFS_QMOPT_DQLOCK flag
> 
> As the result, xfs_qm_dqget() called from xfs_qm_dqattach_one()
> never allocates the new area even if it is needed.
> 
> This patch gives the doalloc arg to xfs_qm_dqget() in
> xfs_qm_dqattach_one() to fix this problem.

Thanks a lot, this is a good fix.  Do you have a good testcase
showing the effect?

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
