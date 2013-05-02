Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9EF837F53
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 10:09:04 -0500 (CDT)
Message-ID: <51828192.6040101@sgi.com>
Date: Thu, 02 May 2013 10:09:06 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfs: Remove struct xfs_chash from xfs_mount
References: <51824CA8.9000209@oracle.com>
In-Reply-To: <51824CA8.9000209@oracle.com>
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

On 05/02/13 06:23, Jeff Liu wrote:
> v2->v1:
> Fix a typo at comments, i.e. s/xfs_krash/xfs_chash/.
>
>
> From: Jie Liu<jeff.liu@oracle.com>
>
> Remove struct xfs_chash from struct xfs_mount as there is no user of
> it nowadays.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> Reviewed-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/xfs_mount.h |    2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index bc90706..b68e56b 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -192,8 +192,6 @@ typedef struct xfs_mount {
>          xfs_dablk_t             m_dirleafblk;   /* blockno of dir non-data v2 */
>          xfs_dablk_t             m_dirfreeblk;   /* blockno of dirfreeindex v2 */
>          uint                    m_chsize;       /* size of next field */
> -       struct xfs_chash        *m_chash;       /* fs private inode per-cluster
> -                                                * hash table */
>          atomic_t                m_active_trans; /* number trans frozen */
>   #ifdef HAVE_PERCPU_SB
>          xfs_icsb_cnts_t __percpu *m_sb_cnts;    /* per-cpu superblock counters */

Your mailer may have damaged the patch. The <TAB> are now spaces.

FYI, I had problems with another patch of yours:
	http://oss.sgi.com/archives/xfs/2013-05/msg00022.html
starting at the line:
	@@ -630,6 +688,12 @@ xfs_log_mount(

I think that this patch can be fixed rather resent. Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
