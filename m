Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n111FPmT142094 for <xfs@oss.sgi.com>; Sat, 31 Jan 2009 19:15:26 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36C62D4751
	for <xfs@oss.sgi.com>; Sat, 31 Jan 2009 17:14:44 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	hYhp7mCUl5KDy4qh for <xfs@oss.sgi.com>;
	Sat, 31 Jan 2009 17:14:44 -0800 (PST)
Date: Sun, 1 Feb 2009 11:54:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/17] xfs: merge xfs_inode_flush into xfs_fs_write_inode
Message-ID: <20090201005426.GC24173@disturbed>
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126073202.588218000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090126073202.588218000@bombadil.infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Jan 26, 2009 at 02:31:47AM -0500, Christoph Hellwig wrote:
> Spliting the task for a VFS-induced inode flush into two functions doesn't

Splitting

> make any sense, so merge the two functions dealing with it.
.....
> +		error = xfs_iflush(ip, XFS_IFLUSH_ASYNC_NOBLOCK);
>  	}
> -	error = xfs_inode_flush(ip, flags);
>  
> -out_error:
> + out_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> + out:

Don't need spaces before the labels.

Otherwise looks OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
