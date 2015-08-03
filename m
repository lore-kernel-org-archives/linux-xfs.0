Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 512267F58
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 11:41:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1EA698F8052
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 09:41:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id oMeewHVA0CVGo1un for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 09:41:21 -0700 (PDT)
Message-ID: <55BF99AD.2090103@sandeen.net>
Date: Mon, 03 Aug 2015 09:41:17 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] xfs: log recovery needs to validate against
	sb_meta_uuid
References: <1438587625-31437-1-git-send-email-david@fromorbit.com>
	<1438587625-31437-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1438587625-31437-4-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 8/3/15 12:40 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that sb_uuid can be changed by the user, we cannot use this to
> validate the metadata blocks being recovered belong to this
> filesystem. We must check against the sb_meta_uuid as that will
> remain unchanged.
> 
> There is a complication in this code - the superblock itself. We can
> not check the sb_meta_uuid unconditionally, as that may not be set
> on disk. Hence we must verify the superblock sb_uuid matches between
> the log record and the in-core superblock.
> 
> Found by inspection after the previous two problems were found.

So, I also had this in my older patchset, I think it's needed for
proper log recovery as well.  I'm not sure why I didn't hit the
xlog_recover_get_buf_lsn problem, though:

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4f5784f..4da291c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -325,7 +325,7 @@ xlog_header_check_recover(
 		XFS_ERROR_REPORT("xlog_header_check_recover(1)",
 				 XFS_ERRLEVEL_HIGH, mp);
 		return -EFSCORRUPTED;
-	} else if (unlikely(!uuid_equal(&mp->m_sb.sb_uuid, &head->h_fs_uuid))) {
+	} else if (!uuid_equal(&mp->m_sb.sb_uuid, &head->h_fs_uuid)) {
 		xfs_warn(mp,
 	"dirty log entry has mismatched uuid - can't recover");
 		xlog_header_check_dump(mp, head);
@@ -353,7 +353,7 @@ xlog_header_check_mount(
 		 * by IRIX and continue.
 		 */
 		xfs_warn(mp, "nil uuid in log - IRIX style log");
-	} else if (unlikely(!uuid_equal(&mp->m_sb.sb_uuid, &head->h_fs_uuid))) {
+	} else if (!uuid_equal(&mp->m_sb.sb_uuid, &head->h_fs_uuid)) {
 		xfs_warn(mp, "log has mismatched uuid - can't recover");
 		xlog_header_check_dump(mp, head);
 		XFS_ERROR_REPORT("xlog_header_check_mount",


as for your patch ... looks fine.  Not sure why I didn't hit that.

Reviewed-by: Eric Sandeen <sandeen@redhat.com> unless you want
to roll the above changes in as well...

-Eric

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_recover.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index c674b40..6f83d12 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1895,15 +1895,25 @@ xlog_recover_get_buf_lsn(
>  		 */
>  		goto recover_immediately;
>  	case XFS_SB_MAGIC:
> +		/*
> +		 * superblock uuids are magic. We may or may not have a
> +		 * sb_meta_uuid on disk, but it will be set in the in-core
> +		 * superblock. We set the uuid pointer for verification
> +		 * according to the superblock feature mask to ensure we check
> +		 * the relevant UUID in the superblock.
> +		 */
>  		lsn = be64_to_cpu(((struct xfs_dsb *)blk)->sb_lsn);
> -		uuid = &((struct xfs_dsb *)blk)->sb_uuid;
> +		if (xfs_sb_version_hasmetauuid(&mp->m_sb))
> +			uuid = &((struct xfs_dsb *)blk)->sb_meta_uuid;
> +		else
> +			uuid = &((struct xfs_dsb *)blk)->sb_uuid;
>  		break;
>  	default:
>  		break;
>  	}
>  
>  	if (lsn != (xfs_lsn_t)-1) {
> -		if (!uuid_equal(&mp->m_sb.sb_uuid, uuid))
> +		if (!uuid_equal(&mp->m_sb.sb_meta_uuid, uuid))
>  			goto recover_immediately;
>  		return lsn;
>  	}
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
