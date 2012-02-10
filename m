Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1AKb5Ai021403 for <xfs@oss.sgi.com>; Fri, 10 Feb 2012 14:37:06 -0600
Message-ID: <4F357FEF.5080507@sgi.com>
Date: Fri, 10 Feb 2012 14:37:03 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH -v2 1/3] xfs: change available ranges of softlimit and
	hardlimit in quota check
References: <20120206124951.12624.88233.stgit@ltc219.sdl.hitachi.co.jp>
	<20120206125007.12624.58454.stgit@ltc219.sdl.hitachi.co.jp>
In-Reply-To: <20120206125007.12624.58454.stgit@ltc219.sdl.hitachi.co.jp>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: xfs@oss.sgi.com

On 02/06/12 06:50, Mitsuo Hayasaka wrote:
> In general, quota allows us to use disk blocks and inodes up to each
> limit, that is, they are available if they don't exceed their limitations.
> Current xfs sets their available ranges to lower than them except disk
> inode quota check. So, this patch changes the ranges to not beyond them.
>
> Signed-off-by: Mitsuo Hayasaka<mitsuo.hayasaka.hu@hitachi.com>
> Cc: Ben Myers<bpm@sgi.com>
> Cc: Alex Elder<elder@kernel.org>
> Cc: Christoph Hellwig<hch@lst.de>
> ---
>
>   fs/xfs/xfs_dquot.c       |   24 ++++++++++++------------
>   fs/xfs/xfs_log_recover.c |    6 +++---
>   fs/xfs/xfs_qm_syscalls.c |    4 ++--
>   fs/xfs/xfs_trans_dquot.c |    4 ++--
>   4 files changed, 19 insertions(+), 19 deletions(-)
>
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c

> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index eafbcff..711a86e 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -813,11 +813,11 @@ xfs_qm_export_dquot(
>   	     (XFS_IS_OQUOTA_ENFORCED(mp)&&
>   			(dst->d_flags&  (FS_PROJ_QUOTA | FS_GROUP_QUOTA))))&&
>   	dst->d_id != 0) {
> -		if (((int) dst->d_bcount>= (int) dst->d_blk_softlimit)&&
> +		if (((int) dst->d_bcount>  (int) dst->d_blk_softlimit)&&
>   		(dst->d_blk_softlimit>  0)) {
>   			ASSERT(dst->d_btimer != 0);
>   		}
> -		if (((int) dst->d_icount>= (int) dst->d_ino_softlimit)&&
> +		if (((int) dst->d_icount>  (int) dst->d_ino_softlimit)&&
>   		(dst->d_ino_softlimit>  0)) {
>   			ASSERT(dst->d_itimer != 0);
>   		}

Good catch on the off by one page comparisons. I like the patch.

Question: I know this was like this before, but why is the 64 bit counts 
and limits being casted into integers for these tests inside the DEBUG?

--Mark Tinguely
   tinguely@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
