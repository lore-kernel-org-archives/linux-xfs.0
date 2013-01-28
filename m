Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B4E577F58
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 10:52:57 -0600 (CST)
Date: Mon, 28 Jan 2013 10:52:57 -0600
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: [PATCH] xfs: re-organize XFS_ILOCK asserts in
	xfs_itruncate_extents()
Message-ID: <20130128165257.GB7124@sgi.com>
References: <1359391710-3862-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1359391710-3862-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 28, 2013 at 11:48:30AM -0500, Carlos Maiolino wrote:
| An logically OR'red assert for check an inode locked in XFS_ILOCK_EXCL and
| XFS_IOLOCK_EXCL looks better than the old way, avoiding possible mistakes while
| readin the code
| 
| Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
| ---
|  fs/xfs/xfs_inode.c | 5 +++--
|  1 file changed, 3 insertions(+), 2 deletions(-)
| 
| diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
| index 66282dc..f7efe77 100644
| --- a/fs/xfs/xfs_inode.c
| +++ b/fs/xfs/xfs_inode.c
| @@ -1395,9 +1395,10 @@ xfs_itruncate_extents(
|  	int			error = 0;
|  	int			done = 0;
|  
| -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
| -	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
| +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL) ||
|  	       xfs_isilocked(ip, XFS_IOLOCK_EXCL));
| +	ASSERT(!atomic_read(&VFS_I(ip)->i_count));
| +	ASSERT(!atomic_read(&VFS_I(ip)->i_count));
|  	ASSERT(new_size <= XFS_ISIZE(ip));
|  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
|  	ASSERT(ip->i_itemp != NULL);
| -- 
| 1.8.1

NACK.  You are changing the logic of the asserts.  The original first
assert indicates that the ILOCK is always locked.  The modified asserts
allow eith the ILOCK or the IOLOCK to be locked.  This is not correct.


Geoffrey

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
