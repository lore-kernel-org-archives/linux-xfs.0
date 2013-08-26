Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0DE497F3F
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 16:24:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 98D25AC00F
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 14:24:28 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	LFEVnBoQpybEyB17 for <xfs@oss.sgi.com>;
	Mon, 26 Aug 2013 14:24:26 -0700 (PDT)
Date: Tue, 27 Aug 2013 07:24:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't leak root inode reference
Message-ID: <20130826212423.GX6023@dastard>
References: <20130826204730.GZ7153@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130826204730.GZ7153@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com

On Mon, Aug 26, 2013 at 03:47:30PM -0500, Ben Myers wrote:
> Looks like in 48fde701 we removed the iput of the root inode in
> xfs_fs_fill_super for the error case.  Add it back.
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>
> 
> ---
>  fs/xfs/xfs_super.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Index: b/fs/xfs/xfs_super.c
> ===================================================================
> --- a/fs/xfs/xfs_super.c	2013-08-26 15:36:09.170848579 -0500
> +++ b/fs/xfs/xfs_super.c	2013-08-26 15:40:19.450817933 -0500
> @@ -1493,12 +1493,12 @@ xfs_fs_fill_super(
>  	}
>  	if (is_bad_inode(root)) {
>  		error = EINVAL;
> -		goto out_unmount;
> +		goto out_iput;
>  	}
>  	sb->s_root = d_make_root(root);
>  	if (!sb->s_root) {
>  		error = ENOMEM;
> -		goto out_unmount;
> +		goto out_iput;
>  	}

That's wrong. d_make_root() drops the reference to the inode on
failure itself, and so the change in 48fde701 is correct and valid.

The leak on bad inodes (which, AFAICT, can never happen on XFS) has
been around a lot longer than Al's change - this commit introduced
it:

	2bcf6e9 xfs: start periodic workers later

with this hunk:

        if (is_bad_inode(root)) {
                error = EINVAL;
-               goto fail_vnrele;
+               goto out_syncd_stop;
        }

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
