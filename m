Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p51NSAZG154970 for <xfs@oss.sgi.com>; Wed, 1 Jun 2011 18:28:10 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 65C07495A2E
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2011 16:28:08 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ZFl4AYWiyRuY7tDs for <xfs@oss.sgi.com>;
	Wed, 01 Jun 2011 16:28:08 -0700 (PDT)
Date: Thu, 2 Jun 2011 09:28:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests: add support for ext4dev FSTYP
Message-ID: <20110601232804.GL32466@dastard>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>
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
Cc: sandeen@redhat.com, Amir Goldstein <amir73il@users.sf.net>, xfs@oss.sgi.com, sergey57@gmail.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Wed, Jun 01, 2011 at 03:56:52PM +0300, amir73il@users.sourceforge.net wrote:
> From: Amir Goldstein <amir73il@users.sf.net>
> 
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
> v1 -> v2:
> - undo change of fsck -t $FSTYP to fsck.$FSTYP
> 
>  common.defrag |    2 +-
>  common.quota  |    4 ++--
>  common.rc     |   10 +++++-----
>  3 files changed, 8 insertions(+), 8 deletions(-)
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
> index 3c87ce1..b6d5f16 100644
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
> @@ -237,7 +237,7 @@ _check_quota_usage()
>  	# Sync to get delalloc to disk
>  	sync
>  	VFS_QUOTA=0
> -	if [ $FSTYP = "ext2" -o $FSTYP = "ext3" -o $FSTYP = "ext4" -o $FSTYP = "reiserfs" ]; then
> +	if [ $FSTYP = "ext2" -o $FSTYP = "ext3" -o $FSTYP = "ext4" -o $FSTYP = "ext4dev" -o $FSTYP = "reiserfs" ]; then
>  		VFS_QUOTA=1
>  		quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
>  	fi

Perhaps this should be changes to a case statement?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
