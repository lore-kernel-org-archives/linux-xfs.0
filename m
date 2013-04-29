Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6FF5F7F4C
	for <xfs@oss.sgi.com>; Mon, 29 Apr 2013 09:51:16 -0500 (CDT)
Message-ID: <517E88E6.9070709@sgi.com>
Date: Mon, 29 Apr 2013 09:51:18 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Don't keep silent if sunit/swidth can not be changed
	via mount
References: <517E5D12.5010809@oracle.com>
In-Reply-To: <517E5D12.5010809@oracle.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 04/29/13 06:44, Jeff Liu wrote:
> From: Jie Liu<jeff.liu@oracle.com>
>
> As per the mount man page, sunit and swidth can be changed via
> mount options.  For XFS, on the face of it, those options seems
> works if the specified alignments is properly, e.g.
> # mount -o sunit=4096,swidth=8192 /dev/sdb1 /mnt
> # mount | grep sdb1
> /dev/sdb1 on /mnt type xfs (rw,sunit=4096,swidth=8192)
>
> However, neither sunit nor swidth is shown from the xfs_info output.
> # xfs_info /mnt
> meta-data=/dev/sdb1    isize=256    agcount=4, agsize=262144 blks
>           =             sectsz=512   attr=2
> data     =             bsize=4096   blocks=1048576, imaxpct=25
>           =             sunit=0      swidth=0 blks
> 		       ^^^^^^^^^^^^^^^^^^^^^^^^^^
> naming   =version 2    bsize=4096   ascii-ci=0
> log      =internal     bsize=4096   blocks=2560, version=2
>           =             sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none         extsz=4096   blocks=0, rtextents=0
>
> The reason is that the alignment can only be changed if the relevant
> super block is already configured with alignments, otherwise, the
> given value will be silently ignored, so it's better to tell user
> that the alignment-changing can not take affect in one way or another.
>
> With this fix, the attempt to mount a storage without strip alignment
> setup on super block will failed if XFS_MOUNT_RETERR is enabled, or
> just ignore the given alignment and drop a warning to indicate the
> cause in syslog.
>
> # mount -o sunit=4096,swidth=8192 /dev/sdb1 /mnt
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
>         missing codepage or helper program, or other error
>         In some cases useful info is found in syslog - try
>         dmesg | tail  or so
>
> # dmesg|tail
> .......
> XFS (sdb1): can not change alignment: no data alignment on superblock
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>
> ---
>   fs/xfs/xfs_mount.c |    7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 3806088..bc7fdd4 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -924,6 +924,13 @@ xfs_update_alignment(xfs_mount_t *mp)
>   				sbp->sb_width = mp->m_swidth;
>   				mp->m_update_flags |= XFS_SB_WIDTH;
>   			}
> +		} else {
> +			xfs_warn(mp, "can not change alignment: "
> +				"no data alignment on superblock");
suggest that you keep the string together so it can be searched.
   "superblock does not support data alignment"

> +			if (mp->m_flags&  XFS_MOUNT_RETERR)
> +				return XFS_ERROR(EINVAL);
> +			mp->m_dalign = 0;
> +			mp->m_swidth = 0;
>   		}
>   	} else if ((mp->m_flags&  XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN&&
>   		xfs_sb_version_hasdalign(&mp->m_sb)) {


Thanks,

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
