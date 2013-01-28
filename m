Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 72A647F4E
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 10:26:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 46A738F804C
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 08:26:34 -0800 (PST)
Date: Mon, 28 Jan 2013 11:26:28 -0500
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: remove unneeded ASSERT from xfs_itruncate_extents
Message-ID: <20130128162628.GA1303@andromeda.usersys.redhat.com>
References: <1359381870-30908-1-git-send-email-cmaiolino@redhat.com>
	<510687B4.7000902@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <510687B4.7000902@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

Meh, you're right, cheated by my eyes.

but the suggestion looks nice to avoid another ones to fall in the same mistake,
will send a change to it, thanks Mark


On Mon, Jan 28, 2013 at 08:14:12AM -0600, Mark Tinguely wrote:
> On 01/28/13 08:04, Carlos Maiolino wrote:
> >There is no reason to ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL)); twice, so,
> >remove one of these ASSERT calls
> >
> >Signed-off-by: Carlos Maiolino<cmaiolino@redhat.com>
> >---
> >  fs/xfs/xfs_inode.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> >diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> >index 66282dc..25226ea 100644
> >--- a/fs/xfs/xfs_inode.c
> >+++ b/fs/xfs/xfs_inode.c
> >@@ -1396,8 +1396,7 @@ xfs_itruncate_extents(
> >  	int			done = 0;
> >
> >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> >-	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
> >-	       xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> >+	ASSERT(!atomic_read(&VFS_I(ip)->i_count));
> >  	ASSERT(new_size<= XFS_ISIZE(ip));
> >  	ASSERT(tp->t_flags&  XFS_TRANS_PERM_LOG_RES);
> >  	ASSERT(ip->i_itemp != NULL);
> 
> You removed an XFS_IOLOCK_EXCL assert not a duplicate
> XFS_ILOCK_EXCL assert. It maybe more obvious if the
> first assert read:
> 
> 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL) ||
> 	       xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> 	ASSERT(!atomic_read(&VFS_I(ip)->i_count));
> ...
> 
> --Mark Tinguely.

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
