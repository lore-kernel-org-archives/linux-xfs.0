Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BEF5A7F54
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 07:52:17 -0600 (CST)
Message-ID: <547DC411.3090202@sgi.com>
Date: Tue, 02 Dec 2014 07:52:17 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: active inodes stat is broken
References: <1417473270-17467-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1417473270-17467-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 12/01/14 16:34, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> vn_active only ever gets decremented, so it has a very large
> negative number.  Make it track the inode count we currently have
> allocated properly so we can easily track the size of the inode
> cache via tools like PCP.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/xfs_icache.c | 3 +++
>   fs/xfs/xfs_super.c  | 1 -
>   2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 92ca910..8bc3d78 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -128,6 +128,7 @@ xfs_inode_free(
>   	/* asserts to verify all state is correct here */
>   	ASSERT(atomic_read(&ip->i_pincount) == 0);
>   	ASSERT(!xfs_isiflocked(ip));
> +	XFS_STATS_DEC(vn_active);
>
>   	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);
>   }

Would the inode allocated and freed in xfs_recover_inode_owner_change()
cause this the count to go negative?

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
