Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SA18An247142 for <xfs@oss.sgi.com>; Thu, 28 May 2009 05:01:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F3FED2B5651
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 03:01:22 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Iucp87zNrAlSQFmk for
	<xfs@oss.sgi.com>; Thu, 28 May 2009 03:01:22 -0700 (PDT)
Date: Thu, 28 May 2009 06:01:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/9] Set default extN mount options
Message-ID: <20090528100122.GG651@infradead.org>
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
	<1243450413-12681-8-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1243450413-12681-8-git-send-email-sandeen@sandeen.net>
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
Cc: xfs@oss.sgi.com

On Wed, May 27, 2009 at 01:53:31PM -0500, Eric Sandeen wrote:
> ext2/3/4 don't support acls & attrs w/o specific mount
> options, so make those the default whenever we mount
> these filesystems.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
>  common.rc |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/common.rc b/common.rc
> index 78514f4..54c36f3 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -49,6 +49,10 @@ _mount_opts()
>      nfs)
>  	export MOUNT_OPTIONS=$NFS_MOUNT_OPTIONS
>  	;;
> +    ext2|ext3|ext4)
> +	# acls & xattrs aren't turned on by default on ext$FOO
> +	export MOUNT_OPTIONS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
> +	;;

This part looks good.

> @@ -585,7 +589,7 @@ _require_scratch()
>  		     _notrun "this test requires a valid \$SCRATCH_DEV"
>  		 fi
>  		 ;;
> -	nfs*|ext2|ext3|reiserfs)
> +	nfs*|ext2|ext3|ext4|reiserfs)
>  		 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
>  		 if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]

This whole function looks fishy to me, but just treating ext4 the same
as ext2/ext3 makes sense at least.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
