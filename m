Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DC8077F59
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 11:23:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B77148F8049
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 09:23:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id bl34CrCza0q8EGJY for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 09:23:19 -0700 (PDT)
Message-ID: <55BF9575.2010106@sandeen.net>
Date: Mon, 03 Aug 2015 09:23:17 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] xfs: dquots should be stamped with sb_meta_uuid
References: <1438587625-31437-1-git-send-email-david@fromorbit.com>
	<1438587625-31437-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1438587625-31437-5-git-send-email-david@fromorbit.com>
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
> Once the sb_uuid is changed, the wrong uuid is stamped into new
> dquots on disk. Found by inspection, verified by generic/219.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_dquot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 4143dc7..b1b26b6 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -251,7 +251,7 @@ xfs_qm_init_dquot_blk(
>  		d->dd_diskdq.d_id = cpu_to_be32(curid);
>  		d->dd_diskdq.d_flags = type;
>  		if (xfs_sb_version_hascrc(&mp->m_sb)) {
> -			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_uuid);
> +			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_meta_uuid);
>  			xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
>  					 XFS_DQUOT_CRC_OFF);
>  		}
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
