Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 55D2D7F3F
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 06:34:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3B63D8F8068
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 04:34:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZDnfIGarWcZD5KS0 for
	<xfs@oss.sgi.com>; Tue, 03 Jun 2014 04:34:43 -0700 (PDT)
Date: Tue, 3 Jun 2014 13:32:30 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] xfstests: f2fs support
In-Reply-To: <1401717572-21731-1-git-send-email-jaegeuk@kernel.org>
Message-ID: <alpine.LFD.2.00.1406031307590.2112@localhost.localdomain>
References: <1401717572-21731-1-git-send-email-jaegeuk@kernel.org>
MIME-Version: 1.0
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
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforget.net, xfs@oss.sgi.com

On Mon, 2 Jun 2014, jaegeuk@kernel.org wrote:

> Date: Mon,  2 Jun 2014 22:59:32 +0900
> From: jaegeuk@kernel.org
> To: Dave Chinner <david@fromorbit.com>
> Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
>     linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforget.net,
>     Jaegeuk Kim <jaegeuk@kernel.org>
> Subject: [PATCH] xfstests: f2fs support
> 
> From: Jaegeuk Kim <jaegeuk@kernel.org>
> 
> This patch adds to support f2fs file system.

Hi,

Looks good.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Btw dry run option in fsck is quite useful here because when the
file system gets corrupted you do not want it to get fixed, but
rather investigate the corrupted file system to figure out what
happened. But of course it's not required :)

However after a quick look at you fsck code it seems that you do not
attempt to fix anything at all...

Also having mkfs to check for existing signatures on the device
before attempting to create the file system is a good thing to do
(at least xfs, btrfs extN are doing so) to avoid data loss by
mistake. You can use libblkid from util-linux and it's very simple
to use.

Thanks!
-Lukas

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  common/config | 7 +++++++
>  common/rc     | 6 ++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/common/config b/common/config
> index 0dbf0b9..0607294 100644
> --- a/common/config
> +++ b/common/config
> @@ -210,6 +210,7 @@ case "$HOSTOS" in
>          export MKFS_XFS_PROG="`set_prog_path mkfs.xfs`"
>          export MKFS_UDF_PROG="`set_prog_path mkudffs`"
>          export MKFS_BTRFS_PROG="`set_btrfs_mkfs_prog_path_with_opts`"
> +        export MKFS_F2FS_PROG="`set_prog_path mkfs.f2fs`"
>          export BTRFS_UTIL_PROG="`set_prog_path btrfs`"
>          export BTRFS_SHOW_SUPER_PROG="`set_prog_path btrfs-show-super`"
>          export XFS_FSR_PROG="`set_prog_path xfs_fsr`"
> @@ -241,6 +242,9 @@ _mount_opts()
>  		# acls & xattrs aren't turned on by default on ext$FOO
>  		export MOUNT_OPTIONS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
>  		;;
> +	f2fs)
> +		export MOUNT_OPTIONS="-o acl,user_xattr $F2FS_MOUNT_OPTIONS"
> +		;;
>  	reiserfs)
>  		# acls & xattrs aren't turned on by default on reiserfs
>  		export MOUNT_OPTIONS="-o acl,user_xattr $REISERFS_MOUNT_OPTIONS"
> @@ -295,6 +299,9 @@ _fsck_opts()
>  	reiserfs)
>  		export FSCK_OPTIONS="--yes"
>  		;;
> +	f2fs)
> +		export FSCK_OPTIONS=""
> +		;;
>  	*)
>  		export FSCK_OPTIONS="-n"
>  		;;
> diff --git a/common/rc b/common/rc
> index f27ee53..fcdabfe 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -105,6 +105,9 @@ case "$FSTYP" in
>      btrfs)
>  	 [ "$MKFS_BTRFS_PROG" = "" ] && _fatal "mkfs.btrfs not found"
>  	 ;;
> +    f2fs)
> +	 [ "$MKFS_F2FS_PROG" = "" ] && _fatal "mkfs.f2fs not found"
> +	 ;;
>      nfs)
>  	 ;;
>  esac
> @@ -511,6 +514,9 @@ _scratch_mkfs()
>      tmpfs)
>  	# do nothing for tmpfs
>  	;;
> +    f2fs)
> +        $MKFS_F2FS_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
> +	;;
>      *)
>  	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV
>  	;;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
