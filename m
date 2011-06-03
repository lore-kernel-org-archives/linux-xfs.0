Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p533X90b249388 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 22:33:09 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1D4C12CFDD6
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 20:33:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BEcbxx0Nd0XG5Xk6 for
	<xfs@oss.sgi.com>; Thu, 02 Jun 2011 20:33:08 -0700 (PDT)
Message-ID: <4DE855EB.6020207@redhat.com>
Date: Thu, 02 Jun 2011 22:32:59 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfstests: add support for ext4dev FSTYP
References: <1306988221-3543-1-git-send-email-amir73il@users.sourceforge.net>
In-Reply-To: <1306988221-3543-1-git-send-email-amir73il@users.sourceforge.net>
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
To: amir73il@users.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, sergey57@gmail.com, linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>, xfs@oss.sgi.com

On 6/1/11 11:17 PM, amir73il@users.sourceforge.net wrote:
> From: Amir Goldstein <amir73il@users.sf.net>
> 
> blkid knows to identify the ext4dev FSTYP of a partition that was
> formatted with mkfs.ext4dev.
> quota tools and various util-linux utils are also aware of ext4dev,
> so ext4dev shares the same capabilities as ext4.
> 
> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
> Tested-by: Sergey Ivanov <sergey57@gmail.com>
> ---
> ext4dev is used to test experimental ext4 code in mutual existance
> with production ext4 code on the same system.
> 
> Specifically, ext4 snapshots code is available for testing as a
> stand-alone ext4dev module for Fedora 15 and Ubuntu 11.4
> (see http://next3.sf.net).
> 
> v2 -> v3:
> - change if to case statement
> 
> v1 -> v2:
> - undo change of fsck -t $FSTYP to fsck.$FSTYP

looks good to me, and thanks for fixing up the case statement :)

I'll merge this tonight to the xfstests-dev tree.

-Eric

>  common.defrag |    2 +-
>  common.quota  |   10 +++++++---
>  common.rc     |   10 +++++-----
>  3 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/common.defrag b/common.defrag
> index 1bcf01d..4850803 100644
> --- a/common.defrag
> +++ b/common.defrag
> @@ -26,7 +26,7 @@ _require_defrag()
>      xfs)
>          DEFRAG_PROG=/usr/sbin/xfs_fsr
>  	;;
> -    ext4)
> +    ext4|ext4dev)
>          DEFRAG_PROG=/usr/bin/e4defrag
>  	;;
>      *)
> diff --git a/common.quota b/common.quota
> index 3c87ce1..9736306 100644
> --- a/common.quota
> +++ b/common.quota
> @@ -29,7 +29,7 @@ _require_quota()
>      [ -n $QUOTA_PROG ] || _notrun "Quota user tools not installed"
>  
>      case $FSTYP in
> -    ext2|ext3|ext4|reiserfs)
> +    ext2|ext3|ext4|ext4dev|reiserfs)
>  	if [ ! -d /proc/sys/fs/quota ]; then
>  	    _notrun "Installed kernel does not support quotas"
>  	fi
> @@ -237,10 +237,14 @@ _check_quota_usage()
>  	# Sync to get delalloc to disk
>  	sync
>  	VFS_QUOTA=0
> -	if [ $FSTYP = "ext2" -o $FSTYP = "ext3" -o $FSTYP = "ext4" -o $FSTYP = "reiserfs" ]; then
> +	case $FSTYP in
> +	ext2|ext3|ext4|ext4dev|reiserfs)
>  		VFS_QUOTA=1
>  		quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
> -	fi
> +		;;
> +	*)
> +		;;
> +	esac
>  	repquota -u -n $SCRATCH_MNT  | grep -v "^#0" | _filter_scratch |
>  		sort >$tmp.user.orig
>  	repquota -g -n $SCRATCH_MNT  | grep -v "^#0" | _filter_scratch |
> diff --git a/common.rc b/common.rc
> index e634fbb..c510c66 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -65,7 +65,7 @@ _mount_opts()
>      nfs)
>  	export MOUNT_OPTIONS=$NFS_MOUNT_OPTIONS
>  	;;
> -    ext2|ext3|ext4)
> +    ext2|ext3|ext4|ext4dev)
>  	# acls & xattrs aren't turned on by default on ext$FOO
>  	export MOUNT_OPTIONS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
>  	;;
> @@ -110,7 +110,7 @@ _mkfs_opts()
>  _fsck_opts()
>  {
>      case $FSTYP in
> -    ext2|ext3|ext4)
> +    ext2|ext3|ext4|ext4dev)
>  	export FSCK_OPTIONS="-nf"
>  	;;
>      reiserfs)
> @@ -326,10 +326,10 @@ _scratch_mkfs_sized()
>      xfs)
>  	_scratch_mkfs_xfs -d size=$fssize -b size=$blocksize
>  	;;
> -    ext2|ext3|ext4)
> +    ext2|ext3|ext4|ext4dev)
>  	/sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
>  	;;
> -     btrfs)
> +    btrfs)
>  	/sbin/mkfs.$FSTYP $MKFS_OPTIONS $SCRATCH_DEV -b $fssize
>  	;;
>      *)
> @@ -354,7 +354,7 @@ _scratch_mkfs_geom()
>      xfs)
>  	MKFS_OPTIONS+=" -b size=$blocksize, -d su=$sunit_bytes,sw=$swidth_mult"
>  	;;
> -    ext4)
> +    ext4|ext4dev)
>  	MKFS_OPTIONS+=" -b $blocksize -E stride=$sunit_blocks,stripe_width=$swidth_blocks"
>  	;;
>      *)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
