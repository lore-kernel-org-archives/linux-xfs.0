Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4TJioeI086224 for <xfs@oss.sgi.com>; Fri, 29 May 2009 14:44:51 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 760D71019AB3
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 12:51:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id STPhBgMdaLXE3Au6 for
	<xfs@oss.sgi.com>; Fri, 29 May 2009 12:51:13 -0700 (PDT)
Date: Fri, 29 May 2009 15:45:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: reiserfs, gfs2, btrfs support
Message-ID: <20090529194500.GA20736@infradead.org>
References: <4A20373A.9070403@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A20373A.9070403@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Fri, May 29, 2009 at 02:27:54PM -0500, Eric Sandeen wrote:
> This patch gets reiserfs, gfs2, and btrfs off the ground.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> diff --git a/common.rc b/common.rc
> index 54c36f3..c3e77e9 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -53,6 +53,14 @@ _mount_opts()
>  	# acls & xattrs aren't turned on by default on ext$FOO
>  	export MOUNT_OPTIONS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
>  	;;
> +    reiserfs)
> +	# acls & xattrs aren't turned on by default on reiserfs
> +	export MOUNT_OPTIONS="-o acl,user_xattr $REISERFS_MOUNT_OPTIONS"
> +	;;
> +    gfs2)
> +	# acls aren't turned on by default on gfs2
> +	export MOUNT_OPTIONS="-o acl $GFS2_MOUNT_OPTIONS"
> +	;;

I wonder if we should find some way to auto-probe these options somehow.
It looks like lots of filesystems copied that utter braindamage from ext2 :(


Anyway the patch looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
