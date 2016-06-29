Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4B19B7CA1
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 23:21:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0C65F8F8050
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2016 21:21:18 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id QV5BMD3i26WFpQYI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2016 21:21:15 -0700 (PDT)
Date: Tue, 28 Jun 2016 21:21:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/11] xfs: simplify inode reclaim tagging interfaces
Message-ID: <20160629042106.GD4917@birch.djwong.org>
References: <1460525492-1170-1-git-send-email-david@fromorbit.com>
	<1460525492-1170-11-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460525492-1170-11-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 13, 2016 at 03:31:31PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Inode radix tree tagging for reclaim passes a lot of unnecessary
> variables around. Over time the xfs-perag has grown a xfs_mount
> backpointer, and an internal agno so we don't need to pass other
> variables into the tagging functions to supply this information.
> 
> Rework the functions to pass the minimal variable set required
> and simplify the internal logic and flow.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 97 +++++++++++++++++++++++++++--------------------------
>  1 file changed, 49 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index a60db43..927e7b0 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -37,8 +37,7 @@
>  #include <linux/kthread.h>
>  #include <linux/freezer.h>
>  
> -STATIC void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp,
> -				struct xfs_perag *pag, struct xfs_inode *ip);
> +STATIC void xfs_inode_clear_reclaim_tag(struct xfs_perag *pag, xfs_ino_t ino);
>  
>  /*
>   * Allocate and initialise an xfs_inode.
> @@ -271,7 +270,7 @@ xfs_iget_cache_hit(
>  		 */
>  		ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
>  		ip->i_flags |= XFS_INEW;
> -		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
> +		xfs_inode_clear_reclaim_tag(pag, ip->i_ino);
>  		inode->i_state = I_NEW;
>  
>  		ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
> @@ -768,29 +767,44 @@ xfs_reclaim_worker(
>  }
>  
>  static void
> -__xfs_inode_set_reclaim_tag(
> +xfs_perag_set_reclaim_tag(
>  	struct xfs_perag	*pag,
> -	struct xfs_inode	*ip)
> +	xfs_ino_t		ino)
>  {
> -	radix_tree_tag_set(&pag->pag_ici_root,
> -			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
> +	struct xfs_mount	*mp = pag->pag_mount;
> +
> +	ASSERT(spin_is_locked(&pag->pag_ici_lock));

Hmm.  On (only) ppc64, I see the following splat on umount:

[ 1598.584616] XFS: Assertion failed: spin_is_locked(&pag->pag_ici_lock), file: /raid/home/djwong/cdev/work/linux-mcsum/fs/xfs/xfs_icache.c, line: 216
[ 1598.584799] ------------[ cut here ]------------
[ 1598.585262] WARNING: CPU: 0 PID: 9144 at /raid/home/djwong/cdev/work/linux-mcsum/fs/xfs/xfs_message.c:105 .asswarn+0x48/0x70 [xfs]
[ 1598.585318] Modules linked in: xfs libcrc32c sg sch_fq_codel autofs4 hid_generic usbhid hid xhci_pci xhci_hcd sd_mod
[ 1598.585518] CPU: 0 PID: 9144 Comm: umount Tainted: G        W       4.7.0-rc5-pcsum #1
[ 1598.585566] task: c000000069621bd0 ti: c000000069668000 task.ti: c000000069668000
[ 1598.585608] NIP: d000000001942658 LR: d000000001942658 CTR: c0000000003e4e30
[ 1598.585651] REGS: c00000006966b300 TRAP: 0700   Tainted: G        W        (4.7.0-rc5-pcsum)
[ 1598.585691] MSR: 800000000282b032 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI>  CR: 28242448  XER: 00000000
[ 1598.585854] CFAR: d000000001942374 SOFTE: 1 
GPR00: d000000001942658 c00000006966b580 d0000000019ff908 ffffffffffffffea 
GPR04: 000000000000000a c00000006966b390 00000000000000d1 ffffffffffffffc0 
GPR08: 0000000000000000 0000000000000021 00000000ffffffd1 d0000000019b01d0 
GPR12: c0000000003e4e30 c00000000fff0000 0000000010110000 c00000007922eb80 
GPR16: 0000000040000000 0000000020000000 0000000000000000 c00000007922ebe8 
GPR20: 0000000000000004 c00000007922ebd0 c00000006966b9d0 0000000000000001 
GPR24: 0000000000600081 c00000007922eb80 c000000069668000 c000000069668000 
GPR28: c00000006966b710 d0000000019aef20 d0000000019aee90 00000000000000d8 
[ 1598.586844] NIP [d000000001942658] .asswarn+0x48/0x70 [xfs]
[ 1598.587242] LR [d000000001942658] .asswarn+0x48/0x70 [xfs]
[ 1598.587281] Call Trace:
[ 1598.587669] [c00000006966b580] [d000000001942658] .asswarn+0x48/0x70 [xfs] (unreliable)
[ 1598.588098] [c00000006966b610] [d00000000192d308] .xfs_perag_clear_reclaim_tag+0x48/0x1a0 [xfs]
[ 1598.588597] [c00000006966b6a0] [d00000000192d7a8] .xfs_reclaim_inode+0x2d8/0x600 [xfs]
[ 1598.589027] [c00000006966b760] [d00000000192dc8c] .xfs_reclaim_inodes_ag+0x1bc/0x390 [xfs]
[ 1598.589451] [c00000006966b960] [d00000000192ff28] .xfs_reclaim_inodes+0x38/0x50 [xfs]
[ 1598.589875] [c00000006966b9f0] [d000000001944754] .xfs_unmountfs+0xb4/0x280 [xfs]
[ 1598.590297] [c00000006966ba90] [d00000000194cd48] .xfs_fs_put_super+0x48/0xa0 [xfs]
[ 1598.590382] [c00000006966bb10] [c0000000002527f8] .generic_shutdown_super+0xb8/0x180
[ 1598.590455] [c00000006966bb90] [c000000000252e18] .kill_block_super+0x38/0xa0
[ 1598.590521] [c00000006966bc20] [c000000000253104] .deactivate_locked_super+0xa4/0xf0
[ 1598.590594] [c00000006966bca0] [c00000000027c73c] .cleanup_mnt+0x5c/0xa0
[ 1598.590671] [c00000006966bd20] [c0000000000a44bc] .task_work_run+0xbc/0x100
[ 1598.590748] [c00000006966bdb0] [c000000000015598] .do_notify_resume+0xf8/0x100
[ 1598.590826] [c00000006966be30] [c0000000000094b0] .ret_from_except_lite+0x5c/0x60
[ 1598.590884] Instruction dump:
[ 1598.590942] 7c7d1b78 7c9e2378 7cbf2b78 48000008 e8410028 3d220000 38600000 e889c190 
[ 1598.591109] 7fa5eb78 7fc6f378 7fe7fb78 4bfffc5d <0fe00000> 38210090 e8010010 eba1ffe8 
[ 1598.591281] ---[ end trace dea443eeb71bd63f ]---

Not sure if it's the rmap/reflink patchset that's to blame, or what.

It's kinda late, so I'm going to set this aside for debugging tomorrow.

(x64/i386/armhf seem fine for whatever reason)

--D

> +	if (pag->pag_ici_reclaimable++)
> +		return;
> +
> +	/* propagate the reclaim tag up into the perag radix tree */
> +	spin_lock(&mp->m_perag_lock);
> +	radix_tree_tag_set(&mp->m_perag_tree, pag->pag_agno,
>  			   XFS_ICI_RECLAIM_TAG);
> +	spin_unlock(&mp->m_perag_lock);
>  
> -	if (!pag->pag_ici_reclaimable) {
> -		/* propagate the reclaim tag up into the perag radix tree */
> -		spin_lock(&ip->i_mount->m_perag_lock);
> -		radix_tree_tag_set(&ip->i_mount->m_perag_tree,
> -				XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
> -				XFS_ICI_RECLAIM_TAG);
> -		spin_unlock(&ip->i_mount->m_perag_lock);
> +	/* schedule periodic background inode reclaim */
> +	xfs_reclaim_work_queue(mp);
>  
> -		/* schedule periodic background inode reclaim */
> -		xfs_reclaim_work_queue(ip->i_mount);
> +	trace_xfs_perag_set_reclaim(mp, pag->pag_agno, -1, _RET_IP_);
> +}
>  
> -		trace_xfs_perag_set_reclaim(ip->i_mount, pag->pag_agno,
> -							-1, _RET_IP_);
> -	}
> -	pag->pag_ici_reclaimable++;
> +static void
> +xfs_perag_clear_reclaim_tag(
> +	struct xfs_perag	*pag)
> +{
> +	struct xfs_mount	*mp = pag->pag_mount;
> +
> +	ASSERT(spin_is_locked(&pag->pag_ici_lock));
> +	if (--pag->pag_ici_reclaimable)
> +		return;
> +
> +	/* clear the reclaim tag from the perag radix tree */
> +	spin_lock(&mp->m_perag_lock);
> +	radix_tree_tag_clear(&mp->m_perag_tree, pag->pag_agno,
> +			     XFS_ICI_RECLAIM_TAG);
> +	spin_unlock(&mp->m_perag_lock);
> +	trace_xfs_perag_clear_reclaim(mp, pag->pag_agno, -1, _RET_IP_);
>  }
>  
>  /*
> @@ -800,48 +814,35 @@ __xfs_inode_set_reclaim_tag(
>   */
>  void
>  xfs_inode_set_reclaim_tag(
> -	xfs_inode_t	*ip)
> +	struct xfs_inode	*ip)
>  {
> -	struct xfs_mount *mp = ip->i_mount;
> -	struct xfs_perag *pag;
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_perag	*pag;
>  
>  	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
>  	spin_lock(&pag->pag_ici_lock);
>  	spin_lock(&ip->i_flags_lock);
> -	__xfs_inode_set_reclaim_tag(pag, ip);
> +
> +	radix_tree_tag_set(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino),
> +			   XFS_ICI_RECLAIM_TAG);
> +	xfs_perag_set_reclaim_tag(pag, ip->i_ino);
>  	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
> +
>  	spin_unlock(&ip->i_flags_lock);
>  	spin_unlock(&pag->pag_ici_lock);
>  	xfs_perag_put(pag);
>  }
>  
> -STATIC void
> -__xfs_inode_clear_reclaim(
> -	xfs_perag_t	*pag,
> -	xfs_inode_t	*ip)
> -{
> -	pag->pag_ici_reclaimable--;
> -	if (!pag->pag_ici_reclaimable) {
> -		/* clear the reclaim tag from the perag radix tree */
> -		spin_lock(&ip->i_mount->m_perag_lock);
> -		radix_tree_tag_clear(&ip->i_mount->m_perag_tree,
> -				XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
> -				XFS_ICI_RECLAIM_TAG);
> -		spin_unlock(&ip->i_mount->m_perag_lock);
> -		trace_xfs_perag_clear_reclaim(ip->i_mount, pag->pag_agno,
> -							-1, _RET_IP_);
> -	}
> -}
>  
>  STATIC void
> -__xfs_inode_clear_reclaim_tag(
> -	xfs_mount_t	*mp,
> -	xfs_perag_t	*pag,
> -	xfs_inode_t	*ip)
> +xfs_inode_clear_reclaim_tag(
> +	struct xfs_perag	*pag,
> +	xfs_ino_t		ino)
>  {
>  	radix_tree_tag_clear(&pag->pag_ici_root,
> -			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
> -	__xfs_inode_clear_reclaim(pag, ip);
> +			     XFS_INO_TO_AGINO(pag->pag_mount, ino),
> +			     XFS_ICI_RECLAIM_TAG);
> +	xfs_perag_clear_reclaim_tag(pag);
>  }
>  
>  /*
> @@ -1032,7 +1033,7 @@ reclaim:
>  	if (!radix_tree_delete(&pag->pag_ici_root,
>  				XFS_INO_TO_AGINO(ip->i_mount, ino)))
>  		ASSERT(0);
> -	__xfs_inode_clear_reclaim(pag, ip);
> +	xfs_perag_clear_reclaim_tag(pag);
>  	spin_unlock(&pag->pag_ici_lock);
>  
>  	/*
> -- 
> 2.7.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
