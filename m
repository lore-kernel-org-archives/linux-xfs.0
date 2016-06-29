Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1FEBA7CA1
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2016 15:20:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8EF4BAC005
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2016 13:20:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 1uFHMrYznNCVpc9N for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2016 13:20:50 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id B97241F1C
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2016 15:20:49 -0500 (CDT)
Subject: Re: [PATCH] xfs: lock the rt summary inode when unmapping realtime
	extents
References: <20160629200234.GE4917@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <873055fd-2642-a95e-102a-40dab76ab698@sandeen.net>
Date: Wed, 29 Jun 2016 15:20:49 -0500
MIME-Version: 1.0
In-Reply-To: <20160629200234.GE4917@birch.djwong.org>
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
To: xfs@oss.sgi.com

On 6/29/16 3:02 PM, Darrick J. Wong wrote:
> When we're deleting realtime extents, lock the summary inode
> in case we need to update the summary info.  This prevents an
> assert on the rsumip inode lock on a debug kernel.
> 
> (Same idea as "xfs: lock rt summary inode on allocation".)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Makes sense to me; I wonder how/when/why this is/got/was broken....

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 97820c1..9c7227b 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5524,6 +5524,8 @@ __xfs_bunmapi(
>  		 */
>  		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
> +		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL);
> +		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
>  	}
>  
>  	extno = 0;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
