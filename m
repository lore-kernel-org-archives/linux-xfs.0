Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6202A7CBF
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 05:02:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4174C304039
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 03:02:49 -0700 (PDT)
Date: Fri, 24 May 2013 06:02:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: kill suid/sgid through the truncate path.
Message-ID: <20130524100246.GA15373@infradead.org>
References: <1369312240-5925-1-git-send-email-david@fromorbit.com>
	<1369385888-17214-1-git-send-email-david@fromorbit.com>
	<1369385888-17214-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369385888-17214-3-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com, xfs@oss.sgi.com

On Fri, May 24, 2013 at 06:58:08PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> XFS has failed to kill suid/sgid bits correctly when truncating
> files of non-zero size since commit c4ed4243 ("xfs: split
> xfs_setattr") introduced in the 3.1 kernel. Fix it.

This should get a testcase in xfstests.

> +xfs_setattr_mode(
> +	struct inode	*inode,
> +	struct iattr	*iattr)
> +{
> +	struct xfs_inode *ip = XFS_I(inode);
> +	umode_t		mode = iattr->ia_mode;
> +
> +	if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
> +		mode &= ~S_ISGID;
> +
> +	ip->i_d.di_mode &= S_IFMT;
> +	ip->i_d.di_mode |= mode & ~S_IFMT;
> +
> +	inode->i_mode &= S_IFMT;
> +	inode->i_mode |= mode & ~S_IFMT;

This function should have assers that the xfs_inode is locked
exclusively and joined to a transaction.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
