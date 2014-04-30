Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1FACC29DF9
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 10:14:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BA499AC00B
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 08:14:33 -0700 (PDT)
Date: Wed, 30 Apr 2014 08:14:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfsprogs: dont free xfs_inode until complete
Message-ID: <20140430151431.GC15162@infradead.org>
References: <20140430134844.924376330@sgi.com>
	<20140430135319.750775813@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140430135319.750775813@sgi.com>
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

On Wed, Apr 30, 2014 at 08:48:46AM -0500, Mark Tinguely wrote:
> Originally, the xfs_inode are released upon the first
> call to xfs_trans_cancel, xfs_trans_commit, or
> inode_item_done. This code used the log item lock field
> to prevent the release of the inode on the next call to
> one of the above functions. This is a unusual use of the
> log item lock field which is suppose to specify which lock
> is to be release on transaction commit or cancel. User
> space does not perform locking in transactions..
> 
> Unfortunately, this breaks any code that relies on multiple
> transaction operations. For example, adding an extended
> attribute to an inode that does not have an attribute fork
> will fail:
> 
>  # xfs_db -x XFS_DEVICE
>  xfs_db> inode INO_NUM
>  xfs_db> attr_set newattribute
> 
> This patch does the following:
>  1) Removes the iput from the transaction completion and
>     requires that the xfs_inode allocators call IRELE()
>     when they are done with the pointer. The real time
>     inodes are pointed to by the xfs_mount and have a longer
>     lifetime.

Makes sense, the kernel hasn't done an iput during transaction
completion for a long time.

>  2) Removes libxfs_trans_iput() because transaction entries
>     are removed in transaction commit and cancel.

Also matches the kernel and makes sense.

>  3) Removes libxfs_trans_ihold() which is an obsolete interface.

Ditto.

>  4) Removes the now unneeded ili_flags from the xfs_inode_log_item
>     structure.

ili_lock_flags, not ili_flags.  Given that we never lock inodes in
userspace there is no need to unlock them during transaction commit,
and no need to track this.  There's also no shared code that references
this field, so it can safely go.

The patch looks good to me, and having consistent behavior with the
kernel code is very useful to have!

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
