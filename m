Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D0B647F6A
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 07:12:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A757D304066
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 05:12:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qCjZwvo8HerJwxtW for
	<xfs@oss.sgi.com>; Wed, 24 Jul 2013 05:12:42 -0700 (PDT)
Message-ID: <51EFC3F4.7040408@redhat.com>
Date: Wed, 24 Jul 2013 08:09:24 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 05/49] xfs: separate dquot on disk format definitions
	out of xfs_quota.h
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-6-git-send-email-david@fromorbit.com>
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

On 07/19/2013 02:24 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The on disk format definitions of the on-disk dquot, log formats and
> quota off log formats are all intertwined with other definitions for
> quotas. Separate them out into their own header file so they can
> easily be shared with userspace.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
...
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index b14f42c..16bde32 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -21,18 +21,6 @@
...
> -
> -/*
> - * Conversion to and from the combined OQUOTA flag (if necessary)
> - * is done only in xfs_sb_qflags_to_disk() and xfs_sb_qflags_from_disk()
> - */
> -#define XFS_GQUOTA_ENFD	0x0080  /* group quota limits enforced */
> -#define XFS_GQUOTA_CHKD	0x0100  /* quotacheck run on group quotas */
> -#define XFS_PQUOTA_ENFD	0x0200  /* project quota limits enforced */
> -#define XFS_PQUOTA_CHKD	0x0400  /* quotacheck run on project quotas */
> -
> -/*
> - * Quota Accounting/Enforcement flags
> - */

A few minor whitespace diffs and the above comment was dropped. Looks
fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> -#define XFS_ALL_QUOTA_ACCT	\
> -		(XFS_UQUOTA_ACCT | XFS_GQUOTA_ACCT | XFS_PQUOTA_ACCT)
> -#define XFS_ALL_QUOTA_ENFD	\
> -		(XFS_UQUOTA_ENFD | XFS_GQUOTA_ENFD | XFS_PQUOTA_ENFD)
> -#define XFS_ALL_QUOTA_CHKD	\
> -		(XFS_UQUOTA_CHKD | XFS_GQUOTA_CHKD | XFS_PQUOTA_CHKD)
> -
>  #define XFS_IS_QUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
>  #define XFS_IS_UQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_UQUOTA_ACCT)
>  #define XFS_IS_PQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_PQUOTA_ACCT)
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index 20e30f9..acf5071 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -16,6 +16,7 @@
>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
>  #include "xfs.h"
> +#include "xfs_format.h"
>  #include "xfs_sb.h"
>  #include "xfs_log.h"
>  #include "xfs_ag.h"
> diff --git a/fs/xfs/xfs_rename.c b/fs/xfs/xfs_rename.c
> index 30ff5f4..0c1f8ef 100644
> --- a/fs/xfs/xfs_rename.c
> +++ b/fs/xfs/xfs_rename.c
> @@ -17,7 +17,7 @@
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> -#include "xfs_types.h"
> +#include "xfs_format.h"
>  #include "xfs_log.h"
>  #include "xfs_trans.h"
>  #include "xfs_sb.h"
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 1d68ffc..146e2c2 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -17,6 +17,7 @@
>   */
>  
>  #include "xfs.h"
> +#include "xfs_format.h"
>  #include "xfs_log.h"
>  #include "xfs_inum.h"
>  #include "xfs_trans.h"
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index f4895b6..80d550c 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -18,7 +18,7 @@
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> -#include "xfs_types.h"
> +#include "xfs_format.h"
>  #include "xfs_bit.h"
>  #include "xfs_log.h"
>  #include "xfs_trans.h"
> diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
> index b6e3897..5d7b3e4 100644
> --- a/fs/xfs/xfs_trace.c
> +++ b/fs/xfs/xfs_trace.c
> @@ -18,6 +18,7 @@
>  #include "xfs.h"
>  #include "xfs_fs.h"
>  #include "xfs_types.h"
> +#include "xfs_format.h"
>  #include "xfs_log.h"
>  #include "xfs_trans.h"
>  #include "xfs_sb.h"
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 35a2299..1d2a061 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -18,7 +18,7 @@
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> -#include "xfs_types.h"
> +#include "xfs_format.h"
>  #include "xfs_log.h"
>  #include "xfs_trans.h"
>  #include "xfs_sb.h"
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 61407a8..54ee3c5 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -17,6 +17,7 @@
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> +#include "xfs_format.h"
>  #include "xfs_log.h"
>  #include "xfs_trans.h"
>  #include "xfs_sb.h"
> diff --git a/fs/xfs/xfs_types.h b/fs/xfs/xfs_types.h
> index 39c48ca..69074ac 100644
> --- a/fs/xfs/xfs_types.h
> +++ b/fs/xfs/xfs_types.h
> @@ -177,4 +177,10 @@ struct xfs_name {
>  	int			len;
>  };
>  
> +/*
> + * uid_t and gid_t are hard-coded to 32 bits in the inode.
> + * Hence, an 'id' in a dquot is 32 bits..
> + */
> +typedef __uint32_t	xfs_dqid_t;
> +
>  #endif	/* __XFS_TYPES_H__ */
> diff --git a/fs/xfs/xfs_utils.c b/fs/xfs/xfs_utils.c
> index 0025c78..58386fa 100644
> --- a/fs/xfs/xfs_utils.c
> +++ b/fs/xfs/xfs_utils.c
> @@ -17,7 +17,7 @@
>   */
>  #include "xfs.h"
>  #include "xfs_fs.h"
> -#include "xfs_types.h"
> +#include "xfs_format.h"
>  #include "xfs_log.h"
>  #include "xfs_trans.h"
>  #include "xfs_sb.h"
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index dc730ac..c2d96cd 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -19,7 +19,7 @@
>  
>  #include "xfs.h"
>  #include "xfs_fs.h"
> -#include "xfs_types.h"
> +#include "xfs_format.h"
>  #include "xfs_bit.h"
>  #include "xfs_log.h"
>  #include "xfs_trans.h"
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
