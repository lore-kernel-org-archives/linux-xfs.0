Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9DF0E7FC7
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 11:17:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7B3D58F8035
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 09:17:58 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id KZAmLvtJDWfe4T4b (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 09:17:57 -0700 (PDT)
Date: Thu, 25 Sep 2014 09:17:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: consider freeze levels in xfs_fs_writable()
Message-ID: <20140925161756.GA25798@infradead.org>
References: <1411647632-28240-1-git-send-email-david@fromorbit.com>
	<1411647632-28240-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411647632-28240-2-git-send-email-david@fromorbit.com>
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

> index d36bdbc..9073895 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -607,7 +607,7 @@ xfs_mount_reset_sbqflags(
>  	 * If the fs is readonly, let the incore superblock run
>  	 * with quotas off but don't flush the update out to disk
>  	 */
> -	if (mp->m_flags & XFS_MOUNT_RDONLY)
> +	if (!xfs_fs_writable(mp, SB_UNFROZEN))

This adds a new caller of xfs_fs_writable, which isn't mentioned in the
changelog.

> +	/*
> +	 * We can be called during the fs freeze process, and we need to be
> +	 * able to write the superblock in that case.
> +	 */
> +	if (!xfs_fs_writable(mp, SB_FREEZE_FS))
>  		return 0;

And this already changes the checked freeze level, also not mentioned.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
