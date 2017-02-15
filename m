Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54550 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750905AbdBOQNR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Feb 2017 11:13:17 -0500
Subject: Re: [PATCH] xfs: do not unconditionally enable hasalign feature on V5
 filesystems
References: <1487174254-9002-1-git-send-email-chandan@linux.vnet.ibm.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7dd96d6b-ccb5-105f-18aa-207e1c28c625@sandeen.net>
Date: Wed, 15 Feb 2017 10:13:15 -0600
MIME-Version: 1.0
In-Reply-To: <1487174254-9002-1-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

On 2/15/17 9:57 AM, Chandan Rajendra wrote:
> On a ppc64 system, executing generic/256 test with 32k block size gives
> the following call trace,
> 
> XFS: Assertion failed: args->maxlen > 0, file: /root/repos/linux/fs/xfs/libxfs/xfs_alloc.c, line: 2026
> 
> kernel BUG at /root/repos/linux/fs/xfs/xfs_message.c:113!
> Oops: Exception in kernel mode, sig: 5 [#1]
> SMP NR_CPUS=2048
> DEBUG_PAGEALLOC
> NUMA
> pSeries
> Modules linked in:
> CPU: 2 PID: 19361 Comm: mkdir Not tainted 4.10.0-rc5 #58
> task: c000000102606d80 task.stack: c0000001026b8000
> NIP: c0000000004ef798 LR: c0000000004ef798 CTR: c00000000082b290
> REGS: c0000001026bb090 TRAP: 0700   Not tainted  (4.10.0-rc5)
> MSR: 8000000000029032 <SF,EE,ME,IR,DR,RI>
> CR: 28004428  XER: 00000000
> CFAR: c0000000004ef180 SOFTE: 1
> GPR00: c0000000004ef798 c0000001026bb310 c000000001157300 ffffffffffffffea
> GPR04: 000000000000000a c0000001026bb130 0000000000000000 ffffffffffffffc0
> GPR08: 00000000000000d1 0000000000000021 00000000ffffffd1 c000000000dd4990
> GPR12: 0000000022004444 c00000000fe00800 0000000020000000 0000000000000000
> GPR16: 0000000000000000 0000000043a606fc 0000000043a76c08 0000000043a1b3d0
> GPR20: 000001002a35cd60 c0000001026bbb80 0000000000000000 0000000000000001
> GPR24: 0000000000000240 0000000000000004 c00000062dc55000 0000000000000000
> GPR28: 0000000000000004 c00000062ecd9200 0000000000000000 c0000001026bb6c0
> NIP [c0000000004ef798] .assfail+0x28/0x30
> LR [c0000000004ef798] .assfail+0x28/0x30
> Call Trace:
> [c0000001026bb310] [c0000000004ef798] .assfail+0x28/0x30 (unreliable)
> [c0000001026bb380] [c000000000455d74] .xfs_alloc_space_available+0x194/0x1b0
> [c0000001026bb410] [c00000000045b914] .xfs_alloc_fix_freelist+0x144/0x480
> [c0000001026bb580] [c00000000045c368] .xfs_alloc_vextent+0x698/0xa90
> [c0000001026bb650] [c0000000004a6200] .xfs_ialloc_ag_alloc+0x170/0x820
> [c0000001026bb7c0] [c0000000004a9098] .xfs_dialloc+0x158/0x320
> [c0000001026bb8a0] [c0000000004e628c] .xfs_ialloc+0x7c/0x610
> [c0000001026bb990] [c0000000004e8138] .xfs_dir_ialloc+0xa8/0x2f0
> [c0000001026bbaa0] [c0000000004e8814] .xfs_create+0x494/0x790
> [c0000001026bbbf0] [c0000000004e5ebc] .xfs_generic_create+0x2bc/0x410
> [c0000001026bbce0] [c0000000002b4a34] .vfs_mkdir+0x154/0x230
> [c0000001026bbd70] [c0000000002bc444] .SyS_mkdirat+0x94/0x120
> [c0000001026bbe30] [c00000000000b760] system_call+0x38/0xfc
> Instruction dump:
> 4e800020 60000000 7c0802a6 7c862378 3c82ffca 7ca72b78 38841c18 7c651b78
> 38600000 f8010010 f821ff91 4bfff94d <0fe00000> 60000000 7c0802a6 7c892378
> 
> The root cause of the problem is due to the fact that
> xfs_sb_version_hasalign() returns true when we are working on a V5
> filesystem. Due to this args.minalignslop (in xfs_ialloc_ag_alloc())
> gets the unsigned equivalent of -1 assigned to it. This later causes
> alloc_len in xfs_alloc_space_available() to have a value of 0. In such a
> scenario when args.total is also 0, the assert statement
> "ASSERT(args->maxlen > 0);" fails.

Hm, the intent of the _haslign() function is to say that V5 must always
imply the "alignbit" - i.e. we don't want to grow an infinite feature
matrix, and by the time you get to V5 supers, there are many things which
cannot be turned on or off, such as this feature.

So what happens here... xfs_ialloc_ag_alloc does:

args.minalignslop = xfs_ialloc_cluster_alignment(args.mp) - 1;

so you're saying that cluster_alignment comes out as 0?

That function is checking _hasalign:

static inline int
xfs_ialloc_cluster_alignment(
        struct xfs_mount        *mp)
{
        if (xfs_sb_version_hasalign(&mp->m_sb) &&
            mp->m_sb.sb_inoalignmt >=
                        XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size))
                return mp->m_sb.sb_inoalignmt;
        return 1;
}

So are you saying that this function returns 0?  That would imply that
sb_inoalignmt and m_inode_cluster_size are both zero, yes?  Is this
what you see?


-Eric

> This commit fixes the bug by checking for the existance of
> XFS_SB_VERSION_ALIGNBIT bit in xfs_sb->sb_versionnum field even on V5
> filesystems.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
> PS: From what I could understand from other code paths,
> xfs_alloc_arg->total must be set to the sum of space required by the
> current code path and the space already reserved in the current
> transaction. Please let me know if my understanding is
> incorrect. Also, In the code path listed in the above call trace we
> have xfs_alloc_arg->total set to 0 which probably isn't correct
> either.
> 
>  fs/xfs/libxfs/xfs_format.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 6b7579e..57a5264 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -346,8 +346,7 @@ static inline void xfs_sb_version_addquota(struct xfs_sb *sbp)
>  
>  static inline bool xfs_sb_version_hasalign(struct xfs_sb *sbp)
>  {
> -	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
> -		(sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT));
> +	return (sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT);
>  }
>  
>  static inline bool xfs_sb_version_hasdalign(struct xfs_sb *sbp)
> 
