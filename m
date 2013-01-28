Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F1BAC7F47
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 08:14:12 -0600 (CST)
Message-ID: <510687B4.7000902@sgi.com>
Date: Mon, 28 Jan 2013 08:14:12 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: remove unneeded ASSERT from xfs_itruncate_extents
References: <1359381870-30908-1-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1359381870-30908-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 01/28/13 08:04, Carlos Maiolino wrote:
> There is no reason to ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL)); twice, so,
> remove one of these ASSERT calls
>
> Signed-off-by: Carlos Maiolino<cmaiolino@redhat.com>
> ---
>   fs/xfs/xfs_inode.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 66282dc..25226ea 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1396,8 +1396,7 @@ xfs_itruncate_extents(
>   	int			done = 0;
>
>   	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
> -	       xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> +	ASSERT(!atomic_read(&VFS_I(ip)->i_count));
>   	ASSERT(new_size<= XFS_ISIZE(ip));
>   	ASSERT(tp->t_flags&  XFS_TRANS_PERM_LOG_RES);
>   	ASSERT(ip->i_itemp != NULL);

You removed an XFS_IOLOCK_EXCL assert not a duplicate
XFS_ILOCK_EXCL assert. It maybe more obvious if the
first assert read:

	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL) ||
	       xfs_isilocked(ip, XFS_IOLOCK_EXCL));
	ASSERT(!atomic_read(&VFS_I(ip)->i_count));
...

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
