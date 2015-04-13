Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2B1287F63
	for <xfs@oss.sgi.com>; Sun, 12 Apr 2015 21:12:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2B46E304039
	for <xfs@oss.sgi.com>; Sun, 12 Apr 2015 19:12:30 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ezzCO9W5GzPrW75V for <xfs@oss.sgi.com>;
	Sun, 12 Apr 2015 19:12:25 -0700 (PDT)
Date: Mon, 13 Apr 2015 12:12:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: linux-next: manual merge of the vfs tree with the xfs tree
Message-ID: <20150413021211.GP15810@dastard>
References: <20150413115737.6ec67270@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150413115737.6ec67270@canb.auug.org.au>
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
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, David Howells <dhowells@redhat.com>, Ben Myers <bpm@sgi.com>, linux-next@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>

On Mon, Apr 13, 2015 at 11:57:37AM +1000, Stephen Rothwell wrote:
> Hi Al,
> 
> Today's linux-next merge of the vfs tree got a conflict in
> fs/xfs/xfs_iops.c between commit e8e9ad42c1f1 ("xfs: take i_mmap_lock
> on extent manipulation operations") from the xfs tree and commit
> 5dd3dc06371a ("VFS: normal filesystems (and lustre): d_inode()
> annotations") from the vfs tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc fs/xfs/xfs_iops.c
> index 015d6a366b16,54b95232d946..000000000000
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@@ -953,13 -975,9 +953,13 @@@ xfs_vn_setattr
>   		uint		iolock = XFS_IOLOCK_EXCL;
>   
>   		xfs_ilock(ip, iolock);
> - 		error = xfs_break_layouts(dentry->d_inode, &iolock);
> + 		error = xfs_break_layouts(d_inode(dentry), &iolock);
>  -		if (!error)
>  +		if (!error) {
>  +			xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
>  +			iolock |= XFS_MMAPLOCK_EXCL;
>  +
>   			error = xfs_setattr_size(ip, iattr);
>  +		}
>   		xfs_iunlock(ip, iolock);
>   	} else {
>   		error = xfs_setattr_nonsize(ip, iattr, 0);

Fix looks good. FWIW, I'm just about to commit a locking fix
which adds a parameter to xfs_break_layouts() so you might need to
rework this again tomorrow...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
