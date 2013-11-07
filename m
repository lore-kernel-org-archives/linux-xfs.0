Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A7E0029E12
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 08:09:53 -0600 (CST)
Received: from eagdhcp-232-150.americas.sgi.com
	(eagdhcp-232-150.americas.sgi.com [128.162.232.150])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7401B30405F
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 06:09:53 -0800 (PST)
Message-ID: <527B9F23.6070208@sgi.com>
Date: Thu, 07 Nov 2013 08:09:39 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfs: fix unlock in xfs_bmap_add_attrfork
References: <20131107134725.690440645@sgi.com>
In-Reply-To: <20131107134725.690440645@sgi.com>
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
To: xfs@oss.sgi.com

On 11/07/13 07:47, Mark Tinguely wrote:
> xfs_trans_ijoin() activates the inode in a transaction and
> also can specify which lock to free when the transaction is
> committed or canceled.
>
> xfs_bmap_add_attrfork adds the XFS_ILOCK_EXCL flag when calling
> xfs_trans_ijoin(). This patch does not add the lock removal in
> the transaction and manually removes the lock.
>
> While here, clean up the goto names.
>
> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
> ---
> v3
>     fix the trans_trans_commit return path.
> v2
>     remove the lock from the transaction.
>     adjust the cancel_flags.
>
>   fs/xfs/xfs_bmap.c |   38 +++++++++++++++++++++-----------------
>   1 file changed, 21 insertions(+), 17 deletions(-)
>
> Index: b/fs/xfs/xfs_bmap.c
> ===================================================================
>

...


>   		/*
>   		 * For inodes coming from pre-6.2 filesystems.
> @@ -1170,7 +1172,7 @@ xfs_bmap_add_attrfork(
>   	ASSERT(ip->i_d.di_anextents == 0);
>
>   	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> -	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	xfs_trans_log_inode(tp, ip, 0);

Auugh! poison, wooden stake, behead and then burn this patch.

sorry, don't know how these entries were changed wrong.

--Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
