Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pADC76xA110135 for <xfs@oss.sgi.com>; Sun, 13 Nov 2011 06:07:06 -0600
Date: Sun, 13 Nov 2011 07:07:04 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/8] xfsprogs: Drop root inode refrerence in
	libxfs_umount()
Message-ID: <20111113120704.GE19435@infradead.org>
References: <3ed89446f6dc1231ec1de712f242522052952b7e.1320955675.git.aelder@sgi.com>
	<8634b2514c7642f4cbcfdaf3b6852e129417c372.1320955676.git.aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8634b2514c7642f4cbcfdaf3b6852e129417c372.1320955676.git.aelder@sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: Kevan Rehm <kfr@sgi.com>, xfs@oss.sgi.com

On Thu, Nov 10, 2011 at 02:35:15PM -0600, Alex Elder wrote:
> From: Kevan Rehm <kfr@sgi.com>
> 
> Routine libxfs_umount() did not call libxfs_iput for the m_rootip
> inode, so updates made to that inode could be lost.  This adds the
> missing call, and re-initializes the m_rootip pointer to be null.
> 
> Since the root inode reference is now dropped by libxfs_umount(), it
> should *not* be dropped in mkfs parseproto().

Looks fine in general, but as mentioned before live would be a lot
easier if we simply made the root inode a local variable in
libxfs_mount.

In fact I wonder if we even want to do that, there seems very little
reason to even do the root inode iget there - the only caller requesting
it will fall back if it fails.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
