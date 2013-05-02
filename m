Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 04ED67F52
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 20:13:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 91FF1AC001
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 18:13:05 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	VCmP6ORlVUpyFiCG for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 18:13:04 -0700 (PDT)
Date: Thu, 2 May 2013 11:13:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2 v2] xfs: Don't keep silent if sunit/swidth can not be
	changed via mount
Message-ID: <20130502011302.GS10481@dastard>
References: <518125CF.3050806@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <518125CF.3050806@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Mark Tinguely <tinguely@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, May 01, 2013 at 10:25:19PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
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
>          =             sectsz=512   attr=2
> data     =             bsize=4096   blocks=1048576, imaxpct=25
>          =             sunit=0      swidth=0 blks
> 		       ^^^^^^^^^^^^^^^^^^^^^^^^^^
> naming   =version 2    bsize=4096   ascii-ci=0
> log      =internal     bsize=4096   blocks=2560, version=2
>          =             sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none         extsz=4096   blocks=0, rtextents=0
> 
> The reason is that the alignment can only be changed if the relevant
> super block is already configured with alignments, otherwise, the
> given value is silently ignored.
> 
> With this fix, the attempt to mount a storage without strip alignment
> setup on a super block will get an error with a warning in syslog to
> indicate the true cause.
> 
> # mount -o sunit=4096,swidth=8192 /dev/sdb1 /mnt
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
> 	dmesg | tail  or so
> # dmesg|tail
> .......
> XFS (sdb1): can not change alignment: superblock does not support data
> alignment
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Cc: Mark Tinguely <tinguely@sgi.com>
> Cc: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_mount.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 29e8de8..2836ef6 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -909,6 +909,10 @@ xfs_update_alignment(xfs_mount_t *mp)
>  				sbp->sb_width = mp->m_swidth;
>  				mp->m_update_flags |= XFS_SB_WIDTH;
>  			}
> +		} else {
> +			xfs_warn(mp, "cannot change alignment: "
> +				 "superblock does not support data alignment");

Same comment again about single line format strings. Otherwise it's
ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
