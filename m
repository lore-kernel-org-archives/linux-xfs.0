Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3TLr248162585 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 16:53:02 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	GY0TtLl9xsm90YXp (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 29 Apr 2012 14:53:01 -0700 (PDT)
Date: Sun, 29 Apr 2012 17:53:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 31/37] xfs: move xfs_fsb_to_db to xfs_bmap.h
Message-ID: <20120429215300.GJ19889@infradead.org>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-32-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1335160747-17254-32-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 23, 2012 at 03:59:01PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This is the only remaining useful function in xfs_rw.h, so move it

Well, xfs_get_extsz_hint also still is useful, and you only move it in
the next patch.

> +/*
> + * Convert the given file system block to a disk block.  We have to treat it
> + * differently based on whether the file is a real time file or not, because the
> + * bmap code does.
> + */

Might be worth alaborating why exactly.  When I last looked over it I
couldn't make much sense of it.

> +xfs_daddr_t
> +xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
> +{
> +	return (XFS_IS_REALTIME_INODE(ip) ? \
> +		 (xfs_daddr_t)XFS_FSB_TO_BB((ip)->i_mount, (fsb)) : \
> +		 XFS_FSB_TO_DADDR((ip)->i_mount, (fsb)));
> +}

Might be worth to "demacrofy" it while you're at it, e.g. rewrite it as:

xfs_daddr_t
xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
{
	if (XFS_IS_REALTIME_INODE(ip))
		return XFS_FSB_TO_BB(ip->i_mount, fsb);
	else
		return XFS_FSB_TO_DADDR(ip->i_mount, fsb);
}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
