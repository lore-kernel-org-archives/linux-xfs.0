Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pASB2UWe232937 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 05:02:30 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48A4E9439A3
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 03:02:29 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	WxFwH5izpnw52luU for <xfs@oss.sgi.com>;
	Mon, 28 Nov 2011 03:02:29 -0800 (PST)
Date: Mon, 28 Nov 2011 06:02:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: mount other filesystems with selinux context
	as well
Message-ID: <20111128110228.GC13766@infradead.org>
References: <4ECD3262.105@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ECD3262.105@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Wed, Nov 23, 2011 at 11:50:26AM -0600, Eric Sandeen wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> For some reason, non-xfs filesystems aren't getting mounted with
> the selinux context; perhaps because none of the xattr tests used
> to work on anything but xfs?
> 
> Anyway, 062 fails for extN unless we mount with the fs-wide
> context.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> - ---
> 
> diff --git a/common.rc b/common.rc
> index cab0b64..5998ff2 100644
> - --- a/common.rc
> +++ b/common.rc
> @@ -86,14 +86,17 @@ _mount_opts()
>  	export MOUNT_OPTIONS=$NFS_MOUNT_OPTIONS
>  	;;
>      ext2|ext3|ext4|ext4dev)
> - -	# acls & xattrs aren't turned on by default on ext$FOO
> +	export SELINUX_MOUNT_OPTIONS
> +	# acls & xattrs aren't turned on by default on ext$FOO in old kernels
>  	export MOUNT_OPTIONS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
>  	;;
>      reiserfs)
> +	export SELINUX_MOUNT_OPTIONS
>  	# acls & xattrs aren't turned on by default on reiserfs
>  	export MOUNT_OPTIONS="-o acl,user_xattr $REISERFS_MOUNT_OPTIONS"
>  	;;
>      gfs2)
> +	export SELINUX_MOUNT_OPTIONS
>  	# acls aren't turned on by default on gfs2
>  	export MOUNT_OPTIONS="-o acl $GFS2_MOUNT_OPTIONS"
>  	;;

shouldn't the "export SELINUX_MOUNT_OPTIONS" simply move to common code?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
