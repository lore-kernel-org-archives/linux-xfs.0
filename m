Return-Path: <xfs-bounces@oss.sgi.com>
Date: Tue, 15 Nov 2011 14:23:14 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] [BUGFIX] xfs: use doalloc flag in xfs_qm_dqattach_one()
Message-ID: <20111115202314.GE29840@sgi.com>
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
> 
> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> Cc: Alex Elder <aelder@sgi.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> ---
> 
>  fs/xfs/xfs_qm.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 9a0aa76..95ba6dc 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -674,7 +674,8 @@ xfs_qm_dqattach_one(
>  	 * disk and we didn't ask it to allocate;
>  	 * ESRCH if quotas got turned off suddenly.
>  	 */
> -	error = xfs_qm_dqget(ip->i_mount, ip, id, type, XFS_QMOPT_DOWARN, &dqp);
> +	error = xfs_qm_dqget(ip->i_mount, ip, id, type,
> +			     doalloc | XFS_QMOPT_DOWARN, &dqp);
>  	if (error)
>  		return error;
>  

Looks like the only caller of xfs_qm_dqattach_one with XFS_QMOPT_DOALLOC
possibly set is xfs_qm_dqattach_locked, which does so based upon its
argument 'flags'.  AFAICS the only caller of xfs_qm_dqattach_locked that
sets this flag is xfs_qm_vop_dqalloc, which is called by
xfs_ioctl_setattr, xfs_setattr_nonsize, xfs_create, and xfs_symlink.

xfs_ioctl_setattr|xfs_setattr_nonsize|xfs_create|xfs_symlink
  xfs_qm_vop_dqalloc
    xfs_qm_dqattach_locked(ip, XFS_QMOPT_DQALLOC
      xfs_qm_dqattach_one

I tried a few things to see if I could hit a problem without the patch
but no luck.

Anyway... Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
