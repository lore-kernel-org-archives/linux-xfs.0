Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBJ8xIdq002409 for <xfs@oss.sgi.com>; Fri, 19 Dec 2008 02:59:20 -0600
Date: Fri, 19 Dec 2008 03:59:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] fs: Add new pre-allocation ioctls to vfs for
	compatibility with legacy xfs ioctls
Message-ID: <20081219085912.GA30293@infradead.org>
References: <494ABEBC.8060101@ankitjain.org> <20081219043744.GC17177@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081219043744.GC17177@disturbed>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Ankit Jain <me@ankitjain.org>, Al Viro <viro@zeniv.linux.org.uk>, mfasheh@suse.com, linux-kernel@vger.kernel.org, joel.becker@oracle.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On Fri, Dec 19, 2008 at 03:37:44PM +1100, Dave Chinner wrote:
> XFS_IOC_RESVSP supports invisible I/O, and that means
> XFS_IOC_RESVSP needs to be passed through to vfs_ioctl()
> to vector to XFS to handle.

When the current XFS git tree gets merged to mainline before this
patch.  invisible I/O handling is now FMODE_NOCMTIME in file->f_flags
which this patch will pass through to the filesystem.  We just need
to chage xfs_vn_fallocate ot honour it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
